/*-------------------------------------------------------------------------
File20 name   : lp_shutdown_urt120.sv
Title20       : Test20 Case20
Project20     :
Created20     :
Description20 : One20 test case for the APB20-UART20 Environment20
Notes20       : The test creates20 a apb_subsystem_tb20 and sets20 the default
            : sequence for the sequencer as lp_shutdown_uart120
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

class apb_subsystem_lp_test20 extends uvm_test;

  apb_subsystem_tb20 ve20;

  `uvm_component_utils(apb_subsystem_lp_test20)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor20", "ahb_monitor20");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve20.virtual_sequencer20.run_phase",
          "default_sequence", lp_shutdown_rand20::type_id::get());
    ve20 = apb_subsystem_tb20::type_id::create("ve20", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test20
