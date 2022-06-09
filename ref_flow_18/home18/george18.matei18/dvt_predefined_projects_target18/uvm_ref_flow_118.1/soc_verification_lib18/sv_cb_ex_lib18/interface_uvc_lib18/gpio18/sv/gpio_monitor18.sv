/*-------------------------------------------------------------------------
File18 name   : gpio_monitor18.sv
Title18       : GPIO18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV18
`define GPIO_MONITOR_SV18

class gpio_monitor18 extends uvm_monitor;

  // This18 property is the virtual interfaced18 needed for this component to
  // view18 HDL signals18. 
  virtual gpio_if18 gpio_if18;

  gpio_csr_s18 csr_s18;

  // Agent18 Id18
  protected int agent_id18;

  // The following18 two18 bits are used to control18 whether18 checks18 and coverage18 are
  // done both in the monitor18 class and the interface.
  bit checks_enable18 = 1;
  bit coverage_enable18 = 1;

  uvm_analysis_port #(gpio_transfer18) item_collected_port18;

  // The following18 property holds18 the transaction information currently
  // begin captured18 (by the collect_receive_data18 and collect_transmit_data18 methods18).
  protected gpio_transfer18 trans_collected18;
  protected gpio_transfer18 last_trans_collected18;

  // Events18 needed to trigger covergroups18
  protected event cov_transaction18;

  event new_transfer_started18;
  event new_bit_started18;

  // Transfer18 collected18 covergroup
  covergroup cov_trans_cg18 @cov_transaction18;
    option.per_instance = 1;
    bypass_mode18 : coverpoint csr_s18.bypass_mode18;
    direction_mode18 : coverpoint csr_s18.direction_mode18;
    output_enable18 : coverpoint csr_s18.output_enable18;
    trans_data18 : coverpoint trans_collected18.monitor_data18 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg18

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor18)
    `uvm_field_int(agent_id18, UVM_ALL_ON)
    `uvm_field_int(checks_enable18, UVM_ALL_ON)
    `uvm_field_int(coverage_enable18, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg18 = new();
    cov_trans_cg18.set_inst_name("gpio_cov_trans_cg18");
    item_collected_port18 = new("item_collected_port18", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if18)::get(this, "", "gpio_if18", gpio_if18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".gpio_if18"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions18();
    join
  endtask : run_phase

  // collect_transactions18
  virtual protected task collect_transactions18();
      last_trans_collected18 = new();
    forever begin
      @(posedge gpio_if18.pclk18);
      trans_collected18 = new();
      if (m_parent != null)
        trans_collected18.agent18 = m_parent.get_name();
      collect_transfer18();
      if (coverage_enable18)
         -> cov_transaction18;
      item_collected_port18.write(trans_collected18);
    end
  endtask : collect_transactions18

  // collect_transfer18
  virtual protected task collect_transfer18();
    void'(this.begin_tr(trans_collected18));
    trans_collected18.transfer_data18 = gpio_if18.gpio_pin_out18;
    trans_collected18.monitor_data18  = gpio_if18.gpio_pin_in18;
    trans_collected18.output_enable18 = gpio_if18.n_gpio_pin_oe18;
    if (!last_trans_collected18.compare(trans_collected18))
      `uvm_info("GPIO_MON18", $psprintf("Transfer18 collected18 :\n%s", trans_collected18.sprint()), UVM_MEDIUM)
    last_trans_collected18 = trans_collected18;
    this.end_tr(trans_collected18);
  endtask : collect_transfer18

endclass : gpio_monitor18

`endif // GPIO_MONITOR_SV18

