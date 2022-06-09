// IVB24 checksum24: 797231401
/*-----------------------------------------------------------------
File24 name     : ahb_master_agent24.sv
Created24       : Wed24 May24 19 15:42:20 2010
Description24   : This24 file implements24 the master24 agent24
Notes24         :
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV24
`define AHB_MASTER_AGENT_SV24

//------------------------------------------------------------------------------
//
// CLASS24: ahb_master_agent24
//
//------------------------------------------------------------------------------

class ahb_master_agent24 extends uvm_agent;

  //  This24 field determines24 whether24 an agent24 is active or passive24.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor24 monitor24;
  ahb_master_sequencer24 sequencer;
  ahb_master_driver24 driver;
  
  /***************************************************************************
   IVB24-NOTE24 : OPTIONAL24 : master24 Agent24 : Agents24
   -------------------------------------------------------------------------
   Add master24 fields, events and methods24.
   For24 each field you add:
     o Update the `uvm_component_utils_begin macro24 to get various24 UVM utilities24
       for this attribute24.
   ***************************************************************************/

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent24)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor24 - required24 syntax24 for UVM automation24 and utilities24
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent24

  // UVM build() phase
  function void ahb_master_agent24::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor24 = ahb_master_monitor24::type_id::create("monitor24", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer24::type_id::create("sequencer", this);
      driver = ahb_master_driver24::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent24::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds24 the driver to the sequencer using consumer24-producer24 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV24

