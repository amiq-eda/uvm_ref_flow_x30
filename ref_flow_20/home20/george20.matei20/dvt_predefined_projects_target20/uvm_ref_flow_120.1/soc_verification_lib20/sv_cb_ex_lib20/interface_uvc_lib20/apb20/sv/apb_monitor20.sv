/*******************************************************************************
  FILE : apb_monitor20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV20
`define APB_MONITOR_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_monitor20
//------------------------------------------------------------------------------

class apb_monitor20 extends uvm_monitor;

  // Property20 indicating the number20 of transactions occuring20 on the apb20.
  protected int unsigned num_transactions20 = 0;
  // FOR20 UVM_ACCEL20
  //protected uvm_abstraction_level_t20 abstraction_level20 = RTL20;
  //protected uvma_output_pipe_proxy20#(apb_transfer20) m_op20;

  //APB20 Configuration20 Class20
  apb_config20 cfg;

  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done both in the monitor20 class and the interface.
  bit checks_enable20 = 1; 
  bit coverage_enable20 = 1;

  // TLM PORT for sending20 transaction OUT20 to scoreboard20, register database, etc20
  uvm_analysis_port #(apb_transfer20) item_collected_port20;

  // TLM Connection20 to the Collector20 - look20 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer20, apb_monitor20) coll_mon_port20;

  // Allows20 the sequencer to look20 at monitored20 data for responses20
  uvm_blocking_peek_imp#(apb_transfer20,apb_monitor20) addr_trans_export20;
 
  // Allows20 monitor20 to look20 at collector20 for address information
  uvm_blocking_peek_port#(apb_transfer20) addr_trans_port20;

  event trans_addr_grabbed20;

  // The current apb_transfer20
  protected apb_transfer20 trans_collected20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor20)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable20, UVM_DEFAULT)
    `uvm_field_int(coverage_enable20, UVM_DEFAULT)
    `uvm_field_int(num_transactions20, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg20;
    TRANS_ADDR20 : coverpoint trans_collected20.addr {
      bins ZERO20 = {0};
      bins NON_ZERO20 = {[1:8'h7f]};
    }
    TRANS_DIRECTION20 : coverpoint trans_collected20.direction20 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA20 : coverpoint trans_collected20.data {
      bins ZERO20     = {0};
      bins NON_ZERO20 = {[1:8'hfe]};
      bins ALL_ONES20 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION20: cross TRANS_ADDR20, TRANS_DIRECTION20;
  endgroup

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected20 = new();
    // Create20 covergroup only if coverage20 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable20", coverage_enable20));
    if (coverage_enable20) begin
       apb_transfer_cg20 = new();
       apb_transfer_cg20.set_inst_name({get_full_name(), ".apb_transfer_cg20"});
    end
    // Create20 TLM ports20
    item_collected_port20 = new("item_collected_port20", this);
    coll_mon_port20 = new("coll_mon_port20", this);
    addr_trans_export20 = new("addr_trans_export20", this);
    addr_trans_port20   = new("addr_trans_port20", this);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer20 trans20); // Interface20 to the sequencer 
  // Receives20 transfers20 from the collector20
  extern virtual function void write(apb_transfer20 trans20);
  extern protected function void perform_checks20();
  extern virtual protected function void perform_coverage20();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor20

// UVM build_phase
function void apb_monitor20::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config20)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG20", "apb_config20 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor20::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port20.peek(trans_collected20);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete20: %h[%s]", trans_collected20.addr, trans_collected20.direction20.name() ), UVM_HIGH)
    -> trans_addr_grabbed20;
  end
endtask : run_phase

// FUNCTION20: peek - Allows20 the sequencer to peek at monitor20 for responses20
task apb_monitor20::peek(output apb_transfer20 trans20);
  @trans_addr_grabbed20;
  trans20 = trans_collected20;
endtask

// FUNCTION20: write - transaction interface to the collector20
function void apb_monitor20::write(apb_transfer20 trans20);
  // Make20 a copy of the transaction (may not be necessary20!)
  $cast(trans_collected20, trans20.clone());
  num_transactions20++;  
  `uvm_info(get_type_name(), {"Transaction20 Collected20:\n", trans_collected20.sprint()}, UVM_HIGH)
  if (checks_enable20) perform_checks20();
  if (coverage_enable20) perform_coverage20();
  // Broadcast20 transaction to the rest20 of the environment20 (module UVC20)
  item_collected_port20.write(trans_collected20);
endfunction : write

// FUNCTION20: perform_checks20()
function void apb_monitor20::perform_checks20();
  // Add checks20 here20
endfunction : perform_checks20

// FUNCTION20 : perform_coverage20()
function void apb_monitor20::perform_coverage20();
  apb_transfer_cg20.sample();
endfunction : perform_coverage20

// FUNCTION20: UVM report() phase
function void apb_monitor20::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report20: APB20 monitor20 collected20 %0d transfers20", num_transactions20), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV20
