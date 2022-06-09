/*-------------------------------------------------------------------------
File12 name   : lp_shutdown_urt112.sv
Title12       : Test12 Case12
Project12     :
Created12     :
Description12 : One12 test case for the APB12-UART12 Environment12
Notes12       : The test creates12 a apb_subsystem_tb12 and sets12 the default
            : sequence for the sequencer as lp_shutdown_uart112
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

class apb_subsystem_lp_test12 extends uvm_test;

  apb_subsystem_tb12 ve12;

  `uvm_component_utils(apb_subsystem_lp_test12)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor12", "ahb_monitor12");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve12.virtual_sequencer12.run_phase",
          "default_sequence", lp_shutdown_rand12::type_id::get());
    ve12 = apb_subsystem_tb12::type_id::create("ve12", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test12
