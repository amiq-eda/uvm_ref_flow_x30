/*******************************************************************************
  FILE : apb_monitor14.sv
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV14
`define APB_MONITOR_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_monitor14
//------------------------------------------------------------------------------

class apb_monitor14 extends uvm_monitor;

  // Property14 indicating the number14 of transactions occuring14 on the apb14.
  protected int unsigned num_transactions14 = 0;
  // FOR14 UVM_ACCEL14
  //protected uvm_abstraction_level_t14 abstraction_level14 = RTL14;
  //protected uvma_output_pipe_proxy14#(apb_transfer14) m_op14;

  //APB14 Configuration14 Class14
  apb_config14 cfg;

  // The following14 two14 bits are used to control14 whether14 checks14 and coverage14 are
  // done both in the monitor14 class and the interface.
  bit checks_enable14 = 1; 
  bit coverage_enable14 = 1;

  // TLM PORT for sending14 transaction OUT14 to scoreboard14, register database, etc14
  uvm_analysis_port #(apb_transfer14) item_collected_port14;

  // TLM Connection14 to the Collector14 - look14 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer14, apb_monitor14) coll_mon_port14;

  // Allows14 the sequencer to look14 at monitored14 data for responses14
  uvm_blocking_peek_imp#(apb_transfer14,apb_monitor14) addr_trans_export14;
 
  // Allows14 monitor14 to look14 at collector14 for address information
  uvm_blocking_peek_port#(apb_transfer14) addr_trans_port14;

  event trans_addr_grabbed14;

  // The current apb_transfer14
  protected apb_transfer14 trans_collected14;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor14)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable14, UVM_DEFAULT)
    `uvm_field_int(coverage_enable14, UVM_DEFAULT)
    `uvm_field_int(num_transactions14, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg14;
    TRANS_ADDR14 : coverpoint trans_collected14.addr {
      bins ZERO14 = {0};
      bins NON_ZERO14 = {[1:8'h7f]};
    }
    TRANS_DIRECTION14 : coverpoint trans_collected14.direction14 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA14 : coverpoint trans_collected14.data {
      bins ZERO14     = {0};
      bins NON_ZERO14 = {[1:8'hfe]};
      bins ALL_ONES14 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION14: cross TRANS_ADDR14, TRANS_DIRECTION14;
  endgroup

  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected14 = new();
    // Create14 covergroup only if coverage14 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable14", coverage_enable14));
    if (coverage_enable14) begin
       apb_transfer_cg14 = new();
       apb_transfer_cg14.set_inst_name({get_full_name(), ".apb_transfer_cg14"});
    end
    // Create14 TLM ports14
    item_collected_port14 = new("item_collected_port14", this);
    coll_mon_port14 = new("coll_mon_port14", this);
    addr_trans_export14 = new("addr_trans_export14", this);
    addr_trans_port14   = new("addr_trans_port14", this);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer14 trans14); // Interface14 to the sequencer 
  // Receives14 transfers14 from the collector14
  extern virtual function void write(apb_transfer14 trans14);
  extern protected function void perform_checks14();
  extern virtual protected function void perform_coverage14();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor14

// UVM build_phase
function void apb_monitor14::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config14)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG14", "apb_config14 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor14::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port14.peek(trans_collected14);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete14: %h[%s]", trans_collected14.addr, trans_collected14.direction14.name() ), UVM_HIGH)
    -> trans_addr_grabbed14;
  end
endtask : run_phase

// FUNCTION14: peek - Allows14 the sequencer to peek at monitor14 for responses14
task apb_monitor14::peek(output apb_transfer14 trans14);
  @trans_addr_grabbed14;
  trans14 = trans_collected14;
endtask

// FUNCTION14: write - transaction interface to the collector14
function void apb_monitor14::write(apb_transfer14 trans14);
  // Make14 a copy of the transaction (may not be necessary14!)
  $cast(trans_collected14, trans14.clone());
  num_transactions14++;  
  `uvm_info(get_type_name(), {"Transaction14 Collected14:\n", trans_collected14.sprint()}, UVM_HIGH)
  if (checks_enable14) perform_checks14();
  if (coverage_enable14) perform_coverage14();
  // Broadcast14 transaction to the rest14 of the environment14 (module UVC14)
  item_collected_port14.write(trans_collected14);
endfunction : write

// FUNCTION14: perform_checks14()
function void apb_monitor14::perform_checks14();
  // Add checks14 here14
endfunction : perform_checks14

// FUNCTION14 : perform_coverage14()
function void apb_monitor14::perform_coverage14();
  apb_transfer_cg14.sample();
endfunction : perform_coverage14

// FUNCTION14: UVM report() phase
function void apb_monitor14::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report14: APB14 monitor14 collected14 %0d transfers14", num_transactions14), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV14
