/*******************************************************************************
  FILE : apb_collector15.sv
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV15
`define APB_COLLECTOR_SV15

//------------------------------------------------------------------------------
// CLASS15: apb_collector15
//------------------------------------------------------------------------------

class apb_collector15 extends uvm_component;

  // The virtual interface used to view15 HDL signals15.
  virtual apb_if15 vif15;

  // APB15 configuration information
  apb_config15 cfg;

  // Property15 indicating the number15 of transactions occuring15 on the apb15.
  protected int unsigned num_transactions15 = 0;

  // The following15 two15 bits are used to control15 whether15 checks15 and coverage15 are
  // done both in the collector15 class and the interface.
  bit checks_enable15 = 1; 
  bit coverage_enable15 = 1;

  // TLM Ports15 - transfer15 collected15 for monitor15 other components15
  uvm_analysis_port #(apb_transfer15) item_collected_port15;

  // TLM Port15 - Allows15 sequencer access to transfer15 during address phase
  uvm_blocking_peek_imp#(apb_transfer15,apb_collector15) addr_trans_export15;
  event addr_trans_grabbed15;

  // The following15 property holds15 the transaction information currently
  // being captured15 (by the collect_address_phase15 and data_phase15 methods15). 
  apb_transfer15 trans_collected15;

  //Adding pseudo15-memory leakage15 for heap15 analysis15 lab15
  `ifdef HEAP15
  static apb_transfer15 runq15[$];
  `endif

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(apb_collector15)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable15, UVM_DEFAULT)
    `uvm_field_int(coverage_enable15, UVM_DEFAULT)
    `uvm_field_int(num_transactions15, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected15 = apb_transfer15::type_id::create("trans_collected15");
    // TLM ports15 are created here15
    item_collected_port15 = new("item_collected_port15", this);
    addr_trans_export15 = new("addr_trans_export15", this);
  endfunction : new

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions15();
  extern task peek(output apb_transfer15 trans15);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector15

// UVM build_phase
function void apb_collector15::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config15)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG15", "apb_config15 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector15::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if15)::get(this, "", "vif15", vif15))
      `uvm_error("NOVIF15", {"virtual interface must be set for: ", get_full_name(), ".vif15"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector15::run_phase(uvm_phase phase);
    @(posedge vif15.preset15);
    `uvm_info(get_type_name(), "Detected15 Reset15 Done15", UVM_LOW)
    collect_transactions15();
endtask : run_phase

// collect_transactions15
task apb_collector15::collect_transactions15();
  forever begin
    @(posedge vif15.pclock15 iff (vif15.psel15 != 0));
    void'(this.begin_tr(trans_collected15,"apb_collector15","UVM Debug15","APB15 collector15 transaction inside collect_transactions15()"));
    trans_collected15.addr = vif15.paddr15;
    trans_collected15.master15 = cfg.master_config15.name;
    trans_collected15.slave15 = cfg.get_slave_name_by_addr15(trans_collected15.addr);
    case (vif15.prwd15)
      1'b0 : trans_collected15.direction15 = APB_READ15;
      1'b1 : trans_collected15.direction15 = APB_WRITE15;
    endcase
      @(posedge vif15.pclock15);
    if(trans_collected15.direction15 == APB_READ15)
      trans_collected15.data = vif15.prdata15;
    if (trans_collected15.direction15 == APB_WRITE15)
      trans_collected15.data = vif15.pwdata15;
    -> addr_trans_grabbed15;
    @(posedge vif15.pclock15);
    if(trans_collected15.direction15 == APB_READ15) begin
        if(vif15.pready15 != 1'b1)
          @(posedge vif15.pclock15);
      trans_collected15.data = vif15.prdata15;
      end
    this.end_tr(trans_collected15);
    item_collected_port15.write(trans_collected15);
    `uvm_info(get_type_name(), $psprintf("Transfer15 collected15 :\n%s",
              trans_collected15.sprint()), UVM_MEDIUM)
      `ifdef HEAP15
      runq15.push_back(trans_collected15);
      `endif
     num_transactions15++;
    end
endtask : collect_transactions15

task apb_collector15::peek(output apb_transfer15 trans15);
  @addr_trans_grabbed15;
  trans15 = trans_collected15;
endtask : peek

function void apb_collector15::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report15: APB15 collector15 collected15 %0d transfers15", num_transactions15), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV15
