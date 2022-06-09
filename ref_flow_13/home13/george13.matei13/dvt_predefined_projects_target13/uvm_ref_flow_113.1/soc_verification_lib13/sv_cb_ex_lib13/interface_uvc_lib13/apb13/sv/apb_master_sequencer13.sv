/*******************************************************************************
  FILE : apb_master_sequencer13.sv
*******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV13
`define APB_MASTER_SEQUENCER_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_master_sequencer13 declaration13
//------------------------------------------------------------------------------

class apb_master_sequencer13 extends uvm_sequencer #(apb_transfer13);

  // Config13 in case it is needed by the sequencer
  apb_config13 cfg;

  bit tful13;   //KATHLEEN13 _REMOVE13 THIS13 LATER13
  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer13)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor13
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config13)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG13", "apb_config13 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer13

`endif // APB_MASTER_SEQUENCER_SV13
