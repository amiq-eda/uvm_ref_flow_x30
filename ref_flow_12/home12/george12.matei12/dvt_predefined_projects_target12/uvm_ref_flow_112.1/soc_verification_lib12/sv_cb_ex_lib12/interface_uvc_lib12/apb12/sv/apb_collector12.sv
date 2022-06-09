/*******************************************************************************
  FILE : apb_collector12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV12
`define APB_COLLECTOR_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_collector12
//------------------------------------------------------------------------------

class apb_collector12 extends uvm_component;

  // The virtual interface used to view12 HDL signals12.
  virtual apb_if12 vif12;

  // APB12 configuration information
  apb_config12 cfg;

  // Property12 indicating the number12 of transactions occuring12 on the apb12.
  protected int unsigned num_transactions12 = 0;

  // The following12 two12 bits are used to control12 whether12 checks12 and coverage12 are
  // done both in the collector12 class and the interface.
  bit checks_enable12 = 1; 
  bit coverage_enable12 = 1;

  // TLM Ports12 - transfer12 collected12 for monitor12 other components12
  uvm_analysis_port #(apb_transfer12) item_collected_port12;

  // TLM Port12 - Allows12 sequencer access to transfer12 during address phase
  uvm_blocking_peek_imp#(apb_transfer12,apb_collector12) addr_trans_export12;
  event addr_trans_grabbed12;

  // The following12 property holds12 the transaction information currently
  // being captured12 (by the collect_address_phase12 and data_phase12 methods12). 
  apb_transfer12 trans_collected12;

  //Adding pseudo12-memory leakage12 for heap12 analysis12 lab12
  `ifdef HEAP12
  static apb_transfer12 runq12[$];
  `endif

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(apb_collector12)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable12, UVM_DEFAULT)
    `uvm_field_int(coverage_enable12, UVM_DEFAULT)
    `uvm_field_int(num_transactions12, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected12 = apb_transfer12::type_id::create("trans_collected12");
    // TLM ports12 are created here12
    item_collected_port12 = new("item_collected_port12", this);
    addr_trans_export12 = new("addr_trans_export12", this);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions12();
  extern task peek(output apb_transfer12 trans12);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector12

// UVM build_phase
function void apb_collector12::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config12)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG12", "apb_config12 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector12::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if12)::get(this, "", "vif12", vif12))
      `uvm_error("NOVIF12", {"virtual interface must be set for: ", get_full_name(), ".vif12"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector12::run_phase(uvm_phase phase);
    @(posedge vif12.preset12);
    `uvm_info(get_type_name(), "Detected12 Reset12 Done12", UVM_LOW)
    collect_transactions12();
endtask : run_phase

// collect_transactions12
task apb_collector12::collect_transactions12();
  forever begin
    @(posedge vif12.pclock12 iff (vif12.psel12 != 0));
    void'(this.begin_tr(trans_collected12,"apb_collector12","UVM Debug12","APB12 collector12 transaction inside collect_transactions12()"));
    trans_collected12.addr = vif12.paddr12;
    trans_collected12.master12 = cfg.master_config12.name;
    trans_collected12.slave12 = cfg.get_slave_name_by_addr12(trans_collected12.addr);
    case (vif12.prwd12)
      1'b0 : trans_collected12.direction12 = APB_READ12;
      1'b1 : trans_collected12.direction12 = APB_WRITE12;
    endcase
      @(posedge vif12.pclock12);
    if(trans_collected12.direction12 == APB_READ12)
      trans_collected12.data = vif12.prdata12;
    if (trans_collected12.direction12 == APB_WRITE12)
      trans_collected12.data = vif12.pwdata12;
    -> addr_trans_grabbed12;
    @(posedge vif12.pclock12);
    if(trans_collected12.direction12 == APB_READ12) begin
        if(vif12.pready12 != 1'b1)
          @(posedge vif12.pclock12);
      trans_collected12.data = vif12.prdata12;
      end
    this.end_tr(trans_collected12);
    item_collected_port12.write(trans_collected12);
    `uvm_info(get_type_name(), $psprintf("Transfer12 collected12 :\n%s",
              trans_collected12.sprint()), UVM_MEDIUM)
      `ifdef HEAP12
      runq12.push_back(trans_collected12);
      `endif
     num_transactions12++;
    end
endtask : collect_transactions12

task apb_collector12::peek(output apb_transfer12 trans12);
  @addr_trans_grabbed12;
  trans12 = trans_collected12;
endtask : peek

function void apb_collector12::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report12: APB12 collector12 collected12 %0d transfers12", num_transactions12), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV12
