// IVB4 checksum4: 797231401
/*-----------------------------------------------------------------
File4 name     : ahb_master_agent4.sv
Created4       : Wed4 May4 19 15:42:20 2010
Description4   : This4 file implements4 the master4 agent4
Notes4         :
-----------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV4
`define AHB_MASTER_AGENT_SV4

//------------------------------------------------------------------------------
//
// CLASS4: ahb_master_agent4
//
//------------------------------------------------------------------------------

class ahb_master_agent4 extends uvm_agent;

  //  This4 field determines4 whether4 an agent4 is active or passive4.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor4 monitor4;
  ahb_master_sequencer4 sequencer;
  ahb_master_driver4 driver;
  
  /***************************************************************************
   IVB4-NOTE4 : OPTIONAL4 : master4 Agent4 : Agents4
   -------------------------------------------------------------------------
   Add master4 fields, events and methods4.
   For4 each field you add:
     o Update the `uvm_component_utils_begin macro4 to get various4 UVM utilities4
       for this attribute4.
   ***************************************************************************/

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent4)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor4 - required4 syntax4 for UVM automation4 and utilities4
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent4

  // UVM build() phase
  function void ahb_master_agent4::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor4 = ahb_master_monitor4::type_id::create("monitor4", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer4::type_id::create("sequencer", this);
      driver = ahb_master_driver4::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent4::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds4 the driver to the sequencer using consumer4-producer4 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV4

