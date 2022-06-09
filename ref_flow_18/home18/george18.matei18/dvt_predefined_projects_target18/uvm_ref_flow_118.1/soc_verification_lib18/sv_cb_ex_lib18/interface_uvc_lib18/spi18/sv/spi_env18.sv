/*-------------------------------------------------------------------------
File18 name   : spi_env18.sv
Title18       : SPI18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV18
`define SPI_ENV_SV18

class spi_env18 extends uvm_env;

  uvm_analysis_imp#(spi_csr18, spi_env18) dut_csr_port_in18;

  uvm_object cobj18;
  spi_config18 spi_ve_config18;

  // Virtual Interface18 variable
  virtual interface spi_if18 spi_if18;

  // Control18 properties18
  protected int unsigned num_agents18 = 1;

  // The following18 two18 bits are used to control18 whether18 checks18 and coverage18 are
  // done both in the bus monitor18 class and the interface.
  bit intf_checks_enable18 = 1; 
  bit intf_coverage_enable18 = 1;

  // Components of the environment18
  spi_agent18 agents18[];

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(spi_env18)
    `uvm_field_int(num_agents18, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable18, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable18, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in18 = new ("dut_csr_port_in18", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents18 = new[num_agents18];

    if(get_config_object("spi_ve_config18", cobj18))
      if (!$cast(spi_ve_config18, cobj18))
        `uvm_fatal ("CASTFL18", "Failed18 to cast cobj18 to spi_ve_config18")
    else
      spi_ve_config18 = spi_config18::type_id::create("spi_ve_config18", this);

    for(int i = 0; i < num_agents18; i++) begin
      $sformat(inst_name, "agents18[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config18.active_passive18);
      agents18[i] = spi_agent18::type_id::create(inst_name, this);
      agents18[i].agent_id18 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if18)::get(this, "", "spi_if18", spi_if18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".spi_if18"})
endfunction : connect_phase

  // update_vif_enables18
  protected task update_vif_enables18();
    forever begin
      @(intf_checks_enable18 || intf_coverage_enable18);
      spi_if18.has_checks18 <= intf_checks_enable18;
      spi_if18.has_coverage <= intf_coverage_enable18;
    end
  endtask : update_vif_enables18

   virtual function void write(input spi_csr18 cfg );
    for(int i = 0; i < num_agents18; i++) begin
      agents18[i].assign_csr18(cfg.csr_s18);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables18();
    join
  endtask : run_phase

endclass : spi_env18

`endif // SPI_ENV_SV18

