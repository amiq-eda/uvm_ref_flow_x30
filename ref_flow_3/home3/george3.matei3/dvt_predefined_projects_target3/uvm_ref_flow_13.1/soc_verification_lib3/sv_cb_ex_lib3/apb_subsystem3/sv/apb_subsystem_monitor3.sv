/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_monitor3.sv
Title3       : 
Project3     :
Created3     :
Description3 : Module3 env3, contains3 the instance of scoreboard3 and coverage3 model
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

class apb_subsystem_monitor3 extends uvm_monitor; 

  spi2ahb_scbd3 tx_scbd3;
  ahb2spi_scbd3 rx_scbd3;
   
  uvm_analysis_imp#(spi_pkg3::spi_csr3, apb_subsystem_monitor3) dut_csr_port_in3;

  `uvm_component_utils(apb_subsystem_monitor3)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in3 = new("dut_csr_port_in3", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard3
    tx_scbd3 = spi2ahb_scbd3::type_id::create("tx_scbd3",this);
    rx_scbd3 = ahb2spi_scbd3::type_id::create("rx_scbd3",this);

  endfunction : build_phase
  
  // pass3 csr_setting3 to scoreboard3 and coverage3
  function void write(spi_pkg3::spi_csr3 csr_setting3);
    tx_scbd3.assign_csr3(csr_setting3.csr_s3);
    rx_scbd3.assign_csr3(csr_setting3.csr_s3);
  endfunction

  function void set_slave_config3(apb_pkg3::apb_slave_config3 slave_cfg3);
    tx_scbd3.slave_cfg3 = slave_cfg3;
    rx_scbd3.slave_cfg3 = slave_cfg3;
  endfunction

endclass : apb_subsystem_monitor3

