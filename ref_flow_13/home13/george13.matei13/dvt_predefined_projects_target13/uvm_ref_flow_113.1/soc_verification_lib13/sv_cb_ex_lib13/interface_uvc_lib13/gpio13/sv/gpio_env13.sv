/*-------------------------------------------------------------------------
File13 name   : gpio_env13.sv
Title13       : GPIO13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV13
`define GPIO_ENV_SV13

class gpio_env13 extends uvm_env;

  uvm_analysis_imp#(gpio_csr13, gpio_env13) dut_csr_port_in13;

  uvm_object cobj13;
  gpio_config13 gpio_ve_config13;

  // Virtual Interface13 variable
  virtual interface gpio_if13 gpio_if13;

  // Control13 properties13
  protected int unsigned num_agents13 = 1;

  // The following13 two13 bits are used to control13 whether13 checks13 and coverage13 are
  // done both in the bus monitor13 class and the interface.
  bit intf_checks_enable13 = 1; 
  bit intf_coverage_enable13 = 1;

  // Components of the environment13
  gpio_agent13 agents13[];

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(gpio_env13)
    `uvm_field_int(num_agents13, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable13, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable13, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in13 = new ("dut_csr_port_in13", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents13 = new[num_agents13];

    if(get_config_object("gpio_ve_config13", cobj13))
      if (!$cast(gpio_ve_config13, cobj13))
        `uvm_fatal ("CASTFL13", "Failed13 to cast cobj13 to gpio_ve_config13")
    else
      gpio_ve_config13 = gpio_config13::type_id::create("gpio_ve_config13", this);

    for(int i = 0; i < num_agents13; i++) begin
      $sformat(inst_name, "agents13[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config13.active_passive13);
      agents13[i] = gpio_agent13::type_id::create(inst_name, this);
      agents13[i].agent_id13 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if13)::get(this, "", "gpio_if13", gpio_if13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".gpio_if13"})
endfunction : connect_phase

  // update_vif_enables13
  protected task update_vif_enables13();
    forever begin
      @(intf_checks_enable13 || intf_coverage_enable13);
      gpio_if13.has_checks13 <= intf_checks_enable13;
      gpio_if13.has_coverage <= intf_coverage_enable13;
    end
  endtask : update_vif_enables13

   virtual function void write(input gpio_csr13 cfg );
    for(int i = 0; i < num_agents13; i++) begin
      agents13[i].assign_csr13(cfg.csr_s13);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables13();
    join
  endtask : run_phase

endclass : gpio_env13

`endif // GPIO_ENV_SV13

