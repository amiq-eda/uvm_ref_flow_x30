/*-------------------------------------------------------------------------
File23 name   : gpio_monitor23.sv
Title23       : GPIO23 SystemVerilog23 UVM UVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV23
`define GPIO_MONITOR_SV23

class gpio_monitor23 extends uvm_monitor;

  // This23 property is the virtual interfaced23 needed for this component to
  // view23 HDL signals23. 
  virtual gpio_if23 gpio_if23;

  gpio_csr_s23 csr_s23;

  // Agent23 Id23
  protected int agent_id23;

  // The following23 two23 bits are used to control23 whether23 checks23 and coverage23 are
  // done both in the monitor23 class and the interface.
  bit checks_enable23 = 1;
  bit coverage_enable23 = 1;

  uvm_analysis_port #(gpio_transfer23) item_collected_port23;

  // The following23 property holds23 the transaction information currently
  // begin captured23 (by the collect_receive_data23 and collect_transmit_data23 methods23).
  protected gpio_transfer23 trans_collected23;
  protected gpio_transfer23 last_trans_collected23;

  // Events23 needed to trigger covergroups23
  protected event cov_transaction23;

  event new_transfer_started23;
  event new_bit_started23;

  // Transfer23 collected23 covergroup
  covergroup cov_trans_cg23 @cov_transaction23;
    option.per_instance = 1;
    bypass_mode23 : coverpoint csr_s23.bypass_mode23;
    direction_mode23 : coverpoint csr_s23.direction_mode23;
    output_enable23 : coverpoint csr_s23.output_enable23;
    trans_data23 : coverpoint trans_collected23.monitor_data23 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg23

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor23)
    `uvm_field_int(agent_id23, UVM_ALL_ON)
    `uvm_field_int(checks_enable23, UVM_ALL_ON)
    `uvm_field_int(coverage_enable23, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg23 = new();
    cov_trans_cg23.set_inst_name("gpio_cov_trans_cg23");
    item_collected_port23 = new("item_collected_port23", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if23)::get(this, "", "gpio_if23", gpio_if23))
   `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".gpio_if23"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions23();
    join
  endtask : run_phase

  // collect_transactions23
  virtual protected task collect_transactions23();
      last_trans_collected23 = new();
    forever begin
      @(posedge gpio_if23.pclk23);
      trans_collected23 = new();
      if (m_parent != null)
        trans_collected23.agent23 = m_parent.get_name();
      collect_transfer23();
      if (coverage_enable23)
         -> cov_transaction23;
      item_collected_port23.write(trans_collected23);
    end
  endtask : collect_transactions23

  // collect_transfer23
  virtual protected task collect_transfer23();
    void'(this.begin_tr(trans_collected23));
    trans_collected23.transfer_data23 = gpio_if23.gpio_pin_out23;
    trans_collected23.monitor_data23  = gpio_if23.gpio_pin_in23;
    trans_collected23.output_enable23 = gpio_if23.n_gpio_pin_oe23;
    if (!last_trans_collected23.compare(trans_collected23))
      `uvm_info("GPIO_MON23", $psprintf("Transfer23 collected23 :\n%s", trans_collected23.sprint()), UVM_MEDIUM)
    last_trans_collected23 = trans_collected23;
    this.end_tr(trans_collected23);
  endtask : collect_transfer23

endclass : gpio_monitor23

`endif // GPIO_MONITOR_SV23

