/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_monitor1.sv
Title1       : 
Project1     :
Created1     :
Description1 : Module1 env1, contains1 the instance of scoreboard1 and coverage1 model
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

class apb_subsystem_monitor1 extends uvm_monitor; 

  spi2ahb_scbd1 tx_scbd1;
  ahb2spi_scbd1 rx_scbd1;
   
  uvm_analysis_imp#(spi_pkg1::spi_csr1, apb_subsystem_monitor1) dut_csr_port_in1;

  `uvm_component_utils(apb_subsystem_monitor1)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in1 = new("dut_csr_port_in1", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard1
    tx_scbd1 = spi2ahb_scbd1::type_id::create("tx_scbd1",this);
    rx_scbd1 = ahb2spi_scbd1::type_id::create("rx_scbd1",this);

  endfunction : build_phase
  
  // pass1 csr_setting1 to scoreboard1 and coverage1
  function void write(spi_pkg1::spi_csr1 csr_setting1);
    tx_scbd1.assign_csr1(csr_setting1.csr_s1);
    rx_scbd1.assign_csr1(csr_setting1.csr_s1);
  endfunction

  function void set_slave_config1(apb_pkg1::apb_slave_config1 slave_cfg1);
    tx_scbd1.slave_cfg1 = slave_cfg1;
    rx_scbd1.slave_cfg1 = slave_cfg1;
  endfunction

endclass : apb_subsystem_monitor1

