// IVB9 checksum9: 1298481799
/*-----------------------------------------------------------------
File9 name     : ahb_slave_agent9.sv
Created9       : Wed9 May9 19 15:42:21 2010
Description9   : This9 file implements9 the slave9 agent9
Notes9         :
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV9
`define AHB_SLAVE_AGENT_SV9

//------------------------------------------------------------------------------
//
// CLASS9: ahb_slave_agent9
//
//------------------------------------------------------------------------------

class ahb_slave_agent9 extends uvm_agent;
 
  // This9 field determines9 whether9 an agent9 is active or passive9.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor9 monitor9;
  ahb_slave_sequencer9 sequencer;
  ahb_slave_driver9 driver;
  
  /***************************************************************************
   IVB9-NOTE9 : OPTIONAL9 : slave9 Agent9 : Agents9
   -------------------------------------------------------------------------
   Add slave9 fields, events, and methods9.
   For9 each field you add:
     o Update the `uvm_component_utils_begin macro9 to get various9 UVM utilities9
       for this attribute9.
   ***************************************************************************/

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent9)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent9

  // UVM build() phase
  function void ahb_slave_agent9::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor9 = ahb_slave_monitor9::type_id::create("monitor9", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer9::type_id::create("sequencer", this);
      driver = ahb_slave_driver9::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent9::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds9 the driver to the sequencer using consumer9-producer9 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV9

