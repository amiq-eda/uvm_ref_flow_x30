/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_monitor9.sv
Title9       : 
Project9     :
Created9     :
Description9 : Module9 env9, contains9 the instance of scoreboard9 and coverage9 model
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

class apb_subsystem_monitor9 extends uvm_monitor; 

  spi2ahb_scbd9 tx_scbd9;
  ahb2spi_scbd9 rx_scbd9;
   
  uvm_analysis_imp#(spi_pkg9::spi_csr9, apb_subsystem_monitor9) dut_csr_port_in9;

  `uvm_component_utils(apb_subsystem_monitor9)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in9 = new("dut_csr_port_in9", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard9
    tx_scbd9 = spi2ahb_scbd9::type_id::create("tx_scbd9",this);
    rx_scbd9 = ahb2spi_scbd9::type_id::create("rx_scbd9",this);

  endfunction : build_phase
  
  // pass9 csr_setting9 to scoreboard9 and coverage9
  function void write(spi_pkg9::spi_csr9 csr_setting9);
    tx_scbd9.assign_csr9(csr_setting9.csr_s9);
    rx_scbd9.assign_csr9(csr_setting9.csr_s9);
  endfunction

  function void set_slave_config9(apb_pkg9::apb_slave_config9 slave_cfg9);
    tx_scbd9.slave_cfg9 = slave_cfg9;
    rx_scbd9.slave_cfg9 = slave_cfg9;
  endfunction

endclass : apb_subsystem_monitor9

