/*******************************************************************************
  FILE : apb_master_sequencer26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV26
`define APB_MASTER_SEQUENCER_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_master_sequencer26 declaration26
//------------------------------------------------------------------------------

class apb_master_sequencer26 extends uvm_sequencer #(apb_transfer26);

  // Config26 in case it is needed by the sequencer
  apb_config26 cfg;

  bit tful26;   //KATHLEEN26 _REMOVE26 THIS26 LATER26
  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer26)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor26
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config26)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG26", "apb_config26 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer26

`endif // APB_MASTER_SEQUENCER_SV26
