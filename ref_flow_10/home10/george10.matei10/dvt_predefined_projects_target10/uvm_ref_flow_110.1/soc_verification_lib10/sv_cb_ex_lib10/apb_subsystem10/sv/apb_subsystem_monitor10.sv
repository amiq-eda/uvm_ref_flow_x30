/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_monitor10.sv
Title10       : 
Project10     :
Created10     :
Description10 : Module10 env10, contains10 the instance of scoreboard10 and coverage10 model
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

class apb_subsystem_monitor10 extends uvm_monitor; 

  spi2ahb_scbd10 tx_scbd10;
  ahb2spi_scbd10 rx_scbd10;
   
  uvm_analysis_imp#(spi_pkg10::spi_csr10, apb_subsystem_monitor10) dut_csr_port_in10;

  `uvm_component_utils(apb_subsystem_monitor10)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in10 = new("dut_csr_port_in10", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard10
    tx_scbd10 = spi2ahb_scbd10::type_id::create("tx_scbd10",this);
    rx_scbd10 = ahb2spi_scbd10::type_id::create("rx_scbd10",this);

  endfunction : build_phase
  
  // pass10 csr_setting10 to scoreboard10 and coverage10
  function void write(spi_pkg10::spi_csr10 csr_setting10);
    tx_scbd10.assign_csr10(csr_setting10.csr_s10);
    rx_scbd10.assign_csr10(csr_setting10.csr_s10);
  endfunction

  function void set_slave_config10(apb_pkg10::apb_slave_config10 slave_cfg10);
    tx_scbd10.slave_cfg10 = slave_cfg10;
    rx_scbd10.slave_cfg10 = slave_cfg10;
  endfunction

endclass : apb_subsystem_monitor10

