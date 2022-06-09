/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_monitor8.sv
Title8       : 
Project8     :
Created8     :
Description8 : Module8 env8, contains8 the instance of scoreboard8 and coverage8 model
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

class apb_subsystem_monitor8 extends uvm_monitor; 

  spi2ahb_scbd8 tx_scbd8;
  ahb2spi_scbd8 rx_scbd8;
   
  uvm_analysis_imp#(spi_pkg8::spi_csr8, apb_subsystem_monitor8) dut_csr_port_in8;

  `uvm_component_utils(apb_subsystem_monitor8)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in8 = new("dut_csr_port_in8", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard8
    tx_scbd8 = spi2ahb_scbd8::type_id::create("tx_scbd8",this);
    rx_scbd8 = ahb2spi_scbd8::type_id::create("rx_scbd8",this);

  endfunction : build_phase
  
  // pass8 csr_setting8 to scoreboard8 and coverage8
  function void write(spi_pkg8::spi_csr8 csr_setting8);
    tx_scbd8.assign_csr8(csr_setting8.csr_s8);
    rx_scbd8.assign_csr8(csr_setting8.csr_s8);
  endfunction

  function void set_slave_config8(apb_pkg8::apb_slave_config8 slave_cfg8);
    tx_scbd8.slave_cfg8 = slave_cfg8;
    rx_scbd8.slave_cfg8 = slave_cfg8;
  endfunction

endclass : apb_subsystem_monitor8

