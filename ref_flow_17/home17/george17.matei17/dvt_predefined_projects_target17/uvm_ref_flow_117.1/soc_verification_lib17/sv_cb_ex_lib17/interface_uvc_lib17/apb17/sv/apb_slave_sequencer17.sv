/*******************************************************************************
  FILE : apb_slave_sequencer17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV17
`define APB_SLAVE_SEQUENCER_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_slave_sequencer17 declaration17
//------------------------------------------------------------------------------

class apb_slave_sequencer17 extends uvm_sequencer #(apb_transfer17);

  uvm_blocking_peek_port#(apb_transfer17) addr_trans_port17;

  apb_slave_config17 cfg;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer17)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor17
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port17 = new("addr_trans_port17", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config17)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG17", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer17

`endif // APB_SLAVE_SEQUENCER_SV17
