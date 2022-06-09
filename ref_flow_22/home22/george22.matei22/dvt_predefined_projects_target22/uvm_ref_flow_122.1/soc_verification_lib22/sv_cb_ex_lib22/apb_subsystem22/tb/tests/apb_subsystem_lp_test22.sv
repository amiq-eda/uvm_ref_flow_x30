/*-------------------------------------------------------------------------
File22 name   : lp_shutdown_urt122.sv
Title22       : Test22 Case22
Project22     :
Created22     :
Description22 : One22 test case for the APB22-UART22 Environment22
Notes22       : The test creates22 a apb_subsystem_tb22 and sets22 the default
            : sequence for the sequencer as lp_shutdown_uart122
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

class apb_subsystem_lp_test22 extends uvm_test;

  apb_subsystem_tb22 ve22;

  `uvm_component_utils(apb_subsystem_lp_test22)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor22", "ahb_monitor22");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve22.virtual_sequencer22.run_phase",
          "default_sequence", lp_shutdown_rand22::type_id::get());
    ve22 = apb_subsystem_tb22::type_id::create("ve22", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test22
