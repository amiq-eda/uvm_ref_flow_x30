/*-------------------------------------------------------------------------
File29 name   : gpio_monitor29.sv
Title29       : GPIO29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV29
`define GPIO_MONITOR_SV29

class gpio_monitor29 extends uvm_monitor;

  // This29 property is the virtual interfaced29 needed for this component to
  // view29 HDL signals29. 
  virtual gpio_if29 gpio_if29;

  gpio_csr_s29 csr_s29;

  // Agent29 Id29
  protected int agent_id29;

  // The following29 two29 bits are used to control29 whether29 checks29 and coverage29 are
  // done both in the monitor29 class and the interface.
  bit checks_enable29 = 1;
  bit coverage_enable29 = 1;

  uvm_analysis_port #(gpio_transfer29) item_collected_port29;

  // The following29 property holds29 the transaction information currently
  // begin captured29 (by the collect_receive_data29 and collect_transmit_data29 methods29).
  protected gpio_transfer29 trans_collected29;
  protected gpio_transfer29 last_trans_collected29;

  // Events29 needed to trigger covergroups29
  protected event cov_transaction29;

  event new_transfer_started29;
  event new_bit_started29;

  // Transfer29 collected29 covergroup
  covergroup cov_trans_cg29 @cov_transaction29;
    option.per_instance = 1;
    bypass_mode29 : coverpoint csr_s29.bypass_mode29;
    direction_mode29 : coverpoint csr_s29.direction_mode29;
    output_enable29 : coverpoint csr_s29.output_enable29;
    trans_data29 : coverpoint trans_collected29.monitor_data29 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg29

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor29)
    `uvm_field_int(agent_id29, UVM_ALL_ON)
    `uvm_field_int(checks_enable29, UVM_ALL_ON)
    `uvm_field_int(coverage_enable29, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg29 = new();
    cov_trans_cg29.set_inst_name("gpio_cov_trans_cg29");
    item_collected_port29 = new("item_collected_port29", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if29)::get(this, "", "gpio_if29", gpio_if29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".gpio_if29"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions29();
    join
  endtask : run_phase

  // collect_transactions29
  virtual protected task collect_transactions29();
      last_trans_collected29 = new();
    forever begin
      @(posedge gpio_if29.pclk29);
      trans_collected29 = new();
      if (m_parent != null)
        trans_collected29.agent29 = m_parent.get_name();
      collect_transfer29();
      if (coverage_enable29)
         -> cov_transaction29;
      item_collected_port29.write(trans_collected29);
    end
  endtask : collect_transactions29

  // collect_transfer29
  virtual protected task collect_transfer29();
    void'(this.begin_tr(trans_collected29));
    trans_collected29.transfer_data29 = gpio_if29.gpio_pin_out29;
    trans_collected29.monitor_data29  = gpio_if29.gpio_pin_in29;
    trans_collected29.output_enable29 = gpio_if29.n_gpio_pin_oe29;
    if (!last_trans_collected29.compare(trans_collected29))
      `uvm_info("GPIO_MON29", $psprintf("Transfer29 collected29 :\n%s", trans_collected29.sprint()), UVM_MEDIUM)
    last_trans_collected29 = trans_collected29;
    this.end_tr(trans_collected29);
  endtask : collect_transfer29

endclass : gpio_monitor29

`endif // GPIO_MONITOR_SV29

