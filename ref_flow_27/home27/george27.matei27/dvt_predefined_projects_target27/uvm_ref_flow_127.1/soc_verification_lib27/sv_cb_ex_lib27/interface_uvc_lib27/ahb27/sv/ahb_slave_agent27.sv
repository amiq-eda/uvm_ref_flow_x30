// IVB27 checksum27: 1298481799
/*-----------------------------------------------------------------
File27 name     : ahb_slave_agent27.sv
Created27       : Wed27 May27 19 15:42:21 2010
Description27   : This27 file implements27 the slave27 agent27
Notes27         :
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV27
`define AHB_SLAVE_AGENT_SV27

//------------------------------------------------------------------------------
//
// CLASS27: ahb_slave_agent27
//
//------------------------------------------------------------------------------

class ahb_slave_agent27 extends uvm_agent;
 
  // This27 field determines27 whether27 an agent27 is active or passive27.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor27 monitor27;
  ahb_slave_sequencer27 sequencer;
  ahb_slave_driver27 driver;
  
  /***************************************************************************
   IVB27-NOTE27 : OPTIONAL27 : slave27 Agent27 : Agents27
   -------------------------------------------------------------------------
   Add slave27 fields, events, and methods27.
   For27 each field you add:
     o Update the `uvm_component_utils_begin macro27 to get various27 UVM utilities27
       for this attribute27.
   ***************************************************************************/

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent27)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor27 - required27 syntax27 for UVM automation27 and utilities27
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent27

  // UVM build() phase
  function void ahb_slave_agent27::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor27 = ahb_slave_monitor27::type_id::create("monitor27", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer27::type_id::create("sequencer", this);
      driver = ahb_slave_driver27::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent27::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds27 the driver to the sequencer using consumer27-producer27 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV27

