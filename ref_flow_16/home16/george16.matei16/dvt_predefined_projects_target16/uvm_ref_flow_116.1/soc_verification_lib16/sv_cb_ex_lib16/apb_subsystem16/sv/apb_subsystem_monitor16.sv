/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_monitor16.sv
Title16       : 
Project16     :
Created16     :
Description16 : Module16 env16, contains16 the instance of scoreboard16 and coverage16 model
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

class apb_subsystem_monitor16 extends uvm_monitor; 

  spi2ahb_scbd16 tx_scbd16;
  ahb2spi_scbd16 rx_scbd16;
   
  uvm_analysis_imp#(spi_pkg16::spi_csr16, apb_subsystem_monitor16) dut_csr_port_in16;

  `uvm_component_utils(apb_subsystem_monitor16)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in16 = new("dut_csr_port_in16", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard16
    tx_scbd16 = spi2ahb_scbd16::type_id::create("tx_scbd16",this);
    rx_scbd16 = ahb2spi_scbd16::type_id::create("rx_scbd16",this);

  endfunction : build_phase
  
  // pass16 csr_setting16 to scoreboard16 and coverage16
  function void write(spi_pkg16::spi_csr16 csr_setting16);
    tx_scbd16.assign_csr16(csr_setting16.csr_s16);
    rx_scbd16.assign_csr16(csr_setting16.csr_s16);
  endfunction

  function void set_slave_config16(apb_pkg16::apb_slave_config16 slave_cfg16);
    tx_scbd16.slave_cfg16 = slave_cfg16;
    rx_scbd16.slave_cfg16 = slave_cfg16;
  endfunction

endclass : apb_subsystem_monitor16

