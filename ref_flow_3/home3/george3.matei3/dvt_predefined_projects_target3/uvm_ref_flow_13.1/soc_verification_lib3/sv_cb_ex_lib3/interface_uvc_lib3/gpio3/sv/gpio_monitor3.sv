/*-------------------------------------------------------------------------
File3 name   : gpio_monitor3.sv
Title3       : GPIO3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV3
`define GPIO_MONITOR_SV3

class gpio_monitor3 extends uvm_monitor;

  // This3 property is the virtual interfaced3 needed for this component to
  // view3 HDL signals3. 
  virtual gpio_if3 gpio_if3;

  gpio_csr_s3 csr_s3;

  // Agent3 Id3
  protected int agent_id3;

  // The following3 two3 bits are used to control3 whether3 checks3 and coverage3 are
  // done both in the monitor3 class and the interface.
  bit checks_enable3 = 1;
  bit coverage_enable3 = 1;

  uvm_analysis_port #(gpio_transfer3) item_collected_port3;

  // The following3 property holds3 the transaction information currently
  // begin captured3 (by the collect_receive_data3 and collect_transmit_data3 methods3).
  protected gpio_transfer3 trans_collected3;
  protected gpio_transfer3 last_trans_collected3;

  // Events3 needed to trigger covergroups3
  protected event cov_transaction3;

  event new_transfer_started3;
  event new_bit_started3;

  // Transfer3 collected3 covergroup
  covergroup cov_trans_cg3 @cov_transaction3;
    option.per_instance = 1;
    bypass_mode3 : coverpoint csr_s3.bypass_mode3;
    direction_mode3 : coverpoint csr_s3.direction_mode3;
    output_enable3 : coverpoint csr_s3.output_enable3;
    trans_data3 : coverpoint trans_collected3.monitor_data3 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg3

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor3)
    `uvm_field_int(agent_id3, UVM_ALL_ON)
    `uvm_field_int(checks_enable3, UVM_ALL_ON)
    `uvm_field_int(coverage_enable3, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg3 = new();
    cov_trans_cg3.set_inst_name("gpio_cov_trans_cg3");
    item_collected_port3 = new("item_collected_port3", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if3)::get(this, "", "gpio_if3", gpio_if3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".gpio_if3"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions3();
    join
  endtask : run_phase

  // collect_transactions3
  virtual protected task collect_transactions3();
      last_trans_collected3 = new();
    forever begin
      @(posedge gpio_if3.pclk3);
      trans_collected3 = new();
      if (m_parent != null)
        trans_collected3.agent3 = m_parent.get_name();
      collect_transfer3();
      if (coverage_enable3)
         -> cov_transaction3;
      item_collected_port3.write(trans_collected3);
    end
  endtask : collect_transactions3

  // collect_transfer3
  virtual protected task collect_transfer3();
    void'(this.begin_tr(trans_collected3));
    trans_collected3.transfer_data3 = gpio_if3.gpio_pin_out3;
    trans_collected3.monitor_data3  = gpio_if3.gpio_pin_in3;
    trans_collected3.output_enable3 = gpio_if3.n_gpio_pin_oe3;
    if (!last_trans_collected3.compare(trans_collected3))
      `uvm_info("GPIO_MON3", $psprintf("Transfer3 collected3 :\n%s", trans_collected3.sprint()), UVM_MEDIUM)
    last_trans_collected3 = trans_collected3;
    this.end_tr(trans_collected3);
  endtask : collect_transfer3

endclass : gpio_monitor3

`endif // GPIO_MONITOR_SV3

