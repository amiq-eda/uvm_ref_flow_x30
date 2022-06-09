/*******************************************************************************
  FILE : apb_slave_sequencer9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV9
`define APB_SLAVE_SEQUENCER_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_slave_sequencer9 declaration9
//------------------------------------------------------------------------------

class apb_slave_sequencer9 extends uvm_sequencer #(apb_transfer9);

  uvm_blocking_peek_port#(apb_transfer9) addr_trans_port9;

  apb_slave_config9 cfg;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer9)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor9
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port9 = new("addr_trans_port9", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config9)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG9", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer9

`endif // APB_SLAVE_SEQUENCER_SV9
