/*-------------------------------------------------------------------------
File9 name   : apb_spi_simple_test9.sv
Title9       : Test9 Case9
Project9     :
Created9     :
Description9 : One9 test case for the APB9-SPI9 data PATH9
Notes9       : The test creates9 a apb_subsystem_tb9 and sets9 the default
            : sequence for the sequencer as apb_spi_incr_payload9
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

class apb_spi_simple_test9 extends uvm_test;

  apb_subsystem_tb9 ve9;

  `uvm_component_utils(apb_spi_simple_test9)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor9", "ahb_monitor9");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve9.virtual_sequencer9.run_phase",
          "default_sequence", apb_spi_incr_payload9::type_id::get());
    ve9 = apb_subsystem_tb9::type_id::create("ve9", this);
  endfunction : build_phase

endclass
