/*-------------------------------------------------------------------------
File16 name   : apb_gpio_simple_test16.sv
Title16       : Test16 Case16
Project16     :
Created16     :
Description16 : One16 test case for the APB16-GPIO16 data PATH16
Notes16       : The test creates16 a apb_subsystem_tb16 and sets16 the default
            : sequence for the sequencer as apb_gpio_incr_payload16
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

class apb_gpio_simple_test16 extends uvm_test;

  apb_subsystem_tb16 ve16;

  `uvm_component_utils(apb_gpio_simple_test16)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    //Move16 set_string16 to be a config parameter
    set_type_override("ahb_master_monitor16", "ahb_monitor16");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve16.virtual_sequencer16.run_phase",
          "default_sequence", apb_gpio_simple_vseq16::type_id::get());
    ve16 = apb_subsystem_tb16::type_id::create("ve16", this);
  endfunction : build_phase

endclass
