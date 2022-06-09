/*******************************************************************************
  FILE : apb_master_sequencer24.sv
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


`ifndef APB_MASTER_SEQUENCER_SV24
`define APB_MASTER_SEQUENCER_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_master_sequencer24 declaration24
//------------------------------------------------------------------------------

class apb_master_sequencer24 extends uvm_sequencer #(apb_transfer24);

  // Config24 in case it is needed by the sequencer
  apb_config24 cfg;

  bit tful24;   //KATHLEEN24 _REMOVE24 THIS24 LATER24
  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer24)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor24
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config24)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG24", "apb_config24 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer24

`endif // APB_MASTER_SEQUENCER_SV24
