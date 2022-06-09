/*-------------------------------------------------------------------------
File17 name   : spi_env17.sv
Title17       : SPI17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV17
`define SPI_ENV_SV17

class spi_env17 extends uvm_env;

  uvm_analysis_imp#(spi_csr17, spi_env17) dut_csr_port_in17;

  uvm_object cobj17;
  spi_config17 spi_ve_config17;

  // Virtual Interface17 variable
  virtual interface spi_if17 spi_if17;

  // Control17 properties17
  protected int unsigned num_agents17 = 1;

  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done both in the bus monitor17 class and the interface.
  bit intf_checks_enable17 = 1; 
  bit intf_coverage_enable17 = 1;

  // Components of the environment17
  spi_agent17 agents17[];

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(spi_env17)
    `uvm_field_int(num_agents17, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable17, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable17, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in17 = new ("dut_csr_port_in17", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents17 = new[num_agents17];

    if(get_config_object("spi_ve_config17", cobj17))
      if (!$cast(spi_ve_config17, cobj17))
        `uvm_fatal ("CASTFL17", "Failed17 to cast cobj17 to spi_ve_config17")
    else
      spi_ve_config17 = spi_config17::type_id::create("spi_ve_config17", this);

    for(int i = 0; i < num_agents17; i++) begin
      $sformat(inst_name, "agents17[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config17.active_passive17);
      agents17[i] = spi_agent17::type_id::create(inst_name, this);
      agents17[i].agent_id17 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if17)::get(this, "", "spi_if17", spi_if17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".spi_if17"})
endfunction : connect_phase

  // update_vif_enables17
  protected task update_vif_enables17();
    forever begin
      @(intf_checks_enable17 || intf_coverage_enable17);
      spi_if17.has_checks17 <= intf_checks_enable17;
      spi_if17.has_coverage <= intf_coverage_enable17;
    end
  endtask : update_vif_enables17

   virtual function void write(input spi_csr17 cfg );
    for(int i = 0; i < num_agents17; i++) begin
      agents17[i].assign_csr17(cfg.csr_s17);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables17();
    join
  endtask : run_phase

endclass : spi_env17

`endif // SPI_ENV_SV17

