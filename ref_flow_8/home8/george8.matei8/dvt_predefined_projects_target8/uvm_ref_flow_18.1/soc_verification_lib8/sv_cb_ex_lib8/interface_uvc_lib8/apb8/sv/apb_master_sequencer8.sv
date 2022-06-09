/*******************************************************************************
  FILE : apb_master_sequencer8.sv
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV8
`define APB_MASTER_SEQUENCER_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_master_sequencer8 declaration8
//------------------------------------------------------------------------------

class apb_master_sequencer8 extends uvm_sequencer #(apb_transfer8);

  // Config8 in case it is needed by the sequencer
  apb_config8 cfg;

  bit tful8;   //KATHLEEN8 _REMOVE8 THIS8 LATER8
  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer8)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor8
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config8)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG8", "apb_config8 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer8

`endif // APB_MASTER_SEQUENCER_SV8
