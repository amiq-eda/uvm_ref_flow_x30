/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_monitor11.sv
Title11       : 
Project11     :
Created11     :
Description11 : Module11 env11, contains11 the instance of scoreboard11 and coverage11 model
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

class apb_subsystem_monitor11 extends uvm_monitor; 

  spi2ahb_scbd11 tx_scbd11;
  ahb2spi_scbd11 rx_scbd11;
   
  uvm_analysis_imp#(spi_pkg11::spi_csr11, apb_subsystem_monitor11) dut_csr_port_in11;

  `uvm_component_utils(apb_subsystem_monitor11)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in11 = new("dut_csr_port_in11", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard11
    tx_scbd11 = spi2ahb_scbd11::type_id::create("tx_scbd11",this);
    rx_scbd11 = ahb2spi_scbd11::type_id::create("rx_scbd11",this);

  endfunction : build_phase
  
  // pass11 csr_setting11 to scoreboard11 and coverage11
  function void write(spi_pkg11::spi_csr11 csr_setting11);
    tx_scbd11.assign_csr11(csr_setting11.csr_s11);
    rx_scbd11.assign_csr11(csr_setting11.csr_s11);
  endfunction

  function void set_slave_config11(apb_pkg11::apb_slave_config11 slave_cfg11);
    tx_scbd11.slave_cfg11 = slave_cfg11;
    rx_scbd11.slave_cfg11 = slave_cfg11;
  endfunction

endclass : apb_subsystem_monitor11

