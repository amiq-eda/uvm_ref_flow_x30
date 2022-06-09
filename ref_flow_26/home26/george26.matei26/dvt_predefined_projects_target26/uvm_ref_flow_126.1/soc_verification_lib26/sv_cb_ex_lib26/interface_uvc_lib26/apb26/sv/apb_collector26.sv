/*******************************************************************************
  FILE : apb_collector26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV26
`define APB_COLLECTOR_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_collector26
//------------------------------------------------------------------------------

class apb_collector26 extends uvm_component;

  // The virtual interface used to view26 HDL signals26.
  virtual apb_if26 vif26;

  // APB26 configuration information
  apb_config26 cfg;

  // Property26 indicating the number26 of transactions occuring26 on the apb26.
  protected int unsigned num_transactions26 = 0;

  // The following26 two26 bits are used to control26 whether26 checks26 and coverage26 are
  // done both in the collector26 class and the interface.
  bit checks_enable26 = 1; 
  bit coverage_enable26 = 1;

  // TLM Ports26 - transfer26 collected26 for monitor26 other components26
  uvm_analysis_port #(apb_transfer26) item_collected_port26;

  // TLM Port26 - Allows26 sequencer access to transfer26 during address phase
  uvm_blocking_peek_imp#(apb_transfer26,apb_collector26) addr_trans_export26;
  event addr_trans_grabbed26;

  // The following26 property holds26 the transaction information currently
  // being captured26 (by the collect_address_phase26 and data_phase26 methods26). 
  apb_transfer26 trans_collected26;

  //Adding pseudo26-memory leakage26 for heap26 analysis26 lab26
  `ifdef HEAP26
  static apb_transfer26 runq26[$];
  `endif

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(apb_collector26)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable26, UVM_DEFAULT)
    `uvm_field_int(coverage_enable26, UVM_DEFAULT)
    `uvm_field_int(num_transactions26, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected26 = apb_transfer26::type_id::create("trans_collected26");
    // TLM ports26 are created here26
    item_collected_port26 = new("item_collected_port26", this);
    addr_trans_export26 = new("addr_trans_export26", this);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions26();
  extern task peek(output apb_transfer26 trans26);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector26

// UVM build_phase
function void apb_collector26::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config26)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG26", "apb_config26 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector26::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if26)::get(this, "", "vif26", vif26))
      `uvm_error("NOVIF26", {"virtual interface must be set for: ", get_full_name(), ".vif26"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector26::run_phase(uvm_phase phase);
    @(posedge vif26.preset26);
    `uvm_info(get_type_name(), "Detected26 Reset26 Done26", UVM_LOW)
    collect_transactions26();
endtask : run_phase

// collect_transactions26
task apb_collector26::collect_transactions26();
  forever begin
    @(posedge vif26.pclock26 iff (vif26.psel26 != 0));
    void'(this.begin_tr(trans_collected26,"apb_collector26","UVM Debug26","APB26 collector26 transaction inside collect_transactions26()"));
    trans_collected26.addr = vif26.paddr26;
    trans_collected26.master26 = cfg.master_config26.name;
    trans_collected26.slave26 = cfg.get_slave_name_by_addr26(trans_collected26.addr);
    case (vif26.prwd26)
      1'b0 : trans_collected26.direction26 = APB_READ26;
      1'b1 : trans_collected26.direction26 = APB_WRITE26;
    endcase
      @(posedge vif26.pclock26);
    if(trans_collected26.direction26 == APB_READ26)
      trans_collected26.data = vif26.prdata26;
    if (trans_collected26.direction26 == APB_WRITE26)
      trans_collected26.data = vif26.pwdata26;
    -> addr_trans_grabbed26;
    @(posedge vif26.pclock26);
    if(trans_collected26.direction26 == APB_READ26) begin
        if(vif26.pready26 != 1'b1)
          @(posedge vif26.pclock26);
      trans_collected26.data = vif26.prdata26;
      end
    this.end_tr(trans_collected26);
    item_collected_port26.write(trans_collected26);
    `uvm_info(get_type_name(), $psprintf("Transfer26 collected26 :\n%s",
              trans_collected26.sprint()), UVM_MEDIUM)
      `ifdef HEAP26
      runq26.push_back(trans_collected26);
      `endif
     num_transactions26++;
    end
endtask : collect_transactions26

task apb_collector26::peek(output apb_transfer26 trans26);
  @addr_trans_grabbed26;
  trans26 = trans_collected26;
endtask : peek

function void apb_collector26::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report26: APB26 collector26 collected26 %0d transfers26", num_transactions26), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV26
