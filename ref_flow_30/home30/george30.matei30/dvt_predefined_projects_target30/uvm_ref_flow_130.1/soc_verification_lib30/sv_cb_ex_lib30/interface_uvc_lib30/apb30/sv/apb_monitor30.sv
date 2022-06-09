/*******************************************************************************
  FILE : apb_monitor30.sv
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV30
`define APB_MONITOR_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_monitor30
//------------------------------------------------------------------------------

class apb_monitor30 extends uvm_monitor;

  // Property30 indicating the number30 of transactions occuring30 on the apb30.
  protected int unsigned num_transactions30 = 0;
  // FOR30 UVM_ACCEL30
  //protected uvm_abstraction_level_t30 abstraction_level30 = RTL30;
  //protected uvma_output_pipe_proxy30#(apb_transfer30) m_op30;

  //APB30 Configuration30 Class30
  apb_config30 cfg;

  // The following30 two30 bits are used to control30 whether30 checks30 and coverage30 are
  // done both in the monitor30 class and the interface.
  bit checks_enable30 = 1; 
  bit coverage_enable30 = 1;

  // TLM PORT for sending30 transaction OUT30 to scoreboard30, register database, etc30
  uvm_analysis_port #(apb_transfer30) item_collected_port30;

  // TLM Connection30 to the Collector30 - look30 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer30, apb_monitor30) coll_mon_port30;

  // Allows30 the sequencer to look30 at monitored30 data for responses30
  uvm_blocking_peek_imp#(apb_transfer30,apb_monitor30) addr_trans_export30;
 
  // Allows30 monitor30 to look30 at collector30 for address information
  uvm_blocking_peek_port#(apb_transfer30) addr_trans_port30;

  event trans_addr_grabbed30;

  // The current apb_transfer30
  protected apb_transfer30 trans_collected30;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor30)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable30, UVM_DEFAULT)
    `uvm_field_int(coverage_enable30, UVM_DEFAULT)
    `uvm_field_int(num_transactions30, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg30;
    TRANS_ADDR30 : coverpoint trans_collected30.addr {
      bins ZERO30 = {0};
      bins NON_ZERO30 = {[1:8'h7f]};
    }
    TRANS_DIRECTION30 : coverpoint trans_collected30.direction30 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA30 : coverpoint trans_collected30.data {
      bins ZERO30     = {0};
      bins NON_ZERO30 = {[1:8'hfe]};
      bins ALL_ONES30 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION30: cross TRANS_ADDR30, TRANS_DIRECTION30;
  endgroup

  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected30 = new();
    // Create30 covergroup only if coverage30 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable30", coverage_enable30));
    if (coverage_enable30) begin
       apb_transfer_cg30 = new();
       apb_transfer_cg30.set_inst_name({get_full_name(), ".apb_transfer_cg30"});
    end
    // Create30 TLM ports30
    item_collected_port30 = new("item_collected_port30", this);
    coll_mon_port30 = new("coll_mon_port30", this);
    addr_trans_export30 = new("addr_trans_export30", this);
    addr_trans_port30   = new("addr_trans_port30", this);
  endfunction : new

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer30 trans30); // Interface30 to the sequencer 
  // Receives30 transfers30 from the collector30
  extern virtual function void write(apb_transfer30 trans30);
  extern protected function void perform_checks30();
  extern virtual protected function void perform_coverage30();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor30

// UVM build_phase
function void apb_monitor30::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config30)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG30", "apb_config30 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor30::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port30.peek(trans_collected30);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete30: %h[%s]", trans_collected30.addr, trans_collected30.direction30.name() ), UVM_HIGH)
    -> trans_addr_grabbed30;
  end
endtask : run_phase

// FUNCTION30: peek - Allows30 the sequencer to peek at monitor30 for responses30
task apb_monitor30::peek(output apb_transfer30 trans30);
  @trans_addr_grabbed30;
  trans30 = trans_collected30;
endtask

// FUNCTION30: write - transaction interface to the collector30
function void apb_monitor30::write(apb_transfer30 trans30);
  // Make30 a copy of the transaction (may not be necessary30!)
  $cast(trans_collected30, trans30.clone());
  num_transactions30++;  
  `uvm_info(get_type_name(), {"Transaction30 Collected30:\n", trans_collected30.sprint()}, UVM_HIGH)
  if (checks_enable30) perform_checks30();
  if (coverage_enable30) perform_coverage30();
  // Broadcast30 transaction to the rest30 of the environment30 (module UVC30)
  item_collected_port30.write(trans_collected30);
endfunction : write

// FUNCTION30: perform_checks30()
function void apb_monitor30::perform_checks30();
  // Add checks30 here30
endfunction : perform_checks30

// FUNCTION30 : perform_coverage30()
function void apb_monitor30::perform_coverage30();
  apb_transfer_cg30.sample();
endfunction : perform_coverage30

// FUNCTION30: UVM report() phase
function void apb_monitor30::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report30: APB30 monitor30 collected30 %0d transfers30", num_transactions30), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV30
