// IVB20 checksum20: 797231401
/*-----------------------------------------------------------------
File20 name     : ahb_master_agent20.sv
Created20       : Wed20 May20 19 15:42:20 2010
Description20   : This20 file implements20 the master20 agent20
Notes20         :
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV20
`define AHB_MASTER_AGENT_SV20

//------------------------------------------------------------------------------
//
// CLASS20: ahb_master_agent20
//
//------------------------------------------------------------------------------

class ahb_master_agent20 extends uvm_agent;

  //  This20 field determines20 whether20 an agent20 is active or passive20.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor20 monitor20;
  ahb_master_sequencer20 sequencer;
  ahb_master_driver20 driver;
  
  /***************************************************************************
   IVB20-NOTE20 : OPTIONAL20 : master20 Agent20 : Agents20
   -------------------------------------------------------------------------
   Add master20 fields, events and methods20.
   For20 each field you add:
     o Update the `uvm_component_utils_begin macro20 to get various20 UVM utilities20
       for this attribute20.
   ***************************************************************************/

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent20)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent20

  // UVM build() phase
  function void ahb_master_agent20::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor20 = ahb_master_monitor20::type_id::create("monitor20", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer20::type_id::create("sequencer", this);
      driver = ahb_master_driver20::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent20::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds20 the driver to the sequencer using consumer20-producer20 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV20

