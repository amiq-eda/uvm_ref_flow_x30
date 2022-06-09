/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_monitor7.sv
Title7       : 
Project7     :
Created7     :
Description7 : Module7 env7, contains7 the instance of scoreboard7 and coverage7 model
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

class apb_subsystem_monitor7 extends uvm_monitor; 

  spi2ahb_scbd7 tx_scbd7;
  ahb2spi_scbd7 rx_scbd7;
   
  uvm_analysis_imp#(spi_pkg7::spi_csr7, apb_subsystem_monitor7) dut_csr_port_in7;

  `uvm_component_utils(apb_subsystem_monitor7)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in7 = new("dut_csr_port_in7", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard7
    tx_scbd7 = spi2ahb_scbd7::type_id::create("tx_scbd7",this);
    rx_scbd7 = ahb2spi_scbd7::type_id::create("rx_scbd7",this);

  endfunction : build_phase
  
  // pass7 csr_setting7 to scoreboard7 and coverage7
  function void write(spi_pkg7::spi_csr7 csr_setting7);
    tx_scbd7.assign_csr7(csr_setting7.csr_s7);
    rx_scbd7.assign_csr7(csr_setting7.csr_s7);
  endfunction

  function void set_slave_config7(apb_pkg7::apb_slave_config7 slave_cfg7);
    tx_scbd7.slave_cfg7 = slave_cfg7;
    rx_scbd7.slave_cfg7 = slave_cfg7;
  endfunction

endclass : apb_subsystem_monitor7

