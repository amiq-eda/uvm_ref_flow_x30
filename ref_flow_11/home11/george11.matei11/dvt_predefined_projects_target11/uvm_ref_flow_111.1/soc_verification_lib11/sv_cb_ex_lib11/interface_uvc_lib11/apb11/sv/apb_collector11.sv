/*******************************************************************************
  FILE : apb_collector11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV11
`define APB_COLLECTOR_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_collector11
//------------------------------------------------------------------------------

class apb_collector11 extends uvm_component;

  // The virtual interface used to view11 HDL signals11.
  virtual apb_if11 vif11;

  // APB11 configuration information
  apb_config11 cfg;

  // Property11 indicating the number11 of transactions occuring11 on the apb11.
  protected int unsigned num_transactions11 = 0;

  // The following11 two11 bits are used to control11 whether11 checks11 and coverage11 are
  // done both in the collector11 class and the interface.
  bit checks_enable11 = 1; 
  bit coverage_enable11 = 1;

  // TLM Ports11 - transfer11 collected11 for monitor11 other components11
  uvm_analysis_port #(apb_transfer11) item_collected_port11;

  // TLM Port11 - Allows11 sequencer access to transfer11 during address phase
  uvm_blocking_peek_imp#(apb_transfer11,apb_collector11) addr_trans_export11;
  event addr_trans_grabbed11;

  // The following11 property holds11 the transaction information currently
  // being captured11 (by the collect_address_phase11 and data_phase11 methods11). 
  apb_transfer11 trans_collected11;

  //Adding pseudo11-memory leakage11 for heap11 analysis11 lab11
  `ifdef HEAP11
  static apb_transfer11 runq11[$];
  `endif

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(apb_collector11)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable11, UVM_DEFAULT)
    `uvm_field_int(coverage_enable11, UVM_DEFAULT)
    `uvm_field_int(num_transactions11, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected11 = apb_transfer11::type_id::create("trans_collected11");
    // TLM ports11 are created here11
    item_collected_port11 = new("item_collected_port11", this);
    addr_trans_export11 = new("addr_trans_export11", this);
  endfunction : new

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions11();
  extern task peek(output apb_transfer11 trans11);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector11

// UVM build_phase
function void apb_collector11::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config11)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG11", "apb_config11 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector11::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if11)::get(this, "", "vif11", vif11))
      `uvm_error("NOVIF11", {"virtual interface must be set for: ", get_full_name(), ".vif11"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector11::run_phase(uvm_phase phase);
    @(posedge vif11.preset11);
    `uvm_info(get_type_name(), "Detected11 Reset11 Done11", UVM_LOW)
    collect_transactions11();
endtask : run_phase

// collect_transactions11
task apb_collector11::collect_transactions11();
  forever begin
    @(posedge vif11.pclock11 iff (vif11.psel11 != 0));
    void'(this.begin_tr(trans_collected11,"apb_collector11","UVM Debug11","APB11 collector11 transaction inside collect_transactions11()"));
    trans_collected11.addr = vif11.paddr11;
    trans_collected11.master11 = cfg.master_config11.name;
    trans_collected11.slave11 = cfg.get_slave_name_by_addr11(trans_collected11.addr);
    case (vif11.prwd11)
      1'b0 : trans_collected11.direction11 = APB_READ11;
      1'b1 : trans_collected11.direction11 = APB_WRITE11;
    endcase
      @(posedge vif11.pclock11);
    if(trans_collected11.direction11 == APB_READ11)
      trans_collected11.data = vif11.prdata11;
    if (trans_collected11.direction11 == APB_WRITE11)
      trans_collected11.data = vif11.pwdata11;
    -> addr_trans_grabbed11;
    @(posedge vif11.pclock11);
    if(trans_collected11.direction11 == APB_READ11) begin
        if(vif11.pready11 != 1'b1)
          @(posedge vif11.pclock11);
      trans_collected11.data = vif11.prdata11;
      end
    this.end_tr(trans_collected11);
    item_collected_port11.write(trans_collected11);
    `uvm_info(get_type_name(), $psprintf("Transfer11 collected11 :\n%s",
              trans_collected11.sprint()), UVM_MEDIUM)
      `ifdef HEAP11
      runq11.push_back(trans_collected11);
      `endif
     num_transactions11++;
    end
endtask : collect_transactions11

task apb_collector11::peek(output apb_transfer11 trans11);
  @addr_trans_grabbed11;
  trans11 = trans_collected11;
endtask : peek

function void apb_collector11::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report11: APB11 collector11 collected11 %0d transfers11", num_transactions11), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV11
