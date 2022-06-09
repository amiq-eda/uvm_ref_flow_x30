/*******************************************************************************
  FILE : apb_monitor27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV27
`define APB_MONITOR_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_monitor27
//------------------------------------------------------------------------------

class apb_monitor27 extends uvm_monitor;

  // Property27 indicating the number27 of transactions occuring27 on the apb27.
  protected int unsigned num_transactions27 = 0;
  // FOR27 UVM_ACCEL27
  //protected uvm_abstraction_level_t27 abstraction_level27 = RTL27;
  //protected uvma_output_pipe_proxy27#(apb_transfer27) m_op27;

  //APB27 Configuration27 Class27
  apb_config27 cfg;

  // The following27 two27 bits are used to control27 whether27 checks27 and coverage27 are
  // done both in the monitor27 class and the interface.
  bit checks_enable27 = 1; 
  bit coverage_enable27 = 1;

  // TLM PORT for sending27 transaction OUT27 to scoreboard27, register database, etc27
  uvm_analysis_port #(apb_transfer27) item_collected_port27;

  // TLM Connection27 to the Collector27 - look27 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer27, apb_monitor27) coll_mon_port27;

  // Allows27 the sequencer to look27 at monitored27 data for responses27
  uvm_blocking_peek_imp#(apb_transfer27,apb_monitor27) addr_trans_export27;
 
  // Allows27 monitor27 to look27 at collector27 for address information
  uvm_blocking_peek_port#(apb_transfer27) addr_trans_port27;

  event trans_addr_grabbed27;

  // The current apb_transfer27
  protected apb_transfer27 trans_collected27;

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor27)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable27, UVM_DEFAULT)
    `uvm_field_int(coverage_enable27, UVM_DEFAULT)
    `uvm_field_int(num_transactions27, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg27;
    TRANS_ADDR27 : coverpoint trans_collected27.addr {
      bins ZERO27 = {0};
      bins NON_ZERO27 = {[1:8'h7f]};
    }
    TRANS_DIRECTION27 : coverpoint trans_collected27.direction27 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA27 : coverpoint trans_collected27.data {
      bins ZERO27     = {0};
      bins NON_ZERO27 = {[1:8'hfe]};
      bins ALL_ONES27 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION27: cross TRANS_ADDR27, TRANS_DIRECTION27;
  endgroup

  // Constructor27 - required27 syntax27 for UVM automation27 and utilities27
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected27 = new();
    // Create27 covergroup only if coverage27 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable27", coverage_enable27));
    if (coverage_enable27) begin
       apb_transfer_cg27 = new();
       apb_transfer_cg27.set_inst_name({get_full_name(), ".apb_transfer_cg27"});
    end
    // Create27 TLM ports27
    item_collected_port27 = new("item_collected_port27", this);
    coll_mon_port27 = new("coll_mon_port27", this);
    addr_trans_export27 = new("addr_trans_export27", this);
    addr_trans_port27   = new("addr_trans_port27", this);
  endfunction : new

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer27 trans27); // Interface27 to the sequencer 
  // Receives27 transfers27 from the collector27
  extern virtual function void write(apb_transfer27 trans27);
  extern protected function void perform_checks27();
  extern virtual protected function void perform_coverage27();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor27

// UVM build_phase
function void apb_monitor27::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config27)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG27", "apb_config27 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor27::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port27.peek(trans_collected27);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete27: %h[%s]", trans_collected27.addr, trans_collected27.direction27.name() ), UVM_HIGH)
    -> trans_addr_grabbed27;
  end
endtask : run_phase

// FUNCTION27: peek - Allows27 the sequencer to peek at monitor27 for responses27
task apb_monitor27::peek(output apb_transfer27 trans27);
  @trans_addr_grabbed27;
  trans27 = trans_collected27;
endtask

// FUNCTION27: write - transaction interface to the collector27
function void apb_monitor27::write(apb_transfer27 trans27);
  // Make27 a copy of the transaction (may not be necessary27!)
  $cast(trans_collected27, trans27.clone());
  num_transactions27++;  
  `uvm_info(get_type_name(), {"Transaction27 Collected27:\n", trans_collected27.sprint()}, UVM_HIGH)
  if (checks_enable27) perform_checks27();
  if (coverage_enable27) perform_coverage27();
  // Broadcast27 transaction to the rest27 of the environment27 (module UVC27)
  item_collected_port27.write(trans_collected27);
endfunction : write

// FUNCTION27: perform_checks27()
function void apb_monitor27::perform_checks27();
  // Add checks27 here27
endfunction : perform_checks27

// FUNCTION27 : perform_coverage27()
function void apb_monitor27::perform_coverage27();
  apb_transfer_cg27.sample();
endfunction : perform_coverage27

// FUNCTION27: UVM report() phase
function void apb_monitor27::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report27: APB27 monitor27 collected27 %0d transfers27", num_transactions27), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV27
