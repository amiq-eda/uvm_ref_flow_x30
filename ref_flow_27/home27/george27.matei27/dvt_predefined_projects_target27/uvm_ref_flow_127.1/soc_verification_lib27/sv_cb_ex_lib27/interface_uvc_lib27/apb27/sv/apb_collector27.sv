/*******************************************************************************
  FILE : apb_collector27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV27
`define APB_COLLECTOR_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_collector27
//------------------------------------------------------------------------------

class apb_collector27 extends uvm_component;

  // The virtual interface used to view27 HDL signals27.
  virtual apb_if27 vif27;

  // APB27 configuration information
  apb_config27 cfg;

  // Property27 indicating the number27 of transactions occuring27 on the apb27.
  protected int unsigned num_transactions27 = 0;

  // The following27 two27 bits are used to control27 whether27 checks27 and coverage27 are
  // done both in the collector27 class and the interface.
  bit checks_enable27 = 1; 
  bit coverage_enable27 = 1;

  // TLM Ports27 - transfer27 collected27 for monitor27 other components27
  uvm_analysis_port #(apb_transfer27) item_collected_port27;

  // TLM Port27 - Allows27 sequencer access to transfer27 during address phase
  uvm_blocking_peek_imp#(apb_transfer27,apb_collector27) addr_trans_export27;
  event addr_trans_grabbed27;

  // The following27 property holds27 the transaction information currently
  // being captured27 (by the collect_address_phase27 and data_phase27 methods27). 
  apb_transfer27 trans_collected27;

  //Adding pseudo27-memory leakage27 for heap27 analysis27 lab27
  `ifdef HEAP27
  static apb_transfer27 runq27[$];
  `endif

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(apb_collector27)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable27, UVM_DEFAULT)
    `uvm_field_int(coverage_enable27, UVM_DEFAULT)
    `uvm_field_int(num_transactions27, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected27 = apb_transfer27::type_id::create("trans_collected27");
    // TLM ports27 are created here27
    item_collected_port27 = new("item_collected_port27", this);
    addr_trans_export27 = new("addr_trans_export27", this);
  endfunction : new

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions27();
  extern task peek(output apb_transfer27 trans27);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector27

// UVM build_phase
function void apb_collector27::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config27)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG27", "apb_config27 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector27::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if27)::get(this, "", "vif27", vif27))
      `uvm_error("NOVIF27", {"virtual interface must be set for: ", get_full_name(), ".vif27"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector27::run_phase(uvm_phase phase);
    @(posedge vif27.preset27);
    `uvm_info(get_type_name(), "Detected27 Reset27 Done27", UVM_LOW)
    collect_transactions27();
endtask : run_phase

// collect_transactions27
task apb_collector27::collect_transactions27();
  forever begin
    @(posedge vif27.pclock27 iff (vif27.psel27 != 0));
    void'(this.begin_tr(trans_collected27,"apb_collector27","UVM Debug27","APB27 collector27 transaction inside collect_transactions27()"));
    trans_collected27.addr = vif27.paddr27;
    trans_collected27.master27 = cfg.master_config27.name;
    trans_collected27.slave27 = cfg.get_slave_name_by_addr27(trans_collected27.addr);
    case (vif27.prwd27)
      1'b0 : trans_collected27.direction27 = APB_READ27;
      1'b1 : trans_collected27.direction27 = APB_WRITE27;
    endcase
      @(posedge vif27.pclock27);
    if(trans_collected27.direction27 == APB_READ27)
      trans_collected27.data = vif27.prdata27;
    if (trans_collected27.direction27 == APB_WRITE27)
      trans_collected27.data = vif27.pwdata27;
    -> addr_trans_grabbed27;
    @(posedge vif27.pclock27);
    if(trans_collected27.direction27 == APB_READ27) begin
        if(vif27.pready27 != 1'b1)
          @(posedge vif27.pclock27);
      trans_collected27.data = vif27.prdata27;
      end
    this.end_tr(trans_collected27);
    item_collected_port27.write(trans_collected27);
    `uvm_info(get_type_name(), $psprintf("Transfer27 collected27 :\n%s",
              trans_collected27.sprint()), UVM_MEDIUM)
      `ifdef HEAP27
      runq27.push_back(trans_collected27);
      `endif
     num_transactions27++;
    end
endtask : collect_transactions27

task apb_collector27::peek(output apb_transfer27 trans27);
  @addr_trans_grabbed27;
  trans27 = trans_collected27;
endtask : peek

function void apb_collector27::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report27: APB27 collector27 collected27 %0d transfers27", num_transactions27), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV27
