/*-------------------------------------------------------------------------
File25 name   : spi_env25.sv
Title25       : SPI25 SystemVerilog25 UVM UVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV25
`define SPI_ENV_SV25

class spi_env25 extends uvm_env;

  uvm_analysis_imp#(spi_csr25, spi_env25) dut_csr_port_in25;

  uvm_object cobj25;
  spi_config25 spi_ve_config25;

  // Virtual Interface25 variable
  virtual interface spi_if25 spi_if25;

  // Control25 properties25
  protected int unsigned num_agents25 = 1;

  // The following25 two25 bits are used to control25 whether25 checks25 and coverage25 are
  // done both in the bus monitor25 class and the interface.
  bit intf_checks_enable25 = 1; 
  bit intf_coverage_enable25 = 1;

  // Components of the environment25
  spi_agent25 agents25[];

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(spi_env25)
    `uvm_field_int(num_agents25, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable25, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable25, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in25 = new ("dut_csr_port_in25", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents25 = new[num_agents25];

    if(get_config_object("spi_ve_config25", cobj25))
      if (!$cast(spi_ve_config25, cobj25))
        `uvm_fatal ("CASTFL25", "Failed25 to cast cobj25 to spi_ve_config25")
    else
      spi_ve_config25 = spi_config25::type_id::create("spi_ve_config25", this);

    for(int i = 0; i < num_agents25; i++) begin
      $sformat(inst_name, "agents25[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config25.active_passive25);
      agents25[i] = spi_agent25::type_id::create(inst_name, this);
      agents25[i].agent_id25 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if25)::get(this, "", "spi_if25", spi_if25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".spi_if25"})
endfunction : connect_phase

  // update_vif_enables25
  protected task update_vif_enables25();
    forever begin
      @(intf_checks_enable25 || intf_coverage_enable25);
      spi_if25.has_checks25 <= intf_checks_enable25;
      spi_if25.has_coverage <= intf_coverage_enable25;
    end
  endtask : update_vif_enables25

   virtual function void write(input spi_csr25 cfg );
    for(int i = 0; i < num_agents25; i++) begin
      agents25[i].assign_csr25(cfg.csr_s25);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables25();
    join
  endtask : run_phase

endclass : spi_env25

`endif // SPI_ENV_SV25

