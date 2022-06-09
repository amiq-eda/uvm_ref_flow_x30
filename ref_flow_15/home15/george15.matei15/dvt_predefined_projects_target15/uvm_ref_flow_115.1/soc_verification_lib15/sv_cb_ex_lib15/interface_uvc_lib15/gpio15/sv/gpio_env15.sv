/*-------------------------------------------------------------------------
File15 name   : gpio_env15.sv
Title15       : GPIO15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV15
`define GPIO_ENV_SV15

class gpio_env15 extends uvm_env;

  uvm_analysis_imp#(gpio_csr15, gpio_env15) dut_csr_port_in15;

  uvm_object cobj15;
  gpio_config15 gpio_ve_config15;

  // Virtual Interface15 variable
  virtual interface gpio_if15 gpio_if15;

  // Control15 properties15
  protected int unsigned num_agents15 = 1;

  // The following15 two15 bits are used to control15 whether15 checks15 and coverage15 are
  // done both in the bus monitor15 class and the interface.
  bit intf_checks_enable15 = 1; 
  bit intf_coverage_enable15 = 1;

  // Components of the environment15
  gpio_agent15 agents15[];

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(gpio_env15)
    `uvm_field_int(num_agents15, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable15, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable15, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in15 = new ("dut_csr_port_in15", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents15 = new[num_agents15];

    if(get_config_object("gpio_ve_config15", cobj15))
      if (!$cast(gpio_ve_config15, cobj15))
        `uvm_fatal ("CASTFL15", "Failed15 to cast cobj15 to gpio_ve_config15")
    else
      gpio_ve_config15 = gpio_config15::type_id::create("gpio_ve_config15", this);

    for(int i = 0; i < num_agents15; i++) begin
      $sformat(inst_name, "agents15[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config15.active_passive15);
      agents15[i] = gpio_agent15::type_id::create(inst_name, this);
      agents15[i].agent_id15 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if15)::get(this, "", "gpio_if15", gpio_if15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".gpio_if15"})
endfunction : connect_phase

  // update_vif_enables15
  protected task update_vif_enables15();
    forever begin
      @(intf_checks_enable15 || intf_coverage_enable15);
      gpio_if15.has_checks15 <= intf_checks_enable15;
      gpio_if15.has_coverage <= intf_coverage_enable15;
    end
  endtask : update_vif_enables15

   virtual function void write(input gpio_csr15 cfg );
    for(int i = 0; i < num_agents15; i++) begin
      agents15[i].assign_csr15(cfg.csr_s15);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables15();
    join
  endtask : run_phase

endclass : gpio_env15

`endif // GPIO_ENV_SV15

