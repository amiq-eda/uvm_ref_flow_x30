/*-------------------------------------------------------------------------
File15 name   : gpio_monitor15.sv
Title15       : GPIO15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV15
`define GPIO_MONITOR_SV15

class gpio_monitor15 extends uvm_monitor;

  // This15 property is the virtual interfaced15 needed for this component to
  // view15 HDL signals15. 
  virtual gpio_if15 gpio_if15;

  gpio_csr_s15 csr_s15;

  // Agent15 Id15
  protected int agent_id15;

  // The following15 two15 bits are used to control15 whether15 checks15 and coverage15 are
  // done both in the monitor15 class and the interface.
  bit checks_enable15 = 1;
  bit coverage_enable15 = 1;

  uvm_analysis_port #(gpio_transfer15) item_collected_port15;

  // The following15 property holds15 the transaction information currently
  // begin captured15 (by the collect_receive_data15 and collect_transmit_data15 methods15).
  protected gpio_transfer15 trans_collected15;
  protected gpio_transfer15 last_trans_collected15;

  // Events15 needed to trigger covergroups15
  protected event cov_transaction15;

  event new_transfer_started15;
  event new_bit_started15;

  // Transfer15 collected15 covergroup
  covergroup cov_trans_cg15 @cov_transaction15;
    option.per_instance = 1;
    bypass_mode15 : coverpoint csr_s15.bypass_mode15;
    direction_mode15 : coverpoint csr_s15.direction_mode15;
    output_enable15 : coverpoint csr_s15.output_enable15;
    trans_data15 : coverpoint trans_collected15.monitor_data15 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg15

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor15)
    `uvm_field_int(agent_id15, UVM_ALL_ON)
    `uvm_field_int(checks_enable15, UVM_ALL_ON)
    `uvm_field_int(coverage_enable15, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg15 = new();
    cov_trans_cg15.set_inst_name("gpio_cov_trans_cg15");
    item_collected_port15 = new("item_collected_port15", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if15)::get(this, "", "gpio_if15", gpio_if15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".gpio_if15"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions15();
    join
  endtask : run_phase

  // collect_transactions15
  virtual protected task collect_transactions15();
      last_trans_collected15 = new();
    forever begin
      @(posedge gpio_if15.pclk15);
      trans_collected15 = new();
      if (m_parent != null)
        trans_collected15.agent15 = m_parent.get_name();
      collect_transfer15();
      if (coverage_enable15)
         -> cov_transaction15;
      item_collected_port15.write(trans_collected15);
    end
  endtask : collect_transactions15

  // collect_transfer15
  virtual protected task collect_transfer15();
    void'(this.begin_tr(trans_collected15));
    trans_collected15.transfer_data15 = gpio_if15.gpio_pin_out15;
    trans_collected15.monitor_data15  = gpio_if15.gpio_pin_in15;
    trans_collected15.output_enable15 = gpio_if15.n_gpio_pin_oe15;
    if (!last_trans_collected15.compare(trans_collected15))
      `uvm_info("GPIO_MON15", $psprintf("Transfer15 collected15 :\n%s", trans_collected15.sprint()), UVM_MEDIUM)
    last_trans_collected15 = trans_collected15;
    this.end_tr(trans_collected15);
  endtask : collect_transfer15

endclass : gpio_monitor15

`endif // GPIO_MONITOR_SV15

