// IVB21 checksum21: 1298481799
/*-----------------------------------------------------------------
File21 name     : ahb_slave_agent21.sv
Created21       : Wed21 May21 19 15:42:21 2010
Description21   : This21 file implements21 the slave21 agent21
Notes21         :
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV21
`define AHB_SLAVE_AGENT_SV21

//------------------------------------------------------------------------------
//
// CLASS21: ahb_slave_agent21
//
//------------------------------------------------------------------------------

class ahb_slave_agent21 extends uvm_agent;
 
  // This21 field determines21 whether21 an agent21 is active or passive21.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor21 monitor21;
  ahb_slave_sequencer21 sequencer;
  ahb_slave_driver21 driver;
  
  /***************************************************************************
   IVB21-NOTE21 : OPTIONAL21 : slave21 Agent21 : Agents21
   -------------------------------------------------------------------------
   Add slave21 fields, events, and methods21.
   For21 each field you add:
     o Update the `uvm_component_utils_begin macro21 to get various21 UVM utilities21
       for this attribute21.
   ***************************************************************************/

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent21)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor21 - required21 syntax21 for UVM automation21 and utilities21
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent21

  // UVM build() phase
  function void ahb_slave_agent21::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor21 = ahb_slave_monitor21::type_id::create("monitor21", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer21::type_id::create("sequencer", this);
      driver = ahb_slave_driver21::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent21::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds21 the driver to the sequencer using consumer21-producer21 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV21

