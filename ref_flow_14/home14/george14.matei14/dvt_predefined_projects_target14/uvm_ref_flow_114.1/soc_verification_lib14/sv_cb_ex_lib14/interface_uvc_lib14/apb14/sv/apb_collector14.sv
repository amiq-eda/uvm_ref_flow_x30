/*******************************************************************************
  FILE : apb_collector14.sv
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV14
`define APB_COLLECTOR_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_collector14
//------------------------------------------------------------------------------

class apb_collector14 extends uvm_component;

  // The virtual interface used to view14 HDL signals14.
  virtual apb_if14 vif14;

  // APB14 configuration information
  apb_config14 cfg;

  // Property14 indicating the number14 of transactions occuring14 on the apb14.
  protected int unsigned num_transactions14 = 0;

  // The following14 two14 bits are used to control14 whether14 checks14 and coverage14 are
  // done both in the collector14 class and the interface.
  bit checks_enable14 = 1; 
  bit coverage_enable14 = 1;

  // TLM Ports14 - transfer14 collected14 for monitor14 other components14
  uvm_analysis_port #(apb_transfer14) item_collected_port14;

  // TLM Port14 - Allows14 sequencer access to transfer14 during address phase
  uvm_blocking_peek_imp#(apb_transfer14,apb_collector14) addr_trans_export14;
  event addr_trans_grabbed14;

  // The following14 property holds14 the transaction information currently
  // being captured14 (by the collect_address_phase14 and data_phase14 methods14). 
  apb_transfer14 trans_collected14;

  //Adding pseudo14-memory leakage14 for heap14 analysis14 lab14
  `ifdef HEAP14
  static apb_transfer14 runq14[$];
  `endif

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(apb_collector14)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable14, UVM_DEFAULT)
    `uvm_field_int(coverage_enable14, UVM_DEFAULT)
    `uvm_field_int(num_transactions14, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected14 = apb_transfer14::type_id::create("trans_collected14");
    // TLM ports14 are created here14
    item_collected_port14 = new("item_collected_port14", this);
    addr_trans_export14 = new("addr_trans_export14", this);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions14();
  extern task peek(output apb_transfer14 trans14);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector14

// UVM build_phase
function void apb_collector14::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config14)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG14", "apb_config14 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector14::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if14)::get(this, "", "vif14", vif14))
      `uvm_error("NOVIF14", {"virtual interface must be set for: ", get_full_name(), ".vif14"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector14::run_phase(uvm_phase phase);
    @(posedge vif14.preset14);
    `uvm_info(get_type_name(), "Detected14 Reset14 Done14", UVM_LOW)
    collect_transactions14();
endtask : run_phase

// collect_transactions14
task apb_collector14::collect_transactions14();
  forever begin
    @(posedge vif14.pclock14 iff (vif14.psel14 != 0));
    void'(this.begin_tr(trans_collected14,"apb_collector14","UVM Debug14","APB14 collector14 transaction inside collect_transactions14()"));
    trans_collected14.addr = vif14.paddr14;
    trans_collected14.master14 = cfg.master_config14.name;
    trans_collected14.slave14 = cfg.get_slave_name_by_addr14(trans_collected14.addr);
    case (vif14.prwd14)
      1'b0 : trans_collected14.direction14 = APB_READ14;
      1'b1 : trans_collected14.direction14 = APB_WRITE14;
    endcase
      @(posedge vif14.pclock14);
    if(trans_collected14.direction14 == APB_READ14)
      trans_collected14.data = vif14.prdata14;
    if (trans_collected14.direction14 == APB_WRITE14)
      trans_collected14.data = vif14.pwdata14;
    -> addr_trans_grabbed14;
    @(posedge vif14.pclock14);
    if(trans_collected14.direction14 == APB_READ14) begin
        if(vif14.pready14 != 1'b1)
          @(posedge vif14.pclock14);
      trans_collected14.data = vif14.prdata14;
      end
    this.end_tr(trans_collected14);
    item_collected_port14.write(trans_collected14);
    `uvm_info(get_type_name(), $psprintf("Transfer14 collected14 :\n%s",
              trans_collected14.sprint()), UVM_MEDIUM)
      `ifdef HEAP14
      runq14.push_back(trans_collected14);
      `endif
     num_transactions14++;
    end
endtask : collect_transactions14

task apb_collector14::peek(output apb_transfer14 trans14);
  @addr_trans_grabbed14;
  trans14 = trans_collected14;
endtask : peek

function void apb_collector14::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report14: APB14 collector14 collected14 %0d transfers14", num_transactions14), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV14
