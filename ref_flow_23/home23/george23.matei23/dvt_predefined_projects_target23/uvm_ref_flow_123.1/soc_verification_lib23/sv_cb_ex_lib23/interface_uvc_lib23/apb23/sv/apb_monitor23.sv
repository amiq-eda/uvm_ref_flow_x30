/*******************************************************************************
  FILE : apb_monitor23.sv
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV23
`define APB_MONITOR_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_monitor23
//------------------------------------------------------------------------------

class apb_monitor23 extends uvm_monitor;

  // Property23 indicating the number23 of transactions occuring23 on the apb23.
  protected int unsigned num_transactions23 = 0;
  // FOR23 UVM_ACCEL23
  //protected uvm_abstraction_level_t23 abstraction_level23 = RTL23;
  //protected uvma_output_pipe_proxy23#(apb_transfer23) m_op23;

  //APB23 Configuration23 Class23
  apb_config23 cfg;

  // The following23 two23 bits are used to control23 whether23 checks23 and coverage23 are
  // done both in the monitor23 class and the interface.
  bit checks_enable23 = 1; 
  bit coverage_enable23 = 1;

  // TLM PORT for sending23 transaction OUT23 to scoreboard23, register database, etc23
  uvm_analysis_port #(apb_transfer23) item_collected_port23;

  // TLM Connection23 to the Collector23 - look23 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer23, apb_monitor23) coll_mon_port23;

  // Allows23 the sequencer to look23 at monitored23 data for responses23
  uvm_blocking_peek_imp#(apb_transfer23,apb_monitor23) addr_trans_export23;
 
  // Allows23 monitor23 to look23 at collector23 for address information
  uvm_blocking_peek_port#(apb_transfer23) addr_trans_port23;

  event trans_addr_grabbed23;

  // The current apb_transfer23
  protected apb_transfer23 trans_collected23;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor23)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable23, UVM_DEFAULT)
    `uvm_field_int(coverage_enable23, UVM_DEFAULT)
    `uvm_field_int(num_transactions23, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg23;
    TRANS_ADDR23 : coverpoint trans_collected23.addr {
      bins ZERO23 = {0};
      bins NON_ZERO23 = {[1:8'h7f]};
    }
    TRANS_DIRECTION23 : coverpoint trans_collected23.direction23 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA23 : coverpoint trans_collected23.data {
      bins ZERO23     = {0};
      bins NON_ZERO23 = {[1:8'hfe]};
      bins ALL_ONES23 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION23: cross TRANS_ADDR23, TRANS_DIRECTION23;
  endgroup

  // Constructor23 - required23 syntax23 for UVM automation23 and utilities23
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected23 = new();
    // Create23 covergroup only if coverage23 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable23", coverage_enable23));
    if (coverage_enable23) begin
       apb_transfer_cg23 = new();
       apb_transfer_cg23.set_inst_name({get_full_name(), ".apb_transfer_cg23"});
    end
    // Create23 TLM ports23
    item_collected_port23 = new("item_collected_port23", this);
    coll_mon_port23 = new("coll_mon_port23", this);
    addr_trans_export23 = new("addr_trans_export23", this);
    addr_trans_port23   = new("addr_trans_port23", this);
  endfunction : new

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer23 trans23); // Interface23 to the sequencer 
  // Receives23 transfers23 from the collector23
  extern virtual function void write(apb_transfer23 trans23);
  extern protected function void perform_checks23();
  extern virtual protected function void perform_coverage23();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor23

// UVM build_phase
function void apb_monitor23::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config23)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG23", "apb_config23 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor23::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port23.peek(trans_collected23);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete23: %h[%s]", trans_collected23.addr, trans_collected23.direction23.name() ), UVM_HIGH)
    -> trans_addr_grabbed23;
  end
endtask : run_phase

// FUNCTION23: peek - Allows23 the sequencer to peek at monitor23 for responses23
task apb_monitor23::peek(output apb_transfer23 trans23);
  @trans_addr_grabbed23;
  trans23 = trans_collected23;
endtask

// FUNCTION23: write - transaction interface to the collector23
function void apb_monitor23::write(apb_transfer23 trans23);
  // Make23 a copy of the transaction (may not be necessary23!)
  $cast(trans_collected23, trans23.clone());
  num_transactions23++;  
  `uvm_info(get_type_name(), {"Transaction23 Collected23:\n", trans_collected23.sprint()}, UVM_HIGH)
  if (checks_enable23) perform_checks23();
  if (coverage_enable23) perform_coverage23();
  // Broadcast23 transaction to the rest23 of the environment23 (module UVC23)
  item_collected_port23.write(trans_collected23);
endfunction : write

// FUNCTION23: perform_checks23()
function void apb_monitor23::perform_checks23();
  // Add checks23 here23
endfunction : perform_checks23

// FUNCTION23 : perform_coverage23()
function void apb_monitor23::perform_coverage23();
  apb_transfer_cg23.sample();
endfunction : perform_coverage23

// FUNCTION23: UVM report() phase
function void apb_monitor23::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report23: APB23 monitor23 collected23 %0d transfers23", num_transactions23), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV23
