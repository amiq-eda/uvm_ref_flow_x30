/*-------------------------------------------------------------------------
File1 name   : gpio_env1.sv
Title1       : GPIO1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV1
`define GPIO_ENV_SV1

class gpio_env1 extends uvm_env;

  uvm_analysis_imp#(gpio_csr1, gpio_env1) dut_csr_port_in1;

  uvm_object cobj1;
  gpio_config1 gpio_ve_config1;

  // Virtual Interface1 variable
  virtual interface gpio_if1 gpio_if1;

  // Control1 properties1
  protected int unsigned num_agents1 = 1;

  // The following1 two1 bits are used to control1 whether1 checks1 and coverage1 are
  // done both in the bus monitor1 class and the interface.
  bit intf_checks_enable1 = 1; 
  bit intf_coverage_enable1 = 1;

  // Components of the environment1
  gpio_agent1 agents1[];

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(gpio_env1)
    `uvm_field_int(num_agents1, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable1, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable1, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in1 = new ("dut_csr_port_in1", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents1 = new[num_agents1];

    if(get_config_object("gpio_ve_config1", cobj1))
      if (!$cast(gpio_ve_config1, cobj1))
        `uvm_fatal ("CASTFL1", "Failed1 to cast cobj1 to gpio_ve_config1")
    else
      gpio_ve_config1 = gpio_config1::type_id::create("gpio_ve_config1", this);

    for(int i = 0; i < num_agents1; i++) begin
      $sformat(inst_name, "agents1[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config1.active_passive1);
      agents1[i] = gpio_agent1::type_id::create(inst_name, this);
      agents1[i].agent_id1 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if1)::get(this, "", "gpio_if1", gpio_if1))
   `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".gpio_if1"})
endfunction : connect_phase

  // update_vif_enables1
  protected task update_vif_enables1();
    forever begin
      @(intf_checks_enable1 || intf_coverage_enable1);
      gpio_if1.has_checks1 <= intf_checks_enable1;
      gpio_if1.has_coverage <= intf_coverage_enable1;
    end
  endtask : update_vif_enables1

   virtual function void write(input gpio_csr1 cfg );
    for(int i = 0; i < num_agents1; i++) begin
      agents1[i].assign_csr1(cfg.csr_s1);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables1();
    join
  endtask : run_phase

endclass : gpio_env1

`endif // GPIO_ENV_SV1

