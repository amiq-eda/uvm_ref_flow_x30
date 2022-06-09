/*******************************************************************************
  FILE : apb_collector22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV22
`define APB_COLLECTOR_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_collector22
//------------------------------------------------------------------------------

class apb_collector22 extends uvm_component;

  // The virtual interface used to view22 HDL signals22.
  virtual apb_if22 vif22;

  // APB22 configuration information
  apb_config22 cfg;

  // Property22 indicating the number22 of transactions occuring22 on the apb22.
  protected int unsigned num_transactions22 = 0;

  // The following22 two22 bits are used to control22 whether22 checks22 and coverage22 are
  // done both in the collector22 class and the interface.
  bit checks_enable22 = 1; 
  bit coverage_enable22 = 1;

  // TLM Ports22 - transfer22 collected22 for monitor22 other components22
  uvm_analysis_port #(apb_transfer22) item_collected_port22;

  // TLM Port22 - Allows22 sequencer access to transfer22 during address phase
  uvm_blocking_peek_imp#(apb_transfer22,apb_collector22) addr_trans_export22;
  event addr_trans_grabbed22;

  // The following22 property holds22 the transaction information currently
  // being captured22 (by the collect_address_phase22 and data_phase22 methods22). 
  apb_transfer22 trans_collected22;

  //Adding pseudo22-memory leakage22 for heap22 analysis22 lab22
  `ifdef HEAP22
  static apb_transfer22 runq22[$];
  `endif

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(apb_collector22)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable22, UVM_DEFAULT)
    `uvm_field_int(coverage_enable22, UVM_DEFAULT)
    `uvm_field_int(num_transactions22, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected22 = apb_transfer22::type_id::create("trans_collected22");
    // TLM ports22 are created here22
    item_collected_port22 = new("item_collected_port22", this);
    addr_trans_export22 = new("addr_trans_export22", this);
  endfunction : new

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions22();
  extern task peek(output apb_transfer22 trans22);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector22

// UVM build_phase
function void apb_collector22::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config22)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG22", "apb_config22 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector22::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if22)::get(this, "", "vif22", vif22))
      `uvm_error("NOVIF22", {"virtual interface must be set for: ", get_full_name(), ".vif22"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector22::run_phase(uvm_phase phase);
    @(posedge vif22.preset22);
    `uvm_info(get_type_name(), "Detected22 Reset22 Done22", UVM_LOW)
    collect_transactions22();
endtask : run_phase

// collect_transactions22
task apb_collector22::collect_transactions22();
  forever begin
    @(posedge vif22.pclock22 iff (vif22.psel22 != 0));
    void'(this.begin_tr(trans_collected22,"apb_collector22","UVM Debug22","APB22 collector22 transaction inside collect_transactions22()"));
    trans_collected22.addr = vif22.paddr22;
    trans_collected22.master22 = cfg.master_config22.name;
    trans_collected22.slave22 = cfg.get_slave_name_by_addr22(trans_collected22.addr);
    case (vif22.prwd22)
      1'b0 : trans_collected22.direction22 = APB_READ22;
      1'b1 : trans_collected22.direction22 = APB_WRITE22;
    endcase
      @(posedge vif22.pclock22);
    if(trans_collected22.direction22 == APB_READ22)
      trans_collected22.data = vif22.prdata22;
    if (trans_collected22.direction22 == APB_WRITE22)
      trans_collected22.data = vif22.pwdata22;
    -> addr_trans_grabbed22;
    @(posedge vif22.pclock22);
    if(trans_collected22.direction22 == APB_READ22) begin
        if(vif22.pready22 != 1'b1)
          @(posedge vif22.pclock22);
      trans_collected22.data = vif22.prdata22;
      end
    this.end_tr(trans_collected22);
    item_collected_port22.write(trans_collected22);
    `uvm_info(get_type_name(), $psprintf("Transfer22 collected22 :\n%s",
              trans_collected22.sprint()), UVM_MEDIUM)
      `ifdef HEAP22
      runq22.push_back(trans_collected22);
      `endif
     num_transactions22++;
    end
endtask : collect_transactions22

task apb_collector22::peek(output apb_transfer22 trans22);
  @addr_trans_grabbed22;
  trans22 = trans_collected22;
endtask : peek

function void apb_collector22::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report22: APB22 collector22 collected22 %0d transfers22", num_transactions22), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV22
