// IVB14 checksum14: 797231401
/*-----------------------------------------------------------------
File14 name     : ahb_master_agent14.sv
Created14       : Wed14 May14 19 15:42:20 2010
Description14   : This14 file implements14 the master14 agent14
Notes14         :
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV14
`define AHB_MASTER_AGENT_SV14

//------------------------------------------------------------------------------
//
// CLASS14: ahb_master_agent14
//
//------------------------------------------------------------------------------

class ahb_master_agent14 extends uvm_agent;

  //  This14 field determines14 whether14 an agent14 is active or passive14.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor14 monitor14;
  ahb_master_sequencer14 sequencer;
  ahb_master_driver14 driver;
  
  /***************************************************************************
   IVB14-NOTE14 : OPTIONAL14 : master14 Agent14 : Agents14
   -------------------------------------------------------------------------
   Add master14 fields, events and methods14.
   For14 each field you add:
     o Update the `uvm_component_utils_begin macro14 to get various14 UVM utilities14
       for this attribute14.
   ***************************************************************************/

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent14)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent14

  // UVM build() phase
  function void ahb_master_agent14::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor14 = ahb_master_monitor14::type_id::create("monitor14", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer14::type_id::create("sequencer", this);
      driver = ahb_master_driver14::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent14::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds14 the driver to the sequencer using consumer14-producer14 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV14

