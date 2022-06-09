/*-------------------------------------------------------------------------
File25 name   : lp_shutdown_urt125.sv
Title25       : Test25 Case25
Project25     :
Created25     :
Description25 : One25 test case for the APB25-UART25 Environment25
Notes25       : The test creates25 a apb_subsystem_tb25 and sets25 the default
            : sequence for the sequencer as lp_shutdown_uart125
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

class lp_shutdown_urt125 extends uvm_test;

  apb_subsystem_tb25 ve25;

  `uvm_component_utils(lp_shutdown_urt125)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor25", "ahb_monitor25");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve25.virtual_sequencer25.run_phase",
          "default_sequence", lp_shutdown_uart125::type_id::get());
    ve25 = apb_subsystem_tb25::type_id::create("ve25", this);
  endfunction : build_phase

endclass : lp_shutdown_urt125
