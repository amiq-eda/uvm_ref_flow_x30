// IVB29 checksum29: 797231401
/*-----------------------------------------------------------------
File29 name     : ahb_master_agent29.sv
Created29       : Wed29 May29 19 15:42:20 2010
Description29   : This29 file implements29 the master29 agent29
Notes29         :
-----------------------------------------------------------------*/
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


`ifndef AHB_MASTER_AGENT_SV29
`define AHB_MASTER_AGENT_SV29

//------------------------------------------------------------------------------
//
// CLASS29: ahb_master_agent29
//
//------------------------------------------------------------------------------

class ahb_master_agent29 extends uvm_agent;

  //  This29 field determines29 whether29 an agent29 is active or passive29.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor29 monitor29;
  ahb_master_sequencer29 sequencer;
  ahb_master_driver29 driver;
  
  /***************************************************************************
   IVB29-NOTE29 : OPTIONAL29 : master29 Agent29 : Agents29
   -------------------------------------------------------------------------
   Add master29 fields, events and methods29.
   For29 each field you add:
     o Update the `uvm_component_utils_begin macro29 to get various29 UVM utilities29
       for this attribute29.
   ***************************************************************************/

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent29)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor29 - required29 syntax29 for UVM automation29 and utilities29
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent29

  // UVM build() phase
  function void ahb_master_agent29::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor29 = ahb_master_monitor29::type_id::create("monitor29", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer29::type_id::create("sequencer", this);
      driver = ahb_master_driver29::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent29::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds29 the driver to the sequencer using consumer29-producer29 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV29

