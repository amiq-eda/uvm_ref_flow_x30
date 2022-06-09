/*-------------------------------------------------------------------------
File9 name   : gpio_monitor9.sv
Title9       : GPIO9 SystemVerilog9 UVM UVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV9
`define GPIO_MONITOR_SV9

class gpio_monitor9 extends uvm_monitor;

  // This9 property is the virtual interfaced9 needed for this component to
  // view9 HDL signals9. 
  virtual gpio_if9 gpio_if9;

  gpio_csr_s9 csr_s9;

  // Agent9 Id9
  protected int agent_id9;

  // The following9 two9 bits are used to control9 whether9 checks9 and coverage9 are
  // done both in the monitor9 class and the interface.
  bit checks_enable9 = 1;
  bit coverage_enable9 = 1;

  uvm_analysis_port #(gpio_transfer9) item_collected_port9;

  // The following9 property holds9 the transaction information currently
  // begin captured9 (by the collect_receive_data9 and collect_transmit_data9 methods9).
  protected gpio_transfer9 trans_collected9;
  protected gpio_transfer9 last_trans_collected9;

  // Events9 needed to trigger covergroups9
  protected event cov_transaction9;

  event new_transfer_started9;
  event new_bit_started9;

  // Transfer9 collected9 covergroup
  covergroup cov_trans_cg9 @cov_transaction9;
    option.per_instance = 1;
    bypass_mode9 : coverpoint csr_s9.bypass_mode9;
    direction_mode9 : coverpoint csr_s9.direction_mode9;
    output_enable9 : coverpoint csr_s9.output_enable9;
    trans_data9 : coverpoint trans_collected9.monitor_data9 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg9

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor9)
    `uvm_field_int(agent_id9, UVM_ALL_ON)
    `uvm_field_int(checks_enable9, UVM_ALL_ON)
    `uvm_field_int(coverage_enable9, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg9 = new();
    cov_trans_cg9.set_inst_name("gpio_cov_trans_cg9");
    item_collected_port9 = new("item_collected_port9", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if9)::get(this, "", "gpio_if9", gpio_if9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".gpio_if9"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions9();
    join
  endtask : run_phase

  // collect_transactions9
  virtual protected task collect_transactions9();
      last_trans_collected9 = new();
    forever begin
      @(posedge gpio_if9.pclk9);
      trans_collected9 = new();
      if (m_parent != null)
        trans_collected9.agent9 = m_parent.get_name();
      collect_transfer9();
      if (coverage_enable9)
         -> cov_transaction9;
      item_collected_port9.write(trans_collected9);
    end
  endtask : collect_transactions9

  // collect_transfer9
  virtual protected task collect_transfer9();
    void'(this.begin_tr(trans_collected9));
    trans_collected9.transfer_data9 = gpio_if9.gpio_pin_out9;
    trans_collected9.monitor_data9  = gpio_if9.gpio_pin_in9;
    trans_collected9.output_enable9 = gpio_if9.n_gpio_pin_oe9;
    if (!last_trans_collected9.compare(trans_collected9))
      `uvm_info("GPIO_MON9", $psprintf("Transfer9 collected9 :\n%s", trans_collected9.sprint()), UVM_MEDIUM)
    last_trans_collected9 = trans_collected9;
    this.end_tr(trans_collected9);
  endtask : collect_transfer9

endclass : gpio_monitor9

`endif // GPIO_MONITOR_SV9

