// IVB5 checksum5: 1298481799
/*-----------------------------------------------------------------
File5 name     : ahb_slave_agent5.sv
Created5       : Wed5 May5 19 15:42:21 2010
Description5   : This5 file implements5 the slave5 agent5
Notes5         :
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_AGENT_SV5
`define AHB_SLAVE_AGENT_SV5

//------------------------------------------------------------------------------
//
// CLASS5: ahb_slave_agent5
//
//------------------------------------------------------------------------------

class ahb_slave_agent5 extends uvm_agent;
 
  // This5 field determines5 whether5 an agent5 is active or passive5.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  ahb_slave_monitor5 monitor5;
  ahb_slave_sequencer5 sequencer;
  ahb_slave_driver5 driver;
  
  /***************************************************************************
   IVB5-NOTE5 : OPTIONAL5 : slave5 Agent5 : Agents5
   -------------------------------------------------------------------------
   Add slave5 fields, events, and methods5.
   For5 each field you add:
     o Update the `uvm_component_utils_begin macro5 to get various5 UVM utilities5
       for this attribute5.
   ***************************************************************************/

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(ahb_slave_agent5)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_slave_agent5

  // UVM build() phase
  function void ahb_slave_agent5::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor5 = ahb_slave_monitor5::type_id::create("monitor5", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_slave_sequencer5::type_id::create("sequencer", this);
      driver = ahb_slave_driver5::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_slave_agent5::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds5 the driver to the sequencer using consumer5-producer5 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_SLAVE_AGENT_SV5

