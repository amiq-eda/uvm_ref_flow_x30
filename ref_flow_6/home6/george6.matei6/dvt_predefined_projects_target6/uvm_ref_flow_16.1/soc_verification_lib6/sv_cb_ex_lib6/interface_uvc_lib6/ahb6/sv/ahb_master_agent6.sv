// IVB6 checksum6: 797231401
/*-----------------------------------------------------------------
File6 name     : ahb_master_agent6.sv
Created6       : Wed6 May6 19 15:42:20 2010
Description6   : This6 file implements6 the master6 agent6
Notes6         :
-----------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV6
`define AHB_MASTER_AGENT_SV6

//------------------------------------------------------------------------------
//
// CLASS6: ahb_master_agent6
//
//------------------------------------------------------------------------------

class ahb_master_agent6 extends uvm_agent;

  //  This6 field determines6 whether6 an agent6 is active or passive6.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor6 monitor6;
  ahb_master_sequencer6 sequencer;
  ahb_master_driver6 driver;
  
  /***************************************************************************
   IVB6-NOTE6 : OPTIONAL6 : master6 Agent6 : Agents6
   -------------------------------------------------------------------------
   Add master6 fields, events and methods6.
   For6 each field you add:
     o Update the `uvm_component_utils_begin macro6 to get various6 UVM utilities6
       for this attribute6.
   ***************************************************************************/

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent6)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor6 - required6 syntax6 for UVM automation6 and utilities6
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent6

  // UVM build() phase
  function void ahb_master_agent6::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor6 = ahb_master_monitor6::type_id::create("monitor6", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer6::type_id::create("sequencer", this);
      driver = ahb_master_driver6::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent6::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds6 the driver to the sequencer using consumer6-producer6 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV6

