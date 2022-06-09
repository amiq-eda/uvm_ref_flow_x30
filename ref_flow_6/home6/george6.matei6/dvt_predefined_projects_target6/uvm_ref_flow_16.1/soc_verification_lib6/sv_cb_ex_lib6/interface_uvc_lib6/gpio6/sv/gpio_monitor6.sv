/*-------------------------------------------------------------------------
File6 name   : gpio_monitor6.sv
Title6       : GPIO6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
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


`ifndef GPIO_MONITOR_SV6
`define GPIO_MONITOR_SV6

class gpio_monitor6 extends uvm_monitor;

  // This6 property is the virtual interfaced6 needed for this component to
  // view6 HDL signals6. 
  virtual gpio_if6 gpio_if6;

  gpio_csr_s6 csr_s6;

  // Agent6 Id6
  protected int agent_id6;

  // The following6 two6 bits are used to control6 whether6 checks6 and coverage6 are
  // done both in the monitor6 class and the interface.
  bit checks_enable6 = 1;
  bit coverage_enable6 = 1;

  uvm_analysis_port #(gpio_transfer6) item_collected_port6;

  // The following6 property holds6 the transaction information currently
  // begin captured6 (by the collect_receive_data6 and collect_transmit_data6 methods6).
  protected gpio_transfer6 trans_collected6;
  protected gpio_transfer6 last_trans_collected6;

  // Events6 needed to trigger covergroups6
  protected event cov_transaction6;

  event new_transfer_started6;
  event new_bit_started6;

  // Transfer6 collected6 covergroup
  covergroup cov_trans_cg6 @cov_transaction6;
    option.per_instance = 1;
    bypass_mode6 : coverpoint csr_s6.bypass_mode6;
    direction_mode6 : coverpoint csr_s6.direction_mode6;
    output_enable6 : coverpoint csr_s6.output_enable6;
    trans_data6 : coverpoint trans_collected6.monitor_data6 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg6

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor6)
    `uvm_field_int(agent_id6, UVM_ALL_ON)
    `uvm_field_int(checks_enable6, UVM_ALL_ON)
    `uvm_field_int(coverage_enable6, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg6 = new();
    cov_trans_cg6.set_inst_name("gpio_cov_trans_cg6");
    item_collected_port6 = new("item_collected_port6", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if6)::get(this, "", "gpio_if6", gpio_if6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".gpio_if6"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions6();
    join
  endtask : run_phase

  // collect_transactions6
  virtual protected task collect_transactions6();
      last_trans_collected6 = new();
    forever begin
      @(posedge gpio_if6.pclk6);
      trans_collected6 = new();
      if (m_parent != null)
        trans_collected6.agent6 = m_parent.get_name();
      collect_transfer6();
      if (coverage_enable6)
         -> cov_transaction6;
      item_collected_port6.write(trans_collected6);
    end
  endtask : collect_transactions6

  // collect_transfer6
  virtual protected task collect_transfer6();
    void'(this.begin_tr(trans_collected6));
    trans_collected6.transfer_data6 = gpio_if6.gpio_pin_out6;
    trans_collected6.monitor_data6  = gpio_if6.gpio_pin_in6;
    trans_collected6.output_enable6 = gpio_if6.n_gpio_pin_oe6;
    if (!last_trans_collected6.compare(trans_collected6))
      `uvm_info("GPIO_MON6", $psprintf("Transfer6 collected6 :\n%s", trans_collected6.sprint()), UVM_MEDIUM)
    last_trans_collected6 = trans_collected6;
    this.end_tr(trans_collected6);
  endtask : collect_transfer6

endclass : gpio_monitor6

`endif // GPIO_MONITOR_SV6

