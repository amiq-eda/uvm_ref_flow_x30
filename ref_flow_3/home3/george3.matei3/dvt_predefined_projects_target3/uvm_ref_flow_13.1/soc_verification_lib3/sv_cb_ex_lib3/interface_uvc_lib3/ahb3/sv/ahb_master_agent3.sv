// IVB3 checksum3: 797231401
/*-----------------------------------------------------------------
File3 name     : ahb_master_agent3.sv
Created3       : Wed3 May3 19 15:42:20 2010
Description3   : This3 file implements3 the master3 agent3
Notes3         :
-----------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV3
`define AHB_MASTER_AGENT_SV3

//------------------------------------------------------------------------------
//
// CLASS3: ahb_master_agent3
//
//------------------------------------------------------------------------------

class ahb_master_agent3 extends uvm_agent;

  //  This3 field determines3 whether3 an agent3 is active or passive3.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor3 monitor3;
  ahb_master_sequencer3 sequencer;
  ahb_master_driver3 driver;
  
  /***************************************************************************
   IVB3-NOTE3 : OPTIONAL3 : master3 Agent3 : Agents3
   -------------------------------------------------------------------------
   Add master3 fields, events and methods3.
   For3 each field you add:
     o Update the `uvm_component_utils_begin macro3 to get various3 UVM utilities3
       for this attribute3.
   ***************************************************************************/

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent3)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent3

  // UVM build() phase
  function void ahb_master_agent3::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor3 = ahb_master_monitor3::type_id::create("monitor3", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer3::type_id::create("sequencer", this);
      driver = ahb_master_driver3::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent3::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds3 the driver to the sequencer using consumer3-producer3 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV3

