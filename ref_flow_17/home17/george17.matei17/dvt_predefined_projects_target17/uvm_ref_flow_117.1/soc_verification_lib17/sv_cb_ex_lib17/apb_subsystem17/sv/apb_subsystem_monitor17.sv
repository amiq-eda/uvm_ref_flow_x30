/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_monitor17.sv
Title17       : 
Project17     :
Created17     :
Description17 : Module17 env17, contains17 the instance of scoreboard17 and coverage17 model
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

class apb_subsystem_monitor17 extends uvm_monitor; 

  spi2ahb_scbd17 tx_scbd17;
  ahb2spi_scbd17 rx_scbd17;
   
  uvm_analysis_imp#(spi_pkg17::spi_csr17, apb_subsystem_monitor17) dut_csr_port_in17;

  `uvm_component_utils(apb_subsystem_monitor17)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in17 = new("dut_csr_port_in17", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard17
    tx_scbd17 = spi2ahb_scbd17::type_id::create("tx_scbd17",this);
    rx_scbd17 = ahb2spi_scbd17::type_id::create("rx_scbd17",this);

  endfunction : build_phase
  
  // pass17 csr_setting17 to scoreboard17 and coverage17
  function void write(spi_pkg17::spi_csr17 csr_setting17);
    tx_scbd17.assign_csr17(csr_setting17.csr_s17);
    rx_scbd17.assign_csr17(csr_setting17.csr_s17);
  endfunction

  function void set_slave_config17(apb_pkg17::apb_slave_config17 slave_cfg17);
    tx_scbd17.slave_cfg17 = slave_cfg17;
    rx_scbd17.slave_cfg17 = slave_cfg17;
  endfunction

endclass : apb_subsystem_monitor17

