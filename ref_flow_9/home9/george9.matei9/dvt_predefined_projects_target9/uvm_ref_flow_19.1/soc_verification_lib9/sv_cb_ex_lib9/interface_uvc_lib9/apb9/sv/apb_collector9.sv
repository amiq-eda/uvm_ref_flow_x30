/*******************************************************************************
  FILE : apb_collector9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV9
`define APB_COLLECTOR_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_collector9
//------------------------------------------------------------------------------

class apb_collector9 extends uvm_component;

  // The virtual interface used to view9 HDL signals9.
  virtual apb_if9 vif9;

  // APB9 configuration information
  apb_config9 cfg;

  // Property9 indicating the number9 of transactions occuring9 on the apb9.
  protected int unsigned num_transactions9 = 0;

  // The following9 two9 bits are used to control9 whether9 checks9 and coverage9 are
  // done both in the collector9 class and the interface.
  bit checks_enable9 = 1; 
  bit coverage_enable9 = 1;

  // TLM Ports9 - transfer9 collected9 for monitor9 other components9
  uvm_analysis_port #(apb_transfer9) item_collected_port9;

  // TLM Port9 - Allows9 sequencer access to transfer9 during address phase
  uvm_blocking_peek_imp#(apb_transfer9,apb_collector9) addr_trans_export9;
  event addr_trans_grabbed9;

  // The following9 property holds9 the transaction information currently
  // being captured9 (by the collect_address_phase9 and data_phase9 methods9). 
  apb_transfer9 trans_collected9;

  //Adding pseudo9-memory leakage9 for heap9 analysis9 lab9
  `ifdef HEAP9
  static apb_transfer9 runq9[$];
  `endif

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(apb_collector9)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable9, UVM_DEFAULT)
    `uvm_field_int(coverage_enable9, UVM_DEFAULT)
    `uvm_field_int(num_transactions9, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected9 = apb_transfer9::type_id::create("trans_collected9");
    // TLM ports9 are created here9
    item_collected_port9 = new("item_collected_port9", this);
    addr_trans_export9 = new("addr_trans_export9", this);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions9();
  extern task peek(output apb_transfer9 trans9);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector9

// UVM build_phase
function void apb_collector9::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config9)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG9", "apb_config9 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector9::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if9)::get(this, "", "vif9", vif9))
      `uvm_error("NOVIF9", {"virtual interface must be set for: ", get_full_name(), ".vif9"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector9::run_phase(uvm_phase phase);
    @(posedge vif9.preset9);
    `uvm_info(get_type_name(), "Detected9 Reset9 Done9", UVM_LOW)
    collect_transactions9();
endtask : run_phase

// collect_transactions9
task apb_collector9::collect_transactions9();
  forever begin
    @(posedge vif9.pclock9 iff (vif9.psel9 != 0));
    void'(this.begin_tr(trans_collected9,"apb_collector9","UVM Debug9","APB9 collector9 transaction inside collect_transactions9()"));
    trans_collected9.addr = vif9.paddr9;
    trans_collected9.master9 = cfg.master_config9.name;
    trans_collected9.slave9 = cfg.get_slave_name_by_addr9(trans_collected9.addr);
    case (vif9.prwd9)
      1'b0 : trans_collected9.direction9 = APB_READ9;
      1'b1 : trans_collected9.direction9 = APB_WRITE9;
    endcase
      @(posedge vif9.pclock9);
    if(trans_collected9.direction9 == APB_READ9)
      trans_collected9.data = vif9.prdata9;
    if (trans_collected9.direction9 == APB_WRITE9)
      trans_collected9.data = vif9.pwdata9;
    -> addr_trans_grabbed9;
    @(posedge vif9.pclock9);
    if(trans_collected9.direction9 == APB_READ9) begin
        if(vif9.pready9 != 1'b1)
          @(posedge vif9.pclock9);
      trans_collected9.data = vif9.prdata9;
      end
    this.end_tr(trans_collected9);
    item_collected_port9.write(trans_collected9);
    `uvm_info(get_type_name(), $psprintf("Transfer9 collected9 :\n%s",
              trans_collected9.sprint()), UVM_MEDIUM)
      `ifdef HEAP9
      runq9.push_back(trans_collected9);
      `endif
     num_transactions9++;
    end
endtask : collect_transactions9

task apb_collector9::peek(output apb_transfer9 trans9);
  @addr_trans_grabbed9;
  trans9 = trans_collected9;
endtask : peek

function void apb_collector9::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report9: APB9 collector9 collected9 %0d transfers9", num_transactions9), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV9
