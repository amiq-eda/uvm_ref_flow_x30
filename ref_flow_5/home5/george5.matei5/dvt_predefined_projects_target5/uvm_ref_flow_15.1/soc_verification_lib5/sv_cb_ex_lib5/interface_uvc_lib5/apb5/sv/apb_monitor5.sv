/*******************************************************************************
  FILE : apb_monitor5.sv
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV5
`define APB_MONITOR_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_monitor5
//------------------------------------------------------------------------------

class apb_monitor5 extends uvm_monitor;

  // Property5 indicating the number5 of transactions occuring5 on the apb5.
  protected int unsigned num_transactions5 = 0;
  // FOR5 UVM_ACCEL5
  //protected uvm_abstraction_level_t5 abstraction_level5 = RTL5;
  //protected uvma_output_pipe_proxy5#(apb_transfer5) m_op5;

  //APB5 Configuration5 Class5
  apb_config5 cfg;

  // The following5 two5 bits are used to control5 whether5 checks5 and coverage5 are
  // done both in the monitor5 class and the interface.
  bit checks_enable5 = 1; 
  bit coverage_enable5 = 1;

  // TLM PORT for sending5 transaction OUT5 to scoreboard5, register database, etc5
  uvm_analysis_port #(apb_transfer5) item_collected_port5;

  // TLM Connection5 to the Collector5 - look5 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer5, apb_monitor5) coll_mon_port5;

  // Allows5 the sequencer to look5 at monitored5 data for responses5
  uvm_blocking_peek_imp#(apb_transfer5,apb_monitor5) addr_trans_export5;
 
  // Allows5 monitor5 to look5 at collector5 for address information
  uvm_blocking_peek_port#(apb_transfer5) addr_trans_port5;

  event trans_addr_grabbed5;

  // The current apb_transfer5
  protected apb_transfer5 trans_collected5;

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor5)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable5, UVM_DEFAULT)
    `uvm_field_int(coverage_enable5, UVM_DEFAULT)
    `uvm_field_int(num_transactions5, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg5;
    TRANS_ADDR5 : coverpoint trans_collected5.addr {
      bins ZERO5 = {0};
      bins NON_ZERO5 = {[1:8'h7f]};
    }
    TRANS_DIRECTION5 : coverpoint trans_collected5.direction5 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA5 : coverpoint trans_collected5.data {
      bins ZERO5     = {0};
      bins NON_ZERO5 = {[1:8'hfe]};
      bins ALL_ONES5 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION5: cross TRANS_ADDR5, TRANS_DIRECTION5;
  endgroup

  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected5 = new();
    // Create5 covergroup only if coverage5 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable5", coverage_enable5));
    if (coverage_enable5) begin
       apb_transfer_cg5 = new();
       apb_transfer_cg5.set_inst_name({get_full_name(), ".apb_transfer_cg5"});
    end
    // Create5 TLM ports5
    item_collected_port5 = new("item_collected_port5", this);
    coll_mon_port5 = new("coll_mon_port5", this);
    addr_trans_export5 = new("addr_trans_export5", this);
    addr_trans_port5   = new("addr_trans_port5", this);
  endfunction : new

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer5 trans5); // Interface5 to the sequencer 
  // Receives5 transfers5 from the collector5
  extern virtual function void write(apb_transfer5 trans5);
  extern protected function void perform_checks5();
  extern virtual protected function void perform_coverage5();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor5

// UVM build_phase
function void apb_monitor5::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config5)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG5", "apb_config5 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor5::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port5.peek(trans_collected5);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete5: %h[%s]", trans_collected5.addr, trans_collected5.direction5.name() ), UVM_HIGH)
    -> trans_addr_grabbed5;
  end
endtask : run_phase

// FUNCTION5: peek - Allows5 the sequencer to peek at monitor5 for responses5
task apb_monitor5::peek(output apb_transfer5 trans5);
  @trans_addr_grabbed5;
  trans5 = trans_collected5;
endtask

// FUNCTION5: write - transaction interface to the collector5
function void apb_monitor5::write(apb_transfer5 trans5);
  // Make5 a copy of the transaction (may not be necessary5!)
  $cast(trans_collected5, trans5.clone());
  num_transactions5++;  
  `uvm_info(get_type_name(), {"Transaction5 Collected5:\n", trans_collected5.sprint()}, UVM_HIGH)
  if (checks_enable5) perform_checks5();
  if (coverage_enable5) perform_coverage5();
  // Broadcast5 transaction to the rest5 of the environment5 (module UVC5)
  item_collected_port5.write(trans_collected5);
endfunction : write

// FUNCTION5: perform_checks5()
function void apb_monitor5::perform_checks5();
  // Add checks5 here5
endfunction : perform_checks5

// FUNCTION5 : perform_coverage5()
function void apb_monitor5::perform_coverage5();
  apb_transfer_cg5.sample();
endfunction : perform_coverage5

// FUNCTION5: UVM report() phase
function void apb_monitor5::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report5: APB5 monitor5 collected5 %0d transfers5", num_transactions5), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV5
