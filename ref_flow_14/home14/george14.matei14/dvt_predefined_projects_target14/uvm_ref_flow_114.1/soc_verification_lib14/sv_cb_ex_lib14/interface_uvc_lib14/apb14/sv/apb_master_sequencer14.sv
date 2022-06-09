/*******************************************************************************
  FILE : apb_master_sequencer14.sv
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


`ifndef APB_MASTER_SEQUENCER_SV14
`define APB_MASTER_SEQUENCER_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_master_sequencer14 declaration14
//------------------------------------------------------------------------------

class apb_master_sequencer14 extends uvm_sequencer #(apb_transfer14);

  // Config14 in case it is needed by the sequencer
  apb_config14 cfg;

  bit tful14;   //KATHLEEN14 _REMOVE14 THIS14 LATER14
  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer14)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor14
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config14)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG14", "apb_config14 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer14

`endif // APB_MASTER_SEQUENCER_SV14
