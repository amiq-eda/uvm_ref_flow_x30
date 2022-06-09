// IVB17 checksum17: 797231401
/*-----------------------------------------------------------------
File17 name     : ahb_master_agent17.sv
Created17       : Wed17 May17 19 15:42:20 2010
Description17   : This17 file implements17 the master17 agent17
Notes17         :
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV17
`define AHB_MASTER_AGENT_SV17

//------------------------------------------------------------------------------
//
// CLASS17: ahb_master_agent17
//
//------------------------------------------------------------------------------

class ahb_master_agent17 extends uvm_agent;

  //  This17 field determines17 whether17 an agent17 is active or passive17.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor17 monitor17;
  ahb_master_sequencer17 sequencer;
  ahb_master_driver17 driver;
  
  /***************************************************************************
   IVB17-NOTE17 : OPTIONAL17 : master17 Agent17 : Agents17
   -------------------------------------------------------------------------
   Add master17 fields, events and methods17.
   For17 each field you add:
     o Update the `uvm_component_utils_begin macro17 to get various17 UVM utilities17
       for this attribute17.
   ***************************************************************************/

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent17)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent17

  // UVM build() phase
  function void ahb_master_agent17::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor17 = ahb_master_monitor17::type_id::create("monitor17", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer17::type_id::create("sequencer", this);
      driver = ahb_master_driver17::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent17::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds17 the driver to the sequencer using consumer17-producer17 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV17

