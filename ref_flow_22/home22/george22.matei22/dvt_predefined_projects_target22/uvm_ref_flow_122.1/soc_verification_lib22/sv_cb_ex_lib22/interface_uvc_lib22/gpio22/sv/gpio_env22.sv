/*-------------------------------------------------------------------------
File22 name   : gpio_env22.sv
Title22       : GPIO22 SystemVerilog22 UVM UVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV22
`define GPIO_ENV_SV22

class gpio_env22 extends uvm_env;

  uvm_analysis_imp#(gpio_csr22, gpio_env22) dut_csr_port_in22;

  uvm_object cobj22;
  gpio_config22 gpio_ve_config22;

  // Virtual Interface22 variable
  virtual interface gpio_if22 gpio_if22;

  // Control22 properties22
  protected int unsigned num_agents22 = 1;

  // The following22 two22 bits are used to control22 whether22 checks22 and coverage22 are
  // done both in the bus monitor22 class and the interface.
  bit intf_checks_enable22 = 1; 
  bit intf_coverage_enable22 = 1;

  // Components of the environment22
  gpio_agent22 agents22[];

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(gpio_env22)
    `uvm_field_int(num_agents22, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable22, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable22, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in22 = new ("dut_csr_port_in22", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents22 = new[num_agents22];

    if(get_config_object("gpio_ve_config22", cobj22))
      if (!$cast(gpio_ve_config22, cobj22))
        `uvm_fatal ("CASTFL22", "Failed22 to cast cobj22 to gpio_ve_config22")
    else
      gpio_ve_config22 = gpio_config22::type_id::create("gpio_ve_config22", this);

    for(int i = 0; i < num_agents22; i++) begin
      $sformat(inst_name, "agents22[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config22.active_passive22);
      agents22[i] = gpio_agent22::type_id::create(inst_name, this);
      agents22[i].agent_id22 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if22)::get(this, "", "gpio_if22", gpio_if22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".gpio_if22"})
endfunction : connect_phase

  // update_vif_enables22
  protected task update_vif_enables22();
    forever begin
      @(intf_checks_enable22 || intf_coverage_enable22);
      gpio_if22.has_checks22 <= intf_checks_enable22;
      gpio_if22.has_coverage <= intf_coverage_enable22;
    end
  endtask : update_vif_enables22

   virtual function void write(input gpio_csr22 cfg );
    for(int i = 0; i < num_agents22; i++) begin
      agents22[i].assign_csr22(cfg.csr_s22);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables22();
    join
  endtask : run_phase

endclass : gpio_env22

`endif // GPIO_ENV_SV22

