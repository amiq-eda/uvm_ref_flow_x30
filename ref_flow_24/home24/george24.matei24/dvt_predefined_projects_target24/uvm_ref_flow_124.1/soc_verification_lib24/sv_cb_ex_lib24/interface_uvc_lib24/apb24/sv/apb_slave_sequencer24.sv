/*******************************************************************************
  FILE : apb_slave_sequencer24.sv
*******************************************************************************/
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

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV24
`define APB_SLAVE_SEQUENCER_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_slave_sequencer24 declaration24
//------------------------------------------------------------------------------

class apb_slave_sequencer24 extends uvm_sequencer #(apb_transfer24);

  uvm_blocking_peek_port#(apb_transfer24) addr_trans_port24;

  apb_slave_config24 cfg;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer24)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor24
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port24 = new("addr_trans_port24", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config24)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG24", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer24

`endif // APB_SLAVE_SEQUENCER_SV24
