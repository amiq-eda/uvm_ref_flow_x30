/*******************************************************************************
  FILE : apb_collector18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV18
`define APB_COLLECTOR_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_collector18
//------------------------------------------------------------------------------

class apb_collector18 extends uvm_component;

  // The virtual interface used to view18 HDL signals18.
  virtual apb_if18 vif18;

  // APB18 configuration information
  apb_config18 cfg;

  // Property18 indicating the number18 of transactions occuring18 on the apb18.
  protected int unsigned num_transactions18 = 0;

  // The following18 two18 bits are used to control18 whether18 checks18 and coverage18 are
  // done both in the collector18 class and the interface.
  bit checks_enable18 = 1; 
  bit coverage_enable18 = 1;

  // TLM Ports18 - transfer18 collected18 for monitor18 other components18
  uvm_analysis_port #(apb_transfer18) item_collected_port18;

  // TLM Port18 - Allows18 sequencer access to transfer18 during address phase
  uvm_blocking_peek_imp#(apb_transfer18,apb_collector18) addr_trans_export18;
  event addr_trans_grabbed18;

  // The following18 property holds18 the transaction information currently
  // being captured18 (by the collect_address_phase18 and data_phase18 methods18). 
  apb_transfer18 trans_collected18;

  //Adding pseudo18-memory leakage18 for heap18 analysis18 lab18
  `ifdef HEAP18
  static apb_transfer18 runq18[$];
  `endif

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_collector18)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable18, UVM_DEFAULT)
    `uvm_field_int(coverage_enable18, UVM_DEFAULT)
    `uvm_field_int(num_transactions18, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected18 = apb_transfer18::type_id::create("trans_collected18");
    // TLM ports18 are created here18
    item_collected_port18 = new("item_collected_port18", this);
    addr_trans_export18 = new("addr_trans_export18", this);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions18();
  extern task peek(output apb_transfer18 trans18);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector18

// UVM build_phase
function void apb_collector18::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config18)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG18", "apb_config18 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector18::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if18)::get(this, "", "vif18", vif18))
      `uvm_error("NOVIF18", {"virtual interface must be set for: ", get_full_name(), ".vif18"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector18::run_phase(uvm_phase phase);
    @(posedge vif18.preset18);
    `uvm_info(get_type_name(), "Detected18 Reset18 Done18", UVM_LOW)
    collect_transactions18();
endtask : run_phase

// collect_transactions18
task apb_collector18::collect_transactions18();
  forever begin
    @(posedge vif18.pclock18 iff (vif18.psel18 != 0));
    void'(this.begin_tr(trans_collected18,"apb_collector18","UVM Debug18","APB18 collector18 transaction inside collect_transactions18()"));
    trans_collected18.addr = vif18.paddr18;
    trans_collected18.master18 = cfg.master_config18.name;
    trans_collected18.slave18 = cfg.get_slave_name_by_addr18(trans_collected18.addr);
    case (vif18.prwd18)
      1'b0 : trans_collected18.direction18 = APB_READ18;
      1'b1 : trans_collected18.direction18 = APB_WRITE18;
    endcase
      @(posedge vif18.pclock18);
    if(trans_collected18.direction18 == APB_READ18)
      trans_collected18.data = vif18.prdata18;
    if (trans_collected18.direction18 == APB_WRITE18)
      trans_collected18.data = vif18.pwdata18;
    -> addr_trans_grabbed18;
    @(posedge vif18.pclock18);
    if(trans_collected18.direction18 == APB_READ18) begin
        if(vif18.pready18 != 1'b1)
          @(posedge vif18.pclock18);
      trans_collected18.data = vif18.prdata18;
      end
    this.end_tr(trans_collected18);
    item_collected_port18.write(trans_collected18);
    `uvm_info(get_type_name(), $psprintf("Transfer18 collected18 :\n%s",
              trans_collected18.sprint()), UVM_MEDIUM)
      `ifdef HEAP18
      runq18.push_back(trans_collected18);
      `endif
     num_transactions18++;
    end
endtask : collect_transactions18

task apb_collector18::peek(output apb_transfer18 trans18);
  @addr_trans_grabbed18;
  trans18 = trans_collected18;
endtask : peek

function void apb_collector18::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report18: APB18 collector18 collected18 %0d transfers18", num_transactions18), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV18
