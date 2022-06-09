/*******************************************************************************
  FILE : apb_master_sequencer11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV11
`define APB_MASTER_SEQUENCER_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_master_sequencer11 declaration11
//------------------------------------------------------------------------------

class apb_master_sequencer11 extends uvm_sequencer #(apb_transfer11);

  // Config11 in case it is needed by the sequencer
  apb_config11 cfg;

  bit tful11;   //KATHLEEN11 _REMOVE11 THIS11 LATER11
  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer11)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor11
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config11)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG11", "apb_config11 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer11

`endif // APB_MASTER_SEQUENCER_SV11
