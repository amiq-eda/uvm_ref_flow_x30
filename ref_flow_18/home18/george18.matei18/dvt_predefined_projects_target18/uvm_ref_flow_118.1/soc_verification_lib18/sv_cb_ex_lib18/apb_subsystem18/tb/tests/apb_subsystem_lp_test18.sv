/*-------------------------------------------------------------------------
File18 name   : lp_shutdown_urt118.sv
Title18       : Test18 Case18
Project18     :
Created18     :
Description18 : One18 test case for the APB18-UART18 Environment18
Notes18       : The test creates18 a apb_subsystem_tb18 and sets18 the default
            : sequence for the sequencer as lp_shutdown_uart118
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

class apb_subsystem_lp_test18 extends uvm_test;

  apb_subsystem_tb18 ve18;

  `uvm_component_utils(apb_subsystem_lp_test18)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor18", "ahb_monitor18");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve18.virtual_sequencer18.run_phase",
          "default_sequence", lp_shutdown_rand18::type_id::get());
    ve18 = apb_subsystem_tb18::type_id::create("ve18", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test18
