/*******************************************************************************
  FILE : apb_collector4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV4
`define APB_COLLECTOR_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_collector4
//------------------------------------------------------------------------------

class apb_collector4 extends uvm_component;

  // The virtual interface used to view4 HDL signals4.
  virtual apb_if4 vif4;

  // APB4 configuration information
  apb_config4 cfg; 

  // Property4 indicating the number4 of transactions occuring4 on the apb4.
  protected int unsigned num_transactions4 = 0;

  // The following4 two4 bits are used to control4 whether4 checks4 and coverage4 are
  // done both in the collector4 class and the interface.
  bit checks_enable4 = 1; 
  bit coverage_enable4 = 1;

  // TLM Ports4 - transfer4 collected4 for monitor4 other components4
  uvm_analysis_port #(apb_transfer4) item_collected_port4;

  // TLM Port4 - Allows4 sequencer access to transfer4 during address phase
  uvm_blocking_peek_imp#(apb_transfer4,apb_collector4) addr_trans_export4;
  event addr_trans_grabbed4;

  // The following4 property holds4 the transaction information currently
  // being captured4 (by the collect_address_phase4 and data_phase4 methods4). 
  apb_transfer4 trans_collected4;

  //Adding pseudo4-memory leakage4 for heap4 analysis4 lab4
  `ifdef HEAP4
  static apb_transfer4 runq4[$];
  `endif

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(apb_collector4)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable4, UVM_DEFAULT)
    `uvm_field_int(coverage_enable4, UVM_DEFAULT)
    `uvm_field_int(num_transactions4, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected4 = apb_transfer4::type_id::create("trans_collected4");
    // TLM ports4 are created here4
    item_collected_port4 = new("item_collected_port4", this);
    addr_trans_export4 = new("addr_trans_export4", this);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions4();
  extern task peek(output apb_transfer4 trans4);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector4

// UVM build_phase
function void apb_collector4::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config4)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG4", "apb_config4 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector4::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if4)::get(this, "", "vif4", vif4))
      `uvm_error("NOVIF4", {"virtual interface must be set for: ", get_full_name(), ".vif4"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector4::run_phase(uvm_phase phase);
    @(posedge vif4.preset4);
    `uvm_info(get_type_name(), "Detected4 Reset4 Done4", UVM_LOW)
    collect_transactions4();
endtask : run_phase

// collect_transactions4
task apb_collector4::collect_transactions4();
  forever begin
    @(posedge vif4.pclock4 iff (vif4.psel4 != 0));
    void'(this.begin_tr(trans_collected4,"apb_collector4","UVM Debug4","APB4 collector4 transaction inside collect_transactions4()"));
    trans_collected4.addr = vif4.paddr4;
    trans_collected4.master4 = cfg.master_config4.name;
    trans_collected4.slave4 = cfg.get_slave_name_by_addr4(trans_collected4.addr);
    case (vif4.prwd4)
      1'b0 : trans_collected4.direction4 = APB_READ4;
      1'b1 : trans_collected4.direction4 = APB_WRITE4;
    endcase
      @(posedge vif4.pclock4);
    if(trans_collected4.direction4 == APB_READ4)
      trans_collected4.data = vif4.prdata4;
    if (trans_collected4.direction4 == APB_WRITE4)
      trans_collected4.data = vif4.pwdata4;
    -> addr_trans_grabbed4;
    @(posedge vif4.pclock4);
    if(trans_collected4.direction4 == APB_READ4) begin
        if(vif4.pready4 != 1'b1)
          @(posedge vif4.pclock4);
      trans_collected4.data = vif4.prdata4;
      end
    this.end_tr(trans_collected4);
    item_collected_port4.write(trans_collected4);
    `uvm_info(get_type_name(), $psprintf("Transfer4 collected4 :\n%s",
              trans_collected4.sprint()), UVM_MEDIUM)
      `ifdef HEAP4
      runq4.push_back(trans_collected4);
      `endif
     num_transactions4++;
    end
endtask : collect_transactions4

task apb_collector4::peek(output apb_transfer4 trans4);
  @addr_trans_grabbed4;
  trans4 = trans_collected4;
endtask : peek

function void apb_collector4::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report4: APB4 collector4 collected4 %0d transfers4", num_transactions4), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV4
