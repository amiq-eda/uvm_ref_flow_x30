/*******************************************************************************
  FILE : apb_master_sequencer17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV17
`define APB_MASTER_SEQUENCER_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_master_sequencer17 declaration17
//------------------------------------------------------------------------------

class apb_master_sequencer17 extends uvm_sequencer #(apb_transfer17);

  // Config17 in case it is needed by the sequencer
  apb_config17 cfg;

  bit tful17;   //KATHLEEN17 _REMOVE17 THIS17 LATER17
  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer17)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor17
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config17)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG17", "apb_config17 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer17

`endif // APB_MASTER_SEQUENCER_SV17
