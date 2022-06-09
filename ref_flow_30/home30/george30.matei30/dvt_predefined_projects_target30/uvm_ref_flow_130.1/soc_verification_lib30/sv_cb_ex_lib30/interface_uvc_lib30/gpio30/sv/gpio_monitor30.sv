/*-------------------------------------------------------------------------
File30 name   : gpio_monitor30.sv
Title30       : GPIO30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV30
`define GPIO_MONITOR_SV30

class gpio_monitor30 extends uvm_monitor;

  // This30 property is the virtual interfaced30 needed for this component to
  // view30 HDL signals30. 
  virtual gpio_if30 gpio_if30;

  gpio_csr_s30 csr_s30;

  // Agent30 Id30
  protected int agent_id30;

  // The following30 two30 bits are used to control30 whether30 checks30 and coverage30 are
  // done both in the monitor30 class and the interface.
  bit checks_enable30 = 1;
  bit coverage_enable30 = 1;

  uvm_analysis_port #(gpio_transfer30) item_collected_port30;

  // The following30 property holds30 the transaction information currently
  // begin captured30 (by the collect_receive_data30 and collect_transmit_data30 methods30).
  protected gpio_transfer30 trans_collected30;
  protected gpio_transfer30 last_trans_collected30;

  // Events30 needed to trigger covergroups30
  protected event cov_transaction30;

  event new_transfer_started30;
  event new_bit_started30;

  // Transfer30 collected30 covergroup
  covergroup cov_trans_cg30 @cov_transaction30;
    option.per_instance = 1;
    bypass_mode30 : coverpoint csr_s30.bypass_mode30;
    direction_mode30 : coverpoint csr_s30.direction_mode30;
    output_enable30 : coverpoint csr_s30.output_enable30;
    trans_data30 : coverpoint trans_collected30.monitor_data30 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg30

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor30)
    `uvm_field_int(agent_id30, UVM_ALL_ON)
    `uvm_field_int(checks_enable30, UVM_ALL_ON)
    `uvm_field_int(coverage_enable30, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg30 = new();
    cov_trans_cg30.set_inst_name("gpio_cov_trans_cg30");
    item_collected_port30 = new("item_collected_port30", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if30)::get(this, "", "gpio_if30", gpio_if30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".gpio_if30"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions30();
    join
  endtask : run_phase

  // collect_transactions30
  virtual protected task collect_transactions30();
      last_trans_collected30 = new();
    forever begin
      @(posedge gpio_if30.pclk30);
      trans_collected30 = new();
      if (m_parent != null)
        trans_collected30.agent30 = m_parent.get_name();
      collect_transfer30();
      if (coverage_enable30)
         -> cov_transaction30;
      item_collected_port30.write(trans_collected30);
    end
  endtask : collect_transactions30

  // collect_transfer30
  virtual protected task collect_transfer30();
    void'(this.begin_tr(trans_collected30));
    trans_collected30.transfer_data30 = gpio_if30.gpio_pin_out30;
    trans_collected30.monitor_data30  = gpio_if30.gpio_pin_in30;
    trans_collected30.output_enable30 = gpio_if30.n_gpio_pin_oe30;
    if (!last_trans_collected30.compare(trans_collected30))
      `uvm_info("GPIO_MON30", $psprintf("Transfer30 collected30 :\n%s", trans_collected30.sprint()), UVM_MEDIUM)
    last_trans_collected30 = trans_collected30;
    this.end_tr(trans_collected30);
  endtask : collect_transfer30

endclass : gpio_monitor30

`endif // GPIO_MONITOR_SV30

