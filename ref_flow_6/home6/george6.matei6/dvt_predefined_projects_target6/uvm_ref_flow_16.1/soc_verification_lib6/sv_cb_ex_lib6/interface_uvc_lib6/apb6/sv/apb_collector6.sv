/*******************************************************************************
  FILE : apb_collector6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV6
`define APB_COLLECTOR_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_collector6
//------------------------------------------------------------------------------

class apb_collector6 extends uvm_component;

  // The virtual interface used to view6 HDL signals6.
  virtual apb_if6 vif6;

  // APB6 configuration information
  apb_config6 cfg;

  // Property6 indicating the number6 of transactions occuring6 on the apb6.
  protected int unsigned num_transactions6 = 0;

  // The following6 two6 bits are used to control6 whether6 checks6 and coverage6 are
  // done both in the collector6 class and the interface.
  bit checks_enable6 = 1; 
  bit coverage_enable6 = 1;

  // TLM Ports6 - transfer6 collected6 for monitor6 other components6
  uvm_analysis_port #(apb_transfer6) item_collected_port6;

  // TLM Port6 - Allows6 sequencer access to transfer6 during address phase
  uvm_blocking_peek_imp#(apb_transfer6,apb_collector6) addr_trans_export6;
  event addr_trans_grabbed6;

  // The following6 property holds6 the transaction information currently
  // being captured6 (by the collect_address_phase6 and data_phase6 methods6). 
  apb_transfer6 trans_collected6;

  //Adding pseudo6-memory leakage6 for heap6 analysis6 lab6
  `ifdef HEAP6
  static apb_transfer6 runq6[$];
  `endif

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(apb_collector6)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable6, UVM_DEFAULT)
    `uvm_field_int(coverage_enable6, UVM_DEFAULT)
    `uvm_field_int(num_transactions6, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected6 = apb_transfer6::type_id::create("trans_collected6");
    // TLM ports6 are created here6
    item_collected_port6 = new("item_collected_port6", this);
    addr_trans_export6 = new("addr_trans_export6", this);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions6();
  extern task peek(output apb_transfer6 trans6);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector6

// UVM build_phase
function void apb_collector6::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config6)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG6", "apb_config6 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector6::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if6)::get(this, "", "vif6", vif6))
      `uvm_error("NOVIF6", {"virtual interface must be set for: ", get_full_name(), ".vif6"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector6::run_phase(uvm_phase phase);
    @(posedge vif6.preset6);
    `uvm_info(get_type_name(), "Detected6 Reset6 Done6", UVM_LOW)
    collect_transactions6();
endtask : run_phase

// collect_transactions6
task apb_collector6::collect_transactions6();
  forever begin
    @(posedge vif6.pclock6 iff (vif6.psel6 != 0));
    void'(this.begin_tr(trans_collected6,"apb_collector6","UVM Debug6","APB6 collector6 transaction inside collect_transactions6()"));
    trans_collected6.addr = vif6.paddr6;
    trans_collected6.master6 = cfg.master_config6.name;
    trans_collected6.slave6 = cfg.get_slave_name_by_addr6(trans_collected6.addr);
    case (vif6.prwd6)
      1'b0 : trans_collected6.direction6 = APB_READ6;
      1'b1 : trans_collected6.direction6 = APB_WRITE6;
    endcase
      @(posedge vif6.pclock6);
    if(trans_collected6.direction6 == APB_READ6)
      trans_collected6.data = vif6.prdata6;
    if (trans_collected6.direction6 == APB_WRITE6)
      trans_collected6.data = vif6.pwdata6;
    -> addr_trans_grabbed6;
    @(posedge vif6.pclock6);
    if(trans_collected6.direction6 == APB_READ6) begin
        if(vif6.pready6 != 1'b1)
          @(posedge vif6.pclock6);
      trans_collected6.data = vif6.prdata6;
      end
    this.end_tr(trans_collected6);
    item_collected_port6.write(trans_collected6);
    `uvm_info(get_type_name(), $psprintf("Transfer6 collected6 :\n%s",
              trans_collected6.sprint()), UVM_MEDIUM)
      `ifdef HEAP6
      runq6.push_back(trans_collected6);
      `endif
     num_transactions6++;
    end
endtask : collect_transactions6

task apb_collector6::peek(output apb_transfer6 trans6);
  @addr_trans_grabbed6;
  trans6 = trans_collected6;
endtask : peek

function void apb_collector6::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report6: APB6 collector6 collected6 %0d transfers6", num_transactions6), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV6
