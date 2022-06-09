/*******************************************************************************
  FILE : apb_monitor18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV18
`define APB_MONITOR_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_monitor18
//------------------------------------------------------------------------------

class apb_monitor18 extends uvm_monitor;

  // Property18 indicating the number18 of transactions occuring18 on the apb18.
  protected int unsigned num_transactions18 = 0;
  // FOR18 UVM_ACCEL18
  //protected uvm_abstraction_level_t18 abstraction_level18 = RTL18;
  //protected uvma_output_pipe_proxy18#(apb_transfer18) m_op18;

  //APB18 Configuration18 Class18
  apb_config18 cfg;

  // The following18 two18 bits are used to control18 whether18 checks18 and coverage18 are
  // done both in the monitor18 class and the interface.
  bit checks_enable18 = 1; 
  bit coverage_enable18 = 1;

  // TLM PORT for sending18 transaction OUT18 to scoreboard18, register database, etc18
  uvm_analysis_port #(apb_transfer18) item_collected_port18;

  // TLM Connection18 to the Collector18 - look18 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer18, apb_monitor18) coll_mon_port18;

  // Allows18 the sequencer to look18 at monitored18 data for responses18
  uvm_blocking_peek_imp#(apb_transfer18,apb_monitor18) addr_trans_export18;
 
  // Allows18 monitor18 to look18 at collector18 for address information
  uvm_blocking_peek_port#(apb_transfer18) addr_trans_port18;

  event trans_addr_grabbed18;

  // The current apb_transfer18
  protected apb_transfer18 trans_collected18;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor18)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable18, UVM_DEFAULT)
    `uvm_field_int(coverage_enable18, UVM_DEFAULT)
    `uvm_field_int(num_transactions18, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg18;
    TRANS_ADDR18 : coverpoint trans_collected18.addr {
      bins ZERO18 = {0};
      bins NON_ZERO18 = {[1:8'h7f]};
    }
    TRANS_DIRECTION18 : coverpoint trans_collected18.direction18 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA18 : coverpoint trans_collected18.data {
      bins ZERO18     = {0};
      bins NON_ZERO18 = {[1:8'hfe]};
      bins ALL_ONES18 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION18: cross TRANS_ADDR18, TRANS_DIRECTION18;
  endgroup

  // Constructor18 - required18 syntax18 for UVM automation18 and utilities18
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected18 = new();
    // Create18 covergroup only if coverage18 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable18", coverage_enable18));
    if (coverage_enable18) begin
       apb_transfer_cg18 = new();
       apb_transfer_cg18.set_inst_name({get_full_name(), ".apb_transfer_cg18"});
    end
    // Create18 TLM ports18
    item_collected_port18 = new("item_collected_port18", this);
    coll_mon_port18 = new("coll_mon_port18", this);
    addr_trans_export18 = new("addr_trans_export18", this);
    addr_trans_port18   = new("addr_trans_port18", this);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer18 trans18); // Interface18 to the sequencer 
  // Receives18 transfers18 from the collector18
  extern virtual function void write(apb_transfer18 trans18);
  extern protected function void perform_checks18();
  extern virtual protected function void perform_coverage18();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor18

// UVM build_phase
function void apb_monitor18::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config18)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG18", "apb_config18 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor18::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port18.peek(trans_collected18);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete18: %h[%s]", trans_collected18.addr, trans_collected18.direction18.name() ), UVM_HIGH)
    -> trans_addr_grabbed18;
  end
endtask : run_phase

// FUNCTION18: peek - Allows18 the sequencer to peek at monitor18 for responses18
task apb_monitor18::peek(output apb_transfer18 trans18);
  @trans_addr_grabbed18;
  trans18 = trans_collected18;
endtask

// FUNCTION18: write - transaction interface to the collector18
function void apb_monitor18::write(apb_transfer18 trans18);
  // Make18 a copy of the transaction (may not be necessary18!)
  $cast(trans_collected18, trans18.clone());
  num_transactions18++;  
  `uvm_info(get_type_name(), {"Transaction18 Collected18:\n", trans_collected18.sprint()}, UVM_HIGH)
  if (checks_enable18) perform_checks18();
  if (coverage_enable18) perform_coverage18();
  // Broadcast18 transaction to the rest18 of the environment18 (module UVC18)
  item_collected_port18.write(trans_collected18);
endfunction : write

// FUNCTION18: perform_checks18()
function void apb_monitor18::perform_checks18();
  // Add checks18 here18
endfunction : perform_checks18

// FUNCTION18 : perform_coverage18()
function void apb_monitor18::perform_coverage18();
  apb_transfer_cg18.sample();
endfunction : perform_coverage18

// FUNCTION18: UVM report() phase
function void apb_monitor18::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report18: APB18 monitor18 collected18 %0d transfers18", num_transactions18), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV18
