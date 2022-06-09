/*-------------------------------------------------------------------------
File14 name   : spi_env14.sv
Title14       : SPI14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV14
`define SPI_ENV_SV14

class spi_env14 extends uvm_env;

  uvm_analysis_imp#(spi_csr14, spi_env14) dut_csr_port_in14;

  uvm_object cobj14;
  spi_config14 spi_ve_config14;

  // Virtual Interface14 variable
  virtual interface spi_if14 spi_if14;

  // Control14 properties14
  protected int unsigned num_agents14 = 1;

  // The following14 two14 bits are used to control14 whether14 checks14 and coverage14 are
  // done both in the bus monitor14 class and the interface.
  bit intf_checks_enable14 = 1; 
  bit intf_coverage_enable14 = 1;

  // Components of the environment14
  spi_agent14 agents14[];

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(spi_env14)
    `uvm_field_int(num_agents14, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable14, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable14, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in14 = new ("dut_csr_port_in14", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents14 = new[num_agents14];

    if(get_config_object("spi_ve_config14", cobj14))
      if (!$cast(spi_ve_config14, cobj14))
        `uvm_fatal ("CASTFL14", "Failed14 to cast cobj14 to spi_ve_config14")
    else
      spi_ve_config14 = spi_config14::type_id::create("spi_ve_config14", this);

    for(int i = 0; i < num_agents14; i++) begin
      $sformat(inst_name, "agents14[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config14.active_passive14);
      agents14[i] = spi_agent14::type_id::create(inst_name, this);
      agents14[i].agent_id14 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if14)::get(this, "", "spi_if14", spi_if14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".spi_if14"})
endfunction : connect_phase

  // update_vif_enables14
  protected task update_vif_enables14();
    forever begin
      @(intf_checks_enable14 || intf_coverage_enable14);
      spi_if14.has_checks14 <= intf_checks_enable14;
      spi_if14.has_coverage <= intf_coverage_enable14;
    end
  endtask : update_vif_enables14

   virtual function void write(input spi_csr14 cfg );
    for(int i = 0; i < num_agents14; i++) begin
      agents14[i].assign_csr14(cfg.csr_s14);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables14();
    join
  endtask : run_phase

endclass : spi_env14

`endif // SPI_ENV_SV14

