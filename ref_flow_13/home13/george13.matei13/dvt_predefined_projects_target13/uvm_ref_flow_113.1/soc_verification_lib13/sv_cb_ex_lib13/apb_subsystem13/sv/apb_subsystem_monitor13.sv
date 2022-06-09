/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_monitor13.sv
Title13       : 
Project13     :
Created13     :
Description13 : Module13 env13, contains13 the instance of scoreboard13 and coverage13 model
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

class apb_subsystem_monitor13 extends uvm_monitor; 

  spi2ahb_scbd13 tx_scbd13;
  ahb2spi_scbd13 rx_scbd13;
   
  uvm_analysis_imp#(spi_pkg13::spi_csr13, apb_subsystem_monitor13) dut_csr_port_in13;

  `uvm_component_utils(apb_subsystem_monitor13)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in13 = new("dut_csr_port_in13", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard13
    tx_scbd13 = spi2ahb_scbd13::type_id::create("tx_scbd13",this);
    rx_scbd13 = ahb2spi_scbd13::type_id::create("rx_scbd13",this);

  endfunction : build_phase
  
  // pass13 csr_setting13 to scoreboard13 and coverage13
  function void write(spi_pkg13::spi_csr13 csr_setting13);
    tx_scbd13.assign_csr13(csr_setting13.csr_s13);
    rx_scbd13.assign_csr13(csr_setting13.csr_s13);
  endfunction

  function void set_slave_config13(apb_pkg13::apb_slave_config13 slave_cfg13);
    tx_scbd13.slave_cfg13 = slave_cfg13;
    rx_scbd13.slave_cfg13 = slave_cfg13;
  endfunction

endclass : apb_subsystem_monitor13

