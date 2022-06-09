/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_monitor4.sv
Title4       : 
Project4     :
Created4     :
Description4 : Module4 env4, contains4 the instance of scoreboard4 and coverage4 model
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

class apb_subsystem_monitor4 extends uvm_monitor; 

  spi2ahb_scbd4 tx_scbd4;
  ahb2spi_scbd4 rx_scbd4;
   
  uvm_analysis_imp#(spi_pkg4::spi_csr4, apb_subsystem_monitor4) dut_csr_port_in4;

  `uvm_component_utils(apb_subsystem_monitor4)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in4 = new("dut_csr_port_in4", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard4
    tx_scbd4 = spi2ahb_scbd4::type_id::create("tx_scbd4",this);
    rx_scbd4 = ahb2spi_scbd4::type_id::create("rx_scbd4",this);

  endfunction : build_phase
  
  // pass4 csr_setting4 to scoreboard4 and coverage4
  function void write(spi_pkg4::spi_csr4 csr_setting4);
    tx_scbd4.assign_csr4(csr_setting4.csr_s4);
    rx_scbd4.assign_csr4(csr_setting4.csr_s4);
  endfunction

  function void set_slave_config4(apb_pkg4::apb_slave_config4 slave_cfg4);
    tx_scbd4.slave_cfg4 = slave_cfg4;
    rx_scbd4.slave_cfg4 = slave_cfg4;
  endfunction

endclass : apb_subsystem_monitor4

