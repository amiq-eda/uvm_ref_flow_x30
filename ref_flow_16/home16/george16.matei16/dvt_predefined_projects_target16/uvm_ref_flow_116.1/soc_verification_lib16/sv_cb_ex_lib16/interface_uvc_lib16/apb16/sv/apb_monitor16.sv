/*******************************************************************************
  FILE : apb_monitor16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV16
`define APB_MONITOR_SV16

//------------------------------------------------------------------------------
// CLASS16: apb_monitor16
//------------------------------------------------------------------------------

class apb_monitor16 extends uvm_monitor;

  // Property16 indicating the number16 of transactions occuring16 on the apb16.
  protected int unsigned num_transactions16 = 0;
  // FOR16 UVM_ACCEL16
  //protected uvm_abstraction_level_t16 abstraction_level16 = RTL16;
  //protected uvma_output_pipe_proxy16#(apb_transfer16) m_op16;

  //APB16 Configuration16 Class16
  apb_config16 cfg;

  // The following16 two16 bits are used to control16 whether16 checks16 and coverage16 are
  // done both in the monitor16 class and the interface.
  bit checks_enable16 = 1; 
  bit coverage_enable16 = 1;

  // TLM PORT for sending16 transaction OUT16 to scoreboard16, register database, etc16
  uvm_analysis_port #(apb_transfer16) item_collected_port16;

  // TLM Connection16 to the Collector16 - look16 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer16, apb_monitor16) coll_mon_port16;

  // Allows16 the sequencer to look16 at monitored16 data for responses16
  uvm_blocking_peek_imp#(apb_transfer16,apb_monitor16) addr_trans_export16;
 
  // Allows16 monitor16 to look16 at collector16 for address information
  uvm_blocking_peek_port#(apb_transfer16) addr_trans_port16;

  event trans_addr_grabbed16;

  // The current apb_transfer16
  protected apb_transfer16 trans_collected16;

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor16)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable16, UVM_DEFAULT)
    `uvm_field_int(coverage_enable16, UVM_DEFAULT)
    `uvm_field_int(num_transactions16, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg16;
    TRANS_ADDR16 : coverpoint trans_collected16.addr {
      bins ZERO16 = {0};
      bins NON_ZERO16 = {[1:8'h7f]};
    }
    TRANS_DIRECTION16 : coverpoint trans_collected16.direction16 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA16 : coverpoint trans_collected16.data {
      bins ZERO16     = {0};
      bins NON_ZERO16 = {[1:8'hfe]};
      bins ALL_ONES16 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION16: cross TRANS_ADDR16, TRANS_DIRECTION16;
  endgroup

  // Constructor16 - required16 syntax16 for UVM automation16 and utilities16
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected16 = new();
    // Create16 covergroup only if coverage16 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable16", coverage_enable16));
    if (coverage_enable16) begin
       apb_transfer_cg16 = new();
       apb_transfer_cg16.set_inst_name({get_full_name(), ".apb_transfer_cg16"});
    end
    // Create16 TLM ports16
    item_collected_port16 = new("item_collected_port16", this);
    coll_mon_port16 = new("coll_mon_port16", this);
    addr_trans_export16 = new("addr_trans_export16", this);
    addr_trans_port16   = new("addr_trans_port16", this);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer16 trans16); // Interface16 to the sequencer 
  // Receives16 transfers16 from the collector16
  extern virtual function void write(apb_transfer16 trans16);
  extern protected function void perform_checks16();
  extern virtual protected function void perform_coverage16();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor16

// UVM build_phase
function void apb_monitor16::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config16)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG16", "apb_config16 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor16::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port16.peek(trans_collected16);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete16: %h[%s]", trans_collected16.addr, trans_collected16.direction16.name() ), UVM_HIGH)
    -> trans_addr_grabbed16;
  end
endtask : run_phase

// FUNCTION16: peek - Allows16 the sequencer to peek at monitor16 for responses16
task apb_monitor16::peek(output apb_transfer16 trans16);
  @trans_addr_grabbed16;
  trans16 = trans_collected16;
endtask

// FUNCTION16: write - transaction interface to the collector16
function void apb_monitor16::write(apb_transfer16 trans16);
  // Make16 a copy of the transaction (may not be necessary16!)
  $cast(trans_collected16, trans16.clone());
  num_transactions16++;  
  `uvm_info(get_type_name(), {"Transaction16 Collected16:\n", trans_collected16.sprint()}, UVM_HIGH)
  if (checks_enable16) perform_checks16();
  if (coverage_enable16) perform_coverage16();
  // Broadcast16 transaction to the rest16 of the environment16 (module UVC16)
  item_collected_port16.write(trans_collected16);
endfunction : write

// FUNCTION16: perform_checks16()
function void apb_monitor16::perform_checks16();
  // Add checks16 here16
endfunction : perform_checks16

// FUNCTION16 : perform_coverage16()
function void apb_monitor16::perform_coverage16();
  apb_transfer_cg16.sample();
endfunction : perform_coverage16

// FUNCTION16: UVM report() phase
function void apb_monitor16::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report16: APB16 monitor16 collected16 %0d transfers16", num_transactions16), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV16
