/*******************************************************************************
  FILE : apb_slave_sequencer28.sv
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV28
`define APB_SLAVE_SEQUENCER_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_slave_sequencer28 declaration28
//------------------------------------------------------------------------------

class apb_slave_sequencer28 extends uvm_sequencer #(apb_transfer28);

  uvm_blocking_peek_port#(apb_transfer28) addr_trans_port28;

  apb_slave_config28 cfg;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer28)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor28
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port28 = new("addr_trans_port28", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config28)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG28", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer28

`endif // APB_SLAVE_SEQUENCER_SV28
