/*-------------------------------------------------------------------------
File4 name   : gpio_env4.sv
Title4       : GPIO4 SystemVerilog4 UVM UVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV4
`define GPIO_ENV_SV4

class gpio_env4 extends uvm_env;

  uvm_analysis_imp#(gpio_csr4, gpio_env4) dut_csr_port_in4;

  uvm_object cobj4;
  gpio_config4 gpio_ve_config4;

  // Virtual Interface4 variable
  virtual interface gpio_if4 gpio_if4;

  // Control4 properties4
  protected int unsigned num_agents4 = 1;

  // The following4 two4 bits are used to control4 whether4 checks4 and coverage4 are
  // done both in the bus monitor4 class and the interface.
  bit intf_checks_enable4 = 1; 
  bit intf_coverage_enable4 = 1;

  // Components of the environment4
  gpio_agent4 agents4[];

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(gpio_env4)
    `uvm_field_int(num_agents4, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable4, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable4, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in4 = new ("dut_csr_port_in4", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents4 = new[num_agents4];

    if(get_config_object("gpio_ve_config4", cobj4))
      if (!$cast(gpio_ve_config4, cobj4))
        `uvm_fatal ("CASTFL4", "Failed4 to cast cobj4 to gpio_ve_config4")
    else
      gpio_ve_config4 = gpio_config4::type_id::create("gpio_ve_config4", this);

    for(int i = 0; i < num_agents4; i++) begin
      $sformat(inst_name, "agents4[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config4.active_passive4);
      agents4[i] = gpio_agent4::type_id::create(inst_name, this);
      agents4[i].agent_id4 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if4)::get(this, "", "gpio_if4", gpio_if4))
   `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".gpio_if4"})
endfunction : connect_phase

  // update_vif_enables4
  protected task update_vif_enables4();
    forever begin
      @(intf_checks_enable4 || intf_coverage_enable4);
      gpio_if4.has_checks4 <= intf_checks_enable4;
      gpio_if4.has_coverage <= intf_coverage_enable4;
    end
  endtask : update_vif_enables4

   virtual function void write(input gpio_csr4 cfg );
    for(int i = 0; i < num_agents4; i++) begin
      agents4[i].assign_csr4(cfg.csr_s4);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables4();
    join
  endtask : run_phase

endclass : gpio_env4

`endif // GPIO_ENV_SV4

