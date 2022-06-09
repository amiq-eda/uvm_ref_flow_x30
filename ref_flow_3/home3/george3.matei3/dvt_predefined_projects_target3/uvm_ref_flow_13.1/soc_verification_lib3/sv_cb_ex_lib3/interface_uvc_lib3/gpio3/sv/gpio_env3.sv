/*-------------------------------------------------------------------------
File3 name   : gpio_env3.sv
Title3       : GPIO3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV3
`define GPIO_ENV_SV3

class gpio_env3 extends uvm_env;

  uvm_analysis_imp#(gpio_csr3, gpio_env3) dut_csr_port_in3;

  uvm_object cobj3;
  gpio_config3 gpio_ve_config3;

  // Virtual Interface3 variable
  virtual interface gpio_if3 gpio_if3;

  // Control3 properties3
  protected int unsigned num_agents3 = 1;

  // The following3 two3 bits are used to control3 whether3 checks3 and coverage3 are
  // done both in the bus monitor3 class and the interface.
  bit intf_checks_enable3 = 1; 
  bit intf_coverage_enable3 = 1;

  // Components of the environment3
  gpio_agent3 agents3[];

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(gpio_env3)
    `uvm_field_int(num_agents3, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable3, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable3, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in3 = new ("dut_csr_port_in3", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents3 = new[num_agents3];

    if(get_config_object("gpio_ve_config3", cobj3))
      if (!$cast(gpio_ve_config3, cobj3))
        `uvm_fatal ("CASTFL3", "Failed3 to cast cobj3 to gpio_ve_config3")
    else
      gpio_ve_config3 = gpio_config3::type_id::create("gpio_ve_config3", this);

    for(int i = 0; i < num_agents3; i++) begin
      $sformat(inst_name, "agents3[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config3.active_passive3);
      agents3[i] = gpio_agent3::type_id::create(inst_name, this);
      agents3[i].agent_id3 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if3)::get(this, "", "gpio_if3", gpio_if3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".gpio_if3"})
endfunction : connect_phase

  // update_vif_enables3
  protected task update_vif_enables3();
    forever begin
      @(intf_checks_enable3 || intf_coverage_enable3);
      gpio_if3.has_checks3 <= intf_checks_enable3;
      gpio_if3.has_coverage <= intf_coverage_enable3;
    end
  endtask : update_vif_enables3

   virtual function void write(input gpio_csr3 cfg );
    for(int i = 0; i < num_agents3; i++) begin
      agents3[i].assign_csr3(cfg.csr_s3);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables3();
    join
  endtask : run_phase

endclass : gpio_env3

`endif // GPIO_ENV_SV3

