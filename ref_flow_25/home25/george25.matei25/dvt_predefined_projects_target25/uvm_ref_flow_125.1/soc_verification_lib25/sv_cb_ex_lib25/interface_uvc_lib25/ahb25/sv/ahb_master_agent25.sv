// IVB25 checksum25: 797231401
/*-----------------------------------------------------------------
File25 name     : ahb_master_agent25.sv
Created25       : Wed25 May25 19 15:42:20 2010
Description25   : This25 file implements25 the master25 agent25
Notes25         :
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV25
`define AHB_MASTER_AGENT_SV25

//------------------------------------------------------------------------------
//
// CLASS25: ahb_master_agent25
//
//------------------------------------------------------------------------------

class ahb_master_agent25 extends uvm_agent;

  //  This25 field determines25 whether25 an agent25 is active or passive25.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor25 monitor25;
  ahb_master_sequencer25 sequencer;
  ahb_master_driver25 driver;
  
  /***************************************************************************
   IVB25-NOTE25 : OPTIONAL25 : master25 Agent25 : Agents25
   -------------------------------------------------------------------------
   Add master25 fields, events and methods25.
   For25 each field you add:
     o Update the `uvm_component_utils_begin macro25 to get various25 UVM utilities25
       for this attribute25.
   ***************************************************************************/

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent25)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent25

  // UVM build() phase
  function void ahb_master_agent25::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor25 = ahb_master_monitor25::type_id::create("monitor25", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer25::type_id::create("sequencer", this);
      driver = ahb_master_driver25::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent25::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds25 the driver to the sequencer using consumer25-producer25 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV25

