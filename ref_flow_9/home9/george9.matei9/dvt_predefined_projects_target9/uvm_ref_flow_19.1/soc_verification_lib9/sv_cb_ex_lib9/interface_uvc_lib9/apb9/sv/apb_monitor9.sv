/*******************************************************************************
  FILE : apb_monitor9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV9
`define APB_MONITOR_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_monitor9
//------------------------------------------------------------------------------

class apb_monitor9 extends uvm_monitor;

  // Property9 indicating the number9 of transactions occuring9 on the apb9.
  protected int unsigned num_transactions9 = 0;
  // FOR9 UVM_ACCEL9
  //protected uvm_abstraction_level_t9 abstraction_level9 = RTL9;
  //protected uvma_output_pipe_proxy9#(apb_transfer9) m_op9;

  //APB9 Configuration9 Class9
  apb_config9 cfg;

  // The following9 two9 bits are used to control9 whether9 checks9 and coverage9 are
  // done both in the monitor9 class and the interface.
  bit checks_enable9 = 1; 
  bit coverage_enable9 = 1;

  // TLM PORT for sending9 transaction OUT9 to scoreboard9, register database, etc9
  uvm_analysis_port #(apb_transfer9) item_collected_port9;

  // TLM Connection9 to the Collector9 - look9 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer9, apb_monitor9) coll_mon_port9;

  // Allows9 the sequencer to look9 at monitored9 data for responses9
  uvm_blocking_peek_imp#(apb_transfer9,apb_monitor9) addr_trans_export9;
 
  // Allows9 monitor9 to look9 at collector9 for address information
  uvm_blocking_peek_port#(apb_transfer9) addr_trans_port9;

  event trans_addr_grabbed9;

  // The current apb_transfer9
  protected apb_transfer9 trans_collected9;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor9)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable9, UVM_DEFAULT)
    `uvm_field_int(coverage_enable9, UVM_DEFAULT)
    `uvm_field_int(num_transactions9, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg9;
    TRANS_ADDR9 : coverpoint trans_collected9.addr {
      bins ZERO9 = {0};
      bins NON_ZERO9 = {[1:8'h7f]};
    }
    TRANS_DIRECTION9 : coverpoint trans_collected9.direction9 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA9 : coverpoint trans_collected9.data {
      bins ZERO9     = {0};
      bins NON_ZERO9 = {[1:8'hfe]};
      bins ALL_ONES9 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION9: cross TRANS_ADDR9, TRANS_DIRECTION9;
  endgroup

  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected9 = new();
    // Create9 covergroup only if coverage9 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable9", coverage_enable9));
    if (coverage_enable9) begin
       apb_transfer_cg9 = new();
       apb_transfer_cg9.set_inst_name({get_full_name(), ".apb_transfer_cg9"});
    end
    // Create9 TLM ports9
    item_collected_port9 = new("item_collected_port9", this);
    coll_mon_port9 = new("coll_mon_port9", this);
    addr_trans_export9 = new("addr_trans_export9", this);
    addr_trans_port9   = new("addr_trans_port9", this);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer9 trans9); // Interface9 to the sequencer 
  // Receives9 transfers9 from the collector9
  extern virtual function void write(apb_transfer9 trans9);
  extern protected function void perform_checks9();
  extern virtual protected function void perform_coverage9();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor9

// UVM build_phase
function void apb_monitor9::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config9)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG9", "apb_config9 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor9::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port9.peek(trans_collected9);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete9: %h[%s]", trans_collected9.addr, trans_collected9.direction9.name() ), UVM_HIGH)
    -> trans_addr_grabbed9;
  end
endtask : run_phase

// FUNCTION9: peek - Allows9 the sequencer to peek at monitor9 for responses9
task apb_monitor9::peek(output apb_transfer9 trans9);
  @trans_addr_grabbed9;
  trans9 = trans_collected9;
endtask

// FUNCTION9: write - transaction interface to the collector9
function void apb_monitor9::write(apb_transfer9 trans9);
  // Make9 a copy of the transaction (may not be necessary9!)
  $cast(trans_collected9, trans9.clone());
  num_transactions9++;  
  `uvm_info(get_type_name(), {"Transaction9 Collected9:\n", trans_collected9.sprint()}, UVM_HIGH)
  if (checks_enable9) perform_checks9();
  if (coverage_enable9) perform_coverage9();
  // Broadcast9 transaction to the rest9 of the environment9 (module UVC9)
  item_collected_port9.write(trans_collected9);
endfunction : write

// FUNCTION9: perform_checks9()
function void apb_monitor9::perform_checks9();
  // Add checks9 here9
endfunction : perform_checks9

// FUNCTION9 : perform_coverage9()
function void apb_monitor9::perform_coverage9();
  apb_transfer_cg9.sample();
endfunction : perform_coverage9

// FUNCTION9: UVM report() phase
function void apb_monitor9::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report9: APB9 monitor9 collected9 %0d transfers9", num_transactions9), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV9
