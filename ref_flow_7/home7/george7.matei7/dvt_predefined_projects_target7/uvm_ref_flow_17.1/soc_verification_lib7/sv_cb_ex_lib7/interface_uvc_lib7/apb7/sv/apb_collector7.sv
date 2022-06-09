/*******************************************************************************
  FILE : apb_collector7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV7
`define APB_COLLECTOR_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_collector7
//------------------------------------------------------------------------------

class apb_collector7 extends uvm_component;

  // The virtual interface used to view7 HDL signals7.
  virtual apb_if7 vif7;

  // APB7 configuration information
  apb_config7 cfg;

  // Property7 indicating the number7 of transactions occuring7 on the apb7.
  protected int unsigned num_transactions7 = 0;

  // The following7 two7 bits are used to control7 whether7 checks7 and coverage7 are
  // done both in the collector7 class and the interface.
  bit checks_enable7 = 1; 
  bit coverage_enable7 = 1;

  // TLM Ports7 - transfer7 collected7 for monitor7 other components7
  uvm_analysis_port #(apb_transfer7) item_collected_port7;

  // TLM Port7 - Allows7 sequencer access to transfer7 during address phase
  uvm_blocking_peek_imp#(apb_transfer7,apb_collector7) addr_trans_export7;
  event addr_trans_grabbed7;

  // The following7 property holds7 the transaction information currently
  // being captured7 (by the collect_address_phase7 and data_phase7 methods7). 
  apb_transfer7 trans_collected7;

  //Adding pseudo7-memory leakage7 for heap7 analysis7 lab7
  `ifdef HEAP7
  static apb_transfer7 runq7[$];
  `endif

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(apb_collector7)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable7, UVM_DEFAULT)
    `uvm_field_int(coverage_enable7, UVM_DEFAULT)
    `uvm_field_int(num_transactions7, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected7 = apb_transfer7::type_id::create("trans_collected7");
    // TLM ports7 are created here7
    item_collected_port7 = new("item_collected_port7", this);
    addr_trans_export7 = new("addr_trans_export7", this);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions7();
  extern task peek(output apb_transfer7 trans7);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector7

// UVM build_phase
function void apb_collector7::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config7)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG7", "apb_config7 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector7::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if7)::get(this, "", "vif7", vif7))
      `uvm_error("NOVIF7", {"virtual interface must be set for: ", get_full_name(), ".vif7"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector7::run_phase(uvm_phase phase);
    @(posedge vif7.preset7);
    `uvm_info(get_type_name(), "Detected7 Reset7 Done7", UVM_LOW)
    collect_transactions7();
endtask : run_phase

// collect_transactions7
task apb_collector7::collect_transactions7();
  forever begin
    @(posedge vif7.pclock7 iff (vif7.psel7 != 0));
    void'(this.begin_tr(trans_collected7,"apb_collector7","UVM Debug7","APB7 collector7 transaction inside collect_transactions7()"));
    trans_collected7.addr = vif7.paddr7;
    trans_collected7.master7 = cfg.master_config7.name;
    trans_collected7.slave7 = cfg.get_slave_name_by_addr7(trans_collected7.addr);
    case (vif7.prwd7)
      1'b0 : trans_collected7.direction7 = APB_READ7;
      1'b1 : trans_collected7.direction7 = APB_WRITE7;
    endcase
      @(posedge vif7.pclock7);
    if(trans_collected7.direction7 == APB_READ7)
      trans_collected7.data = vif7.prdata7;
    if (trans_collected7.direction7 == APB_WRITE7)
      trans_collected7.data = vif7.pwdata7;
    -> addr_trans_grabbed7;
    @(posedge vif7.pclock7);
    if(trans_collected7.direction7 == APB_READ7) begin
        if(vif7.pready7 != 1'b1)
          @(posedge vif7.pclock7);
      trans_collected7.data = vif7.prdata7;
      end
    this.end_tr(trans_collected7);
    item_collected_port7.write(trans_collected7);
    `uvm_info(get_type_name(), $psprintf("Transfer7 collected7 :\n%s",
              trans_collected7.sprint()), UVM_MEDIUM)
      `ifdef HEAP7
      runq7.push_back(trans_collected7);
      `endif
     num_transactions7++;
    end
endtask : collect_transactions7

task apb_collector7::peek(output apb_transfer7 trans7);
  @addr_trans_grabbed7;
  trans7 = trans_collected7;
endtask : peek

function void apb_collector7::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report7: APB7 collector7 collected7 %0d transfers7", num_transactions7), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV7
