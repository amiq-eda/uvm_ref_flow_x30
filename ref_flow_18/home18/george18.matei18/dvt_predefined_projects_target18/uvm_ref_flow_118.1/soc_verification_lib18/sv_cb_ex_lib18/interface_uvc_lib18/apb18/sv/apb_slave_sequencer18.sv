/*******************************************************************************
  FILE : apb_slave_sequencer18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV18
`define APB_SLAVE_SEQUENCER_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_slave_sequencer18 declaration18
//------------------------------------------------------------------------------

class apb_slave_sequencer18 extends uvm_sequencer #(apb_transfer18);

  uvm_blocking_peek_port#(apb_transfer18) addr_trans_port18;

  apb_slave_config18 cfg;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer18)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor18
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port18 = new("addr_trans_port18", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config18)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG18", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer18

`endif // APB_SLAVE_SEQUENCER_SV18
