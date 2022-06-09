/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_monitor12.sv
Title12       : 
Project12     :
Created12     :
Description12 : Module12 env12, contains12 the instance of scoreboard12 and coverage12 model
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

class apb_subsystem_monitor12 extends uvm_monitor; 

  spi2ahb_scbd12 tx_scbd12;
  ahb2spi_scbd12 rx_scbd12;
   
  uvm_analysis_imp#(spi_pkg12::spi_csr12, apb_subsystem_monitor12) dut_csr_port_in12;

  `uvm_component_utils(apb_subsystem_monitor12)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in12 = new("dut_csr_port_in12", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard12
    tx_scbd12 = spi2ahb_scbd12::type_id::create("tx_scbd12",this);
    rx_scbd12 = ahb2spi_scbd12::type_id::create("rx_scbd12",this);

  endfunction : build_phase
  
  // pass12 csr_setting12 to scoreboard12 and coverage12
  function void write(spi_pkg12::spi_csr12 csr_setting12);
    tx_scbd12.assign_csr12(csr_setting12.csr_s12);
    rx_scbd12.assign_csr12(csr_setting12.csr_s12);
  endfunction

  function void set_slave_config12(apb_pkg12::apb_slave_config12 slave_cfg12);
    tx_scbd12.slave_cfg12 = slave_cfg12;
    rx_scbd12.slave_cfg12 = slave_cfg12;
  endfunction

endclass : apb_subsystem_monitor12

