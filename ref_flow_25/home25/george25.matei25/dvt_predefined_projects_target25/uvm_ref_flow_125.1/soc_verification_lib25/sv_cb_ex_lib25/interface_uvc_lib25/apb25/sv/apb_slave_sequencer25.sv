/*******************************************************************************
  FILE : apb_slave_sequencer25.sv
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

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV25
`define APB_SLAVE_SEQUENCER_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_slave_sequencer25 declaration25
//------------------------------------------------------------------------------

class apb_slave_sequencer25 extends uvm_sequencer #(apb_transfer25);

  uvm_blocking_peek_port#(apb_transfer25) addr_trans_port25;

  apb_slave_config25 cfg;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer25)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor25
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port25 = new("addr_trans_port25", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config25)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG25", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer25

`endif // APB_SLAVE_SEQUENCER_SV25
