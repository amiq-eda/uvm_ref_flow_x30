/*******************************************************************************
  FILE : apb_monitor17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV17
`define APB_MONITOR_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_monitor17
//------------------------------------------------------------------------------

class apb_monitor17 extends uvm_monitor;

  // Property17 indicating the number17 of transactions occuring17 on the apb17.
  protected int unsigned num_transactions17 = 0;
  // FOR17 UVM_ACCEL17
  //protected uvm_abstraction_level_t17 abstraction_level17 = RTL17;
  //protected uvma_output_pipe_proxy17#(apb_transfer17) m_op17;

  //APB17 Configuration17 Class17
  apb_config17 cfg;

  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done both in the monitor17 class and the interface.
  bit checks_enable17 = 1; 
  bit coverage_enable17 = 1;

  // TLM PORT for sending17 transaction OUT17 to scoreboard17, register database, etc17
  uvm_analysis_port #(apb_transfer17) item_collected_port17;

  // TLM Connection17 to the Collector17 - look17 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer17, apb_monitor17) coll_mon_port17;

  // Allows17 the sequencer to look17 at monitored17 data for responses17
  uvm_blocking_peek_imp#(apb_transfer17,apb_monitor17) addr_trans_export17;
 
  // Allows17 monitor17 to look17 at collector17 for address information
  uvm_blocking_peek_port#(apb_transfer17) addr_trans_port17;

  event trans_addr_grabbed17;

  // The current apb_transfer17
  protected apb_transfer17 trans_collected17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor17)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable17, UVM_DEFAULT)
    `uvm_field_int(coverage_enable17, UVM_DEFAULT)
    `uvm_field_int(num_transactions17, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg17;
    TRANS_ADDR17 : coverpoint trans_collected17.addr {
      bins ZERO17 = {0};
      bins NON_ZERO17 = {[1:8'h7f]};
    }
    TRANS_DIRECTION17 : coverpoint trans_collected17.direction17 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA17 : coverpoint trans_collected17.data {
      bins ZERO17     = {0};
      bins NON_ZERO17 = {[1:8'hfe]};
      bins ALL_ONES17 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION17: cross TRANS_ADDR17, TRANS_DIRECTION17;
  endgroup

  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected17 = new();
    // Create17 covergroup only if coverage17 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable17", coverage_enable17));
    if (coverage_enable17) begin
       apb_transfer_cg17 = new();
       apb_transfer_cg17.set_inst_name({get_full_name(), ".apb_transfer_cg17"});
    end
    // Create17 TLM ports17
    item_collected_port17 = new("item_collected_port17", this);
    coll_mon_port17 = new("coll_mon_port17", this);
    addr_trans_export17 = new("addr_trans_export17", this);
    addr_trans_port17   = new("addr_trans_port17", this);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer17 trans17); // Interface17 to the sequencer 
  // Receives17 transfers17 from the collector17
  extern virtual function void write(apb_transfer17 trans17);
  extern protected function void perform_checks17();
  extern virtual protected function void perform_coverage17();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor17

// UVM build_phase
function void apb_monitor17::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config17)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG17", "apb_config17 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor17::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port17.peek(trans_collected17);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete17: %h[%s]", trans_collected17.addr, trans_collected17.direction17.name() ), UVM_HIGH)
    -> trans_addr_grabbed17;
  end
endtask : run_phase

// FUNCTION17: peek - Allows17 the sequencer to peek at monitor17 for responses17
task apb_monitor17::peek(output apb_transfer17 trans17);
  @trans_addr_grabbed17;
  trans17 = trans_collected17;
endtask

// FUNCTION17: write - transaction interface to the collector17
function void apb_monitor17::write(apb_transfer17 trans17);
  // Make17 a copy of the transaction (may not be necessary17!)
  $cast(trans_collected17, trans17.clone());
  num_transactions17++;  
  `uvm_info(get_type_name(), {"Transaction17 Collected17:\n", trans_collected17.sprint()}, UVM_HIGH)
  if (checks_enable17) perform_checks17();
  if (coverage_enable17) perform_coverage17();
  // Broadcast17 transaction to the rest17 of the environment17 (module UVC17)
  item_collected_port17.write(trans_collected17);
endfunction : write

// FUNCTION17: perform_checks17()
function void apb_monitor17::perform_checks17();
  // Add checks17 here17
endfunction : perform_checks17

// FUNCTION17 : perform_coverage17()
function void apb_monitor17::perform_coverage17();
  apb_transfer_cg17.sample();
endfunction : perform_coverage17

// FUNCTION17: UVM report() phase
function void apb_monitor17::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report17: APB17 monitor17 collected17 %0d transfers17", num_transactions17), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV17
