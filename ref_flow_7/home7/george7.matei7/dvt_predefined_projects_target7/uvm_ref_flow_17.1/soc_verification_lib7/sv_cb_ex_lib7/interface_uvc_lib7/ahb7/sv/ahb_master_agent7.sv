// IVB7 checksum7: 797231401
/*-----------------------------------------------------------------
File7 name     : ahb_master_agent7.sv
Created7       : Wed7 May7 19 15:42:20 2010
Description7   : This7 file implements7 the master7 agent7
Notes7         :
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV7
`define AHB_MASTER_AGENT_SV7

//------------------------------------------------------------------------------
//
// CLASS7: ahb_master_agent7
//
//------------------------------------------------------------------------------

class ahb_master_agent7 extends uvm_agent;

  //  This7 field determines7 whether7 an agent7 is active or passive7.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor7 monitor7;
  ahb_master_sequencer7 sequencer;
  ahb_master_driver7 driver;
  
  /***************************************************************************
   IVB7-NOTE7 : OPTIONAL7 : master7 Agent7 : Agents7
   -------------------------------------------------------------------------
   Add master7 fields, events and methods7.
   For7 each field you add:
     o Update the `uvm_component_utils_begin macro7 to get various7 UVM utilities7
       for this attribute7.
   ***************************************************************************/

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent7)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor7 - required7 syntax7 for UVM automation7 and utilities7
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent7

  // UVM build() phase
  function void ahb_master_agent7::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor7 = ahb_master_monitor7::type_id::create("monitor7", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer7::type_id::create("sequencer", this);
      driver = ahb_master_driver7::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent7::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds7 the driver to the sequencer using consumer7-producer7 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV7

