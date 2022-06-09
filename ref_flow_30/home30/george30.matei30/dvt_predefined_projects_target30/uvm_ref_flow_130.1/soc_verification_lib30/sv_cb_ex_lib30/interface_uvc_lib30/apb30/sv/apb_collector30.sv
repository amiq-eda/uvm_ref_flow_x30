/*******************************************************************************
  FILE : apb_collector30.sv
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV30
`define APB_COLLECTOR_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_collector30
//------------------------------------------------------------------------------

class apb_collector30 extends uvm_component;

  // The virtual interface used to view30 HDL signals30.
  virtual apb_if30 vif30;

  // APB30 configuration information
  apb_config30 cfg;

  // Property30 indicating the number30 of transactions occuring30 on the apb30.
  protected int unsigned num_transactions30 = 0;

  // The following30 two30 bits are used to control30 whether30 checks30 and coverage30 are
  // done both in the collector30 class and the interface.
  bit checks_enable30 = 1; 
  bit coverage_enable30 = 1;

  // TLM Ports30 - transfer30 collected30 for monitor30 other components30
  uvm_analysis_port #(apb_transfer30) item_collected_port30;

  // TLM Port30 - Allows30 sequencer access to transfer30 during address phase
  uvm_blocking_peek_imp#(apb_transfer30,apb_collector30) addr_trans_export30;
  event addr_trans_grabbed30;

  // The following30 property holds30 the transaction information currently
  // being captured30 (by the collect_address_phase30 and data_phase30 methods30). 
  apb_transfer30 trans_collected30;

  //Adding pseudo30-memory leakage30 for heap30 analysis30 lab30
  `ifdef HEAP30
  static apb_transfer30 runq30[$];
  `endif

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(apb_collector30)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable30, UVM_DEFAULT)
    `uvm_field_int(coverage_enable30, UVM_DEFAULT)
    `uvm_field_int(num_transactions30, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected30 = apb_transfer30::type_id::create("trans_collected30");
    // TLM ports30 are created here30
    item_collected_port30 = new("item_collected_port30", this);
    addr_trans_export30 = new("addr_trans_export30", this);
  endfunction : new

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions30();
  extern task peek(output apb_transfer30 trans30);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector30

// UVM build_phase
function void apb_collector30::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config30)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG30", "apb_config30 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector30::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if30)::get(this, "", "vif30", vif30))
      `uvm_error("NOVIF30", {"virtual interface must be set for: ", get_full_name(), ".vif30"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector30::run_phase(uvm_phase phase);
    @(posedge vif30.preset30);
    `uvm_info(get_type_name(), "Detected30 Reset30 Done30", UVM_LOW)
    collect_transactions30();
endtask : run_phase

// collect_transactions30
task apb_collector30::collect_transactions30();
  forever begin
    @(posedge vif30.pclock30 iff (vif30.psel30 != 0));
    void'(this.begin_tr(trans_collected30,"apb_collector30","UVM Debug30","APB30 collector30 transaction inside collect_transactions30()"));
    trans_collected30.addr = vif30.paddr30;
    trans_collected30.master30 = cfg.master_config30.name;
    trans_collected30.slave30 = cfg.get_slave_name_by_addr30(trans_collected30.addr);
    case (vif30.prwd30)
      1'b0 : trans_collected30.direction30 = APB_READ30;
      1'b1 : trans_collected30.direction30 = APB_WRITE30;
    endcase
      @(posedge vif30.pclock30);
    if(trans_collected30.direction30 == APB_READ30)
      trans_collected30.data = vif30.prdata30;
    if (trans_collected30.direction30 == APB_WRITE30)
      trans_collected30.data = vif30.pwdata30;
    -> addr_trans_grabbed30;
    @(posedge vif30.pclock30);
    if(trans_collected30.direction30 == APB_READ30) begin
        if(vif30.pready30 != 1'b1)
          @(posedge vif30.pclock30);
      trans_collected30.data = vif30.prdata30;
      end
    this.end_tr(trans_collected30);
    item_collected_port30.write(trans_collected30);
    `uvm_info(get_type_name(), $psprintf("Transfer30 collected30 :\n%s",
              trans_collected30.sprint()), UVM_MEDIUM)
      `ifdef HEAP30
      runq30.push_back(trans_collected30);
      `endif
     num_transactions30++;
    end
endtask : collect_transactions30

task apb_collector30::peek(output apb_transfer30 trans30);
  @addr_trans_grabbed30;
  trans30 = trans_collected30;
endtask : peek

function void apb_collector30::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report30: APB30 collector30 collected30 %0d transfers30", num_transactions30), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV30
