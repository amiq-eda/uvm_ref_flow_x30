/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_monitor15.sv
Title15       : 
Project15     :
Created15     :
Description15 : Module15 env15, contains15 the instance of scoreboard15 and coverage15 model
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

class apb_subsystem_monitor15 extends uvm_monitor; 

  spi2ahb_scbd15 tx_scbd15;
  ahb2spi_scbd15 rx_scbd15;
   
  uvm_analysis_imp#(spi_pkg15::spi_csr15, apb_subsystem_monitor15) dut_csr_port_in15;

  `uvm_component_utils(apb_subsystem_monitor15)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in15 = new("dut_csr_port_in15", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard15
    tx_scbd15 = spi2ahb_scbd15::type_id::create("tx_scbd15",this);
    rx_scbd15 = ahb2spi_scbd15::type_id::create("rx_scbd15",this);

  endfunction : build_phase
  
  // pass15 csr_setting15 to scoreboard15 and coverage15
  function void write(spi_pkg15::spi_csr15 csr_setting15);
    tx_scbd15.assign_csr15(csr_setting15.csr_s15);
    rx_scbd15.assign_csr15(csr_setting15.csr_s15);
  endfunction

  function void set_slave_config15(apb_pkg15::apb_slave_config15 slave_cfg15);
    tx_scbd15.slave_cfg15 = slave_cfg15;
    rx_scbd15.slave_cfg15 = slave_cfg15;
  endfunction

endclass : apb_subsystem_monitor15

