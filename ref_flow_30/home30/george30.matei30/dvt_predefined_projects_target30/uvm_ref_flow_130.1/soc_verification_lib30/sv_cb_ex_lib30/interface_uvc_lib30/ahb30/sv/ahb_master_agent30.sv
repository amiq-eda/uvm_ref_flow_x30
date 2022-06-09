// IVB30 checksum30: 797231401
/*-----------------------------------------------------------------
File30 name     : ahb_master_agent30.sv
Created30       : Wed30 May30 19 15:42:20 2010
Description30   : This30 file implements30 the master30 agent30
Notes30         :
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV30
`define AHB_MASTER_AGENT_SV30

//------------------------------------------------------------------------------
//
// CLASS30: ahb_master_agent30
//
//------------------------------------------------------------------------------

class ahb_master_agent30 extends uvm_agent;

  //  This30 field determines30 whether30 an agent30 is active or passive30.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor30 monitor30;
  ahb_master_sequencer30 sequencer;
  ahb_master_driver30 driver;
  
  /***************************************************************************
   IVB30-NOTE30 : OPTIONAL30 : master30 Agent30 : Agents30
   -------------------------------------------------------------------------
   Add master30 fields, events and methods30.
   For30 each field you add:
     o Update the `uvm_component_utils_begin macro30 to get various30 UVM utilities30
       for this attribute30.
   ***************************************************************************/

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent30)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent30

  // UVM build() phase
  function void ahb_master_agent30::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor30 = ahb_master_monitor30::type_id::create("monitor30", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer30::type_id::create("sequencer", this);
      driver = ahb_master_driver30::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent30::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds30 the driver to the sequencer using consumer30-producer30 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV30

