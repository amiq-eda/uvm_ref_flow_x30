/*******************************************************************************
  FILE : apb_master_sequencer5.sv
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV5
`define APB_MASTER_SEQUENCER_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_master_sequencer5 declaration5
//------------------------------------------------------------------------------

class apb_master_sequencer5 extends uvm_sequencer #(apb_transfer5);

  // Config5 in case it is needed by the sequencer
  apb_config5 cfg;

  bit tful5;   //KATHLEEN5 _REMOVE5 THIS5 LATER5
  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer5)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor5
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config5)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG5", "apb_config5 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer5

`endif // APB_MASTER_SEQUENCER_SV5
