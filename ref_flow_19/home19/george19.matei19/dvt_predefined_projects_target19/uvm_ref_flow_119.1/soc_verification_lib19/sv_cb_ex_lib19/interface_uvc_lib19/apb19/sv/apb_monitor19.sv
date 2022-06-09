/*******************************************************************************
  FILE : apb_monitor19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV19
`define APB_MONITOR_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_monitor19
//------------------------------------------------------------------------------

class apb_monitor19 extends uvm_monitor;

  // Property19 indicating the number19 of transactions occuring19 on the apb19.
  protected int unsigned num_transactions19 = 0;
  // FOR19 UVM_ACCEL19
  //protected uvm_abstraction_level_t19 abstraction_level19 = RTL19;
  //protected uvma_output_pipe_proxy19#(apb_transfer19) m_op19;

  //APB19 Configuration19 Class19
  apb_config19 cfg;

  // The following19 two19 bits are used to control19 whether19 checks19 and coverage19 are
  // done both in the monitor19 class and the interface.
  bit checks_enable19 = 1; 
  bit coverage_enable19 = 1;

  // TLM PORT for sending19 transaction OUT19 to scoreboard19, register database, etc19
  uvm_analysis_port #(apb_transfer19) item_collected_port19;

  // TLM Connection19 to the Collector19 - look19 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer19, apb_monitor19) coll_mon_port19;

  // Allows19 the sequencer to look19 at monitored19 data for responses19
  uvm_blocking_peek_imp#(apb_transfer19,apb_monitor19) addr_trans_export19;
 
  // Allows19 monitor19 to look19 at collector19 for address information
  uvm_blocking_peek_port#(apb_transfer19) addr_trans_port19;

  event trans_addr_grabbed19;

  // The current apb_transfer19
  protected apb_transfer19 trans_collected19;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor19)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable19, UVM_DEFAULT)
    `uvm_field_int(coverage_enable19, UVM_DEFAULT)
    `uvm_field_int(num_transactions19, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg19;
    TRANS_ADDR19 : coverpoint trans_collected19.addr {
      bins ZERO19 = {0};
      bins NON_ZERO19 = {[1:8'h7f]};
    }
    TRANS_DIRECTION19 : coverpoint trans_collected19.direction19 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA19 : coverpoint trans_collected19.data {
      bins ZERO19     = {0};
      bins NON_ZERO19 = {[1:8'hfe]};
      bins ALL_ONES19 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION19: cross TRANS_ADDR19, TRANS_DIRECTION19;
  endgroup

  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected19 = new();
    // Create19 covergroup only if coverage19 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable19", coverage_enable19));
    if (coverage_enable19) begin
       apb_transfer_cg19 = new();
       apb_transfer_cg19.set_inst_name({get_full_name(), ".apb_transfer_cg19"});
    end
    // Create19 TLM ports19
    item_collected_port19 = new("item_collected_port19", this);
    coll_mon_port19 = new("coll_mon_port19", this);
    addr_trans_export19 = new("addr_trans_export19", this);
    addr_trans_port19   = new("addr_trans_port19", this);
  endfunction : new

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer19 trans19); // Interface19 to the sequencer 
  // Receives19 transfers19 from the collector19
  extern virtual function void write(apb_transfer19 trans19);
  extern protected function void perform_checks19();
  extern virtual protected function void perform_coverage19();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor19

// UVM build_phase
function void apb_monitor19::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config19)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG19", "apb_config19 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor19::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port19.peek(trans_collected19);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete19: %h[%s]", trans_collected19.addr, trans_collected19.direction19.name() ), UVM_HIGH)
    -> trans_addr_grabbed19;
  end
endtask : run_phase

// FUNCTION19: peek - Allows19 the sequencer to peek at monitor19 for responses19
task apb_monitor19::peek(output apb_transfer19 trans19);
  @trans_addr_grabbed19;
  trans19 = trans_collected19;
endtask

// FUNCTION19: write - transaction interface to the collector19
function void apb_monitor19::write(apb_transfer19 trans19);
  // Make19 a copy of the transaction (may not be necessary19!)
  $cast(trans_collected19, trans19.clone());
  num_transactions19++;  
  `uvm_info(get_type_name(), {"Transaction19 Collected19:\n", trans_collected19.sprint()}, UVM_HIGH)
  if (checks_enable19) perform_checks19();
  if (coverage_enable19) perform_coverage19();
  // Broadcast19 transaction to the rest19 of the environment19 (module UVC19)
  item_collected_port19.write(trans_collected19);
endfunction : write

// FUNCTION19: perform_checks19()
function void apb_monitor19::perform_checks19();
  // Add checks19 here19
endfunction : perform_checks19

// FUNCTION19 : perform_coverage19()
function void apb_monitor19::perform_coverage19();
  apb_transfer_cg19.sample();
endfunction : perform_coverage19

// FUNCTION19: UVM report() phase
function void apb_monitor19::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report19: APB19 monitor19 collected19 %0d transfers19", num_transactions19), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV19
