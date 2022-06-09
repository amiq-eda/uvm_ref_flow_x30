// IVB12 checksum12: 797231401
/*-----------------------------------------------------------------
File12 name     : ahb_master_agent12.sv
Created12       : Wed12 May12 19 15:42:20 2010
Description12   : This12 file implements12 the master12 agent12
Notes12         :
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV12
`define AHB_MASTER_AGENT_SV12

//------------------------------------------------------------------------------
//
// CLASS12: ahb_master_agent12
//
//------------------------------------------------------------------------------

class ahb_master_agent12 extends uvm_agent;

  //  This12 field determines12 whether12 an agent12 is active or passive12.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor12 monitor12;
  ahb_master_sequencer12 sequencer;
  ahb_master_driver12 driver;
  
  /***************************************************************************
   IVB12-NOTE12 : OPTIONAL12 : master12 Agent12 : Agents12
   -------------------------------------------------------------------------
   Add master12 fields, events and methods12.
   For12 each field you add:
     o Update the `uvm_component_utils_begin macro12 to get various12 UVM utilities12
       for this attribute12.
   ***************************************************************************/

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent12)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor12 - required12 syntax12 for UVM automation12 and utilities12
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent12

  // UVM build() phase
  function void ahb_master_agent12::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor12 = ahb_master_monitor12::type_id::create("monitor12", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer12::type_id::create("sequencer", this);
      driver = ahb_master_driver12::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent12::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds12 the driver to the sequencer using consumer12-producer12 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV12

