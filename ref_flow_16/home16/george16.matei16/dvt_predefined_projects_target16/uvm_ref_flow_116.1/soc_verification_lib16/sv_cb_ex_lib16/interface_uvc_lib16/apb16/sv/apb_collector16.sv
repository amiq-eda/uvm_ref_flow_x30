/*******************************************************************************
  FILE : apb_collector16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV16
`define APB_COLLECTOR_SV16

//------------------------------------------------------------------------------
// CLASS16: apb_collector16
//------------------------------------------------------------------------------

class apb_collector16 extends uvm_component;

  // The virtual interface used to view16 HDL signals16.
  virtual apb_if16 vif16;

  // APB16 configuration information
  apb_config16 cfg;

  // Property16 indicating the number16 of transactions occuring16 on the apb16.
  protected int unsigned num_transactions16 = 0;

  // The following16 two16 bits are used to control16 whether16 checks16 and coverage16 are
  // done both in the collector16 class and the interface.
  bit checks_enable16 = 1; 
  bit coverage_enable16 = 1;

  // TLM Ports16 - transfer16 collected16 for monitor16 other components16
  uvm_analysis_port #(apb_transfer16) item_collected_port16;

  // TLM Port16 - Allows16 sequencer access to transfer16 during address phase
  uvm_blocking_peek_imp#(apb_transfer16,apb_collector16) addr_trans_export16;
  event addr_trans_grabbed16;

  // The following16 property holds16 the transaction information currently
  // being captured16 (by the collect_address_phase16 and data_phase16 methods16). 
  apb_transfer16 trans_collected16;

  //Adding pseudo16-memory leakage16 for heap16 analysis16 lab16
  `ifdef HEAP16
  static apb_transfer16 runq16[$];
  `endif

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(apb_collector16)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable16, UVM_DEFAULT)
    `uvm_field_int(coverage_enable16, UVM_DEFAULT)
    `uvm_field_int(num_transactions16, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected16 = apb_transfer16::type_id::create("trans_collected16");
    // TLM ports16 are created here16
    item_collected_port16 = new("item_collected_port16", this);
    addr_trans_export16 = new("addr_trans_export16", this);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions16();
  extern task peek(output apb_transfer16 trans16);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector16

// UVM build_phase
function void apb_collector16::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config16)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG16", "apb_config16 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector16::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if16)::get(this, "", "vif16", vif16))
      `uvm_error("NOVIF16", {"virtual interface must be set for: ", get_full_name(), ".vif16"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector16::run_phase(uvm_phase phase);
    @(posedge vif16.preset16);
    `uvm_info(get_type_name(), "Detected16 Reset16 Done16", UVM_LOW)
    collect_transactions16();
endtask : run_phase

// collect_transactions16
task apb_collector16::collect_transactions16();
  forever begin
    @(posedge vif16.pclock16 iff (vif16.psel16 != 0));
    void'(this.begin_tr(trans_collected16,"apb_collector16","UVM Debug16","APB16 collector16 transaction inside collect_transactions16()"));
    trans_collected16.addr = vif16.paddr16;
    trans_collected16.master16 = cfg.master_config16.name;
    trans_collected16.slave16 = cfg.get_slave_name_by_addr16(trans_collected16.addr);
    case (vif16.prwd16)
      1'b0 : trans_collected16.direction16 = APB_READ16;
      1'b1 : trans_collected16.direction16 = APB_WRITE16;
    endcase
      @(posedge vif16.pclock16);
    if(trans_collected16.direction16 == APB_READ16)
      trans_collected16.data = vif16.prdata16;
    if (trans_collected16.direction16 == APB_WRITE16)
      trans_collected16.data = vif16.pwdata16;
    -> addr_trans_grabbed16;
    @(posedge vif16.pclock16);
    if(trans_collected16.direction16 == APB_READ16) begin
        if(vif16.pready16 != 1'b1)
          @(posedge vif16.pclock16);
      trans_collected16.data = vif16.prdata16;
      end
    this.end_tr(trans_collected16);
    item_collected_port16.write(trans_collected16);
    `uvm_info(get_type_name(), $psprintf("Transfer16 collected16 :\n%s",
              trans_collected16.sprint()), UVM_MEDIUM)
      `ifdef HEAP16
      runq16.push_back(trans_collected16);
      `endif
     num_transactions16++;
    end
endtask : collect_transactions16

task apb_collector16::peek(output apb_transfer16 trans16);
  @addr_trans_grabbed16;
  trans16 = trans_collected16;
endtask : peek

function void apb_collector16::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report16: APB16 collector16 collected16 %0d transfers16", num_transactions16), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV16
