/*******************************************************************************
  FILE : apb_collector8.sv
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV8
`define APB_COLLECTOR_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_collector8
//------------------------------------------------------------------------------

class apb_collector8 extends uvm_component;

  // The virtual interface used to view8 HDL signals8.
  virtual apb_if8 vif8;

  // APB8 configuration information
  apb_config8 cfg;

  // Property8 indicating the number8 of transactions occuring8 on the apb8.
  protected int unsigned num_transactions8 = 0;

  // The following8 two8 bits are used to control8 whether8 checks8 and coverage8 are
  // done both in the collector8 class and the interface.
  bit checks_enable8 = 1; 
  bit coverage_enable8 = 1;

  // TLM Ports8 - transfer8 collected8 for monitor8 other components8
  uvm_analysis_port #(apb_transfer8) item_collected_port8;

  // TLM Port8 - Allows8 sequencer access to transfer8 during address phase
  uvm_blocking_peek_imp#(apb_transfer8,apb_collector8) addr_trans_export8;
  event addr_trans_grabbed8;

  // The following8 property holds8 the transaction information currently
  // being captured8 (by the collect_address_phase8 and data_phase8 methods8). 
  apb_transfer8 trans_collected8;

  //Adding pseudo8-memory leakage8 for heap8 analysis8 lab8
  `ifdef HEAP8
  static apb_transfer8 runq8[$];
  `endif

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(apb_collector8)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable8, UVM_DEFAULT)
    `uvm_field_int(coverage_enable8, UVM_DEFAULT)
    `uvm_field_int(num_transactions8, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected8 = apb_transfer8::type_id::create("trans_collected8");
    // TLM ports8 are created here8
    item_collected_port8 = new("item_collected_port8", this);
    addr_trans_export8 = new("addr_trans_export8", this);
  endfunction : new

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions8();
  extern task peek(output apb_transfer8 trans8);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector8

// UVM build_phase
function void apb_collector8::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config8)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG8", "apb_config8 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector8::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if8)::get(this, "", "vif8", vif8))
      `uvm_error("NOVIF8", {"virtual interface must be set for: ", get_full_name(), ".vif8"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector8::run_phase(uvm_phase phase);
    @(posedge vif8.preset8);
    `uvm_info(get_type_name(), "Detected8 Reset8 Done8", UVM_LOW)
    collect_transactions8();
endtask : run_phase

// collect_transactions8
task apb_collector8::collect_transactions8();
  forever begin
    @(posedge vif8.pclock8 iff (vif8.psel8 != 0));
    void'(this.begin_tr(trans_collected8,"apb_collector8","UVM Debug8","APB8 collector8 transaction inside collect_transactions8()"));
    trans_collected8.addr = vif8.paddr8;
    trans_collected8.master8 = cfg.master_config8.name;
    trans_collected8.slave8 = cfg.get_slave_name_by_addr8(trans_collected8.addr);
    case (vif8.prwd8)
      1'b0 : trans_collected8.direction8 = APB_READ8;
      1'b1 : trans_collected8.direction8 = APB_WRITE8;
    endcase
      @(posedge vif8.pclock8);
    if(trans_collected8.direction8 == APB_READ8)
      trans_collected8.data = vif8.prdata8;
    if (trans_collected8.direction8 == APB_WRITE8)
      trans_collected8.data = vif8.pwdata8;
    -> addr_trans_grabbed8;
    @(posedge vif8.pclock8);
    if(trans_collected8.direction8 == APB_READ8) begin
        if(vif8.pready8 != 1'b1)
          @(posedge vif8.pclock8);
      trans_collected8.data = vif8.prdata8;
      end
    this.end_tr(trans_collected8);
    item_collected_port8.write(trans_collected8);
    `uvm_info(get_type_name(), $psprintf("Transfer8 collected8 :\n%s",
              trans_collected8.sprint()), UVM_MEDIUM)
      `ifdef HEAP8
      runq8.push_back(trans_collected8);
      `endif
     num_transactions8++;
    end
endtask : collect_transactions8

task apb_collector8::peek(output apb_transfer8 trans8);
  @addr_trans_grabbed8;
  trans8 = trans_collected8;
endtask : peek

function void apb_collector8::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report8: APB8 collector8 collected8 %0d transfers8", num_transactions8), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV8
