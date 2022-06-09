/*******************************************************************************
  FILE : apb_monitor22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV22
`define APB_MONITOR_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_monitor22
//------------------------------------------------------------------------------

class apb_monitor22 extends uvm_monitor;

  // Property22 indicating the number22 of transactions occuring22 on the apb22.
  protected int unsigned num_transactions22 = 0;
  // FOR22 UVM_ACCEL22
  //protected uvm_abstraction_level_t22 abstraction_level22 = RTL22;
  //protected uvma_output_pipe_proxy22#(apb_transfer22) m_op22;

  //APB22 Configuration22 Class22
  apb_config22 cfg;

  // The following22 two22 bits are used to control22 whether22 checks22 and coverage22 are
  // done both in the monitor22 class and the interface.
  bit checks_enable22 = 1; 
  bit coverage_enable22 = 1;

  // TLM PORT for sending22 transaction OUT22 to scoreboard22, register database, etc22
  uvm_analysis_port #(apb_transfer22) item_collected_port22;

  // TLM Connection22 to the Collector22 - look22 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer22, apb_monitor22) coll_mon_port22;

  // Allows22 the sequencer to look22 at monitored22 data for responses22
  uvm_blocking_peek_imp#(apb_transfer22,apb_monitor22) addr_trans_export22;
 
  // Allows22 monitor22 to look22 at collector22 for address information
  uvm_blocking_peek_port#(apb_transfer22) addr_trans_port22;

  event trans_addr_grabbed22;

  // The current apb_transfer22
  protected apb_transfer22 trans_collected22;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor22)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable22, UVM_DEFAULT)
    `uvm_field_int(coverage_enable22, UVM_DEFAULT)
    `uvm_field_int(num_transactions22, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg22;
    TRANS_ADDR22 : coverpoint trans_collected22.addr {
      bins ZERO22 = {0};
      bins NON_ZERO22 = {[1:8'h7f]};
    }
    TRANS_DIRECTION22 : coverpoint trans_collected22.direction22 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA22 : coverpoint trans_collected22.data {
      bins ZERO22     = {0};
      bins NON_ZERO22 = {[1:8'hfe]};
      bins ALL_ONES22 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION22: cross TRANS_ADDR22, TRANS_DIRECTION22;
  endgroup

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected22 = new();
    // Create22 covergroup only if coverage22 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable22", coverage_enable22));
    if (coverage_enable22) begin
       apb_transfer_cg22 = new();
       apb_transfer_cg22.set_inst_name({get_full_name(), ".apb_transfer_cg22"});
    end
    // Create22 TLM ports22
    item_collected_port22 = new("item_collected_port22", this);
    coll_mon_port22 = new("coll_mon_port22", this);
    addr_trans_export22 = new("addr_trans_export22", this);
    addr_trans_port22   = new("addr_trans_port22", this);
  endfunction : new

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer22 trans22); // Interface22 to the sequencer 
  // Receives22 transfers22 from the collector22
  extern virtual function void write(apb_transfer22 trans22);
  extern protected function void perform_checks22();
  extern virtual protected function void perform_coverage22();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor22

// UVM build_phase
function void apb_monitor22::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config22)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG22", "apb_config22 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor22::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port22.peek(trans_collected22);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete22: %h[%s]", trans_collected22.addr, trans_collected22.direction22.name() ), UVM_HIGH)
    -> trans_addr_grabbed22;
  end
endtask : run_phase

// FUNCTION22: peek - Allows22 the sequencer to peek at monitor22 for responses22
task apb_monitor22::peek(output apb_transfer22 trans22);
  @trans_addr_grabbed22;
  trans22 = trans_collected22;
endtask

// FUNCTION22: write - transaction interface to the collector22
function void apb_monitor22::write(apb_transfer22 trans22);
  // Make22 a copy of the transaction (may not be necessary22!)
  $cast(trans_collected22, trans22.clone());
  num_transactions22++;  
  `uvm_info(get_type_name(), {"Transaction22 Collected22:\n", trans_collected22.sprint()}, UVM_HIGH)
  if (checks_enable22) perform_checks22();
  if (coverage_enable22) perform_coverage22();
  // Broadcast22 transaction to the rest22 of the environment22 (module UVC22)
  item_collected_port22.write(trans_collected22);
endfunction : write

// FUNCTION22: perform_checks22()
function void apb_monitor22::perform_checks22();
  // Add checks22 here22
endfunction : perform_checks22

// FUNCTION22 : perform_coverage22()
function void apb_monitor22::perform_coverage22();
  apb_transfer_cg22.sample();
endfunction : perform_coverage22

// FUNCTION22: UVM report() phase
function void apb_monitor22::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report22: APB22 monitor22 collected22 %0d transfers22", num_transactions22), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV22
