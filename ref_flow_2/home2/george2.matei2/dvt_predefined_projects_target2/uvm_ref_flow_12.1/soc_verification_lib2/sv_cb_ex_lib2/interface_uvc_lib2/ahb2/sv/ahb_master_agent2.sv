// IVB2 checksum2: 797231401
/*-----------------------------------------------------------------
File2 name     : ahb_master_agent2.sv
Created2       : Wed2 May2 19 15:42:20 2010
Description2   : This2 file implements2 the master2 agent2
Notes2         :
-----------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV2
`define AHB_MASTER_AGENT_SV2

//------------------------------------------------------------------------------
//
// CLASS2: ahb_master_agent2
//
//------------------------------------------------------------------------------

class ahb_master_agent2 extends uvm_agent;

  //  This2 field determines2 whether2 an agent2 is active or passive2.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor2 monitor2;
  ahb_master_sequencer2 sequencer;
  ahb_master_driver2 driver;
  
  /***************************************************************************
   IVB2-NOTE2 : OPTIONAL2 : master2 Agent2 : Agents2
   -------------------------------------------------------------------------
   Add master2 fields, events and methods2.
   For2 each field you add:
     o Update the `uvm_component_utils_begin macro2 to get various2 UVM utilities2
       for this attribute2.
   ***************************************************************************/

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent2)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor2 - required2 syntax2 for UVM automation2 and utilities2
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent2

  // UVM build() phase
  function void ahb_master_agent2::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor2 = ahb_master_monitor2::type_id::create("monitor2", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer2::type_id::create("sequencer", this);
      driver = ahb_master_driver2::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent2::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds2 the driver to the sequencer using consumer2-producer2 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV2

