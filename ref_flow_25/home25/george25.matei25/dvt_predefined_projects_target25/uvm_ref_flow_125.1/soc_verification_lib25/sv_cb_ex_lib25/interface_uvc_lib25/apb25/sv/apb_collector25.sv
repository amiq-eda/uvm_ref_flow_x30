/*******************************************************************************
  FILE : apb_collector25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV25
`define APB_COLLECTOR_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_collector25
//------------------------------------------------------------------------------

class apb_collector25 extends uvm_component;

  // The virtual interface used to view25 HDL signals25.
  virtual apb_if25 vif25;

  // APB25 configuration information
  apb_config25 cfg;

  // Property25 indicating the number25 of transactions occuring25 on the apb25.
  protected int unsigned num_transactions25 = 0;

  // The following25 two25 bits are used to control25 whether25 checks25 and coverage25 are
  // done both in the collector25 class and the interface.
  bit checks_enable25 = 1; 
  bit coverage_enable25 = 1;

  // TLM Ports25 - transfer25 collected25 for monitor25 other components25
  uvm_analysis_port #(apb_transfer25) item_collected_port25;

  // TLM Port25 - Allows25 sequencer access to transfer25 during address phase
  uvm_blocking_peek_imp#(apb_transfer25,apb_collector25) addr_trans_export25;
  event addr_trans_grabbed25;

  // The following25 property holds25 the transaction information currently
  // being captured25 (by the collect_address_phase25 and data_phase25 methods25). 
  apb_transfer25 trans_collected25;

  //Adding pseudo25-memory leakage25 for heap25 analysis25 lab25
  `ifdef HEAP25
  static apb_transfer25 runq25[$];
  `endif

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(apb_collector25)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable25, UVM_DEFAULT)
    `uvm_field_int(coverage_enable25, UVM_DEFAULT)
    `uvm_field_int(num_transactions25, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected25 = apb_transfer25::type_id::create("trans_collected25");
    // TLM ports25 are created here25
    item_collected_port25 = new("item_collected_port25", this);
    addr_trans_export25 = new("addr_trans_export25", this);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions25();
  extern task peek(output apb_transfer25 trans25);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector25

// UVM build_phase
function void apb_collector25::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config25)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG25", "apb_config25 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector25::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if25)::get(this, "", "vif25", vif25))
      `uvm_error("NOVIF25", {"virtual interface must be set for: ", get_full_name(), ".vif25"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector25::run_phase(uvm_phase phase);
    @(posedge vif25.preset25);
    `uvm_info(get_type_name(), "Detected25 Reset25 Done25", UVM_LOW)
    collect_transactions25();
endtask : run_phase

// collect_transactions25
task apb_collector25::collect_transactions25();
  forever begin
    @(posedge vif25.pclock25 iff (vif25.psel25 != 0));
    void'(this.begin_tr(trans_collected25,"apb_collector25","UVM Debug25","APB25 collector25 transaction inside collect_transactions25()"));
    trans_collected25.addr = vif25.paddr25;
    trans_collected25.master25 = cfg.master_config25.name;
    trans_collected25.slave25 = cfg.get_slave_name_by_addr25(trans_collected25.addr);
    case (vif25.prwd25)
      1'b0 : trans_collected25.direction25 = APB_READ25;
      1'b1 : trans_collected25.direction25 = APB_WRITE25;
    endcase
      @(posedge vif25.pclock25);
    if(trans_collected25.direction25 == APB_READ25)
      trans_collected25.data = vif25.prdata25;
    if (trans_collected25.direction25 == APB_WRITE25)
      trans_collected25.data = vif25.pwdata25;
    -> addr_trans_grabbed25;
    @(posedge vif25.pclock25);
    if(trans_collected25.direction25 == APB_READ25) begin
        if(vif25.pready25 != 1'b1)
          @(posedge vif25.pclock25);
      trans_collected25.data = vif25.prdata25;
      end
    this.end_tr(trans_collected25);
    item_collected_port25.write(trans_collected25);
    `uvm_info(get_type_name(), $psprintf("Transfer25 collected25 :\n%s",
              trans_collected25.sprint()), UVM_MEDIUM)
      `ifdef HEAP25
      runq25.push_back(trans_collected25);
      `endif
     num_transactions25++;
    end
endtask : collect_transactions25

task apb_collector25::peek(output apb_transfer25 trans25);
  @addr_trans_grabbed25;
  trans25 = trans_collected25;
endtask : peek

function void apb_collector25::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report25: APB25 collector25 collected25 %0d transfers25", num_transactions25), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV25
