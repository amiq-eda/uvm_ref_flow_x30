/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_monitor28.sv
Title28       : 
Project28     :
Created28     :
Description28 : Module28 env28, contains28 the instance of scoreboard28 and coverage28 model
Notes28       : 
----------------------------------------------------------------------*/
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

class apb_subsystem_monitor28 extends uvm_monitor; 

  spi2ahb_scbd28 tx_scbd28;
  ahb2spi_scbd28 rx_scbd28;
   
  uvm_analysis_imp#(spi_pkg28::spi_csr28, apb_subsystem_monitor28) dut_csr_port_in28;

  `uvm_component_utils(apb_subsystem_monitor28)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in28 = new("dut_csr_port_in28", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard28
    tx_scbd28 = spi2ahb_scbd28::type_id::create("tx_scbd28",this);
    rx_scbd28 = ahb2spi_scbd28::type_id::create("rx_scbd28",this);

  endfunction : build_phase
  
  // pass28 csr_setting28 to scoreboard28 and coverage28
  function void write(spi_pkg28::spi_csr28 csr_setting28);
    tx_scbd28.assign_csr28(csr_setting28.csr_s28);
    rx_scbd28.assign_csr28(csr_setting28.csr_s28);
  endfunction

  function void set_slave_config28(apb_pkg28::apb_slave_config28 slave_cfg28);
    tx_scbd28.slave_cfg28 = slave_cfg28;
    rx_scbd28.slave_cfg28 = slave_cfg28;
  endfunction

endclass : apb_subsystem_monitor28

