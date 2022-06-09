/*******************************************************************************
  FILE : apb_master_sequencer4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQUENCER_SV4
`define APB_MASTER_SEQUENCER_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_master_sequencer4 declaration4
//------------------------------------------------------------------------------

class apb_master_sequencer4 extends uvm_sequencer #(apb_transfer4);

  // Config4 in case it is needed by the sequencer
  apb_config4 cfg;

  bit tful4;   //KATHLEEN4 _REMOVE4 THIS4 LATER4
  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(apb_master_sequencer4)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor4
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null)
        if (!uvm_config_db#(apb_config4)::get(this, "", "cfg", cfg))
        `uvm_warning("NOCONFIG4", "apb_config4 not set for this component")
  endfunction : build_phase

endclass : apb_master_sequencer4

`endif // APB_MASTER_SEQUENCER_SV4
