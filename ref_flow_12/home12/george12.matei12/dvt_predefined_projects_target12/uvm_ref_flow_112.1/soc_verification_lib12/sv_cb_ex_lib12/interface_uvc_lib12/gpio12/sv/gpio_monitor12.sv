/*-------------------------------------------------------------------------
File12 name   : gpio_monitor12.sv
Title12       : GPIO12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
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


`ifndef GPIO_MONITOR_SV12
`define GPIO_MONITOR_SV12

class gpio_monitor12 extends uvm_monitor;

  // This12 property is the virtual interfaced12 needed for this component to
  // view12 HDL signals12. 
  virtual gpio_if12 gpio_if12;

  gpio_csr_s12 csr_s12;

  // Agent12 Id12
  protected int agent_id12;

  // The following12 two12 bits are used to control12 whether12 checks12 and coverage12 are
  // done both in the monitor12 class and the interface.
  bit checks_enable12 = 1;
  bit coverage_enable12 = 1;

  uvm_analysis_port #(gpio_transfer12) item_collected_port12;

  // The following12 property holds12 the transaction information currently
  // begin captured12 (by the collect_receive_data12 and collect_transmit_data12 methods12).
  protected gpio_transfer12 trans_collected12;
  protected gpio_transfer12 last_trans_collected12;

  // Events12 needed to trigger covergroups12
  protected event cov_transaction12;

  event new_transfer_started12;
  event new_bit_started12;

  // Transfer12 collected12 covergroup
  covergroup cov_trans_cg12 @cov_transaction12;
    option.per_instance = 1;
    bypass_mode12 : coverpoint csr_s12.bypass_mode12;
    direction_mode12 : coverpoint csr_s12.direction_mode12;
    output_enable12 : coverpoint csr_s12.output_enable12;
    trans_data12 : coverpoint trans_collected12.monitor_data12 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg12

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor12)
    `uvm_field_int(agent_id12, UVM_ALL_ON)
    `uvm_field_int(checks_enable12, UVM_ALL_ON)
    `uvm_field_int(coverage_enable12, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg12 = new();
    cov_trans_cg12.set_inst_name("gpio_cov_trans_cg12");
    item_collected_port12 = new("item_collected_port12", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if12)::get(this, "", "gpio_if12", gpio_if12))
   `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".gpio_if12"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions12();
    join
  endtask : run_phase

  // collect_transactions12
  virtual protected task collect_transactions12();
      last_trans_collected12 = new();
    forever begin
      @(posedge gpio_if12.pclk12);
      trans_collected12 = new();
      if (m_parent != null)
        trans_collected12.agent12 = m_parent.get_name();
      collect_transfer12();
      if (coverage_enable12)
         -> cov_transaction12;
      item_collected_port12.write(trans_collected12);
    end
  endtask : collect_transactions12

  // collect_transfer12
  virtual protected task collect_transfer12();
    void'(this.begin_tr(trans_collected12));
    trans_collected12.transfer_data12 = gpio_if12.gpio_pin_out12;
    trans_collected12.monitor_data12  = gpio_if12.gpio_pin_in12;
    trans_collected12.output_enable12 = gpio_if12.n_gpio_pin_oe12;
    if (!last_trans_collected12.compare(trans_collected12))
      `uvm_info("GPIO_MON12", $psprintf("Transfer12 collected12 :\n%s", trans_collected12.sprint()), UVM_MEDIUM)
    last_trans_collected12 = trans_collected12;
    this.end_tr(trans_collected12);
  endtask : collect_transfer12

endclass : gpio_monitor12

`endif // GPIO_MONITOR_SV12

