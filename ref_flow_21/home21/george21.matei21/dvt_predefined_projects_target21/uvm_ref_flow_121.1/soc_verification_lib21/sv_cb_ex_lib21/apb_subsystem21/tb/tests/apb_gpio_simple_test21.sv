/*-------------------------------------------------------------------------
File21 name   : apb_gpio_simple_test21.sv
Title21       : Test21 Case21
Project21     :
Created21     :
Description21 : One21 test case for the APB21-GPIO21 data PATH21
Notes21       : The test creates21 a apb_subsystem_tb21 and sets21 the default
            : sequence for the sequencer as apb_gpio_incr_payload21
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

class apb_gpio_simple_test21 extends uvm_test;

  apb_subsystem_tb21 ve21;

  `uvm_component_utils(apb_gpio_simple_test21)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    //Move21 set_string21 to be a config parameter
    set_type_override("ahb_master_monitor21", "ahb_monitor21");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve21.virtual_sequencer21.run_phase",
          "default_sequence", apb_gpio_simple_vseq21::type_id::get());
    ve21 = apb_subsystem_tb21::type_id::create("ve21", this);
  endfunction : build_phase

endclass
