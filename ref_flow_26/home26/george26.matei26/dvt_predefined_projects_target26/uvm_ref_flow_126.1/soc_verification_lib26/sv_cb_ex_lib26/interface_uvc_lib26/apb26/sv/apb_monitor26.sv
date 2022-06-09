/*******************************************************************************
  FILE : apb_monitor26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV26
`define APB_MONITOR_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_monitor26
//------------------------------------------------------------------------------

class apb_monitor26 extends uvm_monitor;

  // Property26 indicating the number26 of transactions occuring26 on the apb26.
  protected int unsigned num_transactions26 = 0;
  // FOR26 UVM_ACCEL26
  //protected uvm_abstraction_level_t26 abstraction_level26 = RTL26;
  //protected uvma_output_pipe_proxy26#(apb_transfer26) m_op26;

  //APB26 Configuration26 Class26
  apb_config26 cfg;

  // The following26 two26 bits are used to control26 whether26 checks26 and coverage26 are
  // done both in the monitor26 class and the interface.
  bit checks_enable26 = 1; 
  bit coverage_enable26 = 1;

  // TLM PORT for sending26 transaction OUT26 to scoreboard26, register database, etc26
  uvm_analysis_port #(apb_transfer26) item_collected_port26;

  // TLM Connection26 to the Collector26 - look26 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer26, apb_monitor26) coll_mon_port26;

  // Allows26 the sequencer to look26 at monitored26 data for responses26
  uvm_blocking_peek_imp#(apb_transfer26,apb_monitor26) addr_trans_export26;
 
  // Allows26 monitor26 to look26 at collector26 for address information
  uvm_blocking_peek_port#(apb_transfer26) addr_trans_port26;

  event trans_addr_grabbed26;

  // The current apb_transfer26
  protected apb_transfer26 trans_collected26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor26)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable26, UVM_DEFAULT)
    `uvm_field_int(coverage_enable26, UVM_DEFAULT)
    `uvm_field_int(num_transactions26, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg26;
    TRANS_ADDR26 : coverpoint trans_collected26.addr {
      bins ZERO26 = {0};
      bins NON_ZERO26 = {[1:8'h7f]};
    }
    TRANS_DIRECTION26 : coverpoint trans_collected26.direction26 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA26 : coverpoint trans_collected26.data {
      bins ZERO26     = {0};
      bins NON_ZERO26 = {[1:8'hfe]};
      bins ALL_ONES26 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION26: cross TRANS_ADDR26, TRANS_DIRECTION26;
  endgroup

  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected26 = new();
    // Create26 covergroup only if coverage26 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable26", coverage_enable26));
    if (coverage_enable26) begin
       apb_transfer_cg26 = new();
       apb_transfer_cg26.set_inst_name({get_full_name(), ".apb_transfer_cg26"});
    end
    // Create26 TLM ports26
    item_collected_port26 = new("item_collected_port26", this);
    coll_mon_port26 = new("coll_mon_port26", this);
    addr_trans_export26 = new("addr_trans_export26", this);
    addr_trans_port26   = new("addr_trans_port26", this);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer26 trans26); // Interface26 to the sequencer 
  // Receives26 transfers26 from the collector26
  extern virtual function void write(apb_transfer26 trans26);
  extern protected function void perform_checks26();
  extern virtual protected function void perform_coverage26();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor26

// UVM build_phase
function void apb_monitor26::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config26)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG26", "apb_config26 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor26::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port26.peek(trans_collected26);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete26: %h[%s]", trans_collected26.addr, trans_collected26.direction26.name() ), UVM_HIGH)
    -> trans_addr_grabbed26;
  end
endtask : run_phase

// FUNCTION26: peek - Allows26 the sequencer to peek at monitor26 for responses26
task apb_monitor26::peek(output apb_transfer26 trans26);
  @trans_addr_grabbed26;
  trans26 = trans_collected26;
endtask

// FUNCTION26: write - transaction interface to the collector26
function void apb_monitor26::write(apb_transfer26 trans26);
  // Make26 a copy of the transaction (may not be necessary26!)
  $cast(trans_collected26, trans26.clone());
  num_transactions26++;  
  `uvm_info(get_type_name(), {"Transaction26 Collected26:\n", trans_collected26.sprint()}, UVM_HIGH)
  if (checks_enable26) perform_checks26();
  if (coverage_enable26) perform_coverage26();
  // Broadcast26 transaction to the rest26 of the environment26 (module UVC26)
  item_collected_port26.write(trans_collected26);
endfunction : write

// FUNCTION26: perform_checks26()
function void apb_monitor26::perform_checks26();
  // Add checks26 here26
endfunction : perform_checks26

// FUNCTION26 : perform_coverage26()
function void apb_monitor26::perform_coverage26();
  apb_transfer_cg26.sample();
endfunction : perform_coverage26

// FUNCTION26: UVM report() phase
function void apb_monitor26::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report26: APB26 monitor26 collected26 %0d transfers26", num_transactions26), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV26
