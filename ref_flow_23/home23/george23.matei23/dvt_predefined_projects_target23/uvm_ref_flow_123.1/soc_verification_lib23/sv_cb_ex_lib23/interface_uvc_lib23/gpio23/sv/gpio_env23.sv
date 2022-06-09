/*-------------------------------------------------------------------------
File23 name   : gpio_env23.sv
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


`ifndef GPIO_ENV_SV23
`define GPIO_ENV_SV23

class gpio_env23 extends uvm_env;

  uvm_analysis_imp#(gpio_csr23, gpio_env23) dut_csr_port_in23;

  uvm_object cobj23;
  gpio_config23 gpio_ve_config23;

  // Virtual Interface23 variable
  virtual interface gpio_if23 gpio_if23;

  // Control23 properties23
  protected int unsigned num_agents23 = 1;

  // The following23 two23 bits are used to control23 whether23 checks23 and coverage23 are
  // done both in the bus monitor23 class and the interface.
  bit intf_checks_enable23 = 1; 
  bit intf_coverage_enable23 = 1;

  // Components of the environment23
  gpio_agent23 agents23[];

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(gpio_env23)
    `uvm_field_int(num_agents23, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable23, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable23, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in23 = new ("dut_csr_port_in23", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents23 = new[num_agents23];

    if(get_config_object("gpio_ve_config23", cobj23))
      if (!$cast(gpio_ve_config23, cobj23))
        `uvm_fatal ("CASTFL23", "Failed23 to cast cobj23 to gpio_ve_config23")
    else
      gpio_ve_config23 = gpio_config23::type_id::create("gpio_ve_config23", this);

    for(int i = 0; i < num_agents23; i++) begin
      $sformat(inst_name, "agents23[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config23.active_passive23);
      agents23[i] = gpio_agent23::type_id::create(inst_name, this);
      agents23[i].agent_id23 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if23)::get(this, "", "gpio_if23", gpio_if23))
   `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".gpio_if23"})
endfunction : connect_phase

  // update_vif_enables23
  protected task update_vif_enables23();
    forever begin
      @(intf_checks_enable23 || intf_coverage_enable23);
      gpio_if23.has_checks23 <= intf_checks_enable23;
      gpio_if23.has_coverage <= intf_coverage_enable23;
    end
  endtask : update_vif_enables23

   virtual function void write(input gpio_csr23 cfg );
    for(int i = 0; i < num_agents23; i++) begin
      agents23[i].assign_csr23(cfg.csr_s23);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables23();
    join
  endtask : run_phase

endclass : gpio_env23

`endif // GPIO_ENV_SV23

