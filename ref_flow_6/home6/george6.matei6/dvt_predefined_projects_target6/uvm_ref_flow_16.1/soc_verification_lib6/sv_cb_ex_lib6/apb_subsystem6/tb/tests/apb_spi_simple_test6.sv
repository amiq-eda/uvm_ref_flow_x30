/*-------------------------------------------------------------------------
File6 name   : apb_spi_simple_test6.sv
Title6       : Test6 Case6
Project6     :
Created6     :
Description6 : One6 test case for the APB6-SPI6 data PATH6
Notes6       : The test creates6 a apb_subsystem_tb6 and sets6 the default
            : sequence for the sequencer as apb_spi_incr_payload6
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

class apb_spi_simple_test6 extends uvm_test;

  apb_subsystem_tb6 ve6;

  `uvm_component_utils(apb_spi_simple_test6)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor6", "ahb_monitor6");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve6.virtual_sequencer6.run_phase",
          "default_sequence", apb_spi_incr_payload6::type_id::get());
    ve6 = apb_subsystem_tb6::type_id::create("ve6", this);
  endfunction : build_phase

endclass
