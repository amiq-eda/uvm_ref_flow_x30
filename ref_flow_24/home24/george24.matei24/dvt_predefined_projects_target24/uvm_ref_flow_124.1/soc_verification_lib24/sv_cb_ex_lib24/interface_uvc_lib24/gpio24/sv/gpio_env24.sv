/*-------------------------------------------------------------------------
File24 name   : gpio_env24.sv
Title24       : GPIO24 SystemVerilog24 UVM UVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV24
`define GPIO_ENV_SV24

class gpio_env24 extends uvm_env;

  uvm_analysis_imp#(gpio_csr24, gpio_env24) dut_csr_port_in24;

  uvm_object cobj24;
  gpio_config24 gpio_ve_config24;

  // Virtual Interface24 variable
  virtual interface gpio_if24 gpio_if24;

  // Control24 properties24
  protected int unsigned num_agents24 = 1;

  // The following24 two24 bits are used to control24 whether24 checks24 and coverage24 are
  // done both in the bus monitor24 class and the interface.
  bit intf_checks_enable24 = 1; 
  bit intf_coverage_enable24 = 1;

  // Components of the environment24
  gpio_agent24 agents24[];

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(gpio_env24)
    `uvm_field_int(num_agents24, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable24, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable24, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in24 = new ("dut_csr_port_in24", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents24 = new[num_agents24];

    if(get_config_object("gpio_ve_config24", cobj24))
      if (!$cast(gpio_ve_config24, cobj24))
        `uvm_fatal ("CASTFL24", "Failed24 to cast cobj24 to gpio_ve_config24")
    else
      gpio_ve_config24 = gpio_config24::type_id::create("gpio_ve_config24", this);

    for(int i = 0; i < num_agents24; i++) begin
      $sformat(inst_name, "agents24[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config24.active_passive24);
      agents24[i] = gpio_agent24::type_id::create(inst_name, this);
      agents24[i].agent_id24 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if24)::get(this, "", "gpio_if24", gpio_if24))
   `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".gpio_if24"})
endfunction : connect_phase

  // update_vif_enables24
  protected task update_vif_enables24();
    forever begin
      @(intf_checks_enable24 || intf_coverage_enable24);
      gpio_if24.has_checks24 <= intf_checks_enable24;
      gpio_if24.has_coverage <= intf_coverage_enable24;
    end
  endtask : update_vif_enables24

   virtual function void write(input gpio_csr24 cfg );
    for(int i = 0; i < num_agents24; i++) begin
      agents24[i].assign_csr24(cfg.csr_s24);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables24();
    join
  endtask : run_phase

endclass : gpio_env24

`endif // GPIO_ENV_SV24

