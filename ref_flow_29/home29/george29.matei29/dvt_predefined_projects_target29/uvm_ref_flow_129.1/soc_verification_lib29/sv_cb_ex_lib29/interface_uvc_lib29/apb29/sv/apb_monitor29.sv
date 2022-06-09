/*******************************************************************************
  FILE : apb_monitor29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV29
`define APB_MONITOR_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_monitor29
//------------------------------------------------------------------------------

class apb_monitor29 extends uvm_monitor;

  // Property29 indicating the number29 of transactions occuring29 on the apb29.
  protected int unsigned num_transactions29 = 0;
  // FOR29 UVM_ACCEL29
  //protected uvm_abstraction_level_t29 abstraction_level29 = RTL29;
  //protected uvma_output_pipe_proxy29#(apb_transfer29) m_op29;

  //APB29 Configuration29 Class29
  apb_config29 cfg;

  // The following29 two29 bits are used to control29 whether29 checks29 and coverage29 are
  // done both in the monitor29 class and the interface.
  bit checks_enable29 = 1; 
  bit coverage_enable29 = 1;

  // TLM PORT for sending29 transaction OUT29 to scoreboard29, register database, etc29
  uvm_analysis_port #(apb_transfer29) item_collected_port29;

  // TLM Connection29 to the Collector29 - look29 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer29, apb_monitor29) coll_mon_port29;

  // Allows29 the sequencer to look29 at monitored29 data for responses29
  uvm_blocking_peek_imp#(apb_transfer29,apb_monitor29) addr_trans_export29;
 
  // Allows29 monitor29 to look29 at collector29 for address information
  uvm_blocking_peek_port#(apb_transfer29) addr_trans_port29;

  event trans_addr_grabbed29;

  // The current apb_transfer29
  protected apb_transfer29 trans_collected29;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor29)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable29, UVM_DEFAULT)
    `uvm_field_int(coverage_enable29, UVM_DEFAULT)
    `uvm_field_int(num_transactions29, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg29;
    TRANS_ADDR29 : coverpoint trans_collected29.addr {
      bins ZERO29 = {0};
      bins NON_ZERO29 = {[1:8'h7f]};
    }
    TRANS_DIRECTION29 : coverpoint trans_collected29.direction29 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA29 : coverpoint trans_collected29.data {
      bins ZERO29     = {0};
      bins NON_ZERO29 = {[1:8'hfe]};
      bins ALL_ONES29 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION29: cross TRANS_ADDR29, TRANS_DIRECTION29;
  endgroup

  // Constructor29 - required29 syntax29 for UVM automation29 and utilities29
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected29 = new();
    // Create29 covergroup only if coverage29 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable29", coverage_enable29));
    if (coverage_enable29) begin
       apb_transfer_cg29 = new();
       apb_transfer_cg29.set_inst_name({get_full_name(), ".apb_transfer_cg29"});
    end
    // Create29 TLM ports29
    item_collected_port29 = new("item_collected_port29", this);
    coll_mon_port29 = new("coll_mon_port29", this);
    addr_trans_export29 = new("addr_trans_export29", this);
    addr_trans_port29   = new("addr_trans_port29", this);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer29 trans29); // Interface29 to the sequencer 
  // Receives29 transfers29 from the collector29
  extern virtual function void write(apb_transfer29 trans29);
  extern protected function void perform_checks29();
  extern virtual protected function void perform_coverage29();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor29

// UVM build_phase
function void apb_monitor29::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config29)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG29", "apb_config29 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor29::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port29.peek(trans_collected29);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete29: %h[%s]", trans_collected29.addr, trans_collected29.direction29.name() ), UVM_HIGH)
    -> trans_addr_grabbed29;
  end
endtask : run_phase

// FUNCTION29: peek - Allows29 the sequencer to peek at monitor29 for responses29
task apb_monitor29::peek(output apb_transfer29 trans29);
  @trans_addr_grabbed29;
  trans29 = trans_collected29;
endtask

// FUNCTION29: write - transaction interface to the collector29
function void apb_monitor29::write(apb_transfer29 trans29);
  // Make29 a copy of the transaction (may not be necessary29!)
  $cast(trans_collected29, trans29.clone());
  num_transactions29++;  
  `uvm_info(get_type_name(), {"Transaction29 Collected29:\n", trans_collected29.sprint()}, UVM_HIGH)
  if (checks_enable29) perform_checks29();
  if (coverage_enable29) perform_coverage29();
  // Broadcast29 transaction to the rest29 of the environment29 (module UVC29)
  item_collected_port29.write(trans_collected29);
endfunction : write

// FUNCTION29: perform_checks29()
function void apb_monitor29::perform_checks29();
  // Add checks29 here29
endfunction : perform_checks29

// FUNCTION29 : perform_coverage29()
function void apb_monitor29::perform_coverage29();
  apb_transfer_cg29.sample();
endfunction : perform_coverage29

// FUNCTION29: UVM report() phase
function void apb_monitor29::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report29: APB29 monitor29 collected29 %0d transfers29", num_transactions29), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV29
