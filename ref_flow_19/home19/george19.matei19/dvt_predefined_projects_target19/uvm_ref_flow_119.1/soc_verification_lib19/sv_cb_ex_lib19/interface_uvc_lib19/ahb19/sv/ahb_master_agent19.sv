// IVB19 checksum19: 797231401
/*-----------------------------------------------------------------
File19 name     : ahb_master_agent19.sv
Created19       : Wed19 May19 19 15:42:20 2010
Description19   : This19 file implements19 the master19 agent19
Notes19         :
-----------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV19
`define AHB_MASTER_AGENT_SV19

//------------------------------------------------------------------------------
//
// CLASS19: ahb_master_agent19
//
//------------------------------------------------------------------------------

class ahb_master_agent19 extends uvm_agent;

  //  This19 field determines19 whether19 an agent19 is active or passive19.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor19 monitor19;
  ahb_master_sequencer19 sequencer;
  ahb_master_driver19 driver;
  
  /***************************************************************************
   IVB19-NOTE19 : OPTIONAL19 : master19 Agent19 : Agents19
   -------------------------------------------------------------------------
   Add master19 fields, events and methods19.
   For19 each field you add:
     o Update the `uvm_component_utils_begin macro19 to get various19 UVM utilities19
       for this attribute19.
   ***************************************************************************/

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent19)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent19

  // UVM build() phase
  function void ahb_master_agent19::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor19 = ahb_master_monitor19::type_id::create("monitor19", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer19::type_id::create("sequencer", this);
      driver = ahb_master_driver19::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent19::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds19 the driver to the sequencer using consumer19-producer19 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV19

