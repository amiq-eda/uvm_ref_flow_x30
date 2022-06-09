/*******************************************************************************
  FILE : apb_master_sequencer7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV7
`define APB_MASTER_SEQUENCER_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_master_sequencer7 declaration7
//------------------------------------------------------------------------------

class apb_master_sequencer7 extends uvm_sequencer #(apb_transfer7);

  // Config7 in case it is needed by the sequencer
  apb_config7 cfg;

  bit tful7;   //KATHLEEN7 _REMOVE7 THIS7 LATER7
  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer7)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor7
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config7)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG7", "apb_config7 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer7

`endif // APB_MASTER_SEQUENCER_SV7
