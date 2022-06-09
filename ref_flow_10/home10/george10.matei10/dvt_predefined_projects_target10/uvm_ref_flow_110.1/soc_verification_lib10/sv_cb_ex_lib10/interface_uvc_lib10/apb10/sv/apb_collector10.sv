/*******************************************************************************
  FILE : apb_collector10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV10
`define APB_COLLECTOR_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_collector10
//------------------------------------------------------------------------------

class apb_collector10 extends uvm_component;

  // The virtual interface used to view10 HDL signals10.
  virtual apb_if10 vif10;

  // APB10 configuration information
  apb_config10 cfg;

  // Property10 indicating the number10 of transactions occuring10 on the apb10.
  protected int unsigned num_transactions10 = 0;

  // The following10 two10 bits are used to control10 whether10 checks10 and coverage10 are
  // done both in the collector10 class and the interface.
  bit checks_enable10 = 1; 
  bit coverage_enable10 = 1;

  // TLM Ports10 - transfer10 collected10 for monitor10 other components10
  uvm_analysis_port #(apb_transfer10) item_collected_port10;

  // TLM Port10 - Allows10 sequencer access to transfer10 during address phase
  uvm_blocking_peek_imp#(apb_transfer10,apb_collector10) addr_trans_export10;
  event addr_trans_grabbed10;

  // The following10 property holds10 the transaction information currently
  // being captured10 (by the collect_address_phase10 and data_phase10 methods10). 
  apb_transfer10 trans_collected10;

  //Adding pseudo10-memory leakage10 for heap10 analysis10 lab10
  `ifdef HEAP10
  static apb_transfer10 runq10[$];
  `endif

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(apb_collector10)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable10, UVM_DEFAULT)
    `uvm_field_int(coverage_enable10, UVM_DEFAULT)
    `uvm_field_int(num_transactions10, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected10 = apb_transfer10::type_id::create("trans_collected10");
    // TLM ports10 are created here10
    item_collected_port10 = new("item_collected_port10", this);
    addr_trans_export10 = new("addr_trans_export10", this);
  endfunction : new

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions10();
  extern task peek(output apb_transfer10 trans10);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector10

// UVM build_phase
function void apb_collector10::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config10)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG10", "apb_config10 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector10::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if10)::get(this, "", "vif10", vif10))
      `uvm_error("NOVIF10", {"virtual interface must be set for: ", get_full_name(), ".vif10"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector10::run_phase(uvm_phase phase);
    @(posedge vif10.preset10);
    `uvm_info(get_type_name(), "Detected10 Reset10 Done10", UVM_LOW)
    collect_transactions10();
endtask : run_phase

// collect_transactions10
task apb_collector10::collect_transactions10();
  forever begin
    @(posedge vif10.pclock10 iff (vif10.psel10 != 0));
    void'(this.begin_tr(trans_collected10,"apb_collector10","UVM Debug10","APB10 collector10 transaction inside collect_transactions10()"));
    trans_collected10.addr = vif10.paddr10;
    trans_collected10.master10 = cfg.master_config10.name;
    trans_collected10.slave10 = cfg.get_slave_name_by_addr10(trans_collected10.addr);
    case (vif10.prwd10)
      1'b0 : trans_collected10.direction10 = APB_READ10;
      1'b1 : trans_collected10.direction10 = APB_WRITE10;
    endcase
      @(posedge vif10.pclock10);
    if(trans_collected10.direction10 == APB_READ10)
      trans_collected10.data = vif10.prdata10;
    if (trans_collected10.direction10 == APB_WRITE10)
      trans_collected10.data = vif10.pwdata10;
    -> addr_trans_grabbed10;
    @(posedge vif10.pclock10);
    if(trans_collected10.direction10 == APB_READ10) begin
        if(vif10.pready10 != 1'b1)
          @(posedge vif10.pclock10);
      trans_collected10.data = vif10.prdata10;
      end
    this.end_tr(trans_collected10);
    item_collected_port10.write(trans_collected10);
    `uvm_info(get_type_name(), $psprintf("Transfer10 collected10 :\n%s",
              trans_collected10.sprint()), UVM_MEDIUM)
      `ifdef HEAP10
      runq10.push_back(trans_collected10);
      `endif
     num_transactions10++;
    end
endtask : collect_transactions10

task apb_collector10::peek(output apb_transfer10 trans10);
  @addr_trans_grabbed10;
  trans10 = trans_collected10;
endtask : peek

function void apb_collector10::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report10: APB10 collector10 collected10 %0d transfers10", num_transactions10), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV10
