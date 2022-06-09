/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_monitor25.sv
Title25       : 
Project25     :
Created25     :
Description25 : Module25 env25, contains25 the instance of scoreboard25 and coverage25 model
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

class apb_subsystem_monitor25 extends uvm_monitor; 

  spi2ahb_scbd25 tx_scbd25;
  ahb2spi_scbd25 rx_scbd25;
   
  uvm_analysis_imp#(spi_pkg25::spi_csr25, apb_subsystem_monitor25) dut_csr_port_in25;

  `uvm_component_utils(apb_subsystem_monitor25)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in25 = new("dut_csr_port_in25", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard25
    tx_scbd25 = spi2ahb_scbd25::type_id::create("tx_scbd25",this);
    rx_scbd25 = ahb2spi_scbd25::type_id::create("rx_scbd25",this);

  endfunction : build_phase
  
  // pass25 csr_setting25 to scoreboard25 and coverage25
  function void write(spi_pkg25::spi_csr25 csr_setting25);
    tx_scbd25.assign_csr25(csr_setting25.csr_s25);
    rx_scbd25.assign_csr25(csr_setting25.csr_s25);
  endfunction

  function void set_slave_config25(apb_pkg25::apb_slave_config25 slave_cfg25);
    tx_scbd25.slave_cfg25 = slave_cfg25;
    rx_scbd25.slave_cfg25 = slave_cfg25;
  endfunction

endclass : apb_subsystem_monitor25

