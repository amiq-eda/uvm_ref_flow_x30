/*******************************************************************************
  FILE : apb_collector23.sv
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV23
`define APB_COLLECTOR_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_collector23
//------------------------------------------------------------------------------

class apb_collector23 extends uvm_component;

  // The virtual interface used to view23 HDL signals23.
  virtual apb_if23 vif23;

  // APB23 configuration information
  apb_config23 cfg;

  // Property23 indicating the number23 of transactions occuring23 on the apb23.
  protected int unsigned num_transactions23 = 0;

  // The following23 two23 bits are used to control23 whether23 checks23 and coverage23 are
  // done both in the collector23 class and the interface.
  bit checks_enable23 = 1; 
  bit coverage_enable23 = 1;

  // TLM Ports23 - transfer23 collected23 for monitor23 other components23
  uvm_analysis_port #(apb_transfer23) item_collected_port23;

  // TLM Port23 - Allows23 sequencer access to transfer23 during address phase
  uvm_blocking_peek_imp#(apb_transfer23,apb_collector23) addr_trans_export23;
  event addr_trans_grabbed23;

  // The following23 property holds23 the transaction information currently
  // being captured23 (by the collect_address_phase23 and data_phase23 methods23). 
  apb_transfer23 trans_collected23;

  //Adding pseudo23-memory leakage23 for heap23 analysis23 lab23
  `ifdef HEAP23
  static apb_transfer23 runq23[$];
  `endif

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(apb_collector23)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable23, UVM_DEFAULT)
    `uvm_field_int(coverage_enable23, UVM_DEFAULT)
    `uvm_field_int(num_transactions23, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected23 = apb_transfer23::type_id::create("trans_collected23");
    // TLM ports23 are created here23
    item_collected_port23 = new("item_collected_port23", this);
    addr_trans_export23 = new("addr_trans_export23", this);
  endfunction : new

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions23();
  extern task peek(output apb_transfer23 trans23);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector23

// UVM build_phase
function void apb_collector23::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config23)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG23", "apb_config23 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector23::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if23)::get(this, "", "vif23", vif23))
      `uvm_error("NOVIF23", {"virtual interface must be set for: ", get_full_name(), ".vif23"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector23::run_phase(uvm_phase phase);
    @(posedge vif23.preset23);
    `uvm_info(get_type_name(), "Detected23 Reset23 Done23", UVM_LOW)
    collect_transactions23();
endtask : run_phase

// collect_transactions23
task apb_collector23::collect_transactions23();
  forever begin
    @(posedge vif23.pclock23 iff (vif23.psel23 != 0));
    void'(this.begin_tr(trans_collected23,"apb_collector23","UVM Debug23","APB23 collector23 transaction inside collect_transactions23()"));
    trans_collected23.addr = vif23.paddr23;
    trans_collected23.master23 = cfg.master_config23.name;
    trans_collected23.slave23 = cfg.get_slave_name_by_addr23(trans_collected23.addr);
    case (vif23.prwd23)
      1'b0 : trans_collected23.direction23 = APB_READ23;
      1'b1 : trans_collected23.direction23 = APB_WRITE23;
    endcase
      @(posedge vif23.pclock23);
    if(trans_collected23.direction23 == APB_READ23)
      trans_collected23.data = vif23.prdata23;
    if (trans_collected23.direction23 == APB_WRITE23)
      trans_collected23.data = vif23.pwdata23;
    -> addr_trans_grabbed23;
    @(posedge vif23.pclock23);
    if(trans_collected23.direction23 == APB_READ23) begin
        if(vif23.pready23 != 1'b1)
          @(posedge vif23.pclock23);
      trans_collected23.data = vif23.prdata23;
      end
    this.end_tr(trans_collected23);
    item_collected_port23.write(trans_collected23);
    `uvm_info(get_type_name(), $psprintf("Transfer23 collected23 :\n%s",
              trans_collected23.sprint()), UVM_MEDIUM)
      `ifdef HEAP23
      runq23.push_back(trans_collected23);
      `endif
     num_transactions23++;
    end
endtask : collect_transactions23

task apb_collector23::peek(output apb_transfer23 trans23);
  @addr_trans_grabbed23;
  trans23 = trans_collected23;
endtask : peek

function void apb_collector23::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report23: APB23 collector23 collected23 %0d transfers23", num_transactions23), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV23
