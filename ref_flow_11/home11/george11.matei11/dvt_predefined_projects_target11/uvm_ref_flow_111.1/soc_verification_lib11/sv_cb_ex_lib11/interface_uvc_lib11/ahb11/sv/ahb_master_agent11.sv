// IVB11 checksum11: 797231401
/*-----------------------------------------------------------------
File11 name     : ahb_master_agent11.sv
Created11       : Wed11 May11 19 15:42:20 2010
Description11   : This11 file implements11 the master11 agent11
Notes11         :
-----------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV11
`define AHB_MASTER_AGENT_SV11

//------------------------------------------------------------------------------
//
// CLASS11: ahb_master_agent11
//
//------------------------------------------------------------------------------

class ahb_master_agent11 extends uvm_agent;

  //  This11 field determines11 whether11 an agent11 is active or passive11.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor11 monitor11;
  ahb_master_sequencer11 sequencer;
  ahb_master_driver11 driver;
  
  /***************************************************************************
   IVB11-NOTE11 : OPTIONAL11 : master11 Agent11 : Agents11
   -------------------------------------------------------------------------
   Add master11 fields, events and methods11.
   For11 each field you add:
     o Update the `uvm_component_utils_begin macro11 to get various11 UVM utilities11
       for this attribute11.
   ***************************************************************************/

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent11)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor11 - required11 syntax11 for UVM automation11 and utilities11
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent11

  // UVM build() phase
  function void ahb_master_agent11::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor11 = ahb_master_monitor11::type_id::create("monitor11", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer11::type_id::create("sequencer", this);
      driver = ahb_master_driver11::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent11::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds11 the driver to the sequencer using consumer11-producer11 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV11

