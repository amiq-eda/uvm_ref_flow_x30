/*******************************************************************************
  FILE : apb_monitor13.sv
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


`ifndef APB_MONITOR_SV13
`define APB_MONITOR_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_monitor13
//------------------------------------------------------------------------------

class apb_monitor13 extends uvm_monitor;

  // Property13 indicating the number13 of transactions occuring13 on the apb13.
  protected int unsigned num_transactions13 = 0;
  // FOR13 UVM_ACCEL13
  //protected uvm_abstraction_level_t13 abstraction_level13 = RTL13;
  //protected uvma_output_pipe_proxy13#(apb_transfer13) m_op13;

  //APB13 Configuration13 Class13
  apb_config13 cfg;

  // The following13 two13 bits are used to control13 whether13 checks13 and coverage13 are
  // done both in the monitor13 class and the interface.
  bit checks_enable13 = 1; 
  bit coverage_enable13 = 1;

  // TLM PORT for sending13 transaction OUT13 to scoreboard13, register database, etc13
  uvm_analysis_port #(apb_transfer13) item_collected_port13;

  // TLM Connection13 to the Collector13 - look13 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer13, apb_monitor13) coll_mon_port13;

  // Allows13 the sequencer to look13 at monitored13 data for responses13
  uvm_blocking_peek_imp#(apb_transfer13,apb_monitor13) addr_trans_export13;
 
  // Allows13 monitor13 to look13 at collector13 for address information
  uvm_blocking_peek_port#(apb_transfer13) addr_trans_port13;

  event trans_addr_grabbed13;

  // The current apb_transfer13
  protected apb_transfer13 trans_collected13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor13)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable13, UVM_DEFAULT)
    `uvm_field_int(coverage_enable13, UVM_DEFAULT)
    `uvm_field_int(num_transactions13, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg13;
    TRANS_ADDR13 : coverpoint trans_collected13.addr {
      bins ZERO13 = {0};
      bins NON_ZERO13 = {[1:8'h7f]};
    }
    TRANS_DIRECTION13 : coverpoint trans_collected13.direction13 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA13 : coverpoint trans_collected13.data {
      bins ZERO13     = {0};
      bins NON_ZERO13 = {[1:8'hfe]};
      bins ALL_ONES13 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION13: cross TRANS_ADDR13, TRANS_DIRECTION13;
  endgroup

  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected13 = new();
    // Create13 covergroup only if coverage13 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable13", coverage_enable13));
    if (coverage_enable13) begin
       apb_transfer_cg13 = new();
       apb_transfer_cg13.set_inst_name({get_full_name(), ".apb_transfer_cg13"});
    end
    // Create13 TLM ports13
    item_collected_port13 = new("item_collected_port13", this);
    coll_mon_port13 = new("coll_mon_port13", this);
    addr_trans_export13 = new("addr_trans_export13", this);
    addr_trans_port13   = new("addr_trans_port13", this);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer13 trans13); // Interface13 to the sequencer 
  // Receives13 transfers13 from the collector13
  extern virtual function void write(apb_transfer13 trans13);
  extern protected function void perform_checks13();
  extern virtual protected function void perform_coverage13();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor13

// UVM build_phase
function void apb_monitor13::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config13)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG13", "apb_config13 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor13::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port13.peek(trans_collected13);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete13: %h[%s]", trans_collected13.addr, trans_collected13.direction13.name() ), UVM_HIGH)
    -> trans_addr_grabbed13;
  end
endtask : run_phase

// FUNCTION13: peek - Allows13 the sequencer to peek at monitor13 for responses13
task apb_monitor13::peek(output apb_transfer13 trans13);
  @trans_addr_grabbed13;
  trans13 = trans_collected13;
endtask

// FUNCTION13: write - transaction interface to the collector13
function void apb_monitor13::write(apb_transfer13 trans13);
  // Make13 a copy of the transaction (may not be necessary13!)
  $cast(trans_collected13, trans13.clone());
  num_transactions13++;  
  `uvm_info(get_type_name(), {"Transaction13 Collected13:\n", trans_collected13.sprint()}, UVM_HIGH)
  if (checks_enable13) perform_checks13();
  if (coverage_enable13) perform_coverage13();
  // Broadcast13 transaction to the rest13 of the environment13 (module UVC13)
  item_collected_port13.write(trans_collected13);
endfunction : write

// FUNCTION13: perform_checks13()
function void apb_monitor13::perform_checks13();
  // Add checks13 here13
endfunction : perform_checks13

// FUNCTION13 : perform_coverage13()
function void apb_monitor13::perform_coverage13();
  apb_transfer_cg13.sample();
endfunction : perform_coverage13

// FUNCTION13: UVM report() phase
function void apb_monitor13::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report13: APB13 monitor13 collected13 %0d transfers13", num_transactions13), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV13
