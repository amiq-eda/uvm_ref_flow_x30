/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_monitor30.sv
Title30       : 
Project30     :
Created30     :
Description30 : Module30 env30, contains30 the instance of scoreboard30 and coverage30 model
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

class apb_subsystem_monitor30 extends uvm_monitor; 

  spi2ahb_scbd30 tx_scbd30;
  ahb2spi_scbd30 rx_scbd30;
   
  uvm_analysis_imp#(spi_pkg30::spi_csr30, apb_subsystem_monitor30) dut_csr_port_in30;

  `uvm_component_utils(apb_subsystem_monitor30)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in30 = new("dut_csr_port_in30", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard30
    tx_scbd30 = spi2ahb_scbd30::type_id::create("tx_scbd30",this);
    rx_scbd30 = ahb2spi_scbd30::type_id::create("rx_scbd30",this);

  endfunction : build_phase
  
  // pass30 csr_setting30 to scoreboard30 and coverage30
  function void write(spi_pkg30::spi_csr30 csr_setting30);
    tx_scbd30.assign_csr30(csr_setting30.csr_s30);
    rx_scbd30.assign_csr30(csr_setting30.csr_s30);
  endfunction

  function void set_slave_config30(apb_pkg30::apb_slave_config30 slave_cfg30);
    tx_scbd30.slave_cfg30 = slave_cfg30;
    rx_scbd30.slave_cfg30 = slave_cfg30;
  endfunction

endclass : apb_subsystem_monitor30

