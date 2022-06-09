/*******************************************************************************
  FILE : apb_monitor8.sv
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


`ifndef APB_MONITOR_SV8
`define APB_MONITOR_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_monitor8
//------------------------------------------------------------------------------

class apb_monitor8 extends uvm_monitor;

  // Property8 indicating the number8 of transactions occuring8 on the apb8.
  protected int unsigned num_transactions8 = 0;
  // FOR8 UVM_ACCEL8
  //protected uvm_abstraction_level_t8 abstraction_level8 = RTL8;
  //protected uvma_output_pipe_proxy8#(apb_transfer8) m_op8;

  //APB8 Configuration8 Class8
  apb_config8 cfg;

  // The following8 two8 bits are used to control8 whether8 checks8 and coverage8 are
  // done both in the monitor8 class and the interface.
  bit checks_enable8 = 1; 
  bit coverage_enable8 = 1;

  // TLM PORT for sending8 transaction OUT8 to scoreboard8, register database, etc8
  uvm_analysis_port #(apb_transfer8) item_collected_port8;

  // TLM Connection8 to the Collector8 - look8 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer8, apb_monitor8) coll_mon_port8;

  // Allows8 the sequencer to look8 at monitored8 data for responses8
  uvm_blocking_peek_imp#(apb_transfer8,apb_monitor8) addr_trans_export8;
 
  // Allows8 monitor8 to look8 at collector8 for address information
  uvm_blocking_peek_port#(apb_transfer8) addr_trans_port8;

  event trans_addr_grabbed8;

  // The current apb_transfer8
  protected apb_transfer8 trans_collected8;

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor8)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable8, UVM_DEFAULT)
    `uvm_field_int(coverage_enable8, UVM_DEFAULT)
    `uvm_field_int(num_transactions8, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg8;
    TRANS_ADDR8 : coverpoint trans_collected8.addr {
      bins ZERO8 = {0};
      bins NON_ZERO8 = {[1:8'h7f]};
    }
    TRANS_DIRECTION8 : coverpoint trans_collected8.direction8 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA8 : coverpoint trans_collected8.data {
      bins ZERO8     = {0};
      bins NON_ZERO8 = {[1:8'hfe]};
      bins ALL_ONES8 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION8: cross TRANS_ADDR8, TRANS_DIRECTION8;
  endgroup

  // Constructor8 - required8 syntax8 for UVM automation8 and utilities8
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected8 = new();
    // Create8 covergroup only if coverage8 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable8", coverage_enable8));
    if (coverage_enable8) begin
       apb_transfer_cg8 = new();
       apb_transfer_cg8.set_inst_name({get_full_name(), ".apb_transfer_cg8"});
    end
    // Create8 TLM ports8
    item_collected_port8 = new("item_collected_port8", this);
    coll_mon_port8 = new("coll_mon_port8", this);
    addr_trans_export8 = new("addr_trans_export8", this);
    addr_trans_port8   = new("addr_trans_port8", this);
  endfunction : new

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer8 trans8); // Interface8 to the sequencer 
  // Receives8 transfers8 from the collector8
  extern virtual function void write(apb_transfer8 trans8);
  extern protected function void perform_checks8();
  extern virtual protected function void perform_coverage8();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor8

// UVM build_phase
function void apb_monitor8::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config8)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG8", "apb_config8 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor8::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port8.peek(trans_collected8);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete8: %h[%s]", trans_collected8.addr, trans_collected8.direction8.name() ), UVM_HIGH)
    -> trans_addr_grabbed8;
  end
endtask : run_phase

// FUNCTION8: peek - Allows8 the sequencer to peek at monitor8 for responses8
task apb_monitor8::peek(output apb_transfer8 trans8);
  @trans_addr_grabbed8;
  trans8 = trans_collected8;
endtask

// FUNCTION8: write - transaction interface to the collector8
function void apb_monitor8::write(apb_transfer8 trans8);
  // Make8 a copy of the transaction (may not be necessary8!)
  $cast(trans_collected8, trans8.clone());
  num_transactions8++;  
  `uvm_info(get_type_name(), {"Transaction8 Collected8:\n", trans_collected8.sprint()}, UVM_HIGH)
  if (checks_enable8) perform_checks8();
  if (coverage_enable8) perform_coverage8();
  // Broadcast8 transaction to the rest8 of the environment8 (module UVC8)
  item_collected_port8.write(trans_collected8);
endfunction : write

// FUNCTION8: perform_checks8()
function void apb_monitor8::perform_checks8();
  // Add checks8 here8
endfunction : perform_checks8

// FUNCTION8 : perform_coverage8()
function void apb_monitor8::perform_coverage8();
  apb_transfer_cg8.sample();
endfunction : perform_coverage8

// FUNCTION8: UVM report() phase
function void apb_monitor8::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report8: APB8 monitor8 collected8 %0d transfers8", num_transactions8), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV8
