/*******************************************************************************
  FILE : apb_monitor6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV6
`define APB_MONITOR_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_monitor6
//------------------------------------------------------------------------------

class apb_monitor6 extends uvm_monitor;

  // Property6 indicating the number6 of transactions occuring6 on the apb6.
  protected int unsigned num_transactions6 = 0;
  // FOR6 UVM_ACCEL6
  //protected uvm_abstraction_level_t6 abstraction_level6 = RTL6;
  //protected uvma_output_pipe_proxy6#(apb_transfer6) m_op6;

  //APB6 Configuration6 Class6
  apb_config6 cfg;

  // The following6 two6 bits are used to control6 whether6 checks6 and coverage6 are
  // done both in the monitor6 class and the interface.
  bit checks_enable6 = 1; 
  bit coverage_enable6 = 1;

  // TLM PORT for sending6 transaction OUT6 to scoreboard6, register database, etc6
  uvm_analysis_port #(apb_transfer6) item_collected_port6;

  // TLM Connection6 to the Collector6 - look6 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer6, apb_monitor6) coll_mon_port6;

  // Allows6 the sequencer to look6 at monitored6 data for responses6
  uvm_blocking_peek_imp#(apb_transfer6,apb_monitor6) addr_trans_export6;
 
  // Allows6 monitor6 to look6 at collector6 for address information
  uvm_blocking_peek_port#(apb_transfer6) addr_trans_port6;

  event trans_addr_grabbed6;

  // The current apb_transfer6
  protected apb_transfer6 trans_collected6;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor6)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable6, UVM_DEFAULT)
    `uvm_field_int(coverage_enable6, UVM_DEFAULT)
    `uvm_field_int(num_transactions6, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg6;
    TRANS_ADDR6 : coverpoint trans_collected6.addr {
      bins ZERO6 = {0};
      bins NON_ZERO6 = {[1:8'h7f]};
    }
    TRANS_DIRECTION6 : coverpoint trans_collected6.direction6 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA6 : coverpoint trans_collected6.data {
      bins ZERO6     = {0};
      bins NON_ZERO6 = {[1:8'hfe]};
      bins ALL_ONES6 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION6: cross TRANS_ADDR6, TRANS_DIRECTION6;
  endgroup

  // Constructor6 - required6 syntax6 for UVM automation6 and utilities6
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected6 = new();
    // Create6 covergroup only if coverage6 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable6", coverage_enable6));
    if (coverage_enable6) begin
       apb_transfer_cg6 = new();
       apb_transfer_cg6.set_inst_name({get_full_name(), ".apb_transfer_cg6"});
    end
    // Create6 TLM ports6
    item_collected_port6 = new("item_collected_port6", this);
    coll_mon_port6 = new("coll_mon_port6", this);
    addr_trans_export6 = new("addr_trans_export6", this);
    addr_trans_port6   = new("addr_trans_port6", this);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer6 trans6); // Interface6 to the sequencer 
  // Receives6 transfers6 from the collector6
  extern virtual function void write(apb_transfer6 trans6);
  extern protected function void perform_checks6();
  extern virtual protected function void perform_coverage6();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor6

// UVM build_phase
function void apb_monitor6::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config6)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG6", "apb_config6 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor6::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port6.peek(trans_collected6);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete6: %h[%s]", trans_collected6.addr, trans_collected6.direction6.name() ), UVM_HIGH)
    -> trans_addr_grabbed6;
  end
endtask : run_phase

// FUNCTION6: peek - Allows6 the sequencer to peek at monitor6 for responses6
task apb_monitor6::peek(output apb_transfer6 trans6);
  @trans_addr_grabbed6;
  trans6 = trans_collected6;
endtask

// FUNCTION6: write - transaction interface to the collector6
function void apb_monitor6::write(apb_transfer6 trans6);
  // Make6 a copy of the transaction (may not be necessary6!)
  $cast(trans_collected6, trans6.clone());
  num_transactions6++;  
  `uvm_info(get_type_name(), {"Transaction6 Collected6:\n", trans_collected6.sprint()}, UVM_HIGH)
  if (checks_enable6) perform_checks6();
  if (coverage_enable6) perform_coverage6();
  // Broadcast6 transaction to the rest6 of the environment6 (module UVC6)
  item_collected_port6.write(trans_collected6);
endfunction : write

// FUNCTION6: perform_checks6()
function void apb_monitor6::perform_checks6();
  // Add checks6 here6
endfunction : perform_checks6

// FUNCTION6 : perform_coverage6()
function void apb_monitor6::perform_coverage6();
  apb_transfer_cg6.sample();
endfunction : perform_coverage6

// FUNCTION6: UVM report() phase
function void apb_monitor6::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report6: APB6 monitor6 collected6 %0d transfers6", num_transactions6), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV6
