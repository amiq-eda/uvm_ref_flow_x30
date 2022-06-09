/*******************************************************************************
  FILE : apb_collector13.sv
*******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV13
`define APB_COLLECTOR_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_collector13
//------------------------------------------------------------------------------

class apb_collector13 extends uvm_component;

  // The virtual interface used to view13 HDL signals13.
  virtual apb_if13 vif13;

  // APB13 configuration information
  apb_config13 cfg;

  // Property13 indicating the number13 of transactions occuring13 on the apb13.
  protected int unsigned num_transactions13 = 0;

  // The following13 two13 bits are used to control13 whether13 checks13 and coverage13 are
  // done both in the collector13 class and the interface.
  bit checks_enable13 = 1; 
  bit coverage_enable13 = 1;

  // TLM Ports13 - transfer13 collected13 for monitor13 other components13
  uvm_analysis_port #(apb_transfer13) item_collected_port13;

  // TLM Port13 - Allows13 sequencer access to transfer13 during address phase
  uvm_blocking_peek_imp#(apb_transfer13,apb_collector13) addr_trans_export13;
  event addr_trans_grabbed13;

  // The following13 property holds13 the transaction information currently
  // being captured13 (by the collect_address_phase13 and data_phase13 methods13). 
  apb_transfer13 trans_collected13;

  //Adding pseudo13-memory leakage13 for heap13 analysis13 lab13
  `ifdef HEAP13
  static apb_transfer13 runq13[$];
  `endif

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(apb_collector13)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable13, UVM_DEFAULT)
    `uvm_field_int(coverage_enable13, UVM_DEFAULT)
    `uvm_field_int(num_transactions13, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected13 = apb_transfer13::type_id::create("trans_collected13");
    // TLM ports13 are created here13
    item_collected_port13 = new("item_collected_port13", this);
    addr_trans_export13 = new("addr_trans_export13", this);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions13();
  extern task peek(output apb_transfer13 trans13);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector13

// UVM build_phase
function void apb_collector13::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config13)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG13", "apb_config13 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector13::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if13)::get(this, "", "vif13", vif13))
      `uvm_error("NOVIF13", {"virtual interface must be set for: ", get_full_name(), ".vif13"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector13::run_phase(uvm_phase phase);
    @(posedge vif13.preset13);
    `uvm_info(get_type_name(), "Detected13 Reset13 Done13", UVM_LOW)
    collect_transactions13();
endtask : run_phase

// collect_transactions13
task apb_collector13::collect_transactions13();
  forever begin
    @(posedge vif13.pclock13 iff (vif13.psel13 != 0));
    void'(this.begin_tr(trans_collected13,"apb_collector13","UVM Debug13","APB13 collector13 transaction inside collect_transactions13()"));
    trans_collected13.addr = vif13.paddr13;
    trans_collected13.master13 = cfg.master_config13.name;
    trans_collected13.slave13 = cfg.get_slave_name_by_addr13(trans_collected13.addr);
    case (vif13.prwd13)
      1'b0 : trans_collected13.direction13 = APB_READ13;
      1'b1 : trans_collected13.direction13 = APB_WRITE13;
    endcase
      @(posedge vif13.pclock13);
    if(trans_collected13.direction13 == APB_READ13)
      trans_collected13.data = vif13.prdata13;
    if (trans_collected13.direction13 == APB_WRITE13)
      trans_collected13.data = vif13.pwdata13;
    -> addr_trans_grabbed13;
    @(posedge vif13.pclock13);
    if(trans_collected13.direction13 == APB_READ13) begin
        if(vif13.pready13 != 1'b1)
          @(posedge vif13.pclock13);
      trans_collected13.data = vif13.prdata13;
      end
    this.end_tr(trans_collected13);
    item_collected_port13.write(trans_collected13);
    `uvm_info(get_type_name(), $psprintf("Transfer13 collected13 :\n%s",
              trans_collected13.sprint()), UVM_MEDIUM)
      `ifdef HEAP13
      runq13.push_back(trans_collected13);
      `endif
     num_transactions13++;
    end
endtask : collect_transactions13

task apb_collector13::peek(output apb_transfer13 trans13);
  @addr_trans_grabbed13;
  trans13 = trans_collected13;
endtask : peek

function void apb_collector13::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report13: APB13 collector13 collected13 %0d transfers13", num_transactions13), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV13
