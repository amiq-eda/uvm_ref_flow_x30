// IVB26 checksum26: 797231401
/*-----------------------------------------------------------------
File26 name     : ahb_master_agent26.sv
Created26       : Wed26 May26 19 15:42:20 2010
Description26   : This26 file implements26 the master26 agent26
Notes26         :
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV26
`define AHB_MASTER_AGENT_SV26

//------------------------------------------------------------------------------
//
// CLASS26: ahb_master_agent26
//
//------------------------------------------------------------------------------

class ahb_master_agent26 extends uvm_agent;

  //  This26 field determines26 whether26 an agent26 is active or passive26.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor26 monitor26;
  ahb_master_sequencer26 sequencer;
  ahb_master_driver26 driver;
  
  /***************************************************************************
   IVB26-NOTE26 : OPTIONAL26 : master26 Agent26 : Agents26
   -------------------------------------------------------------------------
   Add master26 fields, events and methods26.
   For26 each field you add:
     o Update the `uvm_component_utils_begin macro26 to get various26 UVM utilities26
       for this attribute26.
   ***************************************************************************/

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent26)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent26

  // UVM build() phase
  function void ahb_master_agent26::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor26 = ahb_master_monitor26::type_id::create("monitor26", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer26::type_id::create("sequencer", this);
      driver = ahb_master_driver26::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent26::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds26 the driver to the sequencer using consumer26-producer26 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV26

