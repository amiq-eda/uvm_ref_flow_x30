/*******************************************************************************
  FILE : apb_monitor10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV10
`define APB_MONITOR_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_monitor10
//------------------------------------------------------------------------------

class apb_monitor10 extends uvm_monitor;

  // Property10 indicating the number10 of transactions occuring10 on the apb10.
  protected int unsigned num_transactions10 = 0;
  // FOR10 UVM_ACCEL10
  //protected uvm_abstraction_level_t10 abstraction_level10 = RTL10;
  //protected uvma_output_pipe_proxy10#(apb_transfer10) m_op10;

  //APB10 Configuration10 Class10
  apb_config10 cfg;

  // The following10 two10 bits are used to control10 whether10 checks10 and coverage10 are
  // done both in the monitor10 class and the interface.
  bit checks_enable10 = 1; 
  bit coverage_enable10 = 1;

  // TLM PORT for sending10 transaction OUT10 to scoreboard10, register database, etc10
  uvm_analysis_port #(apb_transfer10) item_collected_port10;

  // TLM Connection10 to the Collector10 - look10 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer10, apb_monitor10) coll_mon_port10;

  // Allows10 the sequencer to look10 at monitored10 data for responses10
  uvm_blocking_peek_imp#(apb_transfer10,apb_monitor10) addr_trans_export10;
 
  // Allows10 monitor10 to look10 at collector10 for address information
  uvm_blocking_peek_port#(apb_transfer10) addr_trans_port10;

  event trans_addr_grabbed10;

  // The current apb_transfer10
  protected apb_transfer10 trans_collected10;

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor10)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable10, UVM_DEFAULT)
    `uvm_field_int(coverage_enable10, UVM_DEFAULT)
    `uvm_field_int(num_transactions10, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg10;
    TRANS_ADDR10 : coverpoint trans_collected10.addr {
      bins ZERO10 = {0};
      bins NON_ZERO10 = {[1:8'h7f]};
    }
    TRANS_DIRECTION10 : coverpoint trans_collected10.direction10 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA10 : coverpoint trans_collected10.data {
      bins ZERO10     = {0};
      bins NON_ZERO10 = {[1:8'hfe]};
      bins ALL_ONES10 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION10: cross TRANS_ADDR10, TRANS_DIRECTION10;
  endgroup

  // Constructor10 - required10 syntax10 for UVM automation10 and utilities10
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected10 = new();
    // Create10 covergroup only if coverage10 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable10", coverage_enable10));
    if (coverage_enable10) begin
       apb_transfer_cg10 = new();
       apb_transfer_cg10.set_inst_name({get_full_name(), ".apb_transfer_cg10"});
    end
    // Create10 TLM ports10
    item_collected_port10 = new("item_collected_port10", this);
    coll_mon_port10 = new("coll_mon_port10", this);
    addr_trans_export10 = new("addr_trans_export10", this);
    addr_trans_port10   = new("addr_trans_port10", this);
  endfunction : new

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer10 trans10); // Interface10 to the sequencer 
  // Receives10 transfers10 from the collector10
  extern virtual function void write(apb_transfer10 trans10);
  extern protected function void perform_checks10();
  extern virtual protected function void perform_coverage10();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor10

// UVM build_phase
function void apb_monitor10::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config10)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG10", "apb_config10 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor10::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port10.peek(trans_collected10);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete10: %h[%s]", trans_collected10.addr, trans_collected10.direction10.name() ), UVM_HIGH)
    -> trans_addr_grabbed10;
  end
endtask : run_phase

// FUNCTION10: peek - Allows10 the sequencer to peek at monitor10 for responses10
task apb_monitor10::peek(output apb_transfer10 trans10);
  @trans_addr_grabbed10;
  trans10 = trans_collected10;
endtask

// FUNCTION10: write - transaction interface to the collector10
function void apb_monitor10::write(apb_transfer10 trans10);
  // Make10 a copy of the transaction (may not be necessary10!)
  $cast(trans_collected10, trans10.clone());
  num_transactions10++;  
  `uvm_info(get_type_name(), {"Transaction10 Collected10:\n", trans_collected10.sprint()}, UVM_HIGH)
  if (checks_enable10) perform_checks10();
  if (coverage_enable10) perform_coverage10();
  // Broadcast10 transaction to the rest10 of the environment10 (module UVC10)
  item_collected_port10.write(trans_collected10);
endfunction : write

// FUNCTION10: perform_checks10()
function void apb_monitor10::perform_checks10();
  // Add checks10 here10
endfunction : perform_checks10

// FUNCTION10 : perform_coverage10()
function void apb_monitor10::perform_coverage10();
  apb_transfer_cg10.sample();
endfunction : perform_coverage10

// FUNCTION10: UVM report() phase
function void apb_monitor10::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report10: APB10 monitor10 collected10 %0d transfers10", num_transactions10), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV10
