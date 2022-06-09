/*******************************************************************************
  FILE : apb_monitor4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV4
`define APB_MONITOR_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_monitor4
//------------------------------------------------------------------------------

class apb_monitor4 extends uvm_monitor;

  // Property4 indicating the number4 of transactions occuring4 on the apb4.
  protected int unsigned num_transactions4 = 0;
  // FOR4 UVM_ACCEL4
  //protected uvm_abstraction_level_t4 abstraction_level4 = RTL4;
  //protected uvma_output_pipe_proxy4#(apb_transfer4) m_op4;

  //APB4 Configuration4 Class4
  apb_config4 cfg;

  // The following4 two4 bits are used to control4 whether4 checks4 and coverage4 are
  // done both in the monitor4 class and the interface.
  bit checks_enable4 = 1; 
  bit coverage_enable4 = 1;

  // TLM PORT for sending4 transaction OUT4 to scoreboard4, register database, etc4
  uvm_analysis_port #(apb_transfer4) item_collected_port4;

  // TLM Connection4 to the Collector4 - look4 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer4, apb_monitor4) coll_mon_port4;

  // Allows4 the sequencer to look4 at monitored4 data for responses4
  uvm_blocking_peek_imp#(apb_transfer4,apb_monitor4) addr_trans_export4;
 
  // Allows4 monitor4 to look4 at collector4 for address information
  uvm_blocking_peek_port#(apb_transfer4) addr_trans_port4;

  event trans_addr_grabbed4;

  // The current apb_transfer4
  protected apb_transfer4 trans_collected4;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor4)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable4, UVM_DEFAULT)
    `uvm_field_int(coverage_enable4, UVM_DEFAULT)
    `uvm_field_int(num_transactions4, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg4;
    TRANS_ADDR4 : coverpoint trans_collected4.addr {
      bins ZERO4 = {0};
      bins NON_ZERO4 = {[1:8'h7f]};
    }
    TRANS_DIRECTION4 : coverpoint trans_collected4.direction4 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA4 : coverpoint trans_collected4.data {
      bins ZERO4     = {0};
      bins NON_ZERO4 = {[1:8'hfe]};
      bins ALL_ONES4 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION4: cross TRANS_ADDR4, TRANS_DIRECTION4;
  endgroup

  // Constructor4 - required4 syntax4 for UVM automation4 and utilities4
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected4 = new();
    // Create4 covergroup only if coverage4 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable4", coverage_enable4));
    if (coverage_enable4) begin
       apb_transfer_cg4 = new();
       apb_transfer_cg4.set_inst_name({get_full_name(), ".apb_transfer_cg4"});
    end
    // Create4 TLM ports4
    item_collected_port4 = new("item_collected_port4", this);
    coll_mon_port4 = new("coll_mon_port4", this);
    addr_trans_export4 = new("addr_trans_export4", this);
    addr_trans_port4   = new("addr_trans_port4", this);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer4 trans4); // Interface4 to the sequencer 
  // Receives4 transfers4 from the collector4
  extern virtual function void write(apb_transfer4 trans4);
  extern protected function void perform_checks4();
  extern virtual protected function void perform_coverage4();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor4

// UVM build_phase
function void apb_monitor4::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config4)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG4", "apb_config4 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor4::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port4.peek(trans_collected4);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete4: %h[%s]", trans_collected4.addr, trans_collected4.direction4.name() ), UVM_HIGH)
    -> trans_addr_grabbed4;
  end
endtask : run_phase

// FUNCTION4: peek - Allows4 the sequencer to peek at monitor4 for responses4
task apb_monitor4::peek(output apb_transfer4 trans4);
  @trans_addr_grabbed4;
  trans4 = trans_collected4;
endtask

// FUNCTION4: write - transaction interface to the collector4
function void apb_monitor4::write(apb_transfer4 trans4);
  // Make4 a copy of the transaction (may not be necessary4!)
  $cast(trans_collected4, trans4.clone());
  num_transactions4++;  
  `uvm_info(get_type_name(), {"Transaction4 Collected4:\n", trans_collected4.sprint()}, UVM_HIGH)
  if (checks_enable4) perform_checks4();
  if (coverage_enable4) perform_coverage4();
  // Broadcast4 transaction to the rest4 of the environment4 (module UVC4)
  item_collected_port4.write(trans_collected4);
endfunction : write

// FUNCTION4: perform_checks4()
function void apb_monitor4::perform_checks4();
  // Add checks4 here4
endfunction : perform_checks4

// FUNCTION4 : perform_coverage4()
function void apb_monitor4::perform_coverage4();
  apb_transfer_cg4.sample();
endfunction : perform_coverage4

// FUNCTION4: UVM report() phase
function void apb_monitor4::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report4: APB4 monitor4 collected4 %0d transfers4", num_transactions4), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV4
