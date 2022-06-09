// IVB1 checksum1: 797231401
/*-----------------------------------------------------------------
File1 name     : ahb_master_agent1.sv
Created1       : Wed1 May1 19 15:42:20 2010
Description1   : This1 file implements1 the master1 agent1
Notes1         :
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV1
`define AHB_MASTER_AGENT_SV1

//------------------------------------------------------------------------------
//
// CLASS1: ahb_master_agent1
//
//------------------------------------------------------------------------------

class ahb_master_agent1 extends uvm_agent;

  //  This1 field determines1 whether1 an agent1 is active or passive1.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor1 monitor1;
  ahb_master_sequencer1 sequencer;
  ahb_master_driver1 driver;
  
  /***************************************************************************
   IVB1-NOTE1 : OPTIONAL1 : master1 Agent1 : Agents1
   -------------------------------------------------------------------------
   Add master1 fields, events and methods1.
   For1 each field you add:
     o Update the `uvm_component_utils_begin macro1 to get various1 UVM utilities1
       for this attribute1.
   ***************************************************************************/

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent1)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor1 - required1 syntax1 for UVM automation1 and utilities1
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent1

  // UVM build() phase
  function void ahb_master_agent1::build_phase(uvm_phase phase);
    int a;
    $display(a);
    super.build_phase(phase);
    monitor1 = ahb_master_monitor1::type_id::create("monitor1", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer1::type_id::create("sequencer", this);
      driver = ahb_master_driver1::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent1::connect_phase(uvm_phase phase);
    int a;
      $display(a);
    if(is_active == UVM_ACTIVE) begin
      // Binds1 the driver to the sequencer using consumer1-producer1 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV1

