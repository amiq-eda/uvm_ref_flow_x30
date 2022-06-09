/*******************************************************************************
  FILE : apb_slave_sequencer30.sv
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV30
`define APB_SLAVE_SEQUENCER_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_slave_sequencer30 declaration30
//------------------------------------------------------------------------------

class apb_slave_sequencer30 extends uvm_sequencer #(apb_transfer30);

  uvm_blocking_peek_port#(apb_transfer30) addr_trans_port30;

  apb_slave_config30 cfg;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer30)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor30
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port30 = new("addr_trans_port30", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config30)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG30", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer30

`endif // APB_SLAVE_SEQUENCER_SV30
