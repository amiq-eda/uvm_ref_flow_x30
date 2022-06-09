/*-------------------------------------------------------------------------
File16 name   : gpio_env16.sv
Title16       : GPIO16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV16
`define GPIO_ENV_SV16

class gpio_env16 extends uvm_env;

  uvm_analysis_imp#(gpio_csr16, gpio_env16) dut_csr_port_in16;

  uvm_object cobj16;
  gpio_config16 gpio_ve_config16;

  // Virtual Interface16 variable
  virtual interface gpio_if16 gpio_if16;

  // Control16 properties16
  protected int unsigned num_agents16 = 1;

  // The following16 two16 bits are used to control16 whether16 checks16 and coverage16 are
  // done both in the bus monitor16 class and the interface.
  bit intf_checks_enable16 = 1; 
  bit intf_coverage_enable16 = 1;

  // Components of the environment16
  gpio_agent16 agents16[];

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(gpio_env16)
    `uvm_field_int(num_agents16, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable16, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable16, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in16 = new ("dut_csr_port_in16", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents16 = new[num_agents16];

    if(get_config_object("gpio_ve_config16", cobj16))
      if (!$cast(gpio_ve_config16, cobj16))
        `uvm_fatal ("CASTFL16", "Failed16 to cast cobj16 to gpio_ve_config16")
    else
      gpio_ve_config16 = gpio_config16::type_id::create("gpio_ve_config16", this);

    for(int i = 0; i < num_agents16; i++) begin
      $sformat(inst_name, "agents16[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config16.active_passive16);
      agents16[i] = gpio_agent16::type_id::create(inst_name, this);
      agents16[i].agent_id16 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if16)::get(this, "", "gpio_if16", gpio_if16))
   `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".gpio_if16"})
endfunction : connect_phase

  // update_vif_enables16
  protected task update_vif_enables16();
    forever begin
      @(intf_checks_enable16 || intf_coverage_enable16);
      gpio_if16.has_checks16 <= intf_checks_enable16;
      gpio_if16.has_coverage <= intf_coverage_enable16;
    end
  endtask : update_vif_enables16

   virtual function void write(input gpio_csr16 cfg );
    for(int i = 0; i < num_agents16; i++) begin
      agents16[i].assign_csr16(cfg.csr_s16);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables16();
    join
  endtask : run_phase

endclass : gpio_env16

`endif // GPIO_ENV_SV16

