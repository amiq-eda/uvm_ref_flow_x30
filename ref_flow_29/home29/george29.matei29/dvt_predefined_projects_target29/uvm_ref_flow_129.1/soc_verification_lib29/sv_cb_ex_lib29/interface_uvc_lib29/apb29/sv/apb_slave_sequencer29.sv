/*******************************************************************************
  FILE : apb_slave_sequencer29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

                                                                                
`ifndef APB_SLAVE_SEQUENCER_SV29
`define APB_SLAVE_SEQUENCER_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_slave_sequencer29 declaration29
//------------------------------------------------------------------------------

class apb_slave_sequencer29 extends uvm_sequencer #(apb_transfer29);

  uvm_blocking_peek_port#(apb_transfer29) addr_trans_port29;

  apb_slave_config29 cfg;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_sequencer29)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor29
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_trans_port29 = new("addr_trans_port29", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(apb_slave_config29)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG29", "No configuration set")
  endfunction : build_phase

endclass : apb_slave_sequencer29

`endif // APB_SLAVE_SEQUENCER_SV29
