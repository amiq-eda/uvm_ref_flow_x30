/*-------------------------------------------------------------------------
File14 name   : gpio_monitor14.sv
Title14       : GPIO14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV14
`define GPIO_MONITOR_SV14

class gpio_monitor14 extends uvm_monitor;

  // This14 property is the virtual interfaced14 needed for this component to
  // view14 HDL signals14. 
  virtual gpio_if14 gpio_if14;

  gpio_csr_s14 csr_s14;

  // Agent14 Id14
  protected int agent_id14;

  // The following14 two14 bits are used to control14 whether14 checks14 and coverage14 are
  // done both in the monitor14 class and the interface.
  bit checks_enable14 = 1;
  bit coverage_enable14 = 1;

  uvm_analysis_port #(gpio_transfer14) item_collected_port14;

  // The following14 property holds14 the transaction information currently
  // begin captured14 (by the collect_receive_data14 and collect_transmit_data14 methods14).
  protected gpio_transfer14 trans_collected14;
  protected gpio_transfer14 last_trans_collected14;

  // Events14 needed to trigger covergroups14
  protected event cov_transaction14;

  event new_transfer_started14;
  event new_bit_started14;

  // Transfer14 collected14 covergroup
  covergroup cov_trans_cg14 @cov_transaction14;
    option.per_instance = 1;
    bypass_mode14 : coverpoint csr_s14.bypass_mode14;
    direction_mode14 : coverpoint csr_s14.direction_mode14;
    output_enable14 : coverpoint csr_s14.output_enable14;
    trans_data14 : coverpoint trans_collected14.monitor_data14 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg14

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor14)
    `uvm_field_int(agent_id14, UVM_ALL_ON)
    `uvm_field_int(checks_enable14, UVM_ALL_ON)
    `uvm_field_int(coverage_enable14, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg14 = new();
    cov_trans_cg14.set_inst_name("gpio_cov_trans_cg14");
    item_collected_port14 = new("item_collected_port14", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if14)::get(this, "", "gpio_if14", gpio_if14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".gpio_if14"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions14();
    join
  endtask : run_phase

  // collect_transactions14
  virtual protected task collect_transactions14();
      last_trans_collected14 = new();
    forever begin
      @(posedge gpio_if14.pclk14);
      trans_collected14 = new();
      if (m_parent != null)
        trans_collected14.agent14 = m_parent.get_name();
      collect_transfer14();
      if (coverage_enable14)
         -> cov_transaction14;
      item_collected_port14.write(trans_collected14);
    end
  endtask : collect_transactions14

  // collect_transfer14
  virtual protected task collect_transfer14();
    void'(this.begin_tr(trans_collected14));
    trans_collected14.transfer_data14 = gpio_if14.gpio_pin_out14;
    trans_collected14.monitor_data14  = gpio_if14.gpio_pin_in14;
    trans_collected14.output_enable14 = gpio_if14.n_gpio_pin_oe14;
    if (!last_trans_collected14.compare(trans_collected14))
      `uvm_info("GPIO_MON14", $psprintf("Transfer14 collected14 :\n%s", trans_collected14.sprint()), UVM_MEDIUM)
    last_trans_collected14 = trans_collected14;
    this.end_tr(trans_collected14);
  endtask : collect_transfer14

endclass : gpio_monitor14

`endif // GPIO_MONITOR_SV14

