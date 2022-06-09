// IVB28 checksum28: 1298481799
/*-----------------------------------------------------------------
File28 name     : ahb_slave_agent28.sv
Created28       : Wed28 May28 19 15:42:21 2010
Description28   : This28 file implements28 the slave28 agent28
Notes28         :
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV28
`define AHB_SLAVE_AGENT_SV28

//------------------------------------------------------------------------------
//
// CLASS28: ahb_slave_agent28
//
//------------------------------------------------------------------------------

class ahb_slave_agent28 extends uvm_agent;
 
  // This28 field determines28 whether28 an agent28 is active or passive28.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor28 monitor28;
  ahb_slave_sequencer28 sequencer;
  ahb_slave_driver28 driver;
  
  /***************************************************************************
   IVB28-NOTE28 : OPTIONAL28 : slave28 Agent28 : Agents28
   -------------------------------------------------------------------------
   Add slave28 fields, events, and methods28.
   For28 each field you add:
     o Update the `uvm_component_utils_begin macro28 to get various28 UVM utilities28
       for this attribute28.
   ***************************************************************************/

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent28)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor28 - required28 syntax28 for UVM automation28 and utilities28
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent28

  // UVM build() phase
  function void ahb_slave_agent28::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor28 = ahb_slave_monitor28::type_id::create("monitor28", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer28::type_id::create("sequencer", this);
      driver = ahb_slave_driver28::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent28::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds28 the driver to the sequencer using consumer28-producer28 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV28

