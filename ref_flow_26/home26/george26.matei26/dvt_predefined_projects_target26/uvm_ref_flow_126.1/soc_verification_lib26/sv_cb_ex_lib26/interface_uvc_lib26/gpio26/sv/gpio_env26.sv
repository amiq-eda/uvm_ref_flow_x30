/*-------------------------------------------------------------------------
File26 name   : gpio_env26.sv
Title26       : GPIO26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV26
`define GPIO_ENV_SV26

class gpio_env26 extends uvm_env;

  uvm_analysis_imp#(gpio_csr26, gpio_env26) dut_csr_port_in26;

  uvm_object cobj26;
  gpio_config26 gpio_ve_config26;

  // Virtual Interface26 variable
  virtual interface gpio_if26 gpio_if26;

  // Control26 properties26
  protected int unsigned num_agents26 = 1;

  // The following26 two26 bits are used to control26 whether26 checks26 and coverage26 are
  // done both in the bus monitor26 class and the interface.
  bit intf_checks_enable26 = 1; 
  bit intf_coverage_enable26 = 1;

  // Components of the environment26
  gpio_agent26 agents26[];

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(gpio_env26)
    `uvm_field_int(num_agents26, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable26, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable26, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in26 = new ("dut_csr_port_in26", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents26 = new[num_agents26];

    if(get_config_object("gpio_ve_config26", cobj26))
      if (!$cast(gpio_ve_config26, cobj26))
        `uvm_fatal ("CASTFL26", "Failed26 to cast cobj26 to gpio_ve_config26")
    else
      gpio_ve_config26 = gpio_config26::type_id::create("gpio_ve_config26", this);

    for(int i = 0; i < num_agents26; i++) begin
      $sformat(inst_name, "agents26[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config26.active_passive26);
      agents26[i] = gpio_agent26::type_id::create(inst_name, this);
      agents26[i].agent_id26 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if26)::get(this, "", "gpio_if26", gpio_if26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".gpio_if26"})
endfunction : connect_phase

  // update_vif_enables26
  protected task update_vif_enables26();
    forever begin
      @(intf_checks_enable26 || intf_coverage_enable26);
      gpio_if26.has_checks26 <= intf_checks_enable26;
      gpio_if26.has_coverage <= intf_coverage_enable26;
    end
  endtask : update_vif_enables26

   virtual function void write(input gpio_csr26 cfg );
    for(int i = 0; i < num_agents26; i++) begin
      agents26[i].assign_csr26(cfg.csr_s26);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables26();
    join
  endtask : run_phase

endclass : gpio_env26

`endif // GPIO_ENV_SV26

