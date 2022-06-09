/*******************************************************************************
  FILE : apb_slave_sequencer20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV20
`define APB_SLAVE_SEQUENCER_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_slave_sequencer20 declaration20
//------------------------------------------------------------------------------

class apb_slave_sequencer20 extends uvm_sequencer #(apb_transfer20);

  uvm_blocking_peek_port#(apb_transfer20) addr_trans_port20;

  apb_slave_config20 cfg;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer20)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor20
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port20 = new("addr_trans_port20", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config20)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG20", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer20

`endif // APB_SLAVE_SEQUENCER_SV20
