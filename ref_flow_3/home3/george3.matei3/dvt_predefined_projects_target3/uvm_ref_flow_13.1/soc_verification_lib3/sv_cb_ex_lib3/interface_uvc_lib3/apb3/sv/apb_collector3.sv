/*******************************************************************************
  FILE : apb_collector3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV3
`define APB_COLLECTOR_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_collector3
//------------------------------------------------------------------------------

class apb_collector3 extends uvm_component;

  // The virtual interface used to view3 HDL signals3.
  virtual apb_if3 vif3;

  // APB3 configuration information
  apb_config3 cfg;

  // Property3 indicating the number3 of transactions occuring3 on the apb3.
  protected int unsigned num_transactions3 = 0;

  // The following3 two3 bits are used to control3 whether3 checks3 and coverage3 are
  // done both in the collector3 class and the interface.
  bit checks_enable3 = 1; 
  bit coverage_enable3 = 1;

  // TLM Ports3 - transfer3 collected3 for monitor3 other components3
  uvm_analysis_port #(apb_transfer3) item_collected_port3;

  // TLM Port3 - Allows3 sequencer access to transfer3 during address phase
  uvm_blocking_peek_imp#(apb_transfer3,apb_collector3) addr_trans_export3;
  event addr_trans_grabbed3;

  // The following3 property holds3 the transaction information currently
  // being captured3 (by the collect_address_phase3 and data_phase3 methods3). 
  apb_transfer3 trans_collected3;

  //Adding pseudo3-memory leakage3 for heap3 analysis3 lab3
  `ifdef HEAP3
  static apb_transfer3 runq3[$];
  `endif

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(apb_collector3)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable3, UVM_DEFAULT)
    `uvm_field_int(coverage_enable3, UVM_DEFAULT)
    `uvm_field_int(num_transactions3, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected3 = apb_transfer3::type_id::create("trans_collected3");
    // TLM ports3 are created here3
    item_collected_port3 = new("item_collected_port3", this);
    addr_trans_export3 = new("addr_trans_export3", this);
  endfunction : new

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions3();
  extern task peek(output apb_transfer3 trans3);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector3

// UVM build_phase
function void apb_collector3::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config3)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG3", "apb_config3 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector3::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if3)::get(this, "", "vif3", vif3))
      `uvm_error("NOVIF3", {"virtual interface must be set for: ", get_full_name(), ".vif3"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector3::run_phase(uvm_phase phase);
    @(posedge vif3.preset3);
    `uvm_info(get_type_name(), "Detected3 Reset3 Done3", UVM_LOW)
    collect_transactions3();
endtask : run_phase

// collect_transactions3
task apb_collector3::collect_transactions3();
  forever begin
    @(posedge vif3.pclock3 iff (vif3.psel3 != 0));
    void'(this.begin_tr(trans_collected3,"apb_collector3","UVM Debug3","APB3 collector3 transaction inside collect_transactions3()"));
    trans_collected3.addr = vif3.paddr3;
    trans_collected3.master3 = cfg.master_config3.name;
    trans_collected3.slave3 = cfg.get_slave_name_by_addr3(trans_collected3.addr);
    case (vif3.prwd3)
      1'b0 : trans_collected3.direction3 = APB_READ3;
      1'b1 : trans_collected3.direction3 = APB_WRITE3;
    endcase
      @(posedge vif3.pclock3);
    if(trans_collected3.direction3 == APB_READ3)
      trans_collected3.data = vif3.prdata3;
    if (trans_collected3.direction3 == APB_WRITE3)
      trans_collected3.data = vif3.pwdata3;
    -> addr_trans_grabbed3;
    @(posedge vif3.pclock3);
    if(trans_collected3.direction3 == APB_READ3) begin
        if(vif3.pready3 != 1'b1)
          @(posedge vif3.pclock3);
      trans_collected3.data = vif3.prdata3;
      end
    this.end_tr(trans_collected3);
    item_collected_port3.write(trans_collected3);
    `uvm_info(get_type_name(), $psprintf("Transfer3 collected3 :\n%s",
              trans_collected3.sprint()), UVM_MEDIUM)
      `ifdef HEAP3
      runq3.push_back(trans_collected3);
      `endif
     num_transactions3++;
    end
endtask : collect_transactions3

task apb_collector3::peek(output apb_transfer3 trans3);
  @addr_trans_grabbed3;
  trans3 = trans_collected3;
endtask : peek

function void apb_collector3::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report3: APB3 collector3 collected3 %0d transfers3", num_transactions3), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV3
