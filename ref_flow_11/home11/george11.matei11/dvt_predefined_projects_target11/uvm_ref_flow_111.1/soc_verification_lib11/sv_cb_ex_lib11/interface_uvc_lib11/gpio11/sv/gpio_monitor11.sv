/*-------------------------------------------------------------------------
File11 name   : gpio_monitor11.sv
Title11       : GPIO11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV11
`define GPIO_MONITOR_SV11

class gpio_monitor11 extends uvm_monitor;

  // This11 property is the virtual interfaced11 needed for this component to
  // view11 HDL signals11. 
  virtual gpio_if11 gpio_if11;

  gpio_csr_s11 csr_s11;

  // Agent11 Id11
  protected int agent_id11;

  // The following11 two11 bits are used to control11 whether11 checks11 and coverage11 are
  // done both in the monitor11 class and the interface.
  bit checks_enable11 = 1;
  bit coverage_enable11 = 1;

  uvm_analysis_port #(gpio_transfer11) item_collected_port11;

  // The following11 property holds11 the transaction information currently
  // begin captured11 (by the collect_receive_data11 and collect_transmit_data11 methods11).
  protected gpio_transfer11 trans_collected11;
  protected gpio_transfer11 last_trans_collected11;

  // Events11 needed to trigger covergroups11
  protected event cov_transaction11;

  event new_transfer_started11;
  event new_bit_started11;

  // Transfer11 collected11 covergroup
  covergroup cov_trans_cg11 @cov_transaction11;
    option.per_instance = 1;
    bypass_mode11 : coverpoint csr_s11.bypass_mode11;
    direction_mode11 : coverpoint csr_s11.direction_mode11;
    output_enable11 : coverpoint csr_s11.output_enable11;
    trans_data11 : coverpoint trans_collected11.monitor_data11 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg11

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor11)
    `uvm_field_int(agent_id11, UVM_ALL_ON)
    `uvm_field_int(checks_enable11, UVM_ALL_ON)
    `uvm_field_int(coverage_enable11, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg11 = new();
    cov_trans_cg11.set_inst_name("gpio_cov_trans_cg11");
    item_collected_port11 = new("item_collected_port11", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if11)::get(this, "", "gpio_if11", gpio_if11))
   `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".gpio_if11"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions11();
    join
  endtask : run_phase

  // collect_transactions11
  virtual protected task collect_transactions11();
      last_trans_collected11 = new();
    forever begin
      @(posedge gpio_if11.pclk11);
      trans_collected11 = new();
      if (m_parent != null)
        trans_collected11.agent11 = m_parent.get_name();
      collect_transfer11();
      if (coverage_enable11)
         -> cov_transaction11;
      item_collected_port11.write(trans_collected11);
    end
  endtask : collect_transactions11

  // collect_transfer11
  virtual protected task collect_transfer11();
    void'(this.begin_tr(trans_collected11));
    trans_collected11.transfer_data11 = gpio_if11.gpio_pin_out11;
    trans_collected11.monitor_data11  = gpio_if11.gpio_pin_in11;
    trans_collected11.output_enable11 = gpio_if11.n_gpio_pin_oe11;
    if (!last_trans_collected11.compare(trans_collected11))
      `uvm_info("GPIO_MON11", $psprintf("Transfer11 collected11 :\n%s", trans_collected11.sprint()), UVM_MEDIUM)
    last_trans_collected11 = trans_collected11;
    this.end_tr(trans_collected11);
  endtask : collect_transfer11

endclass : gpio_monitor11

`endif // GPIO_MONITOR_SV11

