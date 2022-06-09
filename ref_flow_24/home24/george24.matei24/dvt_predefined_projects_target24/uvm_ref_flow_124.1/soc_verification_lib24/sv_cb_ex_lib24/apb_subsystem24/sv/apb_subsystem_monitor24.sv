/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_monitor24.sv
Title24       : 
Project24     :
Created24     :
Description24 : Module24 env24, contains24 the instance of scoreboard24 and coverage24 model
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

class apb_subsystem_monitor24 extends uvm_monitor; 

  spi2ahb_scbd24 tx_scbd24;
  ahb2spi_scbd24 rx_scbd24;
   
  uvm_analysis_imp#(spi_pkg24::spi_csr24, apb_subsystem_monitor24) dut_csr_port_in24;

  `uvm_component_utils(apb_subsystem_monitor24)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in24 = new("dut_csr_port_in24", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard24
    tx_scbd24 = spi2ahb_scbd24::type_id::create("tx_scbd24",this);
    rx_scbd24 = ahb2spi_scbd24::type_id::create("rx_scbd24",this);

  endfunction : build_phase
  
  // pass24 csr_setting24 to scoreboard24 and coverage24
  function void write(spi_pkg24::spi_csr24 csr_setting24);
    tx_scbd24.assign_csr24(csr_setting24.csr_s24);
    rx_scbd24.assign_csr24(csr_setting24.csr_s24);
  endfunction

  function void set_slave_config24(apb_pkg24::apb_slave_config24 slave_cfg24);
    tx_scbd24.slave_cfg24 = slave_cfg24;
    rx_scbd24.slave_cfg24 = slave_cfg24;
  endfunction

endclass : apb_subsystem_monitor24

