/*-------------------------------------------------------------------------
File26 name   : apb_spi_simple_test26.sv
Title26       : Test26 Case26
Project26     :
Created26     :
Description26 : One26 test case for the APB26-SPI26 data PATH26
Notes26       : The test creates26 a apb_subsystem_tb26 and sets26 the default
            : sequence for the sequencer as apb_spi_incr_payload26
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

class apb_spi_simple_test26 extends uvm_test;

  apb_subsystem_tb26 ve26;

  `uvm_component_utils(apb_spi_simple_test26)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor26", "ahb_monitor26");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve26.virtual_sequencer26.run_phase",
          "default_sequence", apb_spi_incr_payload26::type_id::get());
    ve26 = apb_subsystem_tb26::type_id::create("ve26", this);
  endfunction : build_phase

endclass
