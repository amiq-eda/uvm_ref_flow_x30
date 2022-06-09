/*-------------------------------------------------------------------------
File10 name   : spi_env10.sv
Title10       : SPI10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV10
`define SPI_ENV_SV10

class spi_env10 extends uvm_env;

  uvm_analysis_imp#(spi_csr10, spi_env10) dut_csr_port_in10;

  uvm_object cobj10;
  spi_config10 spi_ve_config10;

  // Virtual Interface10 variable
  virtual interface spi_if10 spi_if10;

  // Control10 properties10
  protected int unsigned num_agents10 = 1;

  // The following10 two10 bits are used to control10 whether10 checks10 and coverage10 are
  // done both in the bus monitor10 class and the interface.
  bit intf_checks_enable10 = 1; 
  bit intf_coverage_enable10 = 1;

  // Components of the environment10
  spi_agent10 agents10[];

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(spi_env10)
    `uvm_field_int(num_agents10, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable10, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable10, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in10 = new ("dut_csr_port_in10", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents10 = new[num_agents10];

    if(get_config_object("spi_ve_config10", cobj10))
      if (!$cast(spi_ve_config10, cobj10))
        `uvm_fatal ("CASTFL10", "Failed10 to cast cobj10 to spi_ve_config10")
    else
      spi_ve_config10 = spi_config10::type_id::create("spi_ve_config10", this);

    for(int i = 0; i < num_agents10; i++) begin
      $sformat(inst_name, "agents10[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config10.active_passive10);
      agents10[i] = spi_agent10::type_id::create(inst_name, this);
      agents10[i].agent_id10 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if10)::get(this, "", "spi_if10", spi_if10))
   `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".spi_if10"})
endfunction : connect_phase

  // update_vif_enables10
  protected task update_vif_enables10();
    forever begin
      @(intf_checks_enable10 || intf_coverage_enable10);
      spi_if10.has_checks10 <= intf_checks_enable10;
      spi_if10.has_coverage <= intf_coverage_enable10;
    end
  endtask : update_vif_enables10

   virtual function void write(input spi_csr10 cfg );
    for(int i = 0; i < num_agents10; i++) begin
      agents10[i].assign_csr10(cfg.csr_s10);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables10();
    join
  endtask : run_phase

endclass : spi_env10

`endif // SPI_ENV_SV10

