/*-------------------------------------------------------------------------
File28 name   : spi_env28.sv
Title28       : SPI28 SystemVerilog28 UVM UVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV28
`define SPI_ENV_SV28

class spi_env28 extends uvm_env;

  uvm_analysis_imp#(spi_csr28, spi_env28) dut_csr_port_in28;

  uvm_object cobj28;
  spi_config28 spi_ve_config28;

  // Virtual Interface28 variable
  virtual interface spi_if28 spi_if28;

  // Control28 properties28
  protected int unsigned num_agents28 = 1;

  // The following28 two28 bits are used to control28 whether28 checks28 and coverage28 are
  // done both in the bus monitor28 class and the interface.
  bit intf_checks_enable28 = 1; 
  bit intf_coverage_enable28 = 1;

  // Components of the environment28
  spi_agent28 agents28[];

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(spi_env28)
    `uvm_field_int(num_agents28, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable28, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable28, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in28 = new ("dut_csr_port_in28", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents28 = new[num_agents28];

    if(get_config_object("spi_ve_config28", cobj28))
      if (!$cast(spi_ve_config28, cobj28))
        `uvm_fatal ("CASTFL28", "Failed28 to cast cobj28 to spi_ve_config28")
    else
      spi_ve_config28 = spi_config28::type_id::create("spi_ve_config28", this);

    for(int i = 0; i < num_agents28; i++) begin
      $sformat(inst_name, "agents28[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config28.active_passive28);
      agents28[i] = spi_agent28::type_id::create(inst_name, this);
      agents28[i].agent_id28 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if28)::get(this, "", "spi_if28", spi_if28))
   `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".spi_if28"})
endfunction : connect_phase

  // update_vif_enables28
  protected task update_vif_enables28();
    forever begin
      @(intf_checks_enable28 || intf_coverage_enable28);
      spi_if28.has_checks28 <= intf_checks_enable28;
      spi_if28.has_coverage <= intf_coverage_enable28;
    end
  endtask : update_vif_enables28

   virtual function void write(input spi_csr28 cfg );
    for(int i = 0; i < num_agents28; i++) begin
      agents28[i].assign_csr28(cfg.csr_s28);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables28();
    join
  endtask : run_phase

endclass : spi_env28

`endif // SPI_ENV_SV28

