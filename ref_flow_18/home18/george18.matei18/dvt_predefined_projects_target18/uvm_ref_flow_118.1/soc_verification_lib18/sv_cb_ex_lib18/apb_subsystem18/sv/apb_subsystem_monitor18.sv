/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_monitor18.sv
Title18       : 
Project18     :
Created18     :
Description18 : Module18 env18, contains18 the instance of scoreboard18 and coverage18 model
Notes18       : 
----------------------------------------------------------------------*/
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

class apb_subsystem_monitor18 extends uvm_monitor; 

  spi2ahb_scbd18 tx_scbd18;
  ahb2spi_scbd18 rx_scbd18;
   
  uvm_analysis_imp#(spi_pkg18::spi_csr18, apb_subsystem_monitor18) dut_csr_port_in18;

  `uvm_component_utils(apb_subsystem_monitor18)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in18 = new("dut_csr_port_in18", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard18
    tx_scbd18 = spi2ahb_scbd18::type_id::create("tx_scbd18",this);
    rx_scbd18 = ahb2spi_scbd18::type_id::create("rx_scbd18",this);

  endfunction : build_phase
  
  // pass18 csr_setting18 to scoreboard18 and coverage18
  function void write(spi_pkg18::spi_csr18 csr_setting18);
    tx_scbd18.assign_csr18(csr_setting18.csr_s18);
    rx_scbd18.assign_csr18(csr_setting18.csr_s18);
  endfunction

  function void set_slave_config18(apb_pkg18::apb_slave_config18 slave_cfg18);
    tx_scbd18.slave_cfg18 = slave_cfg18;
    rx_scbd18.slave_cfg18 = slave_cfg18;
  endfunction

endclass : apb_subsystem_monitor18

