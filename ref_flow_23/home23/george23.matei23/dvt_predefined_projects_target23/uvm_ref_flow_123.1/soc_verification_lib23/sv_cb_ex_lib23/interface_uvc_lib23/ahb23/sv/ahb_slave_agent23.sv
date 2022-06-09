// IVB23 checksum23: 1298481799
/*-----------------------------------------------------------------
File23 name     : ahb_slave_agent23.sv
Created23       : Wed23 May23 19 15:42:21 2010
Description23   : This23 file implements23 the slave23 agent23
Notes23         :
-----------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV23
`define AHB_SLAVE_AGENT_SV23

//------------------------------------------------------------------------------
//
// CLASS23: ahb_slave_agent23
//
//------------------------------------------------------------------------------

class ahb_slave_agent23 extends uvm_agent;
 
  // This23 field determines23 whether23 an agent23 is active or passive23.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor23 monitor23;
  ahb_slave_sequencer23 sequencer;
  ahb_slave_driver23 driver;
  
  /***************************************************************************
   IVB23-NOTE23 : OPTIONAL23 : slave23 Agent23 : Agents23
   -------------------------------------------------------------------------
   Add slave23 fields, events, and methods23.
   For23 each field you add:
     o Update the `uvm_component_utils_begin macro23 to get various23 UVM utilities23
       for this attribute23.
   ***************************************************************************/

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent23)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor23 - required23 syntax23 for UVM automation23 and utilities23
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent23

  // UVM build() phase
  function void ahb_slave_agent23::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor23 = ahb_slave_monitor23::type_id::create("monitor23", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer23::type_id::create("sequencer", this);
      driver = ahb_slave_driver23::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent23::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds23 the driver to the sequencer using consumer23-producer23 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV23

