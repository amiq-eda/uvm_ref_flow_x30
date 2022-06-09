/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_monitor20.sv
Title20       : 
Project20     :
Created20     :
Description20 : Module20 env20, contains20 the instance of scoreboard20 and coverage20 model
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

class apb_subsystem_monitor20 extends uvm_monitor; 

  spi2ahb_scbd20 tx_scbd20;
  ahb2spi_scbd20 rx_scbd20;
   
  uvm_analysis_imp#(spi_pkg20::spi_csr20, apb_subsystem_monitor20) dut_csr_port_in20;

  `uvm_component_utils(apb_subsystem_monitor20)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in20 = new("dut_csr_port_in20", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard20
    tx_scbd20 = spi2ahb_scbd20::type_id::create("tx_scbd20",this);
    rx_scbd20 = ahb2spi_scbd20::type_id::create("rx_scbd20",this);

  endfunction : build_phase
  
  // pass20 csr_setting20 to scoreboard20 and coverage20
  function void write(spi_pkg20::spi_csr20 csr_setting20);
    tx_scbd20.assign_csr20(csr_setting20.csr_s20);
    rx_scbd20.assign_csr20(csr_setting20.csr_s20);
  endfunction

  function void set_slave_config20(apb_pkg20::apb_slave_config20 slave_cfg20);
    tx_scbd20.slave_cfg20 = slave_cfg20;
    rx_scbd20.slave_cfg20 = slave_cfg20;
  endfunction

endclass : apb_subsystem_monitor20

