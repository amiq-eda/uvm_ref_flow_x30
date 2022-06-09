/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_monitor14.sv
Title14       : 
Project14     :
Created14     :
Description14 : Module14 env14, contains14 the instance of scoreboard14 and coverage14 model
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

class apb_subsystem_monitor14 extends uvm_monitor; 

  spi2ahb_scbd14 tx_scbd14;
  ahb2spi_scbd14 rx_scbd14;
   
  uvm_analysis_imp#(spi_pkg14::spi_csr14, apb_subsystem_monitor14) dut_csr_port_in14;

  `uvm_component_utils(apb_subsystem_monitor14)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in14 = new("dut_csr_port_in14", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard14
    tx_scbd14 = spi2ahb_scbd14::type_id::create("tx_scbd14",this);
    rx_scbd14 = ahb2spi_scbd14::type_id::create("rx_scbd14",this);

  endfunction : build_phase
  
  // pass14 csr_setting14 to scoreboard14 and coverage14
  function void write(spi_pkg14::spi_csr14 csr_setting14);
    tx_scbd14.assign_csr14(csr_setting14.csr_s14);
    rx_scbd14.assign_csr14(csr_setting14.csr_s14);
  endfunction

  function void set_slave_config14(apb_pkg14::apb_slave_config14 slave_cfg14);
    tx_scbd14.slave_cfg14 = slave_cfg14;
    rx_scbd14.slave_cfg14 = slave_cfg14;
  endfunction

endclass : apb_subsystem_monitor14

