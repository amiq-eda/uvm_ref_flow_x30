/*-------------------------------------------------------------------------
File7 name   : gpio_monitor7.sv
Title7       : GPIO7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV7
`define GPIO_MONITOR_SV7

class gpio_monitor7 extends uvm_monitor;

  // This7 property is the virtual interfaced7 needed for this component to
  // view7 HDL signals7. 
  virtual gpio_if7 gpio_if7;

  gpio_csr_s7 csr_s7;

  // Agent7 Id7
  protected int agent_id7;

  // The following7 two7 bits are used to control7 whether7 checks7 and coverage7 are
  // done both in the monitor7 class and the interface.
  bit checks_enable7 = 1;
  bit coverage_enable7 = 1;

  uvm_analysis_port #(gpio_transfer7) item_collected_port7;

  // The following7 property holds7 the transaction information currently
  // begin captured7 (by the collect_receive_data7 and collect_transmit_data7 methods7).
  protected gpio_transfer7 trans_collected7;
  protected gpio_transfer7 last_trans_collected7;

  // Events7 needed to trigger covergroups7
  protected event cov_transaction7;

  event new_transfer_started7;
  event new_bit_started7;

  // Transfer7 collected7 covergroup
  covergroup cov_trans_cg7 @cov_transaction7;
    option.per_instance = 1;
    bypass_mode7 : coverpoint csr_s7.bypass_mode7;
    direction_mode7 : coverpoint csr_s7.direction_mode7;
    output_enable7 : coverpoint csr_s7.output_enable7;
    trans_data7 : coverpoint trans_collected7.monitor_data7 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg7

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor7)
    `uvm_field_int(agent_id7, UVM_ALL_ON)
    `uvm_field_int(checks_enable7, UVM_ALL_ON)
    `uvm_field_int(coverage_enable7, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg7 = new();
    cov_trans_cg7.set_inst_name("gpio_cov_trans_cg7");
    item_collected_port7 = new("item_collected_port7", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if7)::get(this, "", "gpio_if7", gpio_if7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".gpio_if7"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions7();
    join
  endtask : run_phase

  // collect_transactions7
  virtual protected task collect_transactions7();
      last_trans_collected7 = new();
    forever begin
      @(posedge gpio_if7.pclk7);
      trans_collected7 = new();
      if (m_parent != null)
        trans_collected7.agent7 = m_parent.get_name();
      collect_transfer7();
      if (coverage_enable7)
         -> cov_transaction7;
      item_collected_port7.write(trans_collected7);
    end
  endtask : collect_transactions7

  // collect_transfer7
  virtual protected task collect_transfer7();
    void'(this.begin_tr(trans_collected7));
    trans_collected7.transfer_data7 = gpio_if7.gpio_pin_out7;
    trans_collected7.monitor_data7  = gpio_if7.gpio_pin_in7;
    trans_collected7.output_enable7 = gpio_if7.n_gpio_pin_oe7;
    if (!last_trans_collected7.compare(trans_collected7))
      `uvm_info("GPIO_MON7", $psprintf("Transfer7 collected7 :\n%s", trans_collected7.sprint()), UVM_MEDIUM)
    last_trans_collected7 = trans_collected7;
    this.end_tr(trans_collected7);
  endtask : collect_transfer7

endclass : gpio_monitor7

`endif // GPIO_MONITOR_SV7

