/*******************************************************************************
  FILE : apb_slave_sequencer14.sv
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV14
`define APB_SLAVE_SEQUENCER_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_slave_sequencer14 declaration14
//------------------------------------------------------------------------------

class apb_slave_sequencer14 extends uvm_sequencer #(apb_transfer14);

  uvm_blocking_peek_port#(apb_transfer14) addr_trans_port14;

  apb_slave_config14 cfg;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer14)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor14
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port14 = new("addr_trans_port14", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config14)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG14", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer14

`endif // APB_SLAVE_SEQUENCER_SV14
