/*******************************************************************************
  FILE : apb_monitor24.sv
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV24
`define APB_MONITOR_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_monitor24
//------------------------------------------------------------------------------

class apb_monitor24 extends uvm_monitor;

  // Property24 indicating the number24 of transactions occuring24 on the apb24.
  protected int unsigned num_transactions24 = 0;
  // FOR24 UVM_ACCEL24
  //protected uvm_abstraction_level_t24 abstraction_level24 = RTL24;
  //protected uvma_output_pipe_proxy24#(apb_transfer24) m_op24;

  //APB24 Configuration24 Class24
  apb_config24 cfg;

  // The following24 two24 bits are used to control24 whether24 checks24 and coverage24 are
  // done both in the monitor24 class and the interface.
  bit checks_enable24 = 1; 
  bit coverage_enable24 = 1;

  // TLM PORT for sending24 transaction OUT24 to scoreboard24, register database, etc24
  uvm_analysis_port #(apb_transfer24) item_collected_port24;

  // TLM Connection24 to the Collector24 - look24 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer24, apb_monitor24) coll_mon_port24;

  // Allows24 the sequencer to look24 at monitored24 data for responses24
  uvm_blocking_peek_imp#(apb_transfer24,apb_monitor24) addr_trans_export24;
 
  // Allows24 monitor24 to look24 at collector24 for address information
  uvm_blocking_peek_port#(apb_transfer24) addr_trans_port24;

  event trans_addr_grabbed24;

  // The current apb_transfer24
  protected apb_transfer24 trans_collected24;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor24)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable24, UVM_DEFAULT)
    `uvm_field_int(coverage_enable24, UVM_DEFAULT)
    `uvm_field_int(num_transactions24, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg24;
    TRANS_ADDR24 : coverpoint trans_collected24.addr {
      bins ZERO24 = {0};
      bins NON_ZERO24 = {[1:8'h7f]};
    }
    TRANS_DIRECTION24 : coverpoint trans_collected24.direction24 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA24 : coverpoint trans_collected24.data {
      bins ZERO24     = {0};
      bins NON_ZERO24 = {[1:8'hfe]};
      bins ALL_ONES24 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION24: cross TRANS_ADDR24, TRANS_DIRECTION24;
  endgroup

  // Constructor24 - required24 syntax24 for UVM automation24 and utilities24
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected24 = new();
    // Create24 covergroup only if coverage24 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable24", coverage_enable24));
    if (coverage_enable24) begin
       apb_transfer_cg24 = new();
       apb_transfer_cg24.set_inst_name({get_full_name(), ".apb_transfer_cg24"});
    end
    // Create24 TLM ports24
    item_collected_port24 = new("item_collected_port24", this);
    coll_mon_port24 = new("coll_mon_port24", this);
    addr_trans_export24 = new("addr_trans_export24", this);
    addr_trans_port24   = new("addr_trans_port24", this);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer24 trans24); // Interface24 to the sequencer 
  // Receives24 transfers24 from the collector24
  extern virtual function void write(apb_transfer24 trans24);
  extern protected function void perform_checks24();
  extern virtual protected function void perform_coverage24();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor24

// UVM build_phase
function void apb_monitor24::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config24)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG24", "apb_config24 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor24::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port24.peek(trans_collected24);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete24: %h[%s]", trans_collected24.addr, trans_collected24.direction24.name() ), UVM_HIGH)
    -> trans_addr_grabbed24;
  end
endtask : run_phase

// FUNCTION24: peek - Allows24 the sequencer to peek at monitor24 for responses24
task apb_monitor24::peek(output apb_transfer24 trans24);
  @trans_addr_grabbed24;
  trans24 = trans_collected24;
endtask

// FUNCTION24: write - transaction interface to the collector24
function void apb_monitor24::write(apb_transfer24 trans24);
  // Make24 a copy of the transaction (may not be necessary24!)
  $cast(trans_collected24, trans24.clone());
  num_transactions24++;  
  `uvm_info(get_type_name(), {"Transaction24 Collected24:\n", trans_collected24.sprint()}, UVM_HIGH)
  if (checks_enable24) perform_checks24();
  if (coverage_enable24) perform_coverage24();
  // Broadcast24 transaction to the rest24 of the environment24 (module UVC24)
  item_collected_port24.write(trans_collected24);
endfunction : write

// FUNCTION24: perform_checks24()
function void apb_monitor24::perform_checks24();
  // Add checks24 here24
endfunction : perform_checks24

// FUNCTION24 : perform_coverage24()
function void apb_monitor24::perform_coverage24();
  apb_transfer_cg24.sample();
endfunction : perform_coverage24

// FUNCTION24: UVM report() phase
function void apb_monitor24::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report24: APB24 monitor24 collected24 %0d transfers24", num_transactions24), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV24
