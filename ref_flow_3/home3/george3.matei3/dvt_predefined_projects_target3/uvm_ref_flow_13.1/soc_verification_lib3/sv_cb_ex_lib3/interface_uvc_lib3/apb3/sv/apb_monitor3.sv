/*******************************************************************************
  FILE : apb_monitor3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV3
`define APB_MONITOR_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_monitor3
//------------------------------------------------------------------------------

class apb_monitor3 extends uvm_monitor;

  // Property3 indicating the number3 of transactions occuring3 on the apb3.
  protected int unsigned num_transactions3 = 0;
  // FOR3 UVM_ACCEL3
  //protected uvm_abstraction_level_t3 abstraction_level3 = RTL3;
  //protected uvma_output_pipe_proxy3#(apb_transfer3) m_op3;

  //APB3 Configuration3 Class3
  apb_config3 cfg;

  // The following3 two3 bits are used to control3 whether3 checks3 and coverage3 are
  // done both in the monitor3 class and the interface.
  bit checks_enable3 = 1; 
  bit coverage_enable3 = 1;

  // TLM PORT for sending3 transaction OUT3 to scoreboard3, register database, etc3
  uvm_analysis_port #(apb_transfer3) item_collected_port3;

  // TLM Connection3 to the Collector3 - look3 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer3, apb_monitor3) coll_mon_port3;

  // Allows3 the sequencer to look3 at monitored3 data for responses3
  uvm_blocking_peek_imp#(apb_transfer3,apb_monitor3) addr_trans_export3;
 
  // Allows3 monitor3 to look3 at collector3 for address information
  uvm_blocking_peek_port#(apb_transfer3) addr_trans_port3;

  event trans_addr_grabbed3;

  // The current apb_transfer3
  protected apb_transfer3 trans_collected3;

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor3)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable3, UVM_DEFAULT)
    `uvm_field_int(coverage_enable3, UVM_DEFAULT)
    `uvm_field_int(num_transactions3, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg3;
    TRANS_ADDR3 : coverpoint trans_collected3.addr {
      bins ZERO3 = {0};
      bins NON_ZERO3 = {[1:8'h7f]};
    }
    TRANS_DIRECTION3 : coverpoint trans_collected3.direction3 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA3 : coverpoint trans_collected3.data {
      bins ZERO3     = {0};
      bins NON_ZERO3 = {[1:8'hfe]};
      bins ALL_ONES3 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION3: cross TRANS_ADDR3, TRANS_DIRECTION3;
  endgroup

  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected3 = new();
    // Create3 covergroup only if coverage3 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable3", coverage_enable3));
    if (coverage_enable3) begin
       apb_transfer_cg3 = new();
       apb_transfer_cg3.set_inst_name({get_full_name(), ".apb_transfer_cg3"});
    end
    // Create3 TLM ports3
    item_collected_port3 = new("item_collected_port3", this);
    coll_mon_port3 = new("coll_mon_port3", this);
    addr_trans_export3 = new("addr_trans_export3", this);
    addr_trans_port3   = new("addr_trans_port3", this);
  endfunction : new

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer3 trans3); // Interface3 to the sequencer 
  // Receives3 transfers3 from the collector3
  extern virtual function void write(apb_transfer3 trans3);
  extern protected function void perform_checks3();
  extern virtual protected function void perform_coverage3();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor3

// UVM build_phase
function void apb_monitor3::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config3)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG3", "apb_config3 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor3::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port3.peek(trans_collected3);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete3: %h[%s]", trans_collected3.addr, trans_collected3.direction3.name() ), UVM_HIGH)
    -> trans_addr_grabbed3;
  end
endtask : run_phase

// FUNCTION3: peek - Allows3 the sequencer to peek at monitor3 for responses3
task apb_monitor3::peek(output apb_transfer3 trans3);
  @trans_addr_grabbed3;
  trans3 = trans_collected3;
endtask

// FUNCTION3: write - transaction interface to the collector3
function void apb_monitor3::write(apb_transfer3 trans3);
  // Make3 a copy of the transaction (may not be necessary3!)
  $cast(trans_collected3, trans3.clone());
  num_transactions3++;  
  `uvm_info(get_type_name(), {"Transaction3 Collected3:\n", trans_collected3.sprint()}, UVM_HIGH)
  if (checks_enable3) perform_checks3();
  if (coverage_enable3) perform_coverage3();
  // Broadcast3 transaction to the rest3 of the environment3 (module UVC3)
  item_collected_port3.write(trans_collected3);
endfunction : write

// FUNCTION3: perform_checks3()
function void apb_monitor3::perform_checks3();
  // Add checks3 here3
endfunction : perform_checks3

// FUNCTION3 : perform_coverage3()
function void apb_monitor3::perform_coverage3();
  apb_transfer_cg3.sample();
endfunction : perform_coverage3

// FUNCTION3: UVM report() phase
function void apb_monitor3::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report3: APB3 monitor3 collected3 %0d transfers3", num_transactions3), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV3
