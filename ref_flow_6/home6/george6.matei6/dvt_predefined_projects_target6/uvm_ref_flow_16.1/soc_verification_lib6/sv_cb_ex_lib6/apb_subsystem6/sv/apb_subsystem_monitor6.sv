/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_monitor6.sv
Title6       : 
Project6     :
Created6     :
Description6 : Module6 env6, contains6 the instance of scoreboard6 and coverage6 model
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

class apb_subsystem_monitor6 extends uvm_monitor; 

  spi2ahb_scbd6 tx_scbd6;
  ahb2spi_scbd6 rx_scbd6;
   
  uvm_analysis_imp#(spi_pkg6::spi_csr6, apb_subsystem_monitor6) dut_csr_port_in6;

  `uvm_component_utils(apb_subsystem_monitor6)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in6 = new("dut_csr_port_in6", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard6
    tx_scbd6 = spi2ahb_scbd6::type_id::create("tx_scbd6",this);
    rx_scbd6 = ahb2spi_scbd6::type_id::create("rx_scbd6",this);

  endfunction : build_phase
  
  // pass6 csr_setting6 to scoreboard6 and coverage6
  function void write(spi_pkg6::spi_csr6 csr_setting6);
    tx_scbd6.assign_csr6(csr_setting6.csr_s6);
    rx_scbd6.assign_csr6(csr_setting6.csr_s6);
  endfunction

  function void set_slave_config6(apb_pkg6::apb_slave_config6 slave_cfg6);
    tx_scbd6.slave_cfg6 = slave_cfg6;
    rx_scbd6.slave_cfg6 = slave_cfg6;
  endfunction

endclass : apb_subsystem_monitor6

