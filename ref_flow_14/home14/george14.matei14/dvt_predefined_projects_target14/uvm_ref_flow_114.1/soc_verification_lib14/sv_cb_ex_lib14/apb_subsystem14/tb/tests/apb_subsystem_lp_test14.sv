/*-------------------------------------------------------------------------
File14 name   : lp_shutdown_urt114.sv
Title14       : Test14 Case14
Project14     :
Created14     :
Description14 : One14 test case for the APB14-UART14 Environment14
Notes14       : The test creates14 a apb_subsystem_tb14 and sets14 the default
            : sequence for the sequencer as lp_shutdown_uart114
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

class apb_subsystem_lp_test14 extends uvm_test;

  apb_subsystem_tb14 ve14;

  `uvm_component_utils(apb_subsystem_lp_test14)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor14", "ahb_monitor14");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve14.virtual_sequencer14.run_phase",
          "default_sequence", lp_shutdown_rand14::type_id::get());
    ve14 = apb_subsystem_tb14::type_id::create("ve14", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test14
