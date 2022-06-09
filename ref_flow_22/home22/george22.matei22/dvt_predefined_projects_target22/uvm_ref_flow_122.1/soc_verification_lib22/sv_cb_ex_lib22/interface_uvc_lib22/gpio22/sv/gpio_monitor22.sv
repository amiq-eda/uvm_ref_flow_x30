/*-------------------------------------------------------------------------
File22 name   : gpio_monitor22.sv
Title22       : GPIO22 SystemVerilog22 UVM UVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV22
`define GPIO_MONITOR_SV22

class gpio_monitor22 extends uvm_monitor;

  // This22 property is the virtual interfaced22 needed for this component to
  // view22 HDL signals22. 
  virtual gpio_if22 gpio_if22;

  gpio_csr_s22 csr_s22;

  // Agent22 Id22
  protected int agent_id22;

  // The following22 two22 bits are used to control22 whether22 checks22 and coverage22 are
  // done both in the monitor22 class and the interface.
  bit checks_enable22 = 1;
  bit coverage_enable22 = 1;

  uvm_analysis_port #(gpio_transfer22) item_collected_port22;

  // The following22 property holds22 the transaction information currently
  // begin captured22 (by the collect_receive_data22 and collect_transmit_data22 methods22).
  protected gpio_transfer22 trans_collected22;
  protected gpio_transfer22 last_trans_collected22;

  // Events22 needed to trigger covergroups22
  protected event cov_transaction22;

  event new_transfer_started22;
  event new_bit_started22;

  // Transfer22 collected22 covergroup
  covergroup cov_trans_cg22 @cov_transaction22;
    option.per_instance = 1;
    bypass_mode22 : coverpoint csr_s22.bypass_mode22;
    direction_mode22 : coverpoint csr_s22.direction_mode22;
    output_enable22 : coverpoint csr_s22.output_enable22;
    trans_data22 : coverpoint trans_collected22.monitor_data22 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg22

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor22)
    `uvm_field_int(agent_id22, UVM_ALL_ON)
    `uvm_field_int(checks_enable22, UVM_ALL_ON)
    `uvm_field_int(coverage_enable22, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg22 = new();
    cov_trans_cg22.set_inst_name("gpio_cov_trans_cg22");
    item_collected_port22 = new("item_collected_port22", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if22)::get(this, "", "gpio_if22", gpio_if22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".gpio_if22"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions22();
    join
  endtask : run_phase

  // collect_transactions22
  virtual protected task collect_transactions22();
      last_trans_collected22 = new();
    forever begin
      @(posedge gpio_if22.pclk22);
      trans_collected22 = new();
      if (m_parent != null)
        trans_collected22.agent22 = m_parent.get_name();
      collect_transfer22();
      if (coverage_enable22)
         -> cov_transaction22;
      item_collected_port22.write(trans_collected22);
    end
  endtask : collect_transactions22

  // collect_transfer22
  virtual protected task collect_transfer22();
    void'(this.begin_tr(trans_collected22));
    trans_collected22.transfer_data22 = gpio_if22.gpio_pin_out22;
    trans_collected22.monitor_data22  = gpio_if22.gpio_pin_in22;
    trans_collected22.output_enable22 = gpio_if22.n_gpio_pin_oe22;
    if (!last_trans_collected22.compare(trans_collected22))
      `uvm_info("GPIO_MON22", $psprintf("Transfer22 collected22 :\n%s", trans_collected22.sprint()), UVM_MEDIUM)
    last_trans_collected22 = trans_collected22;
    this.end_tr(trans_collected22);
  endtask : collect_transfer22

endclass : gpio_monitor22

`endif // GPIO_MONITOR_SV22

