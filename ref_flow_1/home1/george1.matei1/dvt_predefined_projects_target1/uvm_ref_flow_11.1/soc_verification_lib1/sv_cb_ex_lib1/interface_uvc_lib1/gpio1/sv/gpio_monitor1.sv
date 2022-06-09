/*-------------------------------------------------------------------------
File1 name   : gpio_monitor1.sv
Title1       : GPIO1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV1
`define GPIO_MONITOR_SV1

class gpio_monitor1 extends uvm_monitor;

  // This1 property is the virtual interfaced1 needed for this component to
  // view1 HDL signals1. 
  virtual gpio_if1 gpio_if1;

  gpio_csr_s1 csr_s1;

  // Agent1 Id1
  protected int agent_id1;

  // The following1 two1 bits are used to control1 whether1 checks1 and coverage1 are
  // done both in the monitor1 class and the interface.
  bit checks_enable1 = 1;
  bit coverage_enable1 = 1;

  uvm_analysis_port #(gpio_transfer1) item_collected_port1;

  // The following1 property holds1 the transaction information currently
  // begin captured1 (by the collect_receive_data1 and collect_transmit_data1 methods1).
  protected gpio_transfer1 trans_collected1;
  protected gpio_transfer1 last_trans_collected1;

  // Events1 needed to trigger covergroups1
  protected event cov_transaction1;

  event new_transfer_started1;
  event new_bit_started1;

  // Transfer1 collected1 covergroup
  covergroup cov_trans_cg1 @cov_transaction1;
    option.per_instance = 1;
    bypass_mode1 : coverpoint csr_s1.bypass_mode1;
    direction_mode1 : coverpoint csr_s1.direction_mode1;
    output_enable1 : coverpoint csr_s1.output_enable1;
    trans_data1 : coverpoint trans_collected1.monitor_data1 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg1

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor1)
    `uvm_field_int(agent_id1, UVM_ALL_ON)
    `uvm_field_int(checks_enable1, UVM_ALL_ON)
    `uvm_field_int(coverage_enable1, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg1 = new();
    cov_trans_cg1.set_inst_name("gpio_cov_trans_cg1");
    item_collected_port1 = new("item_collected_port1", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if1)::get(this, "", "gpio_if1", gpio_if1))
   `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".gpio_if1"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions1();
    join
  endtask : run_phase

  // collect_transactions1
  virtual protected task collect_transactions1();
      last_trans_collected1 = new();
    forever begin
      @(posedge gpio_if1.pclk1);
      trans_collected1 = new();
      if (m_parent != null)
        trans_collected1.agent1 = m_parent.get_name();
      collect_transfer1();
      if (coverage_enable1)
         -> cov_transaction1;
      item_collected_port1.write(trans_collected1);
    end
  endtask : collect_transactions1

  // collect_transfer1
  virtual protected task collect_transfer1();
    void'(this.begin_tr(trans_collected1));
    trans_collected1.transfer_data1 = gpio_if1.gpio_pin_out1;
    trans_collected1.monitor_data1  = gpio_if1.gpio_pin_in1;
    trans_collected1.output_enable1 = gpio_if1.n_gpio_pin_oe1;
    if (!last_trans_collected1.compare(trans_collected1))
      `uvm_info("GPIO_MON1", $psprintf("Transfer1 collected1 :\n%s", trans_collected1.sprint()), UVM_MEDIUM)
    last_trans_collected1 = trans_collected1;
    this.end_tr(trans_collected1);
  endtask : collect_transfer1

endclass : gpio_monitor1

`endif // GPIO_MONITOR_SV1

