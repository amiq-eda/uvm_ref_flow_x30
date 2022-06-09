// IVB10 checksum10: 797231401
/*-----------------------------------------------------------------
File10 name     : ahb_master_agent10.sv
Created10       : Wed10 May10 19 15:42:20 2010
Description10   : This10 file implements10 the master10 agent10
Notes10         :
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV10
`define AHB_MASTER_AGENT_SV10

//------------------------------------------------------------------------------
//
// CLASS10: ahb_master_agent10
//
//------------------------------------------------------------------------------

class ahb_master_agent10 extends uvm_agent;
    
  //  This10 field determines10 whether10 an agent10 is active or passive10.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor10 monitor10;
  ahb_master_sequencer10 sequencer;
  ahb_master_driver10 driver;
  
  /***************************************************************************
   IVB10-NOTE10 : OPTIONAL10 : master10 Agent10 : Agents10
   -------------------------------------------------------------------------
   Add master10 fields, events and methods10.
   For10 each field you add:
     o Update the `uvm_component_utils_begin macro10 to get various10 UVM utilities10
       for this attribute10.
   ***************************************************************************/

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent10)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor10 - required10 syntax10 for UVM automation10 and utilities10
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent10

  // UVM build() phase
  function void ahb_master_agent10::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor10 = ahb_master_monitor10::type_id::create("monitor10", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer10::type_id::create("sequencer", this);
      driver = ahb_master_driver10::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent10::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds10 the driver to the sequencer using consumer10-producer10 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV10

