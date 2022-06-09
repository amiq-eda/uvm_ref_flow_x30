/*******************************************************************************
  FILE : apb_monitor2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV2
`define APB_MONITOR_SV2

//------------------------------------------------------------------------------
// CLASS2: apb_monitor2
//------------------------------------------------------------------------------

class apb_monitor2 extends uvm_monitor;

  // Property2 indicating the number2 of transactions occuring2 on the apb2.
  protected int unsigned num_transactions2 = 0;
  // FOR2 UVM_ACCEL2
  //protected uvm_abstraction_level_t2 abstraction_level2 = RTL2;
  //protected uvma_output_pipe_proxy2#(apb_transfer2) m_op2;

  //APB2 Configuration2 Class2
  apb_config2 cfg;

  // The following2 two2 bits are used to control2 whether2 checks2 and coverage2 are
  // done both in the monitor2 class and the interface.
  bit checks_enable2 = 1; 
  bit coverage_enable2 = 1;

  // TLM PORT for sending2 transaction OUT2 to scoreboard2, register database, etc2
  uvm_analysis_port #(apb_transfer2) item_collected_port2;

  // TLM Connection2 to the Collector2 - look2 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer2, apb_monitor2) coll_mon_port2;

  // Allows2 the sequencer to look2 at monitored2 data for responses2
  uvm_blocking_peek_imp#(apb_transfer2,apb_monitor2) addr_trans_export2;
 
  // Allows2 monitor2 to look2 at collector2 for address information
  uvm_blocking_peek_port#(apb_transfer2) addr_trans_port2;

  event trans_addr_grabbed2;

  // The current apb_transfer2
  protected apb_transfer2 trans_collected2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor2)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable2, UVM_DEFAULT)
    `uvm_field_int(coverage_enable2, UVM_DEFAULT)
    `uvm_field_int(num_transactions2, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg2;
    TRANS_ADDR2 : coverpoint trans_collected2.addr {
      bins ZERO2 = {0};
      bins NON_ZERO2 = {[1:8'h7f]};
    }
    TRANS_DIRECTION2 : coverpoint trans_collected2.direction2 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA2 : coverpoint trans_collected2.data {
      bins ZERO2     = {0};
      bins NON_ZERO2 = {[1:8'hfe]};
      bins ALL_ONES2 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION2: cross TRANS_ADDR2, TRANS_DIRECTION2;
  endgroup

  // Constructor2 - required2 syntax2 for UVM automation2 and utilities2
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected2 = new();
    // Create2 covergroup only if coverage2 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable2", coverage_enable2));
    if (coverage_enable2) begin
       apb_transfer_cg2 = new();
       apb_transfer_cg2.set_inst_name({get_full_name(), ".apb_transfer_cg2"});
    end
    // Create2 TLM ports2
    item_collected_port2 = new("item_collected_port2", this);
    coll_mon_port2 = new("coll_mon_port2", this);
    addr_trans_export2 = new("addr_trans_export2", this);
    addr_trans_port2   = new("addr_trans_port2", this);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer2 trans2); // Interface2 to the sequencer 
  // Receives2 transfers2 from the collector2
  extern virtual function void write(apb_transfer2 trans2);
  extern protected function void perform_checks2();
  extern virtual protected function void perform_coverage2();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor2

// UVM build_phase
function void apb_monitor2::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config2)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG2", "apb_config2 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor2::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port2.peek(trans_collected2);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete2: %h[%s]", trans_collected2.addr, trans_collected2.direction2.name() ), UVM_HIGH)
    -> trans_addr_grabbed2;
  end
endtask : run_phase

// FUNCTION2: peek - Allows2 the sequencer to peek at monitor2 for responses2
task apb_monitor2::peek(output apb_transfer2 trans2);
  @trans_addr_grabbed2;
  trans2 = trans_collected2;
endtask

// FUNCTION2: write - transaction interface to the collector2
function void apb_monitor2::write(apb_transfer2 trans2);
  // Make2 a copy of the transaction (may not be necessary2!)
  $cast(trans_collected2, trans2.clone());
  num_transactions2++;  
  `uvm_info(get_type_name(), {"Transaction2 Collected2:\n", trans_collected2.sprint()}, UVM_HIGH)
  if (checks_enable2) perform_checks2();
  if (coverage_enable2) perform_coverage2();
  // Broadcast2 transaction to the rest2 of the environment2 (module UVC2)
  item_collected_port2.write(trans_collected2);
endfunction : write

// FUNCTION2: perform_checks2()
function void apb_monitor2::perform_checks2();
  // Add checks2 here2
endfunction : perform_checks2

// FUNCTION2 : perform_coverage2()
function void apb_monitor2::perform_coverage2();
  apb_transfer_cg2.sample();
endfunction : perform_coverage2

// FUNCTION2: UVM report() phase
function void apb_monitor2::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report2: APB2 monitor2 collected2 %0d transfers2", num_transactions2), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV2
