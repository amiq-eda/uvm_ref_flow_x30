/*******************************************************************************
  FILE : apb_collector19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV19
`define APB_COLLECTOR_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_collector19
//------------------------------------------------------------------------------

class apb_collector19 extends uvm_component;

  // The virtual interface used to view19 HDL signals19.
  virtual apb_if19 vif19;

  // APB19 configuration information
  apb_config19 cfg;

  // Property19 indicating the number19 of transactions occuring19 on the apb19.
  protected int unsigned num_transactions19 = 0;

  // The following19 two19 bits are used to control19 whether19 checks19 and coverage19 are
  // done both in the collector19 class and the interface.
  bit checks_enable19 = 1; 
  bit coverage_enable19 = 1;

  // TLM Ports19 - transfer19 collected19 for monitor19 other components19
  uvm_analysis_port #(apb_transfer19) item_collected_port19;

  // TLM Port19 - Allows19 sequencer access to transfer19 during address phase
  uvm_blocking_peek_imp#(apb_transfer19,apb_collector19) addr_trans_export19;
  event addr_trans_grabbed19;

  // The following19 property holds19 the transaction information currently
  // being captured19 (by the collect_address_phase19 and data_phase19 methods19). 
  apb_transfer19 trans_collected19;

  //Adding pseudo19-memory leakage19 for heap19 analysis19 lab19
  `ifdef HEAP19
  static apb_transfer19 runq19[$];
  `endif

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(apb_collector19)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable19, UVM_DEFAULT)
    `uvm_field_int(coverage_enable19, UVM_DEFAULT)
    `uvm_field_int(num_transactions19, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected19 = apb_transfer19::type_id::create("trans_collected19");
    // TLM ports19 are created here19
    item_collected_port19 = new("item_collected_port19", this);
    addr_trans_export19 = new("addr_trans_export19", this);
  endfunction : new

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions19();
  extern task peek(output apb_transfer19 trans19);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector19

// UVM build_phase
function void apb_collector19::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config19)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG19", "apb_config19 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector19::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if19)::get(this, "", "vif19", vif19))
      `uvm_error("NOVIF19", {"virtual interface must be set for: ", get_full_name(), ".vif19"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector19::run_phase(uvm_phase phase);
    @(posedge vif19.preset19);
    `uvm_info(get_type_name(), "Detected19 Reset19 Done19", UVM_LOW)
    collect_transactions19();
endtask : run_phase

// collect_transactions19
task apb_collector19::collect_transactions19();
  forever begin
    @(posedge vif19.pclock19 iff (vif19.psel19 != 0));
    void'(this.begin_tr(trans_collected19,"apb_collector19","UVM Debug19","APB19 collector19 transaction inside collect_transactions19()"));
    trans_collected19.addr = vif19.paddr19;
    trans_collected19.master19 = cfg.master_config19.name;
    trans_collected19.slave19 = cfg.get_slave_name_by_addr19(trans_collected19.addr);
    case (vif19.prwd19)
      1'b0 : trans_collected19.direction19 = APB_READ19;
      1'b1 : trans_collected19.direction19 = APB_WRITE19;
    endcase
      @(posedge vif19.pclock19);
    if(trans_collected19.direction19 == APB_READ19)
      trans_collected19.data = vif19.prdata19;
    if (trans_collected19.direction19 == APB_WRITE19)
      trans_collected19.data = vif19.pwdata19;
    -> addr_trans_grabbed19;
    @(posedge vif19.pclock19);
    if(trans_collected19.direction19 == APB_READ19) begin
        if(vif19.pready19 != 1'b1)
          @(posedge vif19.pclock19);
      trans_collected19.data = vif19.prdata19;
      end
    this.end_tr(trans_collected19);
    item_collected_port19.write(trans_collected19);
    `uvm_info(get_type_name(), $psprintf("Transfer19 collected19 :\n%s",
              trans_collected19.sprint()), UVM_MEDIUM)
      `ifdef HEAP19
      runq19.push_back(trans_collected19);
      `endif
     num_transactions19++;
    end
endtask : collect_transactions19

task apb_collector19::peek(output apb_transfer19 trans19);
  @addr_trans_grabbed19;
  trans19 = trans_collected19;
endtask : peek

function void apb_collector19::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report19: APB19 collector19 collected19 %0d transfers19", num_transactions19), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV19
