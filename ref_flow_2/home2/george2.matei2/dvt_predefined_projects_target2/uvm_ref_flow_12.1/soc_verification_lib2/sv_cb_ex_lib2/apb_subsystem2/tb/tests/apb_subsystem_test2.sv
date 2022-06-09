/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_test2.sv
Title2       : Test2 Case2
Project2     :
Created2     :
Description2 : One2 test case for the APB2 Subsystem2 Environment2
Notes2       : The test creates2 a apb_subsystem_tb2 and sets2 the default
            : sequence for the sequencer as apb_subsystem_vseq2
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

class apb_subsystem_test2 extends uvm_test;

  apb_subsystem_tb2 ve2;

  `uvm_component_utils(apb_subsystem_test2)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor2", "ahb_monitor2");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve2.virtual_sequencer2.run_phase",
          "default_sequence", apb_subsystem_vseq2::type_id::get());
    ve2 = apb_subsystem_tb2::type_id::create("ve2", this);
  endfunction : build_phase

endclass : apb_subsystem_test2

