/*******************************************************************************
  FILE : apb_collector28.sv
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


`ifndef APB_COLLECTOR_SV28
`define APB_COLLECTOR_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_collector28
//------------------------------------------------------------------------------

class apb_collector28 extends uvm_component;

  // The virtual interface used to view28 HDL signals28.
  virtual apb_if28 vif28;

  // APB28 configuration information
  apb_config28 cfg;

  // Property28 indicating the number28 of transactions occuring28 on the apb28.
  protected int unsigned num_transactions28 = 0;

  // The following28 two28 bits are used to control28 whether28 checks28 and coverage28 are
  // done both in the collector28 class and the interface.
  bit checks_enable28 = 1; 
  bit coverage_enable28 = 1;

  // TLM Ports28 - transfer28 collected28 for monitor28 other components28
  uvm_analysis_port #(apb_transfer28) item_collected_port28;

  // TLM Port28 - Allows28 sequencer access to transfer28 during address phase
  uvm_blocking_peek_imp#(apb_transfer28,apb_collector28) addr_trans_export28;
  event addr_trans_grabbed28;

  // The following28 property holds28 the transaction information currently
  // being captured28 (by the collect_address_phase28 and data_phase28 methods28). 
  apb_transfer28 trans_collected28;

  //Adding pseudo28-memory leakage28 for heap28 analysis28 lab28
  `ifdef HEAP28
  static apb_transfer28 runq28[$];
  `endif

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(apb_collector28)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable28, UVM_DEFAULT)
    `uvm_field_int(coverage_enable28, UVM_DEFAULT)
    `uvm_field_int(num_transactions28, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected28 = apb_transfer28::type_id::create("trans_collected28");
    // TLM ports28 are created here28
    item_collected_port28 = new("item_collected_port28", this);
    addr_trans_export28 = new("addr_trans_export28", this);
  endfunction : new

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions28();
  extern task peek(output apb_transfer28 trans28);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector28

// UVM build_phase
function void apb_collector28::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config28)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG28", "apb_config28 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector28::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if28)::get(this, "", "vif28", vif28))
      `uvm_error("NOVIF28", {"virtual interface must be set for: ", get_full_name(), ".vif28"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector28::run_phase(uvm_phase phase);
    @(posedge vif28.preset28);
    `uvm_info(get_type_name(), "Detected28 Reset28 Done28", UVM_LOW)
    collect_transactions28();
endtask : run_phase

// collect_transactions28
task apb_collector28::collect_transactions28();
  forever begin
    @(posedge vif28.pclock28 iff (vif28.psel28 != 0));
    void'(this.begin_tr(trans_collected28,"apb_collector28","UVM Debug28","APB28 collector28 transaction inside collect_transactions28()"));
    trans_collected28.addr = vif28.paddr28;
    trans_collected28.master28 = cfg.master_config28.name;
    trans_collected28.slave28 = cfg.get_slave_name_by_addr28(trans_collected28.addr);
    case (vif28.prwd28)
      1'b0 : trans_collected28.direction28 = APB_READ28;
      1'b1 : trans_collected28.direction28 = APB_WRITE28;
    endcase
      @(posedge vif28.pclock28);
    if(trans_collected28.direction28 == APB_READ28)
      trans_collected28.data = vif28.prdata28;
    if (trans_collected28.direction28 == APB_WRITE28)
      trans_collected28.data = vif28.pwdata28;
    -> addr_trans_grabbed28;
    @(posedge vif28.pclock28);
    if(trans_collected28.direction28 == APB_READ28) begin
        if(vif28.pready28 != 1'b1)
          @(posedge vif28.pclock28);
      trans_collected28.data = vif28.prdata28;
      end
    this.end_tr(trans_collected28);
    item_collected_port28.write(trans_collected28);
    `uvm_info(get_type_name(), $psprintf("Transfer28 collected28 :\n%s",
              trans_collected28.sprint()), UVM_MEDIUM)
      `ifdef HEAP28
      runq28.push_back(trans_collected28);
      `endif
     num_transactions28++;
    end
endtask : collect_transactions28

task apb_collector28::peek(output apb_transfer28 trans28);
  @addr_trans_grabbed28;
  trans28 = trans_collected28;
endtask : peek

function void apb_collector28::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report28: APB28 collector28 collected28 %0d transfers28", num_transactions28), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV28
