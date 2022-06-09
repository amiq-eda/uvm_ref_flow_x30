/*******************************************************************************
  FILE : apb_slave_sequencer23.sv
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV23
`define APB_SLAVE_SEQUENCER_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_slave_sequencer23 declaration23
//------------------------------------------------------------------------------

class apb_slave_sequencer23 extends uvm_sequencer #(apb_transfer23);

  uvm_blocking_peek_port#(apb_transfer23) addr_trans_port23;

  apb_slave_config23 cfg;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer23)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor23
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port23 = new("addr_trans_port23", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config23)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG23", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer23

`endif // APB_SLAVE_SEQUENCER_SV23
