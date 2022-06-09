/*******************************************************************************
  FILE : apb_slave_sequencer12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV12
`define APB_SLAVE_SEQUENCER_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_slave_sequencer12 declaration12
//------------------------------------------------------------------------------

class apb_slave_sequencer12 extends uvm_sequencer #(apb_transfer12);

  uvm_blocking_peek_port#(apb_transfer12) addr_trans_port12;

  apb_slave_config12 cfg;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer12)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor12
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port12 = new("addr_trans_port12", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config12)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG12", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer12

`endif // APB_SLAVE_SEQUENCER_SV12
