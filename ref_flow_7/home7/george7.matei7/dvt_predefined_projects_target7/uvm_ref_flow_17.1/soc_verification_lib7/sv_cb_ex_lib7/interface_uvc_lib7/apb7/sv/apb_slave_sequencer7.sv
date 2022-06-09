/*******************************************************************************
  FILE : apb_slave_sequencer7.sv
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

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV7
`define APB_SLAVE_SEQUENCER_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_slave_sequencer7 declaration7
//------------------------------------------------------------------------------

class apb_slave_sequencer7 extends uvm_sequencer #(apb_transfer7);

  uvm_blocking_peek_port#(apb_transfer7) addr_trans_port7;

  apb_slave_config7 cfg;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer7)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor7
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port7 = new("addr_trans_port7", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config7)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG7", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer7

`endif // APB_SLAVE_SEQUENCER_SV7
