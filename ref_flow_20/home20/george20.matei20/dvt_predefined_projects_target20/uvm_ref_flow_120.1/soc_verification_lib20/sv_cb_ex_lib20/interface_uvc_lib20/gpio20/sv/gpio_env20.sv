/*-------------------------------------------------------------------------
File20 name   : gpio_env20.sv
Title20       : GPIO20 SystemVerilog20 UVM UVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV20
`define GPIO_ENV_SV20

class gpio_env20 extends uvm_env;

  uvm_analysis_imp#(gpio_csr20, gpio_env20) dut_csr_port_in20;

  uvm_object cobj20;
  gpio_config20 gpio_ve_config20;

  // Virtual Interface20 variable
  virtual interface gpio_if20 gpio_if20;

  // Control20 properties20
  protected int unsigned num_agents20 = 1;

  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done both in the bus monitor20 class and the interface.
  bit intf_checks_enable20 = 1; 
  bit intf_coverage_enable20 = 1;

  // Components of the environment20
  gpio_agent20 agents20[];

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(gpio_env20)
    `uvm_field_int(num_agents20, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable20, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable20, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in20 = new ("dut_csr_port_in20", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents20 = new[num_agents20];

    if(get_config_object("gpio_ve_config20", cobj20))
      if (!$cast(gpio_ve_config20, cobj20))
        `uvm_fatal ("CASTFL20", "Failed20 to cast cobj20 to gpio_ve_config20")
    else
      gpio_ve_config20 = gpio_config20::type_id::create("gpio_ve_config20", this);

    for(int i = 0; i < num_agents20; i++) begin
      $sformat(inst_name, "agents20[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config20.active_passive20);
      agents20[i] = gpio_agent20::type_id::create(inst_name, this);
      agents20[i].agent_id20 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if20)::get(this, "", "gpio_if20", gpio_if20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".gpio_if20"})
endfunction : connect_phase

  // update_vif_enables20
  protected task update_vif_enables20();
    forever begin
      @(intf_checks_enable20 || intf_coverage_enable20);
      gpio_if20.has_checks20 <= intf_checks_enable20;
      gpio_if20.has_coverage <= intf_coverage_enable20;
    end
  endtask : update_vif_enables20

   virtual function void write(input gpio_csr20 cfg );
    for(int i = 0; i < num_agents20; i++) begin
      agents20[i].assign_csr20(cfg.csr_s20);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables20();
    join
  endtask : run_phase

endclass : gpio_env20

`endif // GPIO_ENV_SV20

