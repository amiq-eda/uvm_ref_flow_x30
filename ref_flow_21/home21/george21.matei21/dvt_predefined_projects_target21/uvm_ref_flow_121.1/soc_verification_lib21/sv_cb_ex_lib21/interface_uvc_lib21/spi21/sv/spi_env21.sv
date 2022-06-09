/*-------------------------------------------------------------------------
File21 name   : spi_env21.sv
Title21       : SPI21 SystemVerilog21 UVM UVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV21
`define SPI_ENV_SV21

class spi_env21 extends uvm_env;

  uvm_analysis_imp#(spi_csr21, spi_env21) dut_csr_port_in21;

  uvm_object cobj21;
  spi_config21 spi_ve_config21;

  // Virtual Interface21 variable
  virtual interface spi_if21 spi_if21;

  // Control21 properties21
  protected int unsigned num_agents21 = 1;

  // The following21 two21 bits are used to control21 whether21 checks21 and coverage21 are
  // done both in the bus monitor21 class and the interface.
  bit intf_checks_enable21 = 1; 
  bit intf_coverage_enable21 = 1;

  // Components of the environment21
  spi_agent21 agents21[];

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(spi_env21)
    `uvm_field_int(num_agents21, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable21, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable21, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in21 = new ("dut_csr_port_in21", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents21 = new[num_agents21];

    if(get_config_object("spi_ve_config21", cobj21))
      if (!$cast(spi_ve_config21, cobj21))
        `uvm_fatal ("CASTFL21", "Failed21 to cast cobj21 to spi_ve_config21")
    else
      spi_ve_config21 = spi_config21::type_id::create("spi_ve_config21", this);

    for(int i = 0; i < num_agents21; i++) begin
      $sformat(inst_name, "agents21[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config21.active_passive21);
      agents21[i] = spi_agent21::type_id::create(inst_name, this);
      agents21[i].agent_id21 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if21)::get(this, "", "spi_if21", spi_if21))
   `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".spi_if21"})
endfunction : connect_phase

  // update_vif_enables21
  protected task update_vif_enables21();
    forever begin
      @(intf_checks_enable21 || intf_coverage_enable21);
      spi_if21.has_checks21 <= intf_checks_enable21;
      spi_if21.has_coverage <= intf_coverage_enable21;
    end
  endtask : update_vif_enables21

   virtual function void write(input spi_csr21 cfg );
    for(int i = 0; i < num_agents21; i++) begin
      agents21[i].assign_csr21(cfg.csr_s21);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables21();
    join
  endtask : run_phase

endclass : spi_env21

`endif // SPI_ENV_SV21

