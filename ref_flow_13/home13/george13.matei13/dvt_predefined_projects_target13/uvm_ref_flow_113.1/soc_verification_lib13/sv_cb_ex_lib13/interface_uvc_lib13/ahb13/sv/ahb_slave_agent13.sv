// IVB13 checksum13: 1298481799
/*-----------------------------------------------------------------
File13 name     : ahb_slave_agent13.sv
Created13       : Wed13 May13 19 15:42:21 2010
Description13   : This13 file implements13 the slave13 agent13
Notes13         :
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV13
`define AHB_SLAVE_AGENT_SV13

//------------------------------------------------------------------------------
//
// CLASS13: ahb_slave_agent13
//
//------------------------------------------------------------------------------

class ahb_slave_agent13 extends uvm_agent;
 
  // This13 field determines13 whether13 an agent13 is active or passive13.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor13 monitor13;
  ahb_slave_sequencer13 sequencer;
  ahb_slave_driver13 driver;
  
  /***************************************************************************
   IVB13-NOTE13 : OPTIONAL13 : slave13 Agent13 : Agents13
   -------------------------------------------------------------------------
   Add slave13 fields, events, and methods13.
   For13 each field you add:
     o Update the `uvm_component_utils_begin macro13 to get various13 UVM utilities13
       for this attribute13.
   ***************************************************************************/

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent13)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent13

  // UVM build() phase
  function void ahb_slave_agent13::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor13 = ahb_slave_monitor13::type_id::create("monitor13", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer13::type_id::create("sequencer", this);
      driver = ahb_slave_driver13::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent13::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds13 the driver to the sequencer using consumer13-producer13 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV13

