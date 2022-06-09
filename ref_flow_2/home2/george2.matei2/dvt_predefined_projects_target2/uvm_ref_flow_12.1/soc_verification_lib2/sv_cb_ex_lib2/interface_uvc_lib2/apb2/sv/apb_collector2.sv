/*******************************************************************************
  FILE : apb_collector2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV2
`define APB_COLLECTOR_SV2

//------------------------------------------------------------------------------
// CLASS2: apb_collector2
//------------------------------------------------------------------------------

class apb_collector2 extends uvm_component;

  // The virtual interface used to view2 HDL signals2.
  virtual apb_if2 vif2;

  // APB2 configuration information
  apb_config2 cfg;

  // Property2 indicating the number2 of transactions occuring2 on the apb2.
  protected int unsigned num_transactions2 = 0;

  // The following2 two2 bits are used to control2 whether2 checks2 and coverage2 are
  // done both in the collector2 class and the interface.
  bit checks_enable2 = 1; 
  bit coverage_enable2 = 1;

  // TLM Ports2 - transfer2 collected2 for monitor2 other components2
  uvm_analysis_port #(apb_transfer2) item_collected_port2;

  // TLM Port2 - Allows2 sequencer access to transfer2 during address phase
  uvm_blocking_peek_imp#(apb_transfer2,apb_collector2) addr_trans_export2;
  event addr_trans_grabbed2;

  // The following2 property holds2 the transaction information currently
  // being captured2 (by the collect_address_phase2 and data_phase2 methods2). 
  apb_transfer2 trans_collected2;

  //Adding pseudo2-memory leakage2 for heap2 analysis2 lab2
  `ifdef HEAP2
  static apb_transfer2 runq2[$];
  `endif

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(apb_collector2)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable2, UVM_DEFAULT)
    `uvm_field_int(coverage_enable2, UVM_DEFAULT)
    `uvm_field_int(num_transactions2, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected2 = apb_transfer2::type_id::create("trans_collected2");
    // TLM ports2 are created here2
    item_collected_port2 = new("item_collected_port2", this);
    addr_trans_export2 = new("addr_trans_export2", this);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions2();
  extern task peek(output apb_transfer2 trans2);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector2

// UVM build_phase
function void apb_collector2::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config2)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG2", "apb_config2 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector2::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if2)::get(this, "", "vif2", vif2))
      `uvm_error("NOVIF2", {"virtual interface must be set for: ", get_full_name(), ".vif2"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector2::run_phase(uvm_phase phase);
    @(posedge vif2.preset2);
    `uvm_info(get_type_name(), "Detected2 Reset2 Done2", UVM_LOW)
    collect_transactions2();
endtask : run_phase

// collect_transactions2
task apb_collector2::collect_transactions2();
  forever begin
    @(posedge vif2.pclock2 iff (vif2.psel2 != 0));
    void'(this.begin_tr(trans_collected2,"apb_collector2","UVM Debug2","APB2 collector2 transaction inside collect_transactions2()"));
    trans_collected2.addr = vif2.paddr2;
    trans_collected2.master2 = cfg.master_config2.name;
    trans_collected2.slave2 = cfg.get_slave_name_by_addr2(trans_collected2.addr);
    case (vif2.prwd2)
      1'b0 : trans_collected2.direction2 = APB_READ2;
      1'b1 : trans_collected2.direction2 = APB_WRITE2;
    endcase
      @(posedge vif2.pclock2);
    if(trans_collected2.direction2 == APB_READ2)
      trans_collected2.data = vif2.prdata2;
    if (trans_collected2.direction2 == APB_WRITE2)
      trans_collected2.data = vif2.pwdata2;
    -> addr_trans_grabbed2;
    @(posedge vif2.pclock2);
    if(trans_collected2.direction2 == APB_READ2) begin
        if(vif2.pready2 != 1'b1)
          @(posedge vif2.pclock2);
      trans_collected2.data = vif2.prdata2;
      end
    this.end_tr(trans_collected2);
    item_collected_port2.write(trans_collected2);
    `uvm_info(get_type_name(), $psprintf("Transfer2 collected2 :\n%s",
              trans_collected2.sprint()), UVM_MEDIUM)
      `ifdef HEAP2
      runq2.push_back(trans_collected2);
      `endif
     num_transactions2++;
    end
endtask : collect_transactions2

task apb_collector2::peek(output apb_transfer2 trans2);
  @addr_trans_grabbed2;
  trans2 = trans_collected2;
endtask : peek

function void apb_collector2::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report2: APB2 collector2 collected2 %0d transfers2", num_transactions2), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV2
