/*-------------------------------------------------------------------------
File8 name   : spi_env8.sv
Title8       : SPI8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV8
`define SPI_ENV_SV8

class spi_env8 extends uvm_env;

  uvm_analysis_imp#(spi_csr8, spi_env8) dut_csr_port_in8;

  uvm_object cobj8;
  spi_config8 spi_ve_config8;

  // Virtual Interface8 variable
  virtual interface spi_if8 spi_if8;

  // Control8 properties8
  protected int unsigned num_agents8 = 1;

  // The following8 two8 bits are used to control8 whether8 checks8 and coverage8 are
  // done both in the bus monitor8 class and the interface.
  bit intf_checks_enable8 = 1; 
  bit intf_coverage_enable8 = 1;

  // Components of the environment8
  spi_agent8 agents8[];

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(spi_env8)
    `uvm_field_int(num_agents8, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable8, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable8, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in8 = new ("dut_csr_port_in8", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents8 = new[num_agents8];

    if(get_config_object("spi_ve_config8", cobj8))
      if (!$cast(spi_ve_config8, cobj8))
        `uvm_fatal ("CASTFL8", "Failed8 to cast cobj8 to spi_ve_config8")
    else
      spi_ve_config8 = spi_config8::type_id::create("spi_ve_config8", this);

    for(int i = 0; i < num_agents8; i++) begin
      $sformat(inst_name, "agents8[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config8.active_passive8);
      agents8[i] = spi_agent8::type_id::create(inst_name, this);
      agents8[i].agent_id8 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if8)::get(this, "", "spi_if8", spi_if8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".spi_if8"})
endfunction : connect_phase

  // update_vif_enables8
  protected task update_vif_enables8();
    forever begin
      @(intf_checks_enable8 || intf_coverage_enable8);
      spi_if8.has_checks8 <= intf_checks_enable8;
      spi_if8.has_coverage <= intf_coverage_enable8;
    end
  endtask : update_vif_enables8

   virtual function void write(input spi_csr8 cfg );
    for(int i = 0; i < num_agents8; i++) begin
      agents8[i].assign_csr8(cfg.csr_s8);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables8();
    join
  endtask : run_phase

endclass : spi_env8

`endif // SPI_ENV_SV8

