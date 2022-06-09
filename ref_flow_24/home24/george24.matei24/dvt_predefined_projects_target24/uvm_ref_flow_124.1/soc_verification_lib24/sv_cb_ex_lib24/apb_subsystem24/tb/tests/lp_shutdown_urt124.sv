/*-------------------------------------------------------------------------
File24 name   : lp_shutdown_urt124.sv
Title24       : Test24 Case24
Project24     :
Created24     :
Description24 : One24 test case for the APB24-UART24 Environment24
Notes24       : The test creates24 a apb_subsystem_tb24 and sets24 the default
            : sequence for the sequencer as lp_shutdown_uart124
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

class lp_shutdown_urt124 extends uvm_test;

  apb_subsystem_tb24 ve24;

  `uvm_component_utils(lp_shutdown_urt124)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor24", "ahb_monitor24");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve24.virtual_sequencer24.run_phase",
          "default_sequence", lp_shutdown_uart124::type_id::get());
    ve24 = apb_subsystem_tb24::type_id::create("ve24", this);
  endfunction : build_phase

endclass : lp_shutdown_urt124
