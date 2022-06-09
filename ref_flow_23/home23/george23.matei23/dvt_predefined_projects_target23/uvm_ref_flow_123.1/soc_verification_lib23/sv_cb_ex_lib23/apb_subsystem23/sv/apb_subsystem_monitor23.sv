/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_monitor23.sv
Title23       : 
Project23     :
Created23     :
Description23 : Module23 env23, contains23 the instance of scoreboard23 and coverage23 model
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

class apb_subsystem_monitor23 extends uvm_monitor; 

  spi2ahb_scbd23 tx_scbd23;
  ahb2spi_scbd23 rx_scbd23;
   
  uvm_analysis_imp#(spi_pkg23::spi_csr23, apb_subsystem_monitor23) dut_csr_port_in23;

  `uvm_component_utils(apb_subsystem_monitor23)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in23 = new("dut_csr_port_in23", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard23
    tx_scbd23 = spi2ahb_scbd23::type_id::create("tx_scbd23",this);
    rx_scbd23 = ahb2spi_scbd23::type_id::create("rx_scbd23",this);

  endfunction : build_phase
  
  // pass23 csr_setting23 to scoreboard23 and coverage23
  function void write(spi_pkg23::spi_csr23 csr_setting23);
    tx_scbd23.assign_csr23(csr_setting23.csr_s23);
    rx_scbd23.assign_csr23(csr_setting23.csr_s23);
  endfunction

  function void set_slave_config23(apb_pkg23::apb_slave_config23 slave_cfg23);
    tx_scbd23.slave_cfg23 = slave_cfg23;
    rx_scbd23.slave_cfg23 = slave_cfg23;
  endfunction

endclass : apb_subsystem_monitor23

