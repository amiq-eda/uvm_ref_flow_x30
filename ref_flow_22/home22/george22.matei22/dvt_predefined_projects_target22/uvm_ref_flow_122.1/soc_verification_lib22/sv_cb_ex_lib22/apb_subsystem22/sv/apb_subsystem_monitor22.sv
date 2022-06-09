/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_monitor22.sv
Title22       : 
Project22     :
Created22     :
Description22 : Module22 env22, contains22 the instance of scoreboard22 and coverage22 model
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

class apb_subsystem_monitor22 extends uvm_monitor; 

  spi2ahb_scbd22 tx_scbd22;
  ahb2spi_scbd22 rx_scbd22;
   
  uvm_analysis_imp#(spi_pkg22::spi_csr22, apb_subsystem_monitor22) dut_csr_port_in22;

  `uvm_component_utils(apb_subsystem_monitor22)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in22 = new("dut_csr_port_in22", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard22
    tx_scbd22 = spi2ahb_scbd22::type_id::create("tx_scbd22",this);
    rx_scbd22 = ahb2spi_scbd22::type_id::create("rx_scbd22",this);

  endfunction : build_phase
  
  // pass22 csr_setting22 to scoreboard22 and coverage22
  function void write(spi_pkg22::spi_csr22 csr_setting22);
    tx_scbd22.assign_csr22(csr_setting22.csr_s22);
    rx_scbd22.assign_csr22(csr_setting22.csr_s22);
  endfunction

  function void set_slave_config22(apb_pkg22::apb_slave_config22 slave_cfg22);
    tx_scbd22.slave_cfg22 = slave_cfg22;
    rx_scbd22.slave_cfg22 = slave_cfg22;
  endfunction

endclass : apb_subsystem_monitor22

