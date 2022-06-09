/*-------------------------------------------------------------------------
File20 name   : gpio_monitor20.sv
Title20       : GPIO20 SystemVerilog20 UVM UVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV20
`define GPIO_MONITOR_SV20

class gpio_monitor20 extends uvm_monitor;

  // This20 property is the virtual interfaced20 needed for this component to
  // view20 HDL signals20. 
  virtual gpio_if20 gpio_if20;

  gpio_csr_s20 csr_s20;

  // Agent20 Id20
  protected int agent_id20;

  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done both in the monitor20 class and the interface.
  bit checks_enable20 = 1;
  bit coverage_enable20 = 1;

  uvm_analysis_port #(gpio_transfer20) item_collected_port20;

  // The following20 property holds20 the transaction information currently
  // begin captured20 (by the collect_receive_data20 and collect_transmit_data20 methods20).
  protected gpio_transfer20 trans_collected20;
  protected gpio_transfer20 last_trans_collected20;

  // Events20 needed to trigger covergroups20
  protected event cov_transaction20;

  event new_transfer_started20;
  event new_bit_started20;

  // Transfer20 collected20 covergroup
  covergroup cov_trans_cg20 @cov_transaction20;
    option.per_instance = 1;
    bypass_mode20 : coverpoint csr_s20.bypass_mode20;
    direction_mode20 : coverpoint csr_s20.direction_mode20;
    output_enable20 : coverpoint csr_s20.output_enable20;
    trans_data20 : coverpoint trans_collected20.monitor_data20 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg20

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor20)
    `uvm_field_int(agent_id20, UVM_ALL_ON)
    `uvm_field_int(checks_enable20, UVM_ALL_ON)
    `uvm_field_int(coverage_enable20, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg20 = new();
    cov_trans_cg20.set_inst_name("gpio_cov_trans_cg20");
    item_collected_port20 = new("item_collected_port20", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if20)::get(this, "", "gpio_if20", gpio_if20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".gpio_if20"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions20();
    join
  endtask : run_phase

  // collect_transactions20
  virtual protected task collect_transactions20();
      last_trans_collected20 = new();
    forever begin
      @(posedge gpio_if20.pclk20);
      trans_collected20 = new();
      if (m_parent != null)
        trans_collected20.agent20 = m_parent.get_name();
      collect_transfer20();
      if (coverage_enable20)
         -> cov_transaction20;
      item_collected_port20.write(trans_collected20);
    end
  endtask : collect_transactions20

  // collect_transfer20
  virtual protected task collect_transfer20();
    void'(this.begin_tr(trans_collected20));
    trans_collected20.transfer_data20 = gpio_if20.gpio_pin_out20;
    trans_collected20.monitor_data20  = gpio_if20.gpio_pin_in20;
    trans_collected20.output_enable20 = gpio_if20.n_gpio_pin_oe20;
    if (!last_trans_collected20.compare(trans_collected20))
      `uvm_info("GPIO_MON20", $psprintf("Transfer20 collected20 :\n%s", trans_collected20.sprint()), UVM_MEDIUM)
    last_trans_collected20 = trans_collected20;
    this.end_tr(trans_collected20);
  endtask : collect_transfer20

endclass : gpio_monitor20

`endif // GPIO_MONITOR_SV20

