/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_monitor2.sv
Title2       : 
Project2     :
Created2     :
Description2 : Module2 env2, contains2 the instance of scoreboard2 and coverage2 model
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

class apb_subsystem_monitor2 extends uvm_monitor; 

  spi2ahb_scbd2 tx_scbd2;
  ahb2spi_scbd2 rx_scbd2;
   
  uvm_analysis_imp#(spi_pkg2::spi_csr2, apb_subsystem_monitor2) dut_csr_port_in2;

  `uvm_component_utils(apb_subsystem_monitor2)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in2 = new("dut_csr_port_in2", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard2
    tx_scbd2 = spi2ahb_scbd2::type_id::create("tx_scbd2",this);
    rx_scbd2 = ahb2spi_scbd2::type_id::create("rx_scbd2",this);

  endfunction : build_phase
  
  // pass2 csr_setting2 to scoreboard2 and coverage2
  function void write(spi_pkg2::spi_csr2 csr_setting2);
    tx_scbd2.assign_csr2(csr_setting2.csr_s2);
    rx_scbd2.assign_csr2(csr_setting2.csr_s2);
  endfunction

  function void set_slave_config2(apb_pkg2::apb_slave_config2 slave_cfg2);
    tx_scbd2.slave_cfg2 = slave_cfg2;
    rx_scbd2.slave_cfg2 = slave_cfg2;
  endfunction

endclass : apb_subsystem_monitor2

