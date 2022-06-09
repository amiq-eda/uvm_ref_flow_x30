// IVB16 checksum16: 797231401
/*-----------------------------------------------------------------
File16 name     : ahb_master_agent16.sv
Created16       : Wed16 May16 19 15:42:20 2010
Description16   : This16 file implements16 the master16 agent16
Notes16         :
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV16
`define AHB_MASTER_AGENT_SV16

//------------------------------------------------------------------------------
//
// CLASS16: ahb_master_agent16
//
//------------------------------------------------------------------------------

class ahb_master_agent16 extends uvm_agent;

  //  This16 field determines16 whether16 an agent16 is active or passive16.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor16 monitor16;
  ahb_master_sequencer16 sequencer;
  ahb_master_driver16 driver;
  
  /***************************************************************************
   IVB16-NOTE16 : OPTIONAL16 : master16 Agent16 : Agents16
   -------------------------------------------------------------------------
   Add master16 fields, events and methods16.
   For16 each field you add:
     o Update the `uvm_component_utils_begin macro16 to get various16 UVM utilities16
       for this attribute16.
   ***************************************************************************/

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent16)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor16 - required16 syntax16 for UVM automation16 and utilities16
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent16

  // UVM build() phase
  function void ahb_master_agent16::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor16 = ahb_master_monitor16::type_id::create("monitor16", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer16::type_id::create("sequencer", this);
      driver = ahb_master_driver16::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent16::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds16 the driver to the sequencer using consumer16-producer16 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV16

