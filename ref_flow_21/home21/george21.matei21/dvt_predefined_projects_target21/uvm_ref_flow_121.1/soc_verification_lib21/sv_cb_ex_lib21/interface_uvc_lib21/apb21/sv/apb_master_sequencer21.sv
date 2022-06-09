/*******************************************************************************
  FILE : apb_master_sequencer21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV21
`define APB_MASTER_SEQUENCER_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_master_sequencer21 declaration21
//------------------------------------------------------------------------------

class apb_master_sequencer21 extends uvm_sequencer #(apb_transfer21);

  // Config21 in case it is needed by the sequencer
  apb_config21 cfg;

  bit tful21;   //KATHLEEN21 _REMOVE21 THIS21 LATER21
  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer21)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor21
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config21)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG21", "apb_config21 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer21

`endif // APB_MASTER_SEQUENCER_SV21
