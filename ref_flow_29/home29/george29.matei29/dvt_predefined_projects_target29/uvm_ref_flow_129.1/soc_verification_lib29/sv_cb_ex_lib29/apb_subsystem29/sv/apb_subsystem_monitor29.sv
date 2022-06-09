/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_monitor29.sv
Title29       : 
Project29     :
Created29     :
Description29 : Module29 env29, contains29 the instance of scoreboard29 and coverage29 model
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

class apb_subsystem_monitor29 extends uvm_monitor; 

  spi2ahb_scbd29 tx_scbd29;
  ahb2spi_scbd29 rx_scbd29;
   
  uvm_analysis_imp#(spi_pkg29::spi_csr29, apb_subsystem_monitor29) dut_csr_port_in29;

  `uvm_component_utils(apb_subsystem_monitor29)

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    dut_csr_port_in29 = new("dut_csr_port_in29", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // build scoreboard29
    tx_scbd29 = spi2ahb_scbd29::type_id::create("tx_scbd29",this);
    rx_scbd29 = ahb2spi_scbd29::type_id::create("rx_scbd29",this);

  endfunction : build_phase
  
  // pass29 csr_setting29 to scoreboard29 and coverage29
  function void write(spi_pkg29::spi_csr29 csr_setting29);
    tx_scbd29.assign_csr29(csr_setting29.csr_s29);
    rx_scbd29.assign_csr29(csr_setting29.csr_s29);
  endfunction

  function void set_slave_config29(apb_pkg29::apb_slave_config29 slave_cfg29);
    tx_scbd29.slave_cfg29 = slave_cfg29;
    rx_scbd29.slave_cfg29 = slave_cfg29;
  endfunction

endclass : apb_subsystem_monitor29

