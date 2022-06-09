/*******************************************************************************
  FILE : apb_monitor28.sv
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_MONITOR_SV28
`define APB_MONITOR_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_monitor28
//------------------------------------------------------------------------------

class apb_monitor28 extends uvm_monitor;

  // Property28 indicating the number28 of transactions occuring28 on the apb28.
  protected int unsigned num_transactions28 = 0;
  // FOR28 UVM_ACCEL28
  //protected uvm_abstraction_level_t28 abstraction_level28 = RTL28;
  //protected uvma_output_pipe_proxy28#(apb_transfer28) m_op28;

  //APB28 Configuration28 Class28
  apb_config28 cfg;

  // The following28 two28 bits are used to control28 whether28 checks28 and coverage28 are
  // done both in the monitor28 class and the interface.
  bit checks_enable28 = 1; 
  bit coverage_enable28 = 1;

  // TLM PORT for sending28 transaction OUT28 to scoreboard28, register database, etc28
  uvm_analysis_port #(apb_transfer28) item_collected_port28;

  // TLM Connection28 to the Collector28 - look28 for a write() task implementation
  uvm_analysis_imp  #(apb_transfer28, apb_monitor28) coll_mon_port28;

  // Allows28 the sequencer to look28 at monitored28 data for responses28
  uvm_blocking_peek_imp#(apb_transfer28,apb_monitor28) addr_trans_export28;
 
  // Allows28 monitor28 to look28 at collector28 for address information
  uvm_blocking_peek_port#(apb_transfer28) addr_trans_port28;

  event trans_addr_grabbed28;

  // The current apb_transfer28
  protected apb_transfer28 trans_collected28;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(apb_monitor28)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable28, UVM_DEFAULT)
    `uvm_field_int(coverage_enable28, UVM_DEFAULT)
    `uvm_field_int(num_transactions28, UVM_DEFAULT)
  `uvm_component_utils_end

  covergroup apb_transfer_cg28;
    TRANS_ADDR28 : coverpoint trans_collected28.addr {
      bins ZERO28 = {0};
      bins NON_ZERO28 = {[1:8'h7f]};
    }
    TRANS_DIRECTION28 : coverpoint trans_collected28.direction28 {
      bins READ = {0};
      bins WRITE = {1};
    }
    TRANS_DATA28 : coverpoint trans_collected28.data {
      bins ZERO28     = {0};
      bins NON_ZERO28 = {[1:8'hfe]};
      bins ALL_ONES28 = {8'hff};
    }
    TRANS_ADDR_X_TRANS_DIRECTION28: cross TRANS_ADDR28, TRANS_DIRECTION28;
  endgroup

  // Constructor28 - required28 syntax28 for UVM automation28 and utilities28
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected28 = new();
    // Create28 covergroup only if coverage28 is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable28", coverage_enable28));
    if (coverage_enable28) begin
       apb_transfer_cg28 = new();
       apb_transfer_cg28.set_inst_name({get_full_name(), ".apb_transfer_cg28"});
    end
    // Create28 TLM ports28
    item_collected_port28 = new("item_collected_port28", this);
    coll_mon_port28 = new("coll_mon_port28", this);
    addr_trans_export28 = new("addr_trans_export28", this);
    addr_trans_port28   = new("addr_trans_port28", this);
  endfunction : new

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task peek (output apb_transfer28 trans28); // Interface28 to the sequencer 
  // Receives28 transfers28 from the collector28
  extern virtual function void write(apb_transfer28 trans28);
  extern protected function void perform_checks28();
  extern virtual protected function void perform_coverage28();
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_monitor28

// UVM build_phase
function void apb_monitor28::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config28)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG28", "apb_config28 not set for this component")
endfunction : build_phase

// UVM run_phase
task apb_monitor28::run_phase(uvm_phase phase);
  forever begin
    addr_trans_port28.peek(trans_collected28);
    `uvm_info(get_type_name(), $psprintf("Address Phase Complete28: %h[%s]", trans_collected28.addr, trans_collected28.direction28.name() ), UVM_HIGH)
    -> trans_addr_grabbed28;
  end
endtask : run_phase

// FUNCTION28: peek - Allows28 the sequencer to peek at monitor28 for responses28
task apb_monitor28::peek(output apb_transfer28 trans28);
  @trans_addr_grabbed28;
  trans28 = trans_collected28;
endtask

// FUNCTION28: write - transaction interface to the collector28
function void apb_monitor28::write(apb_transfer28 trans28);
  // Make28 a copy of the transaction (may not be necessary28!)
  $cast(trans_collected28, trans28.clone());
  num_transactions28++;  
  `uvm_info(get_type_name(), {"Transaction28 Collected28:\n", trans_collected28.sprint()}, UVM_HIGH)
  if (checks_enable28) perform_checks28();
  if (coverage_enable28) perform_coverage28();
  // Broadcast28 transaction to the rest28 of the environment28 (module UVC28)
  item_collected_port28.write(trans_collected28);
endfunction : write

// FUNCTION28: perform_checks28()
function void apb_monitor28::perform_checks28();
  // Add checks28 here28
endfunction : perform_checks28

// FUNCTION28 : perform_coverage28()
function void apb_monitor28::perform_coverage28();
  apb_transfer_cg28.sample();
endfunction : perform_coverage28

// FUNCTION28: UVM report() phase
function void apb_monitor28::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report28: APB28 monitor28 collected28 %0d transfers28", num_transactions28), UVM_LOW);
endfunction : report_phase

`endif // APB_MONITOR_SV28
