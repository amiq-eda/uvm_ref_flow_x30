/*-------------------------------------------------------------------------
File30 name   : gpio_env30.sv
Title30       : GPIO30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV30
`define GPIO_ENV_SV30

class gpio_env30 extends uvm_env;

  uvm_analysis_imp#(gpio_csr30, gpio_env30) dut_csr_port_in30;

  uvm_object cobj30;
  gpio_config30 gpio_ve_config30;

  // Virtual Interface30 variable
  virtual interface gpio_if30 gpio_if30;

  // Control30 properties30
  protected int unsigned num_agents30 = 1;

  // The following30 two30 bits are used to control30 whether30 checks30 and coverage30 are
  // done both in the bus monitor30 class and the interface.
  bit intf_checks_enable30 = 1; 
  bit intf_coverage_enable30 = 1;

  // Components of the environment30
  gpio_agent30 agents30[];

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(gpio_env30)
    `uvm_field_int(num_agents30, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable30, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable30, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in30 = new ("dut_csr_port_in30", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents30 = new[num_agents30];

    if(get_config_object("gpio_ve_config30", cobj30))
      if (!$cast(gpio_ve_config30, cobj30))
        `uvm_fatal ("CASTFL30", "Failed30 to cast cobj30 to gpio_ve_config30")
    else
      gpio_ve_config30 = gpio_config30::type_id::create("gpio_ve_config30", this);

    for(int i = 0; i < num_agents30; i++) begin
      $sformat(inst_name, "agents30[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config30.active_passive30);
      agents30[i] = gpio_agent30::type_id::create(inst_name, this);
      agents30[i].agent_id30 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if30)::get(this, "", "gpio_if30", gpio_if30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".gpio_if30"})
endfunction : connect_phase

  // update_vif_enables30
  protected task update_vif_enables30();
    forever begin
      @(intf_checks_enable30 || intf_coverage_enable30);
      gpio_if30.has_checks30 <= intf_checks_enable30;
      gpio_if30.has_coverage <= intf_coverage_enable30;
    end
  endtask : update_vif_enables30

   virtual function void write(input gpio_csr30 cfg );
    for(int i = 0; i < num_agents30; i++) begin
      agents30[i].assign_csr30(cfg.csr_s30);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables30();
    join
  endtask : run_phase

endclass : gpio_env30

`endif // GPIO_ENV_SV30

