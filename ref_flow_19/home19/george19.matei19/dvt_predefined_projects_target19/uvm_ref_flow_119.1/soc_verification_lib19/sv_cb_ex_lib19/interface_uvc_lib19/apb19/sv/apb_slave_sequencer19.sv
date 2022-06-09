/*******************************************************************************
  FILE : apb_slave_sequencer19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV19
`define APB_SLAVE_SEQUENCER_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_slave_sequencer19 declaration19
//------------------------------------------------------------------------------

class apb_slave_sequencer19 extends uvm_sequencer #(apb_transfer19);

  uvm_blocking_peek_port#(apb_transfer19) addr_trans_port19;

  apb_slave_config19 cfg;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer19)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor19
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port19 = new("addr_trans_port19", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config19)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG19", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer19

`endif // APB_SLAVE_SEQUENCER_SV19
