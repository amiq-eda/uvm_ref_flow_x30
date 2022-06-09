/*-------------------------------------------------------------------------
File11 name   : spi_env11.sv
Title11       : SPI11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV11
`define SPI_ENV_SV11

class spi_env11 extends uvm_env;

  uvm_analysis_imp#(spi_csr11, spi_env11) dut_csr_port_in11;

  uvm_object cobj11;
  spi_config11 spi_ve_config11;

  // Virtual Interface11 variable
  virtual interface spi_if11 spi_if11;

  // Control11 properties11
  protected int unsigned num_agents11 = 1;

  // The following11 two11 bits are used to control11 whether11 checks11 and coverage11 are
  // done both in the bus monitor11 class and the interface.
  bit intf_checks_enable11 = 1; 
  bit intf_coverage_enable11 = 1;

  // Components of the environment11
  spi_agent11 agents11[];

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(spi_env11)
    `uvm_field_int(num_agents11, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable11, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable11, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in11 = new ("dut_csr_port_in11", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents11 = new[num_agents11];

    if(get_config_object("spi_ve_config11", cobj11))
      if (!$cast(spi_ve_config11, cobj11))
        `uvm_fatal ("CASTFL11", "Failed11 to cast cobj11 to spi_ve_config11")
    else
      spi_ve_config11 = spi_config11::type_id::create("spi_ve_config11", this);

    for(int i = 0; i < num_agents11; i++) begin
      $sformat(inst_name, "agents11[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config11.active_passive11);
      agents11[i] = spi_agent11::type_id::create(inst_name, this);
      agents11[i].agent_id11 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if11)::get(this, "", "spi_if11", spi_if11))
   `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".spi_if11"})
endfunction : connect_phase

  // update_vif_enables11
  protected task update_vif_enables11();
    forever begin
      @(intf_checks_enable11 || intf_coverage_enable11);
      spi_if11.has_checks11 <= intf_checks_enable11;
      spi_if11.has_coverage <= intf_coverage_enable11;
    end
  endtask : update_vif_enables11

   virtual function void write(input spi_csr11 cfg );
    for(int i = 0; i < num_agents11; i++) begin
      agents11[i].assign_csr11(cfg.csr_s11);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables11();
    join
  endtask : run_phase

endclass : spi_env11

`endif // SPI_ENV_SV11

