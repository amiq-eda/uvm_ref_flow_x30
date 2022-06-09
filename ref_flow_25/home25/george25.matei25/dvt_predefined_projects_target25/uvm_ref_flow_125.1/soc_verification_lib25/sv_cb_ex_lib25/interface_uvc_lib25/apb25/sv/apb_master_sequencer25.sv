/*******************************************************************************
  FILE : apb_master_sequencer25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV25
`define APB_MASTER_SEQUENCER_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_master_sequencer25 declaration25
//------------------------------------------------------------------------------

class apb_master_sequencer25 extends uvm_sequencer #(apb_transfer25);

  // Config25 in case it is needed by the sequencer
  apb_config25 cfg;

  bit tful25;   //KATHLEEN25 _REMOVE25 THIS25 LATER25
  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer25)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor25
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config25)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG25", "apb_config25 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer25

`endif // APB_MASTER_SEQUENCER_SV25
