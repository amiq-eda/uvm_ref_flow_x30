/*******************************************************************************
  FILE : apb_master_sequencer27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV27
`define APB_MASTER_SEQUENCER_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_master_sequencer27 declaration27
//------------------------------------------------------------------------------

class apb_master_sequencer27 extends uvm_sequencer #(apb_transfer27);

  // Config27 in case it is needed by the sequencer
  apb_config27 cfg;

  bit tful27;   //KATHLEEN27 _REMOVE27 THIS27 LATER27
  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer27)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor27
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config27)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG27", "apb_config27 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer27

`endif // APB_MASTER_SEQUENCER_SV27
