/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_monitor26.sv
Title26       : 
Project26     :
Created26     :
Description26 : Module26 env26, contains26 the instance of scoreboard26 and coverage26 model
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

class apb_subsystem_monitor26 extends uvm_monitor; 

  spi2ahb_scbd26 tx_scbd26;
  ahb2spi_scbd26 rx_scbd26;
   
  uvm_analysis_imp#(spi_pkg26::spi_csr26, apb_subsystem_monitor26) dut_csr_port_in26;

  `uvm_component_utils(apb_subsystem_monitor26)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in26 = new("dut_csr_port_in26", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard26
    tx_scbd26 = spi2ahb_scbd26::type_id::create("tx_scbd26",this);
    rx_scbd26 = ahb2spi_scbd26::type_id::create("rx_scbd26",this);

  endfunction : build_phase
  
  // pass26 csr_setting26 to scoreboard26 and coverage26
  function void write(spi_pkg26::spi_csr26 csr_setting26);
    tx_scbd26.assign_csr26(csr_setting26.csr_s26);
    rx_scbd26.assign_csr26(csr_setting26.csr_s26);
  endfunction

  function void set_slave_config26(apb_pkg26::apb_slave_config26 slave_cfg26);
    tx_scbd26.slave_cfg26 = slave_cfg26;
    rx_scbd26.slave_cfg26 = slave_cfg26;
  endfunction

endclass : apb_subsystem_monitor26

