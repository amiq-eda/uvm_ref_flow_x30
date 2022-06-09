/*-------------------------------------------------------------------------
File2 name   : spi_env2.sv
Title2       : SPI2 SystemVerilog2 UVM UVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV2
`define SPI_ENV_SV2

class spi_env2 extends uvm_env;

  uvm_analysis_imp#(spi_csr2, spi_env2) dut_csr_port_in2;

  uvm_object cobj2;
  spi_config2 spi_ve_config2;

  // Virtual Interface2 variable
  virtual interface spi_if2 spi_if2;

  // Control2 properties2
  protected int unsigned num_agents2 = 1;

  // The following2 two2 bits are used to control2 whether2 checks2 and coverage2 are
  // done both in the bus monitor2 class and the interface.
  bit intf_checks_enable2 = 1; 
  bit intf_coverage_enable2 = 1;

  // Components of the environment2
  spi_agent2 agents2[];

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(spi_env2)
    `uvm_field_int(num_agents2, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable2, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable2, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in2 = new ("dut_csr_port_in2", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents2 = new[num_agents2];

    if(get_config_object("spi_ve_config2", cobj2))
      if (!$cast(spi_ve_config2, cobj2))
        `uvm_fatal ("CASTFL2", "Failed2 to cast cobj2 to spi_ve_config2")
    else
      spi_ve_config2 = spi_config2::type_id::create("spi_ve_config2", this);

    for(int i = 0; i < num_agents2; i++) begin
      $sformat(inst_name, "agents2[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config2.active_passive2);
      agents2[i] = spi_agent2::type_id::create(inst_name, this);
      agents2[i].agent_id2 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if2)::get(this, "", "spi_if2", spi_if2))
   `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".spi_if2"})
endfunction : connect_phase

  // update_vif_enables2
  protected task update_vif_enables2();
    forever begin
      @(intf_checks_enable2 || intf_coverage_enable2);
      spi_if2.has_checks2 <= intf_checks_enable2;
      spi_if2.has_coverage <= intf_coverage_enable2;
    end
  endtask : update_vif_enables2

   virtual function void write(input spi_csr2 cfg );
    for(int i = 0; i < num_agents2; i++) begin
      agents2[i].assign_csr2(cfg.csr_s2);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables2();
    join
  endtask : run_phase

endclass : spi_env2

`endif // SPI_ENV_SV2

