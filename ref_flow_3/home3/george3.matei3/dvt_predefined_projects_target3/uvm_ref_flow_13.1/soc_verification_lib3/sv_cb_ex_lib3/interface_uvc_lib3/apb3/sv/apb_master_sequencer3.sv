/*******************************************************************************
  FILE : apb_master_sequencer3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV3
`define APB_MASTER_SEQUENCER_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_master_sequencer3 declaration3
//------------------------------------------------------------------------------

class apb_master_sequencer3 extends uvm_sequencer #(apb_transfer3);

  // Config3 in case it is needed by the sequencer
  apb_config3 cfg;

  bit tful3;   //KATHLEEN3 _REMOVE3 THIS3 LATER3
  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer3)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor3
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config3)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG3", "apb_config3 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer3

`endif // APB_MASTER_SEQUENCER_SV3
