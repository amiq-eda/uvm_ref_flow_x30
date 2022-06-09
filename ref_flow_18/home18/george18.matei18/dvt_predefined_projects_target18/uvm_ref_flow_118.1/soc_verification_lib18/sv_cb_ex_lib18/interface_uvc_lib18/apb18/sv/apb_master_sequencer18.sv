/*******************************************************************************
  FILE : apb_master_sequencer18.sv
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


`ifndef APB_MASTER_SEQUENCER_SV18
`define APB_MASTER_SEQUENCER_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_master_sequencer18 declaration18
//------------------------------------------------------------------------------

class apb_master_sequencer18 extends uvm_sequencer #(apb_transfer18);

  // Config18 in case it is needed by the sequencer
  apb_config18 cfg;

  bit tful18;   //KATHLEEN18 _REMOVE18 THIS18 LATER18
  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer18)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor18
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config18)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG18", "apb_config18 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer18

`endif // APB_MASTER_SEQUENCER_SV18
