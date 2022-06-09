/*-------------------------------------------------------------------------
File19 name   : apb_gpio_simple_test19.sv
Title19       : Test19 Case19
Project19     :
Created19     :
Description19 : One19 test case for the APB19-GPIO19 data PATH19
Notes19       : The test creates19 a apb_subsystem_tb19 and sets19 the default
            : sequence for the sequencer as apb_gpio_incr_payload19
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

class apb_gpio_simple_test19 extends uvm_test;

  apb_subsystem_tb19 ve19;

  `uvm_component_utils(apb_gpio_simple_test19)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    //Move19 set_string19 to be a config parameter
    set_type_override("ahb_master_monitor19", "ahb_monitor19");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve19.virtual_sequencer19.run_phase",
          "default_sequence", apb_gpio_simple_vseq19::type_id::get());
    ve19 = apb_subsystem_tb19::type_id::create("ve19", this);
  endfunction : build_phase

endclass
