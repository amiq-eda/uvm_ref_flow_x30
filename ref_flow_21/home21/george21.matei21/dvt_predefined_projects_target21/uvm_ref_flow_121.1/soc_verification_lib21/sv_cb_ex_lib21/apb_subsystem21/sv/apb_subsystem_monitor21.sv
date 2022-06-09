/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_monitor21.sv
Title21       : 
Project21     :
Created21     :
Description21 : Module21 env21, contains21 the instance of scoreboard21 and coverage21 model
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

class apb_subsystem_monitor21 extends uvm_monitor; 

  spi2ahb_scbd21 tx_scbd21;
  ahb2spi_scbd21 rx_scbd21;
   
  uvm_analysis_imp#(spi_pkg21::spi_csr21, apb_subsystem_monitor21) dut_csr_port_in21;

  `uvm_component_utils(apb_subsystem_monitor21)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in21 = new("dut_csr_port_in21", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard21
    tx_scbd21 = spi2ahb_scbd21::type_id::create("tx_scbd21",this);
    rx_scbd21 = ahb2spi_scbd21::type_id::create("rx_scbd21",this);

  endfunction : build_phase
  
  // pass21 csr_setting21 to scoreboard21 and coverage21
  function void write(spi_pkg21::spi_csr21 csr_setting21);
    tx_scbd21.assign_csr21(csr_setting21.csr_s21);
    rx_scbd21.assign_csr21(csr_setting21.csr_s21);
  endfunction

  function void set_slave_config21(apb_pkg21::apb_slave_config21 slave_cfg21);
    tx_scbd21.slave_cfg21 = slave_cfg21;
    rx_scbd21.slave_cfg21 = slave_cfg21;
  endfunction

endclass : apb_subsystem_monitor21

