/*******************************************************************************
  FILE : apb_monitor1.sv
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV1
`define APB_MONITOR_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_monitor1
//------------------------------------------------------------------------------

class apb_monitor1 extends uvm_monitor;

  // Property1 indicating the number1 of transactions occuring1 on the apb1.
  protected int unsigned num_transactions1 = 0;
  // FOR1 UVM_ACCEL1
  //protected uvm_abstraction_level_t1 abstraction_level1 = RTL1;
  //protected uvma_output_pipe_proxy1#(apb_transfer1) m_op1;

  //APB1 Configuration1 Class1
  apb_config1 cfg;

  // The following1 two1 bits are used to control1 whether1 checks1 and coverage1 are
  // done both in the monitor1 class and the interface.
  bit checks_enable1 = 1; 
  bit coverage_enable1 = 1;

  // TLM PORT for sending1 transaction OUT1 to scoreboard1, register database, etc1
  uvm_analysis_port #(apb_transfer1) item_collected_port1;

  // TLM Connection1 to the Collector1 - look1 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer1, apb_monitor1) coll_mon_port1;

  // Allows1 the sequencer to look1 at monitored1 data for responses1
  uvm_blocking_peek_imp#(apb_transfer1,apb_monitor1) addr_trans_export1;
 
  // Allows1 monitor1 to look1 at collector1 for address information
  uvm_blocking_peek_port#(apb_transfer1) addr_trans_port1;

  event trans_addr_grabbed1;

  // The current apb_transfer1
  protected apb_transfer1 trans_collected1;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor1)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable1, UVM_DEFAULT)
    `uvm_field_int(coverage_enable1, UVM_DEFAULT)
    `uvm_field_int(num_transactions1, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg1;
    TRANS_ADDR1 : coverpoint trans_collected1.addr {
      bins ZERO1 = {0};
      bins NON_ZERO1 = {[1:8'h7f]};
    }
    TRANS_DIRECTION1 : coverpoint trans_collected1.direction1 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA1 : coverpoint trans_collected1.data {
      bins ZERO1     = {0};
      bins NON_ZERO1 = {[1:8'hfe]};
      bins ALL_ONES1 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION1: cross TRANS_ADDR1, TRANS_DIRECTION1;
  endgroup

  // Constructor1 - required1 syntax1 for UVM automation1 and utilities1
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected1 = new();
    // Create1 covergroup only if coverage1 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable1", coverage_enable1));
    if (coverage_enable1) begin
       apb_transfer_cg1 = new();
       apb_transfer_cg1.set_inst_name({get_full_name(), ".apb_transfer_cg1"});
    end
    // Create1 TLM ports1
    item_collected_port1 = new("item_collected_port1", this);
    coll_mon_port1 = new("coll_mon_port1", this);
    addr_trans_export1 = new("addr_trans_export1", this);
    addr_trans_port1   = new("addr_trans_port1", this);
  endfunction : new

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer1 trans1); // Interface1 to the sequencer 
  // Receives1 transfers1 from the collector1
  extern virtual function void write(apb_transfer1 trans1);
  extern protected function void perform_checks1();
  extern virtual protected function void perform_coverage1();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor1

// UVM build_phase
function void apb_monitor1::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config1)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG1", "apb_config1 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor1::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port1.peek(trans_collected1);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete1: %h[%s]", trans_collected1.addr, trans_collected1.direction1.name() ), UVM_HIGH)
    -> trans_addr_grabbed1;
  end
endtask : run_phase

// FUNCTION1: peek - Allows1 the sequencer to peek at monitor1 for responses1
task apb_monitor1::peek(output apb_transfer1 trans1);
  @trans_addr_grabbed1;
  trans1 = trans_collected1;
endtask

// FUNCTION1: write - transaction interface to the collector1
function void apb_monitor1::write(apb_transfer1 trans1);
  // Make1 a copy of the transaction (may not be necessary1!)
  $cast(trans_collected1, trans1.clone());
  num_transactions1++;  
  `uvm_info(get_type_name(), {"Transaction1 Collected1:\n", trans_collected1.sprint()}, UVM_HIGH)
  if (checks_enable1) perform_checks1();
  if (coverage_enable1) perform_coverage1();
  // Broadcast1 transaction to the rest1 of the environment1 (module UVC1)
  item_collected_port1.write(trans_collected1);
endfunction : write

// FUNCTION1: perform_checks1()
function void apb_monitor1::perform_checks1();
  // Add checks1 here1
endfunction : perform_checks1

// FUNCTION1 : perform_coverage1()
function void apb_monitor1::perform_coverage1();
  apb_transfer_cg1.sample();
endfunction : perform_coverage1

// FUNCTION1: UVM report() phase
function void apb_monitor1::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report1: APB1 monitor1 collected1 %0d transfers1", num_transactions1), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV1
