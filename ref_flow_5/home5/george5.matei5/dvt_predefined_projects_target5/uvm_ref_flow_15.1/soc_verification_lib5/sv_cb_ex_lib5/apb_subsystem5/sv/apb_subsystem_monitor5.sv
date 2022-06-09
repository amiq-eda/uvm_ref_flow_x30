/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_monitor5.sv
Title5       : 
Project5     :
Created5     :
Description5 : Module5 env5, contains5 the instance of scoreboard5 and coverage5 model
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

class apb_subsystem_monitor5 extends uvm_monitor; 

  spi2ahb_scbd5 tx_scbd5;
  ahb2spi_scbd5 rx_scbd5;
   
  uvm_analysis_imp#(spi_pkg5::spi_csr5, apb_subsystem_monitor5) dut_csr_port_in5;

  `uvm_component_utils(apb_subsystem_monitor5)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in5 = new("dut_csr_port_in5", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard5
    tx_scbd5 = spi2ahb_scbd5::type_id::create("tx_scbd5",this);
    rx_scbd5 = ahb2spi_scbd5::type_id::create("rx_scbd5",this);

  endfunction : build_phase
  
  // pass5 csr_setting5 to scoreboard5 and coverage5
  function void write(spi_pkg5::spi_csr5 csr_setting5);
    tx_scbd5.assign_csr5(csr_setting5.csr_s5);
    rx_scbd5.assign_csr5(csr_setting5.csr_s5);
  endfunction

  function void set_slave_config5(apb_pkg5::apb_slave_config5 slave_cfg5);
    tx_scbd5.slave_cfg5 = slave_cfg5;
    rx_scbd5.slave_cfg5 = slave_cfg5;
  endfunction

endclass : apb_subsystem_monitor5

