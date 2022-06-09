/*******************************************************************************
  FILE : apb_collector24.sv
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV24
`define APB_COLLECTOR_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_collector24
//------------------------------------------------------------------------------

class apb_collector24 extends uvm_component;

  // The virtual interface used to view24 HDL signals24.
  virtual apb_if24 vif24;

  // APB24 configuration information
  apb_config24 cfg;

  // Property24 indicating the number24 of transactions occuring24 on the apb24.
  protected int unsigned num_transactions24 = 0;

  // The following24 two24 bits are used to control24 whether24 checks24 and coverage24 are
  // done both in the collector24 class and the interface.
  bit checks_enable24 = 1; 
  bit coverage_enable24 = 1;

  // TLM Ports24 - transfer24 collected24 for monitor24 other components24
  uvm_analysis_port #(apb_transfer24) item_collected_port24;

  // TLM Port24 - Allows24 sequencer access to transfer24 during address phase
  uvm_blocking_peek_imp#(apb_transfer24,apb_collector24) addr_trans_export24;
  event addr_trans_grabbed24;

  // The following24 property holds24 the transaction information currently
  // being captured24 (by the collect_address_phase24 and data_phase24 methods24). 
  apb_transfer24 trans_collected24;

  //Adding pseudo24-memory leakage24 for heap24 analysis24 lab24
  `ifdef HEAP24
  static apb_transfer24 runq24[$];
  `endif

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(apb_collector24)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable24, UVM_DEFAULT)
    `uvm_field_int(coverage_enable24, UVM_DEFAULT)
    `uvm_field_int(num_transactions24, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected24 = apb_transfer24::type_id::create("trans_collected24");
    // TLM ports24 are created here24
    item_collected_port24 = new("item_collected_port24", this);
    addr_trans_export24 = new("addr_trans_export24", this);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions24();
  extern task peek(output apb_transfer24 trans24);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector24

// UVM build_phase
function void apb_collector24::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config24)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG24", "apb_config24 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector24::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if24)::get(this, "", "vif24", vif24))
      `uvm_error("NOVIF24", {"virtual interface must be set for: ", get_full_name(), ".vif24"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector24::run_phase(uvm_phase phase);
    @(posedge vif24.preset24);
    `uvm_info(get_type_name(), "Detected24 Reset24 Done24", UVM_LOW)
    collect_transactions24();
endtask : run_phase

// collect_transactions24
task apb_collector24::collect_transactions24();
  forever begin
    @(posedge vif24.pclock24 iff (vif24.psel24 != 0));
    void'(this.begin_tr(trans_collected24,"apb_collector24","UVM Debug24","APB24 collector24 transaction inside collect_transactions24()"));
    trans_collected24.addr = vif24.paddr24;
    trans_collected24.master24 = cfg.master_config24.name;
    trans_collected24.slave24 = cfg.get_slave_name_by_addr24(trans_collected24.addr);
    case (vif24.prwd24)
      1'b0 : trans_collected24.direction24 = APB_READ24;
      1'b1 : trans_collected24.direction24 = APB_WRITE24;
    endcase
      @(posedge vif24.pclock24);
    if(trans_collected24.direction24 == APB_READ24)
      trans_collected24.data = vif24.prdata24;
    if (trans_collected24.direction24 == APB_WRITE24)
      trans_collected24.data = vif24.pwdata24;
    -> addr_trans_grabbed24;
    @(posedge vif24.pclock24);
    if(trans_collected24.direction24 == APB_READ24) begin
        if(vif24.pready24 != 1'b1)
          @(posedge vif24.pclock24);
      trans_collected24.data = vif24.prdata24;
      end
    this.end_tr(trans_collected24);
    item_collected_port24.write(trans_collected24);
    `uvm_info(get_type_name(), $psprintf("Transfer24 collected24 :\n%s",
              trans_collected24.sprint()), UVM_MEDIUM)
      `ifdef HEAP24
      runq24.push_back(trans_collected24);
      `endif
     num_transactions24++;
    end
endtask : collect_transactions24

task apb_collector24::peek(output apb_transfer24 trans24);
  @addr_trans_grabbed24;
  trans24 = trans_collected24;
endtask : peek

function void apb_collector24::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report24: APB24 collector24 collected24 %0d transfers24", num_transactions24), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV24
