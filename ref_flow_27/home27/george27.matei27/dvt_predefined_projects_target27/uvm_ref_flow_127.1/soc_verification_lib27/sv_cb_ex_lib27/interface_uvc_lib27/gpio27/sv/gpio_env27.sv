/*-------------------------------------------------------------------------
File27 name   : gpio_env27.sv
Title27       : GPIO27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV27
`define GPIO_ENV_SV27

class gpio_env27 extends uvm_env;

  uvm_analysis_imp#(gpio_csr27, gpio_env27) dut_csr_port_in27;

  uvm_object cobj27;
  gpio_config27 gpio_ve_config27;

  // Virtual Interface27 variable
  virtual interface gpio_if27 gpio_if27;

  // Control27 properties27
  protected int unsigned num_agents27 = 1;

  // The following27 two27 bits are used to control27 whether27 checks27 and coverage27 are
  // done both in the bus monitor27 class and the interface.
  bit intf_checks_enable27 = 1; 
  bit intf_coverage_enable27 = 1;

  // Components of the environment27
  gpio_agent27 agents27[];

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(gpio_env27)
    `uvm_field_int(num_agents27, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable27, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable27, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in27 = new ("dut_csr_port_in27", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents27 = new[num_agents27];

    if(get_config_object("gpio_ve_config27", cobj27))
      if (!$cast(gpio_ve_config27, cobj27))
        `uvm_fatal ("CASTFL27", "Failed27 to cast cobj27 to gpio_ve_config27")
    else
      gpio_ve_config27 = gpio_config27::type_id::create("gpio_ve_config27", this);

    for(int i = 0; i < num_agents27; i++) begin
      $sformat(inst_name, "agents27[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config27.active_passive27);
      agents27[i] = gpio_agent27::type_id::create(inst_name, this);
      agents27[i].agent_id27 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if27)::get(this, "", "gpio_if27", gpio_if27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".gpio_if27"})
endfunction : connect_phase

  // update_vif_enables27
  protected task update_vif_enables27();
    forever begin
      @(intf_checks_enable27 || intf_coverage_enable27);
      gpio_if27.has_checks27 <= intf_checks_enable27;
      gpio_if27.has_coverage <= intf_coverage_enable27;
    end
  endtask : update_vif_enables27

   virtual function void write(input gpio_csr27 cfg );
    for(int i = 0; i < num_agents27; i++) begin
      agents27[i].assign_csr27(cfg.csr_s27);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables27();
    join
  endtask : run_phase

endclass : gpio_env27

`endif // GPIO_ENV_SV27

