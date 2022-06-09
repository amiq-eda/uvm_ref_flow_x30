// IVB18 checksum18: 1298481799
/*-----------------------------------------------------------------
File18 name     : ahb_slave_agent18.sv
Created18       : Wed18 May18 19 15:42:21 2010
Description18   : This18 file implements18 the slave18 agent18
Notes18         :
-----------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV18
`define AHB_SLAVE_AGENT_SV18

//------------------------------------------------------------------------------
//
// CLASS18: ahb_slave_agent18
//
//------------------------------------------------------------------------------

class ahb_slave_agent18 extends uvm_agent;
 
  // This18 field determines18 whether18 an agent18 is active or passive18.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor18 monitor18;
  ahb_slave_sequencer18 sequencer;
  ahb_slave_driver18 driver;
  
  /***************************************************************************
   IVB18-NOTE18 : OPTIONAL18 : slave18 Agent18 : Agents18
   -------------------------------------------------------------------------
   Add slave18 fields, events, and methods18.
   For18 each field you add:
     o Update the `uvm_component_utils_begin macro18 to get various18 UVM utilities18
       for this attribute18.
   ***************************************************************************/

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent18)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor18 - required18 syntax18 for UVM automation18 and utilities18
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent18

  // UVM build() phase
  function void ahb_slave_agent18::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor18 = ahb_slave_monitor18::type_id::create("monitor18", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer18::type_id::create("sequencer", this);
      driver = ahb_slave_driver18::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent18::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds18 the driver to the sequencer using consumer18-producer18 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV18

