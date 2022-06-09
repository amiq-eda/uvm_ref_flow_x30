/*******************************************************************************
  FILE : apb_collector29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV29
`define APB_COLLECTOR_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_collector29
//------------------------------------------------------------------------------

class apb_collector29 extends uvm_component;

  // The virtual interface used to view29 HDL signals29.
  virtual apb_if29 vif29;

  // APB29 configuration information
  apb_config29 cfg;

  // Property29 indicating the number29 of transactions occuring29 on the apb29.
  protected int unsigned num_transactions29 = 0;

  // The following29 two29 bits are used to control29 whether29 checks29 and coverage29 are
  // done both in the collector29 class and the interface.
  bit checks_enable29 = 1; 
  bit coverage_enable29 = 1;

  // TLM Ports29 - transfer29 collected29 for monitor29 other components29
  uvm_analysis_port #(apb_transfer29) item_collected_port29;

  // TLM Port29 - Allows29 sequencer access to transfer29 during address phase
  uvm_blocking_peek_imp#(apb_transfer29,apb_collector29) addr_trans_export29;
  event addr_trans_grabbed29;

  // The following29 property holds29 the transaction information currently
  // being captured29 (by the collect_address_phase29 and data_phase29 methods29). 
  apb_transfer29 trans_collected29;

  //Adding pseudo29-memory leakage29 for heap29 analysis29 lab29
  `ifdef HEAP29
  static apb_transfer29 runq29[$];
  `endif

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(apb_collector29)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable29, UVM_DEFAULT)
    `uvm_field_int(coverage_enable29, UVM_DEFAULT)
    `uvm_field_int(num_transactions29, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected29 = apb_transfer29::type_id::create("trans_collected29");
    // TLM ports29 are created here29
    item_collected_port29 = new("item_collected_port29", this);
    addr_trans_export29 = new("addr_trans_export29", this);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions29();
  extern task peek(output apb_transfer29 trans29);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector29

// UVM build_phase
function void apb_collector29::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config29)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG29", "apb_config29 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector29::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if29)::get(this, "", "vif29", vif29))
      `uvm_error("NOVIF29", {"virtual interface must be set for: ", get_full_name(), ".vif29"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector29::run_phase(uvm_phase phase);
    @(posedge vif29.preset29);
    `uvm_info(get_type_name(), "Detected29 Reset29 Done29", UVM_LOW)
    collect_transactions29();
endtask : run_phase

// collect_transactions29
task apb_collector29::collect_transactions29();
  forever begin
    @(posedge vif29.pclock29 iff (vif29.psel29 != 0));
    void'(this.begin_tr(trans_collected29,"apb_collector29","UVM Debug29","APB29 collector29 transaction inside collect_transactions29()"));
    trans_collected29.addr = vif29.paddr29;
    trans_collected29.master29 = cfg.master_config29.name;
    trans_collected29.slave29 = cfg.get_slave_name_by_addr29(trans_collected29.addr);
    case (vif29.prwd29)
      1'b0 : trans_collected29.direction29 = APB_READ29;
      1'b1 : trans_collected29.direction29 = APB_WRITE29;
    endcase
      @(posedge vif29.pclock29);
    if(trans_collected29.direction29 == APB_READ29)
      trans_collected29.data = vif29.prdata29;
    if (trans_collected29.direction29 == APB_WRITE29)
      trans_collected29.data = vif29.pwdata29;
    -> addr_trans_grabbed29;
    @(posedge vif29.pclock29);
    if(trans_collected29.direction29 == APB_READ29) begin
        if(vif29.pready29 != 1'b1)
          @(posedge vif29.pclock29);
      trans_collected29.data = vif29.prdata29;
      end
    this.end_tr(trans_collected29);
    item_collected_port29.write(trans_collected29);
    `uvm_info(get_type_name(), $psprintf("Transfer29 collected29 :\n%s",
              trans_collected29.sprint()), UVM_MEDIUM)
      `ifdef HEAP29
      runq29.push_back(trans_collected29);
      `endif
     num_transactions29++;
    end
endtask : collect_transactions29

task apb_collector29::peek(output apb_transfer29 trans29);
  @addr_trans_grabbed29;
  trans29 = trans_collected29;
endtask : peek

function void apb_collector29::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report29: APB29 collector29 collected29 %0d transfers29", num_transactions29), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV29
