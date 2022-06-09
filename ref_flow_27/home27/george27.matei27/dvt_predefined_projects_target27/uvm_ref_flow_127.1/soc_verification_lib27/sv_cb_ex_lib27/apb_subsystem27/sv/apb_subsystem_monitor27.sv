/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_monitor27.sv
Title27       : 
Project27     :
Created27     :
Description27 : Module27 env27, contains27 the instance of scoreboard27 and coverage27 model
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

class apb_subsystem_monitor27 extends uvm_monitor; 

  spi2ahb_scbd27 tx_scbd27;
  ahb2spi_scbd27 rx_scbd27;
   
  uvm_analysis_imp#(spi_pkg27::spi_csr27, apb_subsystem_monitor27) dut_csr_port_in27;

  `uvm_component_utils(apb_subsystem_monitor27)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in27 = new("dut_csr_port_in27", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard27
    tx_scbd27 = spi2ahb_scbd27::type_id::create("tx_scbd27",this);
    rx_scbd27 = ahb2spi_scbd27::type_id::create("rx_scbd27",this);

  endfunction : build_phase
  
  // pass27 csr_setting27 to scoreboard27 and coverage27
  function void write(spi_pkg27::spi_csr27 csr_setting27);
    tx_scbd27.assign_csr27(csr_setting27.csr_s27);
    rx_scbd27.assign_csr27(csr_setting27.csr_s27);
  endfunction

  function void set_slave_config27(apb_pkg27::apb_slave_config27 slave_cfg27);
    tx_scbd27.slave_cfg27 = slave_cfg27;
    rx_scbd27.slave_cfg27 = slave_cfg27;
  endfunction

endclass : apb_subsystem_monitor27

