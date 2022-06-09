/*-------------------------------------------------------------------------
File19 name   : gpio_env19.sv
Title19       : GPIO19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV19
`define GPIO_ENV_SV19

class gpio_env19 extends uvm_env;

  uvm_analysis_imp#(gpio_csr19, gpio_env19) dut_csr_port_in19;

  uvm_object cobj19;
  gpio_config19 gpio_ve_config19;

  // Virtual Interface19 variable
  virtual interface gpio_if19 gpio_if19;

  // Control19 properties19
  protected int unsigned num_agents19 = 1;

  // The following19 two19 bits are used to control19 whether19 checks19 and coverage19 are
  // done both in the bus monitor19 class and the interface.
  bit intf_checks_enable19 = 1; 
  bit intf_coverage_enable19 = 1;

  // Components of the environment19
  gpio_agent19 agents19[];

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(gpio_env19)
    `uvm_field_int(num_agents19, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable19, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable19, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in19 = new ("dut_csr_port_in19", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents19 = new[num_agents19];

    if(get_config_object("gpio_ve_config19", cobj19))
      if (!$cast(gpio_ve_config19, cobj19))
        `uvm_fatal ("CASTFL19", "Failed19 to cast cobj19 to gpio_ve_config19")
    else
      gpio_ve_config19 = gpio_config19::type_id::create("gpio_ve_config19", this);

    for(int i = 0; i < num_agents19; i++) begin
      $sformat(inst_name, "agents19[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config19.active_passive19);
      agents19[i] = gpio_agent19::type_id::create(inst_name, this);
      agents19[i].agent_id19 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if19)::get(this, "", "gpio_if19", gpio_if19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".gpio_if19"})
endfunction : connect_phase

  // update_vif_enables19
  protected task update_vif_enables19();
    forever begin
      @(intf_checks_enable19 || intf_coverage_enable19);
      gpio_if19.has_checks19 <= intf_checks_enable19;
      gpio_if19.has_coverage <= intf_coverage_enable19;
    end
  endtask : update_vif_enables19

   virtual function void write(input gpio_csr19 cfg );
    for(int i = 0; i < num_agents19; i++) begin
      agents19[i].assign_csr19(cfg.csr_s19);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables19();
    join
  endtask : run_phase

endclass : gpio_env19

`endif // GPIO_ENV_SV19

