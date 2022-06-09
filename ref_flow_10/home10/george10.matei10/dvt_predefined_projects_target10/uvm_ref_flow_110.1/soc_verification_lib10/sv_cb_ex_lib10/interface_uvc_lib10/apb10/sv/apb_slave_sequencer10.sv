/*******************************************************************************
  FILE : apb_slave_sequencer10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV10
`define APB_SLAVE_SEQUENCER_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_slave_sequencer10 declaration10
//------------------------------------------------------------------------------

class apb_slave_sequencer10 extends uvm_sequencer #(apb_transfer10);

  uvm_blocking_peek_port#(apb_transfer10) addr_trans_port10;

  apb_slave_config10 cfg;

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer10)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor10
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port10 = new("addr_trans_port10", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config10)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG10", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer10

`endif // APB_SLAVE_SEQUENCER_SV10
