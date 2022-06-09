// IVB15 checksum15: 797231401
/*-----------------------------------------------------------------
File15 name     : ahb_master_agent15.sv
Created15       : Wed15 May15 19 15:42:20 2010
Description15   : This15 file implements15 the master15 agent15
Notes15         :
-----------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV15
`define AHB_MASTER_AGENT_SV15

//------------------------------------------------------------------------------
//
// CLASS15: ahb_master_agent15
//
//------------------------------------------------------------------------------

class ahb_master_agent15 extends uvm_agent;

  //  This15 field determines15 whether15 an agent15 is active or passive15.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor15 monitor15;
  ahb_master_sequencer15 sequencer;
  ahb_master_driver15 driver;
  
  /***************************************************************************
   IVB15-NOTE15 : OPTIONAL15 : master15 Agent15 : Agents15
   -------------------------------------------------------------------------
   Add master15 fields, events and methods15.
   For15 each field you add:
     o Update the `uvm_component_utils_begin macro15 to get various15 UVM utilities15
       for this attribute15.
   ***************************************************************************/

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent15)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor15 - required15 syntax15 for UVM automation15 and utilities15
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent15

  // UVM build() phase
  function void ahb_master_agent15::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor15 = ahb_master_monitor15::type_id::create("monitor15", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer15::type_id::create("sequencer", this);
      driver = ahb_master_driver15::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent15::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds15 the driver to the sequencer using consumer15-producer15 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV15

