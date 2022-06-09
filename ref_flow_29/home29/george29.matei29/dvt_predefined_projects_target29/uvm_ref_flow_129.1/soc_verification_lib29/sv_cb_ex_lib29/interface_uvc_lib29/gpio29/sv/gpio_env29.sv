/*-------------------------------------------------------------------------
File29 name   : gpio_env29.sv
Title29       : GPIO29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_ENV_SV29
`define GPIO_ENV_SV29

class gpio_env29 extends uvm_env;

  uvm_analysis_imp#(gpio_csr29, gpio_env29) dut_csr_port_in29;

  uvm_object cobj29;
  gpio_config29 gpio_ve_config29;

  // Virtual Interface29 variable
  virtual interface gpio_if29 gpio_if29;

  // Control29 properties29
  protected int unsigned num_agents29 = 1;

  // The following29 two29 bits are used to control29 whether29 checks29 and coverage29 are
  // done both in the bus monitor29 class and the interface.
  bit intf_checks_enable29 = 1; 
  bit intf_coverage_enable29 = 1;

  // Components of the environment29
  gpio_agent29 agents29[];

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(gpio_env29)
    `uvm_field_int(num_agents29, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable29, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable29, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in29 = new ("dut_csr_port_in29", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents29 = new[num_agents29];

    if(get_config_object("gpio_ve_config29", cobj29))
      if (!$cast(gpio_ve_config29, cobj29))
        `uvm_fatal ("CASTFL29", "Failed29 to cast cobj29 to gpio_ve_config29")
    else
      gpio_ve_config29 = gpio_config29::type_id::create("gpio_ve_config29", this);

    for(int i = 0; i < num_agents29; i++) begin
      $sformat(inst_name, "agents29[%0d]", i);
      set_config_int(inst_name, "is_active", gpio_ve_config29.active_passive29);
      agents29[i] = gpio_agent29::type_id::create(inst_name, this);
      agents29[i].agent_id29 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if29)::get(this, "", "gpio_if29", gpio_if29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".gpio_if29"})
endfunction : connect_phase

  // update_vif_enables29
  protected task update_vif_enables29();
    forever begin
      @(intf_checks_enable29 || intf_coverage_enable29);
      gpio_if29.has_checks29 <= intf_checks_enable29;
      gpio_if29.has_coverage <= intf_coverage_enable29;
    end
  endtask : update_vif_enables29

   virtual function void write(input gpio_csr29 cfg );
    for(int i = 0; i < num_agents29; i++) begin
      agents29[i].assign_csr29(cfg.csr_s29);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables29();
    join
  endtask : run_phase

endclass : gpio_env29

`endif // GPIO_ENV_SV29

