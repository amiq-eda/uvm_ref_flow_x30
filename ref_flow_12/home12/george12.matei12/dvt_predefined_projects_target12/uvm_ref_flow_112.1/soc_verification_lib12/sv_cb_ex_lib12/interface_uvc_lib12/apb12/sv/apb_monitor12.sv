/*******************************************************************************
  FILE : apb_monitor12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV12
`define APB_MONITOR_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_monitor12
//------------------------------------------------------------------------------

class apb_monitor12 extends uvm_monitor;

  // Property12 indicating the number12 of transactions occuring12 on the apb12.
  protected int unsigned num_transactions12 = 0;
  // FOR12 UVM_ACCEL12
  //protected uvm_abstraction_level_t12 abstraction_level12 = RTL12;
  //protected uvma_output_pipe_proxy12#(apb_transfer12) m_op12;

  //APB12 Configuration12 Class12
  apb_config12 cfg;

  // The following12 two12 bits are used to control12 whether12 checks12 and coverage12 are
  // done both in the monitor12 class and the interface.
  bit checks_enable12 = 1; 
  bit coverage_enable12 = 1;

  // TLM PORT for sending12 transaction OUT12 to scoreboard12, register database, etc12
  uvm_analysis_port #(apb_transfer12) item_collected_port12;

  // TLM Connection12 to the Collector12 - look12 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer12, apb_monitor12) coll_mon_port12;

  // Allows12 the sequencer to look12 at monitored12 data for responses12
  uvm_blocking_peek_imp#(apb_transfer12,apb_monitor12) addr_trans_export12;
 
  // Allows12 monitor12 to look12 at collector12 for address information
  uvm_blocking_peek_port#(apb_transfer12) addr_trans_port12;

  event trans_addr_grabbed12;

  // The current apb_transfer12
  protected apb_transfer12 trans_collected12;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor12)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable12, UVM_DEFAULT)
    `uvm_field_int(coverage_enable12, UVM_DEFAULT)
    `uvm_field_int(num_transactions12, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg12;
    TRANS_ADDR12 : coverpoint trans_collected12.addr {
      bins ZERO12 = {0};
      bins NON_ZERO12 = {[1:8'h7f]};
    }
    TRANS_DIRECTION12 : coverpoint trans_collected12.direction12 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA12 : coverpoint trans_collected12.data {
      bins ZERO12     = {0};
      bins NON_ZERO12 = {[1:8'hfe]};
      bins ALL_ONES12 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION12: cross TRANS_ADDR12, TRANS_DIRECTION12;
  endgroup

  // Constructor12 - required12 syntax12 for UVM automation12 and utilities12
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected12 = new();
    // Create12 covergroup only if coverage12 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable12", coverage_enable12));
    if (coverage_enable12) begin
       apb_transfer_cg12 = new();
       apb_transfer_cg12.set_inst_name({get_full_name(), ".apb_transfer_cg12"});
    end
    // Create12 TLM ports12
    item_collected_port12 = new("item_collected_port12", this);
    coll_mon_port12 = new("coll_mon_port12", this);
    addr_trans_export12 = new("addr_trans_export12", this);
    addr_trans_port12   = new("addr_trans_port12", this);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer12 trans12); // Interface12 to the sequencer 
  // Receives12 transfers12 from the collector12
  extern virtual function void write(apb_transfer12 trans12);
  extern protected function void perform_checks12();
  extern virtual protected function void perform_coverage12();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor12

// UVM build_phase
function void apb_monitor12::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config12)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG12", "apb_config12 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor12::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port12.peek(trans_collected12);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete12: %h[%s]", trans_collected12.addr, trans_collected12.direction12.name() ), UVM_HIGH)
    -> trans_addr_grabbed12;
  end
endtask : run_phase

// FUNCTION12: peek - Allows12 the sequencer to peek at monitor12 for responses12
task apb_monitor12::peek(output apb_transfer12 trans12);
  @trans_addr_grabbed12;
  trans12 = trans_collected12;
endtask

// FUNCTION12: write - transaction interface to the collector12
function void apb_monitor12::write(apb_transfer12 trans12);
  // Make12 a copy of the transaction (may not be necessary12!)
  $cast(trans_collected12, trans12.clone());
  num_transactions12++;  
  `uvm_info(get_type_name(), {"Transaction12 Collected12:\n", trans_collected12.sprint()}, UVM_HIGH)
  if (checks_enable12) perform_checks12();
  if (coverage_enable12) perform_coverage12();
  // Broadcast12 transaction to the rest12 of the environment12 (module UVC12)
  item_collected_port12.write(trans_collected12);
endfunction : write

// FUNCTION12: perform_checks12()
function void apb_monitor12::perform_checks12();
  // Add checks12 here12
endfunction : perform_checks12

// FUNCTION12 : perform_coverage12()
function void apb_monitor12::perform_coverage12();
  apb_transfer_cg12.sample();
endfunction : perform_coverage12

// FUNCTION12: UVM report() phase
function void apb_monitor12::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report12: APB12 monitor12 collected12 %0d transfers12", num_transactions12), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV12
