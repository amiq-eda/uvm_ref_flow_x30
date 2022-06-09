/*******************************************************************************
  FILE : apb_slave_sequencer22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV22
`define APB_SLAVE_SEQUENCER_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_slave_sequencer22 declaration22
//------------------------------------------------------------------------------

class apb_slave_sequencer22 extends uvm_sequencer #(apb_transfer22);

  uvm_blocking_peek_port#(apb_transfer22) addr_trans_port22;

  apb_slave_config22 cfg;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer22)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor22
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port22 = new("addr_trans_port22", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config22)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG22", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer22

`endif // APB_SLAVE_SEQUENCER_SV22
