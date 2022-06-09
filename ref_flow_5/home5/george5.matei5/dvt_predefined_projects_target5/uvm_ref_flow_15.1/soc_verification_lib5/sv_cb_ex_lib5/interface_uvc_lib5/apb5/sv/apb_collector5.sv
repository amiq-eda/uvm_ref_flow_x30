/*******************************************************************************
  FILE : apb_collector5.sv
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV5
`define APB_COLLECTOR_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_collector5
//------------------------------------------------------------------------------

class apb_collector5 extends uvm_component;

  // The virtual interface used to view5 HDL signals5.
  virtual apb_if5 vif5;

  // APB5 configuration information
  apb_config5 cfg;

  // Property5 indicating the number5 of transactions occuring5 on the apb5.
  protected int unsigned num_transactions5 = 0;

  // The following5 two5 bits are used to control5 whether5 checks5 and coverage5 are
  // done both in the collector5 class and the interface.
  bit checks_enable5 = 1; 
  bit coverage_enable5 = 1;

  // TLM Ports5 - transfer5 collected5 for monitor5 other components5
  uvm_analysis_port #(apb_transfer5) item_collected_port5;

  // TLM Port5 - Allows5 sequencer access to transfer5 during address phase
  uvm_blocking_peek_imp#(apb_transfer5,apb_collector5) addr_trans_export5;
  event addr_trans_grabbed5;

  // The following5 property holds5 the transaction information currently
  // being captured5 (by the collect_address_phase5 and data_phase5 methods5). 
  apb_transfer5 trans_collected5;

  //Adding pseudo5-memory leakage5 for heap5 analysis5 lab5
  `ifdef HEAP5
  static apb_transfer5 runq5[$];
  `endif

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(apb_collector5)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable5, UVM_DEFAULT)
    `uvm_field_int(coverage_enable5, UVM_DEFAULT)
    `uvm_field_int(num_transactions5, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected5 = apb_transfer5::type_id::create("trans_collected5");
    // TLM ports5 are created here5
    item_collected_port5 = new("item_collected_port5", this);
    addr_trans_export5 = new("addr_trans_export5", this);
  endfunction : new

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions5();
  extern task peek(output apb_transfer5 trans5);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector5

// UVM build_phase
function void apb_collector5::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config5)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG5", "apb_config5 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector5::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if5)::get(this, "", "vif5", vif5))
      `uvm_error("NOVIF5", {"virtual interface must be set for: ", get_full_name(), ".vif5"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector5::run_phase(uvm_phase phase);
    @(posedge vif5.preset5);
    `uvm_info(get_type_name(), "Detected5 Reset5 Done5", UVM_LOW)
    collect_transactions5();
endtask : run_phase

// collect_transactions5
task apb_collector5::collect_transactions5();
  forever begin
    @(posedge vif5.pclock5 iff (vif5.psel5 != 0));
    void'(this.begin_tr(trans_collected5,"apb_collector5","UVM Debug5","APB5 collector5 transaction inside collect_transactions5()"));
    trans_collected5.addr = vif5.paddr5;
    trans_collected5.master5 = cfg.master_config5.name;
    trans_collected5.slave5 = cfg.get_slave_name_by_addr5(trans_collected5.addr);
    case (vif5.prwd5)
      1'b0 : trans_collected5.direction5 = APB_READ5;
      1'b1 : trans_collected5.direction5 = APB_WRITE5;
    endcase
      @(posedge vif5.pclock5);
    if(trans_collected5.direction5 == APB_READ5)
      trans_collected5.data = vif5.prdata5;
    if (trans_collected5.direction5 == APB_WRITE5)
      trans_collected5.data = vif5.pwdata5;
    -> addr_trans_grabbed5;
    @(posedge vif5.pclock5);
    if(trans_collected5.direction5 == APB_READ5) begin
        if(vif5.pready5 != 1'b1)
          @(posedge vif5.pclock5);
      trans_collected5.data = vif5.prdata5;
      end
    this.end_tr(trans_collected5);
    item_collected_port5.write(trans_collected5);
    `uvm_info(get_type_name(), $psprintf("Transfer5 collected5 :\n%s",
              trans_collected5.sprint()), UVM_MEDIUM)
      `ifdef HEAP5
      runq5.push_back(trans_collected5);
      `endif
     num_transactions5++;
    end
endtask : collect_transactions5

task apb_collector5::peek(output apb_transfer5 trans5);
  @addr_trans_grabbed5;
  trans5 = trans_collected5;
endtask : peek

function void apb_collector5::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report5: APB5 collector5 collected5 %0d transfers5", num_transactions5), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV5
