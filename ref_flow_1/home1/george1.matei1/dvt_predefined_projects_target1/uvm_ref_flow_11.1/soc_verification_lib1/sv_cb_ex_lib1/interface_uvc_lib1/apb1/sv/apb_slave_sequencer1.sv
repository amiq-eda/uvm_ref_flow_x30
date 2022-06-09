/*******************************************************************************
  FILE : apb_slave_sequencer1.sv
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV1
`define APB_SLAVE_SEQUENCER_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_slave_sequencer1 declaration1
//------------------------------------------------------------------------------

class apb_slave_sequencer1 extends uvm_sequencer #(apb_transfer1);

  uvm_blocking_peek_port#(apb_transfer1) addr_trans_port1;

  apb_slave_config1 cfg;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer1)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor1
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port1 = new("addr_trans_port1", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config1)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG1", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer1

`endif // APB_SLAVE_SEQUENCER_SV1
