/*******************************************************************************
  FILE : apb_collector20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV20
`define APB_COLLECTOR_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_collector20
//------------------------------------------------------------------------------

class apb_collector20 extends uvm_component;

  // The virtual interface used to view20 HDL signals20.
  virtual apb_if20 vif20;

  // APB20 configuration information
  apb_config20 cfg;

  // Property20 indicating the number20 of transactions occuring20 on the apb20.
  protected int unsigned num_transactions20 = 0;

  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done both in the collector20 class and the interface.
  bit checks_enable20 = 1; 
  bit coverage_enable20 = 1;

  // TLM Ports20 - transfer20 collected20 for monitor20 other components20
  uvm_analysis_port #(apb_transfer20) item_collected_port20;

  // TLM Port20 - Allows20 sequencer access to transfer20 during address phase
  uvm_blocking_peek_imp#(apb_transfer20,apb_collector20) addr_trans_export20;
  event addr_trans_grabbed20;

  // The following20 property holds20 the transaction information currently
  // being captured20 (by the collect_address_phase20 and data_phase20 methods20). 
  apb_transfer20 trans_collected20;

  //Adding pseudo20-memory leakage20 for heap20 analysis20 lab20
  `ifdef HEAP20
  static apb_transfer20 runq20[$];
  `endif

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(apb_collector20)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable20, UVM_DEFAULT)
    `uvm_field_int(coverage_enable20, UVM_DEFAULT)
    `uvm_field_int(num_transactions20, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected20 = apb_transfer20::type_id::create("trans_collected20");
    // TLM ports20 are created here20
    item_collected_port20 = new("item_collected_port20", this);
    addr_trans_export20 = new("addr_trans_export20", this);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions20();
  extern task peek(output apb_transfer20 trans20);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector20

// UVM build_phase
function void apb_collector20::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config20)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG20", "apb_config20 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector20::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if20)::get(this, "", "vif20", vif20))
      `uvm_error("NOVIF20", {"virtual interface must be set for: ", get_full_name(), ".vif20"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector20::run_phase(uvm_phase phase);
    @(posedge vif20.preset20);
    `uvm_info(get_type_name(), "Detected20 Reset20 Done20", UVM_LOW)
    collect_transactions20();
endtask : run_phase

// collect_transactions20
task apb_collector20::collect_transactions20();
  forever begin
    @(posedge vif20.pclock20 iff (vif20.psel20 != 0));
    void'(this.begin_tr(trans_collected20,"apb_collector20","UVM Debug20","APB20 collector20 transaction inside collect_transactions20()"));
    trans_collected20.addr = vif20.paddr20;
    trans_collected20.master20 = cfg.master_config20.name;
    trans_collected20.slave20 = cfg.get_slave_name_by_addr20(trans_collected20.addr);
    case (vif20.prwd20)
      1'b0 : trans_collected20.direction20 = APB_READ20;
      1'b1 : trans_collected20.direction20 = APB_WRITE20;
    endcase
      @(posedge vif20.pclock20);
    if(trans_collected20.direction20 == APB_READ20)
      trans_collected20.data = vif20.prdata20;
    if (trans_collected20.direction20 == APB_WRITE20)
      trans_collected20.data = vif20.pwdata20;
    -> addr_trans_grabbed20;
    @(posedge vif20.pclock20);
    if(trans_collected20.direction20 == APB_READ20) begin
        if(vif20.pready20 != 1'b1)
          @(posedge vif20.pclock20);
      trans_collected20.data = vif20.prdata20;
      end
    this.end_tr(trans_collected20);
    item_collected_port20.write(trans_collected20);
    `uvm_info(get_type_name(), $psprintf("Transfer20 collected20 :\n%s",
              trans_collected20.sprint()), UVM_MEDIUM)
      `ifdef HEAP20
      runq20.push_back(trans_collected20);
      `endif
     num_transactions20++;
    end
endtask : collect_transactions20

task apb_collector20::peek(output apb_transfer20 trans20);
  @addr_trans_grabbed20;
  trans20 = trans_collected20;
endtask : peek

function void apb_collector20::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report20: APB20 collector20 collected20 %0d transfers20", num_transactions20), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV20
