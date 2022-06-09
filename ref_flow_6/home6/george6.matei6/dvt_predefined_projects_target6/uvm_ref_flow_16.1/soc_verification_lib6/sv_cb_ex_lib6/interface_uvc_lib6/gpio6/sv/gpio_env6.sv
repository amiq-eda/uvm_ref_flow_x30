/*-------------------------------------------------------------------------
File6 name   : gpio_env6.sv
Title6       : GPIO6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV6
`define GPIO_ENV_SV6

class gpio_env6 extends uvm_env;

  uvm_analysis_imp#(gpio_csr6, gpio_env6) dut_csr_port_in6;

  uvm_object cobj6;
  gpio_config6 gpio_ve_config6;

  // Virtual Interface6 variable
  virtual interface gpio_if6 gpio_if6;

  // Control6 properties6
  protected int unsigned num_agents6 = 1;

  // The following6 two6 bits are used to control6 whether6 checks6 and coverage6 are
  // done both in the bus monitor6 class and the interface.
  bit intf_checks_enable6 = 1; 
  bit intf_coverage_enable6 = 1;

  // Components of the environment6
  gpio_agent6 agents6[];

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(gpio_env6)
    `uvm_field_int(num_agents6, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable6, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable6, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in6 = new ("dut_csr_port_in6", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents6 = new[num_agents6];

    if(get_config_object("gpio_ve_config6", cobj6))
      if (!$cast(gpio_ve_config6, cobj6))
        `uvm_fatal ("CASTFL6", "Failed6 to cast cobj6 to gpio_ve_config6")
    else
      gpio_ve_config6 = gpio_config6::type_id::create("gpio_ve_config6", this);

    for(int i = 0; i < num_agents6; i++) begin
      $sformat(inst_name, "agents6[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config6.active_passive6);
      agents6[i] = gpio_agent6::type_id::create(inst_name, this);
      agents6[i].agent_id6 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if6)::get(this, "", "gpio_if6", gpio_if6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".gpio_if6"})
endfunction : connect_phase

  // update_vif_enables6
  protected task update_vif_enables6();
    forever begin
      @(intf_checks_enable6 || intf_coverage_enable6);
      gpio_if6.has_checks6 <= intf_checks_enable6;
      gpio_if6.has_coverage <= intf_coverage_enable6;
    end
  endtask : update_vif_enables6

   virtual function void write(input gpio_csr6 cfg );
    for(int i = 0; i < num_agents6; i++) begin
      agents6[i].assign_csr6(cfg.csr_s6);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables6();
    join
  endtask : run_phase

endclass : gpio_env6

`endif // GPIO_ENV_SV6

