/*******************************************************************************
  FILE : apb_master_sequencer6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV6
`define APB_MASTER_SEQUENCER_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_master_sequencer6 declaration6
//------------------------------------------------------------------------------

class apb_master_sequencer6 extends uvm_sequencer #(apb_transfer6);

  // Config6 in case it is needed by the sequencer
  apb_config6 cfg;

  bit tful6;   //KATHLEEN6 _REMOVE6 THIS6 LATER6
  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer6)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor6
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config6)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG6", "apb_config6 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer6

`endif // APB_MASTER_SEQUENCER_SV6
