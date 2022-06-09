/*-------------------------------------------------------------------------
File5 name   : spi_env5.sv
Title5       : SPI5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV5
`define SPI_ENV_SV5

class spi_env5 extends uvm_env;

  uvm_analysis_imp#(spi_csr5, spi_env5) dut_csr_port_in5;

  uvm_object cobj5;
  spi_config5 spi_ve_config5;

  // Virtual Interface5 variable
  virtual interface spi_if5 spi_if5;

  // Control5 properties5
  protected int unsigned num_agents5 = 1;

  // The following5 two5 bits are used to control5 whether5 checks5 and coverage5 are
  // done both in the bus monitor5 class and the interface.
  bit intf_checks_enable5 = 1; 
  bit intf_coverage_enable5 = 1;

  // Components of the environment5
  spi_agent5 agents5[];

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(spi_env5)
    `uvm_field_int(num_agents5, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable5, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable5, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in5 = new ("dut_csr_port_in5", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents5 = new[num_agents5];

    if(get_config_object("spi_ve_config5", cobj5))
      if (!$cast(spi_ve_config5, cobj5))
        `uvm_fatal ("CASTFL5", "Failed5 to cast cobj5 to spi_ve_config5")
    else
      spi_ve_config5 = spi_config5::type_id::create("spi_ve_config5", this);

    for(int i = 0; i < num_agents5; i++) begin
      $sformat(inst_name, "agents5[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config5.active_passive5);
      agents5[i] = spi_agent5::type_id::create(inst_name, this);
      agents5[i].agent_id5 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if5)::get(this, "", "spi_if5", spi_if5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".spi_if5"})
endfunction : connect_phase

  // update_vif_enables5
  protected task update_vif_enables5();
    forever begin
      @(intf_checks_enable5 || intf_coverage_enable5);
      spi_if5.has_checks5 <= intf_checks_enable5;
      spi_if5.has_coverage <= intf_coverage_enable5;
    end
  endtask : update_vif_enables5

   virtual function void write(input spi_csr5 cfg );
    for(int i = 0; i < num_agents5; i++) begin
      agents5[i].assign_csr5(cfg.csr_s5);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables5();
    join
  endtask : run_phase

endclass : spi_env5

`endif // SPI_ENV_SV5

