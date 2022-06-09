/*-------------------------------------------------------------------------
File30 name   : apb_spi_simple_test30.sv
Title30       : Test30 Case30
Project30     :
Created30     :
Description30 : One30 test case for the APB30-SPI30 data PATH30
Notes30       : The test creates30 a apb_subsystem_tb30 and sets30 the default
            : sequence for the sequencer as apb_spi_incr_payload30
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

class apb_spi_simple_test30 extends uvm_test;

  apb_subsystem_tb30 ve30;

  `uvm_component_utils(apb_spi_simple_test30)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor30", "ahb_monitor30");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve30.virtual_sequencer30.run_phase",
          "default_sequence", apb_spi_incr_payload30::type_id::get());
    ve30 = apb_subsystem_tb30::type_id::create("ve30", this);
  endfunction : build_phase

endclass
