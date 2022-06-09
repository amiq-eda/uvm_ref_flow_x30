/*-------------------------------------------------------------------------
File9 name   : spi_env9.sv
Title9       : SPI9 SystemVerilog9 UVM UVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV9
`define SPI_ENV_SV9

class spi_env9 extends uvm_env;

  uvm_analysis_imp#(spi_csr9, spi_env9) dut_csr_port_in9;

  uvm_object cobj9;
  spi_config9 spi_ve_config9;

  // Virtual Interface9 variable
  virtual interface spi_if9 spi_if9;

  // Control9 properties9
  protected int unsigned num_agents9 = 1;

  // The following9 two9 bits are used to control9 whether9 checks9 and coverage9 are
  // done both in the bus monitor9 class and the interface.
  bit intf_checks_enable9 = 1; 
  bit intf_coverage_enable9 = 1;

  // Components of the environment9
  spi_agent9 agents9[];

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(spi_env9)
    `uvm_field_int(num_agents9, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable9, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable9, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in9 = new ("dut_csr_port_in9", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents9 = new[num_agents9];

    if(get_config_object("spi_ve_config9", cobj9))
      if (!$cast(spi_ve_config9, cobj9))
        `uvm_fatal ("CASTFL9", "Failed9 to cast cobj9 to spi_ve_config9")
    else
      spi_ve_config9 = spi_config9::type_id::create("spi_ve_config9", this);

    for(int i = 0; i < num_agents9; i++) begin
      $sformat(inst_name, "agents9[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config9.active_passive9);
      agents9[i] = spi_agent9::type_id::create(inst_name, this);
      agents9[i].agent_id9 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if9)::get(this, "", "spi_if9", spi_if9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".spi_if9"})
endfunction : connect_phase

  // update_vif_enables9
  protected task update_vif_enables9();
    forever begin
      @(intf_checks_enable9 || intf_coverage_enable9);
      spi_if9.has_checks9 <= intf_checks_enable9;
      spi_if9.has_coverage <= intf_coverage_enable9;
    end
  endtask : update_vif_enables9

   virtual function void write(input spi_csr9 cfg );
    for(int i = 0; i < num_agents9; i++) begin
      agents9[i].assign_csr9(cfg.csr_s9);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables9();
    join
  endtask : run_phase

endclass : spi_env9

`endif // SPI_ENV_SV9

