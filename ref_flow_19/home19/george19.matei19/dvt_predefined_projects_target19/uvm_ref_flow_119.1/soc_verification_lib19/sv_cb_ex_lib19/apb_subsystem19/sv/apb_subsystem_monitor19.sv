/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_monitor19.sv
Title19       : 
Project19     :
Created19     :
Description19 : Module19 env19, contains19 the instance of scoreboard19 and coverage19 model
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

class apb_subsystem_monitor19 extends uvm_monitor; 

  spi2ahb_scbd19 tx_scbd19;
  ahb2spi_scbd19 rx_scbd19;
   
  uvm_analysis_imp#(spi_pkg19::spi_csr19, apb_subsystem_monitor19) dut_csr_port_in19;

  `uvm_component_utils(apb_subsystem_monitor19)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in19 = new("dut_csr_port_in19", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard19
    tx_scbd19 = spi2ahb_scbd19::type_id::create("tx_scbd19",this);
    rx_scbd19 = ahb2spi_scbd19::type_id::create("rx_scbd19",this);

  endfunction : build_phase
  
  // pass19 csr_setting19 to scoreboard19 and coverage19
  function void write(spi_pkg19::spi_csr19 csr_setting19);
    tx_scbd19.assign_csr19(csr_setting19.csr_s19);
    rx_scbd19.assign_csr19(csr_setting19.csr_s19);
  endfunction

  function void set_slave_config19(apb_pkg19::apb_slave_config19 slave_cfg19);
    tx_scbd19.slave_cfg19 = slave_cfg19;
    rx_scbd19.slave_cfg19 = slave_cfg19;
  endfunction

endclass : apb_subsystem_monitor19

