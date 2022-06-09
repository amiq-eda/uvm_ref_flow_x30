/*-------------------------------------------------------------------------
File7 name   : gpio_env7.sv
Title7       : GPIO7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV7
`define GPIO_ENV_SV7

class gpio_env7 extends uvm_env;

  uvm_analysis_imp#(gpio_csr7, gpio_env7) dut_csr_port_in7;

  uvm_object cobj7;
  gpio_config7 gpio_ve_config7;

  // Virtual Interface7 variable
  virtual interface gpio_if7 gpio_if7;

  // Control7 properties7
  protected int unsigned num_agents7 = 1;

  // The following7 two7 bits are used to control7 whether7 checks7 and coverage7 are
  // done both in the bus monitor7 class and the interface.
  bit intf_checks_enable7 = 1; 
  bit intf_coverage_enable7 = 1;

  // Components of the environment7
  gpio_agent7 agents7[];

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(gpio_env7)
    `uvm_field_int(num_agents7, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable7, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable7, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in7 = new ("dut_csr_port_in7", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents7 = new[num_agents7];

    if(get_config_object("gpio_ve_config7", cobj7))
      if (!$cast(gpio_ve_config7, cobj7))
        `uvm_fatal ("CASTFL7", "Failed7 to cast cobj7 to gpio_ve_config7")
    else
      gpio_ve_config7 = gpio_config7::type_id::create("gpio_ve_config7", this);

    for(int i = 0; i < num_agents7; i++) begin
      $sformat(inst_name, "agents7[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config7.active_passive7);
      agents7[i] = gpio_agent7::type_id::create(inst_name, this);
      agents7[i].agent_id7 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if7)::get(this, "", "gpio_if7", gpio_if7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".gpio_if7"})
endfunction : connect_phase

  // update_vif_enables7
  protected task update_vif_enables7();
    forever begin
      @(intf_checks_enable7 || intf_coverage_enable7);
      gpio_if7.has_checks7 <= intf_checks_enable7;
      gpio_if7.has_coverage <= intf_coverage_enable7;
    end
  endtask : update_vif_enables7

   virtual function void write(input gpio_csr7 cfg );
    for(int i = 0; i < num_agents7; i++) begin
      agents7[i].assign_csr7(cfg.csr_s7);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables7();
    join
  endtask : run_phase

endclass : gpio_env7

`endif // GPIO_ENV_SV7

