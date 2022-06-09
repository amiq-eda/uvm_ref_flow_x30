/*******************************************************************************
  FILE : apb_monitor7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV7
`define APB_MONITOR_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_monitor7
//------------------------------------------------------------------------------

class apb_monitor7 extends uvm_monitor;

  // Property7 indicating the number7 of transactions occuring7 on the apb7.
  protected int unsigned num_transactions7 = 0;
  // FOR7 UVM_ACCEL7
  //protected uvm_abstraction_level_t7 abstraction_level7 = RTL7;
  //protected uvma_output_pipe_proxy7#(apb_transfer7) m_op7;

  //APB7 Configuration7 Class7
  apb_config7 cfg;

  // The following7 two7 bits are used to control7 whether7 checks7 and coverage7 are
  // done both in the monitor7 class and the interface.
  bit checks_enable7 = 1; 
  bit coverage_enable7 = 1;

  // TLM PORT for sending7 transaction OUT7 to scoreboard7, register database, etc7
  uvm_analysis_port #(apb_transfer7) item_collected_port7;

  // TLM Connection7 to the Collector7 - look7 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer7, apb_monitor7) coll_mon_port7;

  // Allows7 the sequencer to look7 at monitored7 data for responses7
  uvm_blocking_peek_imp#(apb_transfer7,apb_monitor7) addr_trans_export7;
 
  // Allows7 monitor7 to look7 at collector7 for address information
  uvm_blocking_peek_port#(apb_transfer7) addr_trans_port7;

  event trans_addr_grabbed7;

  // The current apb_transfer7
  protected apb_transfer7 trans_collected7;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor7)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable7, UVM_DEFAULT)
    `uvm_field_int(coverage_enable7, UVM_DEFAULT)
    `uvm_field_int(num_transactions7, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg7;
    TRANS_ADDR7 : coverpoint trans_collected7.addr {
      bins ZERO7 = {0};
      bins NON_ZERO7 = {[1:8'h7f]};
    }
    TRANS_DIRECTION7 : coverpoint trans_collected7.direction7 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA7 : coverpoint trans_collected7.data {
      bins ZERO7     = {0};
      bins NON_ZERO7 = {[1:8'hfe]};
      bins ALL_ONES7 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION7: cross TRANS_ADDR7, TRANS_DIRECTION7;
  endgroup

  // Constructor7 - required7 syntax7 for UVM automation7 and utilities7
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected7 = new();
    // Create7 covergroup only if coverage7 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable7", coverage_enable7));
    if (coverage_enable7) begin
       apb_transfer_cg7 = new();
       apb_transfer_cg7.set_inst_name({get_full_name(), ".apb_transfer_cg7"});
    end
    // Create7 TLM ports7
    item_collected_port7 = new("item_collected_port7", this);
    coll_mon_port7 = new("coll_mon_port7", this);
    addr_trans_export7 = new("addr_trans_export7", this);
    addr_trans_port7   = new("addr_trans_port7", this);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer7 trans7); // Interface7 to the sequencer 
  // Receives7 transfers7 from the collector7
  extern virtual function void write(apb_transfer7 trans7);
  extern protected function void perform_checks7();
  extern virtual protected function void perform_coverage7();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor7

// UVM build_phase
function void apb_monitor7::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config7)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG7", "apb_config7 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor7::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port7.peek(trans_collected7);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete7: %h[%s]", trans_collected7.addr, trans_collected7.direction7.name() ), UVM_HIGH)
    -> trans_addr_grabbed7;
  end
endtask : run_phase

// FUNCTION7: peek - Allows7 the sequencer to peek at monitor7 for responses7
task apb_monitor7::peek(output apb_transfer7 trans7);
  @trans_addr_grabbed7;
  trans7 = trans_collected7;
endtask

// FUNCTION7: write - transaction interface to the collector7
function void apb_monitor7::write(apb_transfer7 trans7);
  // Make7 a copy of the transaction (may not be necessary7!)
  $cast(trans_collected7, trans7.clone());
  num_transactions7++;  
  `uvm_info(get_type_name(), {"Transaction7 Collected7:\n", trans_collected7.sprint()}, UVM_HIGH)
  if (checks_enable7) perform_checks7();
  if (coverage_enable7) perform_coverage7();
  // Broadcast7 transaction to the rest7 of the environment7 (module UVC7)
  item_collected_port7.write(trans_collected7);
endfunction : write

// FUNCTION7: perform_checks7()
function void apb_monitor7::perform_checks7();
  // Add checks7 here7
endfunction : perform_checks7

// FUNCTION7 : perform_coverage7()
function void apb_monitor7::perform_coverage7();
  apb_transfer_cg7.sample();
endfunction : perform_coverage7

// FUNCTION7: UVM report() phase
function void apb_monitor7::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report7: APB7 monitor7 collected7 %0d transfers7", num_transactions7), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV7
