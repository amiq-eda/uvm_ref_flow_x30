// IVB8 checksum8: 797231401
/*-----------------------------------------------------------------
File8 name     : ahb_master_agent8.sv
Created8       : Wed8 May8 19 15:42:20 2010
Description8   : This8 file implements8 the master8 agent8
Notes8         :
-----------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV8
`define AHB_MASTER_AGENT_SV8

//------------------------------------------------------------------------------
//
// CLASS8: ahb_master_agent8
//
//------------------------------------------------------------------------------

class ahb_master_agent8 extends uvm_agent;

  //  This8 field determines8 whether8 an agent8 is active or passive8.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor8 monitor8;
  ahb_master_sequencer8 sequencer;
  ahb_master_driver8 driver;
  
  /***************************************************************************
   IVB8-NOTE8 : OPTIONAL8 : master8 Agent8 : Agents8
   -------------------------------------------------------------------------
   Add master8 fields, events and methods8.
   For8 each field you add:
     o Update the `uvm_component_utils_begin macro8 to get various8 UVM utilities8
       for this attribute8.
   ***************************************************************************/

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent8)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor8 - required8 syntax8 for UVM automation8 and utilities8
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent8

  // UVM build() phase
  function void ahb_master_agent8::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor8 = ahb_master_monitor8::type_id::create("monitor8", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer8::type_id::create("sequencer", this);
      driver = ahb_master_driver8::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent8::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds8 the driver to the sequencer using consumer8-producer8 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV8

