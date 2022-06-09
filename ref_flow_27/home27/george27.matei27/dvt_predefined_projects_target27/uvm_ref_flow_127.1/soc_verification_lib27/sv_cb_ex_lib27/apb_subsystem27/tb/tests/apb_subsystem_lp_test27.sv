/*-------------------------------------------------------------------------
File27 name   : lp_shutdown_urt127.sv
Title27       : Test27 Case27
Project27     :
Created27     :
Description27 : One27 test case for the APB27-UART27 Environment27
Notes27       : The test creates27 a apb_subsystem_tb27 and sets27 the default
            : sequence for the sequencer as lp_shutdown_uart127
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

class apb_subsystem_lp_test27 extends uvm_test;

  apb_subsystem_tb27 ve27;

  `uvm_component_utils(apb_subsystem_lp_test27)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor27", "ahb_monitor27");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve27.virtual_sequencer27.run_phase",
          "default_sequence", lp_shutdown_rand27::type_id::get());
    ve27 = apb_subsystem_tb27::type_id::create("ve27", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test27
