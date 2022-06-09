/*******************************************************************************
  FILE : apb_monitor15.sv
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV15
`define APB_MONITOR_SV15

//------------------------------------------------------------------------------
// CLASS15: apb_monitor15
//------------------------------------------------------------------------------

class apb_monitor15 extends uvm_monitor;

  // Property15 indicating the number15 of transactions occuring15 on the apb15.
  protected int unsigned num_transactions15 = 0;
  // FOR15 UVM_ACCEL15
  //protected uvm_abstraction_level_t15 abstraction_level15 = RTL15;
  //protected uvma_output_pipe_proxy15#(apb_transfer15) m_op15;

  //APB15 Configuration15 Class15
  apb_config15 cfg;

  // The following15 two15 bits are used to control15 whether15 checks15 and coverage15 are
  // done both in the monitor15 class and the interface.
  bit checks_enable15 = 1; 
  bit coverage_enable15 = 1;

  // TLM PORT for sending15 transaction OUT15 to scoreboard15, register database, etc15
  uvm_analysis_port #(apb_transfer15) item_collected_port15;

  // TLM Connection15 to the Collector15 - look15 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer15, apb_monitor15) coll_mon_port15;

  // Allows15 the sequencer to look15 at monitored15 data for responses15
  uvm_blocking_peek_imp#(apb_transfer15,apb_monitor15) addr_trans_export15;
 
  // Allows15 monitor15 to look15 at collector15 for address information
  uvm_blocking_peek_port#(apb_transfer15) addr_trans_port15;

  event trans_addr_grabbed15;

  // The current apb_transfer15
  protected apb_transfer15 trans_collected15;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor15)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable15, UVM_DEFAULT)
    `uvm_field_int(coverage_enable15, UVM_DEFAULT)
    `uvm_field_int(num_transactions15, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg15;
    TRANS_ADDR15 : coverpoint trans_collected15.addr {
      bins ZERO15 = {0};
      bins NON_ZERO15 = {[1:8'h7f]};
    }
    TRANS_DIRECTION15 : coverpoint trans_collected15.direction15 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA15 : coverpoint trans_collected15.data {
      bins ZERO15     = {0};
      bins NON_ZERO15 = {[1:8'hfe]};
      bins ALL_ONES15 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION15: cross TRANS_ADDR15, TRANS_DIRECTION15;
  endgroup

  // Constructor15 - required15 syntax15 for UVM automation15 and utilities15
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected15 = new();
    // Create15 covergroup only if coverage15 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable15", coverage_enable15));
    if (coverage_enable15) begin
       apb_transfer_cg15 = new();
       apb_transfer_cg15.set_inst_name({get_full_name(), ".apb_transfer_cg15"});
    end
    // Create15 TLM ports15
    item_collected_port15 = new("item_collected_port15", this);
    coll_mon_port15 = new("coll_mon_port15", this);
    addr_trans_export15 = new("addr_trans_export15", this);
    addr_trans_port15   = new("addr_trans_port15", this);
  endfunction : new

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer15 trans15); // Interface15 to the sequencer 
  // Receives15 transfers15 from the collector15
  extern virtual function void write(apb_transfer15 trans15);
  extern protected function void perform_checks15();
  extern virtual protected function void perform_coverage15();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor15

// UVM build_phase
function void apb_monitor15::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config15)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG15", "apb_config15 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor15::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port15.peek(trans_collected15);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete15: %h[%s]", trans_collected15.addr, trans_collected15.direction15.name() ), UVM_HIGH)
    -> trans_addr_grabbed15;
  end
endtask : run_phase

// FUNCTION15: peek - Allows15 the sequencer to peek at monitor15 for responses15
task apb_monitor15::peek(output apb_transfer15 trans15);
  @trans_addr_grabbed15;
  trans15 = trans_collected15;
endtask

// FUNCTION15: write - transaction interface to the collector15
function void apb_monitor15::write(apb_transfer15 trans15);
  // Make15 a copy of the transaction (may not be necessary15!)
  $cast(trans_collected15, trans15.clone());
  num_transactions15++;  
  `uvm_info(get_type_name(), {"Transaction15 Collected15:\n", trans_collected15.sprint()}, UVM_HIGH)
  if (checks_enable15) perform_checks15();
  if (coverage_enable15) perform_coverage15();
  // Broadcast15 transaction to the rest15 of the environment15 (module UVC15)
  item_collected_port15.write(trans_collected15);
endfunction : write

// FUNCTION15: perform_checks15()
function void apb_monitor15::perform_checks15();
  // Add checks15 here15
endfunction : perform_checks15

// FUNCTION15 : perform_coverage15()
function void apb_monitor15::perform_coverage15();
  apb_transfer_cg15.sample();
endfunction : perform_coverage15

// FUNCTION15: UVM report() phase
function void apb_monitor15::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report15: APB15 monitor15 collected15 %0d transfers15", num_transactions15), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV15
