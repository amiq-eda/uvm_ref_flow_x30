/*-------------------------------------------------------------------------
File19 name   : gpio_monitor19.sv
Title19       : GPIO19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV19
`define GPIO_MONITOR_SV19

class gpio_monitor19 extends uvm_monitor;

  // This19 property is the virtual interfaced19 needed for this component to
  // view19 HDL signals19. 
  virtual gpio_if19 gpio_if19;

  gpio_csr_s19 csr_s19;

  // Agent19 Id19
  protected int agent_id19;

  // The following19 two19 bits are used to control19 whether19 checks19 and coverage19 are
  // done both in the monitor19 class and the interface.
  bit checks_enable19 = 1;
  bit coverage_enable19 = 1;

  uvm_analysis_port #(gpio_transfer19) item_collected_port19;

  // The following19 property holds19 the transaction information currently
  // begin captured19 (by the collect_receive_data19 and collect_transmit_data19 methods19).
  protected gpio_transfer19 trans_collected19;
  protected gpio_transfer19 last_trans_collected19;

  // Events19 needed to trigger covergroups19
  protected event cov_transaction19;

  event new_transfer_started19;
  event new_bit_started19;

  // Transfer19 collected19 covergroup
  covergroup cov_trans_cg19 @cov_transaction19;
    option.per_instance = 1;
    bypass_mode19 : coverpoint csr_s19.bypass_mode19;
    direction_mode19 : coverpoint csr_s19.direction_mode19;
    output_enable19 : coverpoint csr_s19.output_enable19;
    trans_data19 : coverpoint trans_collected19.monitor_data19 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg19

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor19)
    `uvm_field_int(agent_id19, UVM_ALL_ON)
    `uvm_field_int(checks_enable19, UVM_ALL_ON)
    `uvm_field_int(coverage_enable19, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg19 = new();
    cov_trans_cg19.set_inst_name("gpio_cov_trans_cg19");
    item_collected_port19 = new("item_collected_port19", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if19)::get(this, "", "gpio_if19", gpio_if19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".gpio_if19"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions19();
    join
  endtask : run_phase

  // collect_transactions19
  virtual protected task collect_transactions19();
      last_trans_collected19 = new();
    forever begin
      @(posedge gpio_if19.pclk19);
      trans_collected19 = new();
      if (m_parent != null)
        trans_collected19.agent19 = m_parent.get_name();
      collect_transfer19();
      if (coverage_enable19)
         -> cov_transaction19;
      item_collected_port19.write(trans_collected19);
    end
  endtask : collect_transactions19

  // collect_transfer19
  virtual protected task collect_transfer19();
    void'(this.begin_tr(trans_collected19));
    trans_collected19.transfer_data19 = gpio_if19.gpio_pin_out19;
    trans_collected19.monitor_data19  = gpio_if19.gpio_pin_in19;
    trans_collected19.output_enable19 = gpio_if19.n_gpio_pin_oe19;
    if (!last_trans_collected19.compare(trans_collected19))
      `uvm_info("GPIO_MON19", $psprintf("Transfer19 collected19 :\n%s", trans_collected19.sprint()), UVM_MEDIUM)
    last_trans_collected19 = trans_collected19;
    this.end_tr(trans_collected19);
  endtask : collect_transfer19

endclass : gpio_monitor19

`endif // GPIO_MONITOR_SV19

