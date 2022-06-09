/*-------------------------------------------------------------------------
File28 name   : gpio_monitor28.sv
Title28       : GPIO28 SystemVerilog28 UVM UVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV28
`define GPIO_MONITOR_SV28

class gpio_monitor28 extends uvm_monitor;

  // This28 property is the virtual interfaced28 needed for this component to
  // view28 HDL signals28. 
  virtual gpio_if28 gpio_if28;

  gpio_csr_s28 csr_s28;

  // Agent28 Id28
  protected int agent_id28;

  // The following28 two28 bits are used to control28 whether28 checks28 and coverage28 are
  // done both in the monitor28 class and the interface.
  bit checks_enable28 = 1;
  bit coverage_enable28 = 1;

  uvm_analysis_port #(gpio_transfer28) item_collected_port28;

  // The following28 property holds28 the transaction information currently
  // begin captured28 (by the collect_receive_data28 and collect_transmit_data28 methods28).
  protected gpio_transfer28 trans_collected28;
  protected gpio_transfer28 last_trans_collected28;

  // Events28 needed to trigger covergroups28
  protected event cov_transaction28;

  event new_transfer_started28;
  event new_bit_started28;

  // Transfer28 collected28 covergroup
  covergroup cov_trans_cg28 @cov_transaction28;
    option.per_instance = 1;
    bypass_mode28 : coverpoint csr_s28.bypass_mode28;
    direction_mode28 : coverpoint csr_s28.direction_mode28;
    output_enable28 : coverpoint csr_s28.output_enable28;
    trans_data28 : coverpoint trans_collected28.monitor_data28 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg28

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor28)
    `uvm_field_int(agent_id28, UVM_ALL_ON)
    `uvm_field_int(checks_enable28, UVM_ALL_ON)
    `uvm_field_int(coverage_enable28, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg28 = new();
    cov_trans_cg28.set_inst_name("gpio_cov_trans_cg28");
    item_collected_port28 = new("item_collected_port28", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if28)::get(this, "", "gpio_if28", gpio_if28))
   `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".gpio_if28"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions28();
    join
  endtask : run_phase

  // collect_transactions28
  virtual protected task collect_transactions28();
      last_trans_collected28 = new();
    forever begin
      @(posedge gpio_if28.pclk28);
      trans_collected28 = new();
      if (m_parent != null)
        trans_collected28.agent28 = m_parent.get_name();
      collect_transfer28();
      if (coverage_enable28)
         -> cov_transaction28;
      item_collected_port28.write(trans_collected28);
    end
  endtask : collect_transactions28

  // collect_transfer28
  virtual protected task collect_transfer28();
    void'(this.begin_tr(trans_collected28));
    trans_collected28.transfer_data28 = gpio_if28.gpio_pin_out28;
    trans_collected28.monitor_data28  = gpio_if28.gpio_pin_in28;
    trans_collected28.output_enable28 = gpio_if28.n_gpio_pin_oe28;
    if (!last_trans_collected28.compare(trans_collected28))
      `uvm_info("GPIO_MON28", $psprintf("Transfer28 collected28 :\n%s", trans_collected28.sprint()), UVM_MEDIUM)
    last_trans_collected28 = trans_collected28;
    this.end_tr(trans_collected28);
  endtask : collect_transfer28

endclass : gpio_monitor28

`endif // GPIO_MONITOR_SV28

