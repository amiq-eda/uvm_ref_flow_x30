/*******************************************************************************
  FILE : apb_monitor21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV21
`define APB_MONITOR_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_monitor21
//------------------------------------------------------------------------------

class apb_monitor21 extends uvm_monitor;

  // Property21 indicating the number21 of transactions occuring21 on the apb21.
  protected int unsigned num_transactions21 = 0;
  // FOR21 UVM_ACCEL21
  //protected uvm_abstraction_level_t21 abstraction_level21 = RTL21;
  //protected uvma_output_pipe_proxy21#(apb_transfer21) m_op21;

  //APB21 Configuration21 Class21
  apb_config21 cfg;

  // The following21 two21 bits are used to control21 whether21 checks21 and coverage21 are
  // done both in the monitor21 class and the interface.
  bit checks_enable21 = 1; 
  bit coverage_enable21 = 1;

  // TLM PORT for sending21 transaction OUT21 to scoreboard21, register database, etc21
  uvm_analysis_port #(apb_transfer21) item_collected_port21;

  // TLM Connection21 to the Collector21 - look21 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer21, apb_monitor21) coll_mon_port21;

  // Allows21 the sequencer to look21 at monitored21 data for responses21
  uvm_blocking_peek_imp#(apb_transfer21,apb_monitor21) addr_trans_export21;
 
  // Allows21 monitor21 to look21 at collector21 for address information
  uvm_blocking_peek_port#(apb_transfer21) addr_trans_port21;

  event trans_addr_grabbed21;

  // The current apb_transfer21
  protected apb_transfer21 trans_collected21;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor21)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable21, UVM_DEFAULT)
    `uvm_field_int(coverage_enable21, UVM_DEFAULT)
    `uvm_field_int(num_transactions21, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg21;
    TRANS_ADDR21 : coverpoint trans_collected21.addr {
      bins ZERO21 = {0};
      bins NON_ZERO21 = {[1:8'h7f]};
    }
    TRANS_DIRECTION21 : coverpoint trans_collected21.direction21 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA21 : coverpoint trans_collected21.data {
      bins ZERO21     = {0};
      bins NON_ZERO21 = {[1:8'hfe]};
      bins ALL_ONES21 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION21: cross TRANS_ADDR21, TRANS_DIRECTION21;
  endgroup

  // Constructor21 - required21 syntax21 for UVM automation21 and utilities21
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected21 = new();
    // Create21 covergroup only if coverage21 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable21", coverage_enable21));
    if (coverage_enable21) begin
       apb_transfer_cg21 = new();
       apb_transfer_cg21.set_inst_name({get_full_name(), ".apb_transfer_cg21"});
    end
    // Create21 TLM ports21
    item_collected_port21 = new("item_collected_port21", this);
    coll_mon_port21 = new("coll_mon_port21", this);
    addr_trans_export21 = new("addr_trans_export21", this);
    addr_trans_port21   = new("addr_trans_port21", this);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer21 trans21); // Interface21 to the sequencer 
  // Receives21 transfers21 from the collector21
  extern virtual function void write(apb_transfer21 trans21);
  extern protected function void perform_checks21();
  extern virtual protected function void perform_coverage21();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor21

// UVM build_phase
function void apb_monitor21::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config21)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG21", "apb_config21 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor21::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port21.peek(trans_collected21);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete21: %h[%s]", trans_collected21.addr, trans_collected21.direction21.name() ), UVM_HIGH)
    -> trans_addr_grabbed21;
  end
endtask : run_phase

// FUNCTION21: peek - Allows21 the sequencer to peek at monitor21 for responses21
task apb_monitor21::peek(output apb_transfer21 trans21);
  @trans_addr_grabbed21;
  trans21 = trans_collected21;
endtask

// FUNCTION21: write - transaction interface to the collector21
function void apb_monitor21::write(apb_transfer21 trans21);
  // Make21 a copy of the transaction (may not be necessary21!)
  $cast(trans_collected21, trans21.clone());
  num_transactions21++;  
  `uvm_info(get_type_name(), {"Transaction21 Collected21:\n", trans_collected21.sprint()}, UVM_HIGH)
  if (checks_enable21) perform_checks21();
  if (coverage_enable21) perform_coverage21();
  // Broadcast21 transaction to the rest21 of the environment21 (module UVC21)
  item_collected_port21.write(trans_collected21);
endfunction : write

// FUNCTION21: perform_checks21()
function void apb_monitor21::perform_checks21();
  // Add checks21 here21
endfunction : perform_checks21

// FUNCTION21 : perform_coverage21()
function void apb_monitor21::perform_coverage21();
  apb_transfer_cg21.sample();
endfunction : perform_coverage21

// FUNCTION21: UVM report() phase
function void apb_monitor21::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report21: APB21 monitor21 collected21 %0d transfers21", num_transactions21), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV21
