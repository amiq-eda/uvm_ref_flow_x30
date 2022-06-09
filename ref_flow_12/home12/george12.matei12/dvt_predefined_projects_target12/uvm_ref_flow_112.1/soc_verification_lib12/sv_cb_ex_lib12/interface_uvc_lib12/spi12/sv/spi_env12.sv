/*-------------------------------------------------------------------------
File12 name   : spi_env12.sv
Title12       : SPI12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef SPI_ENV_SV12
`define SPI_ENV_SV12

class spi_env12 extends uvm_env;

  uvm_analysis_imp#(spi_csr12, spi_env12) dut_csr_port_in12;

  uvm_object cobj12;
  spi_config12 spi_ve_config12;

  // Virtual Interface12 variable
  virtual interface spi_if12 spi_if12;

  // Control12 properties12
  protected int unsigned num_agents12 = 1;

  // The following12 two12 bits are used to control12 whether12 checks12 and coverage12 are
  // done both in the bus monitor12 class and the interface.
  bit intf_checks_enable12 = 1; 
  bit intf_coverage_enable12 = 1;

  // Components of the environment12
  spi_agent12 agents12[];

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(spi_env12)
    `uvm_field_int(num_agents12, UVM_ALL_ON)
    `uvm_field_int(intf_checks_enable12, UVM_ALL_ON)
    `uvm_field_int(intf_coverage_enable12, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_csr_port_in12 = new ("dut_csr_port_in12", this);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    agents12 = new[num_agents12];

    if(get_config_object("spi_ve_config12", cobj12))
      if (!$cast(spi_ve_config12, cobj12))
        `uvm_fatal ("CASTFL12", "Failed12 to cast cobj12 to spi_ve_config12")
    else
      spi_ve_config12 = spi_config12::type_id::create("spi_ve_config12", this);

    for(int i = 0; i < num_agents12; i++) begin
      $sformat(inst_name, "agents12[%0d]", i);
      set_config_int(inst_name, "is_active", spi_ve_config12.active_passive12);
      agents12[i] = spi_agent12::type_id::create(inst_name, this);
      agents12[i].agent_id12 = i;
    end
  endfunction : build_phase

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if12)::get(this, "", "spi_if12", spi_if12))
   `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".spi_if12"})
endfunction : connect_phase

  // update_vif_enables12
  protected task update_vif_enables12();
    forever begin
      @(intf_checks_enable12 || intf_coverage_enable12);
      spi_if12.has_checks12 <= intf_checks_enable12;
      spi_if12.has_coverage <= intf_coverage_enable12;
    end
  endtask : update_vif_enables12

   virtual function void write(input spi_csr12 cfg );
    for(int i = 0; i < num_agents12; i++) begin
      agents12[i].assign_csr12(cfg.csr_s12);
    end
   endfunction

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables12();
    join
  endtask : run_phase

endclass : spi_env12

`endif // SPI_ENV_SV12

