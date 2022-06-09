/*-------------------------------------------------------------------------
File17 name   : gpio_monitor17.sv
Title17       : GPIO17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV17
`define GPIO_MONITOR_SV17

class gpio_monitor17 extends uvm_monitor;

  // This17 property is the virtual interfaced17 needed for this component to
  // view17 HDL signals17. 
  virtual gpio_if17 gpio_if17;

  gpio_csr_s17 csr_s17;

  // Agent17 Id17
  protected int agent_id17;

  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done both in the monitor17 class and the interface.
  bit checks_enable17 = 1;
  bit coverage_enable17 = 1;

  uvm_analysis_port #(gpio_transfer17) item_collected_port17;

  // The following17 property holds17 the transaction information currently
  // begin captured17 (by the collect_receive_data17 and collect_transmit_data17 methods17).
  protected gpio_transfer17 trans_collected17;
  protected gpio_transfer17 last_trans_collected17;

  // Events17 needed to trigger covergroups17
  protected event cov_transaction17;

  event new_transfer_started17;
  event new_bit_started17;

  // Transfer17 collected17 covergroup
  covergroup cov_trans_cg17 @cov_transaction17;
    option.per_instance = 1;
    bypass_mode17 : coverpoint csr_s17.bypass_mode17;
    direction_mode17 : coverpoint csr_s17.direction_mode17;
    output_enable17 : coverpoint csr_s17.output_enable17;
    trans_data17 : coverpoint trans_collected17.monitor_data17 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg17

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor17)
    `uvm_field_int(agent_id17, UVM_ALL_ON)
    `uvm_field_int(checks_enable17, UVM_ALL_ON)
    `uvm_field_int(coverage_enable17, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg17 = new();
    cov_trans_cg17.set_inst_name("gpio_cov_trans_cg17");
    item_collected_port17 = new("item_collected_port17", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if17)::get(this, "", "gpio_if17", gpio_if17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".gpio_if17"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions17();
    join
  endtask : run_phase

  // collect_transactions17
  virtual protected task collect_transactions17();
      last_trans_collected17 = new();
    forever begin
      @(posedge gpio_if17.pclk17);
      trans_collected17 = new();
      if (m_parent != null)
        trans_collected17.agent17 = m_parent.get_name();
      collect_transfer17();
      if (coverage_enable17)
         -> cov_transaction17;
      item_collected_port17.write(trans_collected17);
    end
  endtask : collect_transactions17

  // collect_transfer17
  virtual protected task collect_transfer17();
    void'(this.begin_tr(trans_collected17));
    trans_collected17.transfer_data17 = gpio_if17.gpio_pin_out17;
    trans_collected17.monitor_data17  = gpio_if17.gpio_pin_in17;
    trans_collected17.output_enable17 = gpio_if17.n_gpio_pin_oe17;
    if (!last_trans_collected17.compare(trans_collected17))
      `uvm_info("GPIO_MON17", $psprintf("Transfer17 collected17 :\n%s", trans_collected17.sprint()), UVM_MEDIUM)
    last_trans_collected17 = trans_collected17;
    this.end_tr(trans_collected17);
  endtask : collect_transfer17

endclass : gpio_monitor17

`endif // GPIO_MONITOR_SV17

