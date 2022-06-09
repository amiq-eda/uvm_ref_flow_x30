/*-------------------------------------------------------------------------
File13 name   : gpio_monitor13.sv
Title13       : GPIO13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV13
`define GPIO_MONITOR_SV13

class gpio_monitor13 extends uvm_monitor;

  // This13 property is the virtual interfaced13 needed for this component to
  // view13 HDL signals13. 
  virtual gpio_if13 gpio_if13;

  gpio_csr_s13 csr_s13;

  // Agent13 Id13
  protected int agent_id13;

  // The following13 two13 bits are used to control13 whether13 checks13 and coverage13 are
  // done both in the monitor13 class and the interface.
  bit checks_enable13 = 1;
  bit coverage_enable13 = 1;

  uvm_analysis_port #(gpio_transfer13) item_collected_port13;

  // The following13 property holds13 the transaction information currently
  // begin captured13 (by the collect_receive_data13 and collect_transmit_data13 methods13).
  protected gpio_transfer13 trans_collected13;
  protected gpio_transfer13 last_trans_collected13;

  // Events13 needed to trigger covergroups13
  protected event cov_transaction13;

  event new_transfer_started13;
  event new_bit_started13;

  // Transfer13 collected13 covergroup
  covergroup cov_trans_cg13 @cov_transaction13;
    option.per_instance = 1;
    bypass_mode13 : coverpoint csr_s13.bypass_mode13;
    direction_mode13 : coverpoint csr_s13.direction_mode13;
    output_enable13 : coverpoint csr_s13.output_enable13;
    trans_data13 : coverpoint trans_collected13.monitor_data13 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg13

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor13)
    `uvm_field_int(agent_id13, UVM_ALL_ON)
    `uvm_field_int(checks_enable13, UVM_ALL_ON)
    `uvm_field_int(coverage_enable13, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg13 = new();
    cov_trans_cg13.set_inst_name("gpio_cov_trans_cg13");
    item_collected_port13 = new("item_collected_port13", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if13)::get(this, "", "gpio_if13", gpio_if13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".gpio_if13"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions13();
    join
  endtask : run_phase

  // collect_transactions13
  virtual protected task collect_transactions13();
      last_trans_collected13 = new();
    forever begin
      @(posedge gpio_if13.pclk13);
      trans_collected13 = new();
      if (m_parent != null)
        trans_collected13.agent13 = m_parent.get_name();
      collect_transfer13();
      if (coverage_enable13)
         -> cov_transaction13;
      item_collected_port13.write(trans_collected13);
    end
  endtask : collect_transactions13

  // collect_transfer13
  virtual protected task collect_transfer13();
    void'(this.begin_tr(trans_collected13));
    trans_collected13.transfer_data13 = gpio_if13.gpio_pin_out13;
    trans_collected13.monitor_data13  = gpio_if13.gpio_pin_in13;
    trans_collected13.output_enable13 = gpio_if13.n_gpio_pin_oe13;
    if (!last_trans_collected13.compare(trans_collected13))
      `uvm_info("GPIO_MON13", $psprintf("Transfer13 collected13 :\n%s", trans_collected13.sprint()), UVM_MEDIUM)
    last_trans_collected13 = trans_collected13;
    this.end_tr(trans_collected13);
  endtask : collect_transfer13

endclass : gpio_monitor13

`endif // GPIO_MONITOR_SV13

