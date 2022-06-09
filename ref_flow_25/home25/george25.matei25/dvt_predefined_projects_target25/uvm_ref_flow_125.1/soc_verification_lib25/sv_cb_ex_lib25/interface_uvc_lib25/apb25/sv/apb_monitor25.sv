/*******************************************************************************
  FILE : apb_monitor25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV25
`define APB_MONITOR_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_monitor25
//------------------------------------------------------------------------------

class apb_monitor25 extends uvm_monitor;

  // Property25 indicating the number25 of transactions occuring25 on the apb25.
  protected int unsigned num_transactions25 = 0;
  // FOR25 UVM_ACCEL25
  //protected uvm_abstraction_level_t25 abstraction_level25 = RTL25;
  //protected uvma_output_pipe_proxy25#(apb_transfer25) m_op25;

  //APB25 Configuration25 Class25
  apb_config25 cfg;

  // The following25 two25 bits are used to control25 whether25 checks25 and coverage25 are
  // done both in the monitor25 class and the interface.
  bit checks_enable25 = 1; 
  bit coverage_enable25 = 1;

  // TLM PORT for sending25 transaction OUT25 to scoreboard25, register database, etc25
  uvm_analysis_port #(apb_transfer25) item_collected_port25;

  // TLM Connection25 to the Collector25 - look25 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer25, apb_monitor25) coll_mon_port25;

  // Allows25 the sequencer to look25 at monitored25 data for responses25
  uvm_blocking_peek_imp#(apb_transfer25,apb_monitor25) addr_trans_export25;
 
  // Allows25 monitor25 to look25 at collector25 for address information
  uvm_blocking_peek_port#(apb_transfer25) addr_trans_port25;

  event trans_addr_grabbed25;

  // The current apb_transfer25
  protected apb_transfer25 trans_collected25;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor25)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable25, UVM_DEFAULT)
    `uvm_field_int(coverage_enable25, UVM_DEFAULT)
    `uvm_field_int(num_transactions25, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg25;
    TRANS_ADDR25 : coverpoint trans_collected25.addr {
      bins ZERO25 = {0};
      bins NON_ZERO25 = {[1:8'h7f]};
    }
    TRANS_DIRECTION25 : coverpoint trans_collected25.direction25 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA25 : coverpoint trans_collected25.data {
      bins ZERO25     = {0};
      bins NON_ZERO25 = {[1:8'hfe]};
      bins ALL_ONES25 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION25: cross TRANS_ADDR25, TRANS_DIRECTION25;
  endgroup

  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected25 = new();
    // Create25 covergroup only if coverage25 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable25", coverage_enable25));
    if (coverage_enable25) begin
       apb_transfer_cg25 = new();
       apb_transfer_cg25.set_inst_name({get_full_name(), ".apb_transfer_cg25"});
    end
    // Create25 TLM ports25
    item_collected_port25 = new("item_collected_port25", this);
    coll_mon_port25 = new("coll_mon_port25", this);
    addr_trans_export25 = new("addr_trans_export25", this);
    addr_trans_port25   = new("addr_trans_port25", this);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer25 trans25); // Interface25 to the sequencer 
  // Receives25 transfers25 from the collector25
  extern virtual function void write(apb_transfer25 trans25);
  extern protected function void perform_checks25();
  extern virtual protected function void perform_coverage25();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor25

// UVM build_phase
function void apb_monitor25::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config25)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG25", "apb_config25 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor25::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port25.peek(trans_collected25);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete25: %h[%s]", trans_collected25.addr, trans_collected25.direction25.name() ), UVM_HIGH)
    -> trans_addr_grabbed25;
  end
endtask : run_phase

// FUNCTION25: peek - Allows25 the sequencer to peek at monitor25 for responses25
task apb_monitor25::peek(output apb_transfer25 trans25);
  @trans_addr_grabbed25;
  trans25 = trans_collected25;
endtask

// FUNCTION25: write - transaction interface to the collector25
function void apb_monitor25::write(apb_transfer25 trans25);
  // Make25 a copy of the transaction (may not be necessary25!)
  $cast(trans_collected25, trans25.clone());
  num_transactions25++;  
  `uvm_info(get_type_name(), {"Transaction25 Collected25:\n", trans_collected25.sprint()}, UVM_HIGH)
  if (checks_enable25) perform_checks25();
  if (coverage_enable25) perform_coverage25();
  // Broadcast25 transaction to the rest25 of the environment25 (module UVC25)
  item_collected_port25.write(trans_collected25);
endfunction : write

// FUNCTION25: perform_checks25()
function void apb_monitor25::perform_checks25();
  // Add checks25 here25
endfunction : perform_checks25

// FUNCTION25 : perform_coverage25()
function void apb_monitor25::perform_coverage25();
  apb_transfer_cg25.sample();
endfunction : perform_coverage25

// FUNCTION25: UVM report() phase
function void apb_monitor25::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report25: APB25 monitor25 collected25 %0d transfers25", num_transactions25), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV25
