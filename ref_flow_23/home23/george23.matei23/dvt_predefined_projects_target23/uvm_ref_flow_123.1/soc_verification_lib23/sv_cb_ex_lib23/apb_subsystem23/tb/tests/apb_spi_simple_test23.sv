/*-------------------------------------------------------------------------
File23 name   : apb_spi_simple_test23.sv
Title23       : Test23 Case23
Project23     :
Created23     :
Description23 : One23 test case for the APB23-SPI23 data PATH23
Notes23       : The test creates23 a apb_subsystem_tb23 and sets23 the default
            : sequence for the sequencer as apb_spi_incr_payload23
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

class apb_spi_simple_test23 extends uvm_test;

  apb_subsystem_tb23 ve23;

  `uvm_component_utils(apb_spi_simple_test23)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor23", "ahb_monitor23");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve23.virtual_sequencer23.run_phase",
          "default_sequence", apb_spi_incr_payload23::type_id::get());
    ve23 = apb_subsystem_tb23::type_id::create("ve23", this);
  endfunction : build_phase

endclass
