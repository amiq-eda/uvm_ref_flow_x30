/*******************************************************************************
  FILE : apb_collector17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV17
`define APB_COLLECTOR_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_collector17
//------------------------------------------------------------------------------

class apb_collector17 extends uvm_component;

  // The virtual interface used to view17 HDL signals17.
  virtual apb_if17 vif17;

  // APB17 configuration information
  apb_config17 cfg;

  // Property17 indicating the number17 of transactions occuring17 on the apb17.
  protected int unsigned num_transactions17 = 0;

  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done both in the collector17 class and the interface.
  bit checks_enable17 = 1; 
  bit coverage_enable17 = 1;

  // TLM Ports17 - transfer17 collected17 for monitor17 other components17
  uvm_analysis_port #(apb_transfer17) item_collected_port17;

  // TLM Port17 - Allows17 sequencer access to transfer17 during address phase
  uvm_blocking_peek_imp#(apb_transfer17,apb_collector17) addr_trans_export17;
  event addr_trans_grabbed17;

  // The following17 property holds17 the transaction information currently
  // being captured17 (by the collect_address_phase17 and data_phase17 methods17). 
  apb_transfer17 trans_collected17;

  //Adding pseudo17-memory leakage17 for heap17 analysis17 lab17
  `ifdef HEAP17
  static apb_transfer17 runq17[$];
  `endif

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(apb_collector17)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable17, UVM_DEFAULT)
    `uvm_field_int(coverage_enable17, UVM_DEFAULT)
    `uvm_field_int(num_transactions17, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected17 = apb_transfer17::type_id::create("trans_collected17");
    // TLM ports17 are created here17
    item_collected_port17 = new("item_collected_port17", this);
    addr_trans_export17 = new("addr_trans_export17", this);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions17();
  extern task peek(output apb_transfer17 trans17);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector17

// UVM build_phase
function void apb_collector17::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config17)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG17", "apb_config17 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector17::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if17)::get(this, "", "vif17", vif17))
      `uvm_error("NOVIF17", {"virtual interface must be set for: ", get_full_name(), ".vif17"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector17::run_phase(uvm_phase phase);
    @(posedge vif17.preset17);
    `uvm_info(get_type_name(), "Detected17 Reset17 Done17", UVM_LOW)
    collect_transactions17();
endtask : run_phase

// collect_transactions17
task apb_collector17::collect_transactions17();
  forever begin
    @(posedge vif17.pclock17 iff (vif17.psel17 != 0));
    void'(this.begin_tr(trans_collected17,"apb_collector17","UVM Debug17","APB17 collector17 transaction inside collect_transactions17()"));
    trans_collected17.addr = vif17.paddr17;
    trans_collected17.master17 = cfg.master_config17.name;
    trans_collected17.slave17 = cfg.get_slave_name_by_addr17(trans_collected17.addr);
    case (vif17.prwd17)
      1'b0 : trans_collected17.direction17 = APB_READ17;
      1'b1 : trans_collected17.direction17 = APB_WRITE17;
    endcase
      @(posedge vif17.pclock17);
    if(trans_collected17.direction17 == APB_READ17)
      trans_collected17.data = vif17.prdata17;
    if (trans_collected17.direction17 == APB_WRITE17)
      trans_collected17.data = vif17.pwdata17;
    -> addr_trans_grabbed17;
    @(posedge vif17.pclock17);
    if(trans_collected17.direction17 == APB_READ17) begin
        if(vif17.pready17 != 1'b1)
          @(posedge vif17.pclock17);
      trans_collected17.data = vif17.prdata17;
      end
    this.end_tr(trans_collected17);
    item_collected_port17.write(trans_collected17);
    `uvm_info(get_type_name(), $psprintf("Transfer17 collected17 :\n%s",
              trans_collected17.sprint()), UVM_MEDIUM)
      `ifdef HEAP17
      runq17.push_back(trans_collected17);
      `endif
     num_transactions17++;
    end
endtask : collect_transactions17

task apb_collector17::peek(output apb_transfer17 trans17);
  @addr_trans_grabbed17;
  trans17 = trans_collected17;
endtask : peek

function void apb_collector17::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report17: APB17 collector17 collected17 %0d transfers17", num_transactions17), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV17
