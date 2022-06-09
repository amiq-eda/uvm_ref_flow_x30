/*******************************************************************************
  FILE : apb_collector1.sv
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV1
`define APB_COLLECTOR_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_collector1
//------------------------------------------------------------------------------

class apb_collector1 extends uvm_component;

  // The virtual interface used to view1 HDL signals1.
  virtual apb_if1 vif1;

  // APB1 configuration information
  apb_config1 cfg;

  // Property1 indicating the number1 of transactions occuring1 on the apb1.
  protected int unsigned num_transactions1 = 0;

  // The following1 two1 bits are used to control1 whether1 checks1 and coverage1 are
  // done both in the collector1 class and the interface.
  bit checks_enable1 = 1; 
  bit coverage_enable1 = 1;

  // TLM Ports1 - transfer1 collected1 for monitor1 other components1
  uvm_analysis_port #(apb_transfer1) item_collected_port1;

  // TLM Port1 - Allows1 sequencer access to transfer1 during address phase
  uvm_blocking_peek_imp#(apb_transfer1,apb_collector1) addr_trans_export1;
  event addr_trans_grabbed1;

  // The following1 property holds1 the transaction information currently
  // being captured1 (by the collect_address_phase1 and data_phase1 methods1). 
  apb_transfer1 trans_collected1;

  //Adding pseudo1-memory leakage1 for heap1 analysis1 lab1
  `ifdef HEAP1
  static apb_transfer1 runq1[$];
  `endif

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(apb_collector1)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable1, UVM_DEFAULT)
    `uvm_field_int(coverage_enable1, UVM_DEFAULT)
    `uvm_field_int(num_transactions1, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected1 = apb_transfer1::type_id::create("trans_collected1");
    // TLM ports1 are created here1
    item_collected_port1 = new("item_collected_port1", this);
    addr_trans_export1 = new("addr_trans_export1", this);
  endfunction : new

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions1();
  extern task peek(output apb_transfer1 trans1);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector1

// UVM build_phase
function void apb_collector1::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config1)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG1", "apb_config1 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector1::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if1)::get(this, "", "vif1", vif1))
      `uvm_error("NOVIF1", {"virtual interface must be set for: ", get_full_name(), ".vif1"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector1::run_phase(uvm_phase phase);
    @(posedge vif1.preset1);
    `uvm_info(get_type_name(), "Detected1 Reset1 Done1", UVM_LOW)
    collect_transactions1();
endtask : run_phase

// collect_transactions1
task apb_collector1::collect_transactions1();
  forever begin
    @(posedge vif1.pclock1 iff (vif1.psel1 != 0));
    void'(this.begin_tr(trans_collected1,"apb_collector1","UVM Debug1","APB1 collector1 transaction inside collect_transactions1()"));
    trans_collected1.addr = vif1.paddr1;
    trans_collected1.master1 = cfg.master_config1.name;
    trans_collected1.slave1 = cfg.get_slave_name_by_addr1(trans_collected1.addr);
    case (vif1.prwd1)
      1'b0 : trans_collected1.direction1 = APB_READ1;
      1'b1 : trans_collected1.direction1 = APB_WRITE1;
    endcase
      @(posedge vif1.pclock1);
    if(trans_collected1.direction1 == APB_READ1)
      trans_collected1.data = vif1.prdata1;
    if (trans_collected1.direction1 == APB_WRITE1)
      trans_collected1.data = vif1.pwdata1;
    -> addr_trans_grabbed1;
    @(posedge vif1.pclock1);
    if(trans_collected1.direction1 == APB_READ1) begin
        if(vif1.pready1 != 1'b1)
          @(posedge vif1.pclock1);
      trans_collected1.data = vif1.prdata1;
      end
    this.end_tr(trans_collected1);
    item_collected_port1.write(trans_collected1);
    `uvm_info(get_type_name(), $psprintf("Transfer1 collected1 :\n%s",
              trans_collected1.sprint()), UVM_MEDIUM)
      `ifdef HEAP1
      runq1.push_back(trans_collected1);
      `endif
     num_transactions1++;
    end
endtask : collect_transactions1

task apb_collector1::peek(output apb_transfer1 trans1);
  @addr_trans_grabbed1;
  trans1 = trans_collected1;
endtask : peek

function void apb_collector1::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report1: APB1 collector1 collected1 %0d transfers1", num_transactions1), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV1
