/*******************************************************************************
  FILE : apb_monitor11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV11
`define APB_MONITOR_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_monitor11
//------------------------------------------------------------------------------

class apb_monitor11 extends uvm_monitor;

  // Property11 indicating the number11 of transactions occuring11 on the apb11.
  protected int unsigned num_transactions11 = 0;
  // FOR11 UVM_ACCEL11
  //protected uvm_abstraction_level_t11 abstraction_level11 = RTL11;
  //protected uvma_output_pipe_proxy11#(apb_transfer11) m_op11;

  //APB11 Configuration11 Class11
  apb_config11 cfg;

  // The following11 two11 bits are used to control11 whether11 checks11 and coverage11 are
  // done both in the monitor11 class and the interface.
  bit checks_enable11 = 1; 
  bit coverage_enable11 = 1;

  // TLM PORT for sending11 transaction OUT11 to scoreboard11, register database, etc11
  uvm_analysis_port #(apb_transfer11) item_collected_port11;

  // TLM Connection11 to the Collector11 - look11 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer11, apb_monitor11) coll_mon_port11;

  // Allows11 the sequencer to look11 at monitored11 data for responses11
  uvm_blocking_peek_imp#(apb_transfer11,apb_monitor11) addr_trans_export11;
 
  // Allows11 monitor11 to look11 at collector11 for address information
  uvm_blocking_peek_port#(apb_transfer11) addr_trans_port11;

  event trans_addr_grabbed11;

  // The current apb_transfer11
  protected apb_transfer11 trans_collected11;

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor11)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable11, UVM_DEFAULT)
    `uvm_field_int(coverage_enable11, UVM_DEFAULT)
    `uvm_field_int(num_transactions11, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg11;
    TRANS_ADDR11 : coverpoint trans_collected11.addr {
      bins ZERO11 = {0};
      bins NON_ZERO11 = {[1:8'h7f]};
    }
    TRANS_DIRECTION11 : coverpoint trans_collected11.direction11 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA11 : coverpoint trans_collected11.data {
      bins ZERO11     = {0};
      bins NON_ZERO11 = {[1:8'hfe]};
      bins ALL_ONES11 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION11: cross TRANS_ADDR11, TRANS_DIRECTION11;
  endgroup

  // Constructor11 - required11 syntax11 for UVM automation11 and utilities11
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected11 = new();
    // Create11 covergroup only if coverage11 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable11", coverage_enable11));
    if (coverage_enable11) begin
       apb_transfer_cg11 = new();
       apb_transfer_cg11.set_inst_name({get_full_name(), ".apb_transfer_cg11"});
    end
    // Create11 TLM ports11
    item_collected_port11 = new("item_collected_port11", this);
    coll_mon_port11 = new("coll_mon_port11", this);
    addr_trans_export11 = new("addr_trans_export11", this);
    addr_trans_port11   = new("addr_trans_port11", this);
  endfunction : new

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer11 trans11); // Interface11 to the sequencer 
  // Receives11 transfers11 from the collector11
  extern virtual function void write(apb_transfer11 trans11);
  extern protected function void perform_checks11();
  extern virtual protected function void perform_coverage11();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor11

// UVM build_phase
function void apb_monitor11::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config11)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG11", "apb_config11 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor11::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port11.peek(trans_collected11);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete11: %h[%s]", trans_collected11.addr, trans_collected11.direction11.name() ), UVM_HIGH)
    -> trans_addr_grabbed11;
  end
endtask : run_phase

// FUNCTION11: peek - Allows11 the sequencer to peek at monitor11 for responses11
task apb_monitor11::peek(output apb_transfer11 trans11);
  @trans_addr_grabbed11;
  trans11 = trans_collected11;
endtask

// FUNCTION11: write - transaction interface to the collector11
function void apb_monitor11::write(apb_transfer11 trans11);
  // Make11 a copy of the transaction (may not be necessary11!)
  $cast(trans_collected11, trans11.clone());
  num_transactions11++;  
  `uvm_info(get_type_name(), {"Transaction11 Collected11:\n", trans_collected11.sprint()}, UVM_HIGH)
  if (checks_enable11) perform_checks11();
  if (coverage_enable11) perform_coverage11();
  // Broadcast11 transaction to the rest11 of the environment11 (module UVC11)
  item_collected_port11.write(trans_collected11);
endfunction : write

// FUNCTION11: perform_checks11()
function void apb_monitor11::perform_checks11();
  // Add checks11 here11
endfunction : perform_checks11

// FUNCTION11 : perform_coverage11()
function void apb_monitor11::perform_coverage11();
  apb_transfer_cg11.sample();
endfunction : perform_coverage11

// FUNCTION11: UVM report() phase
function void apb_monitor11::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report11: APB11 monitor11 collected11 %0d transfers11", num_transactions11), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV11
