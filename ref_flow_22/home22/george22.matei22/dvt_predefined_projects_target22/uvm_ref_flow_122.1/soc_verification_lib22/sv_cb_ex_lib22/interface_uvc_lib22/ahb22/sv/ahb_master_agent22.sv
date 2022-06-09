// IVB22 checksum22: 797231401
/*-----------------------------------------------------------------
File22 name     : ahb_master_agent22.sv
Created22       : Wed22 May22 19 15:42:20 2010
Description22   : This22 file implements22 the master22 agent22
Notes22         :
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_AGENT_SV22
`define AHB_MASTER_AGENT_SV22

//------------------------------------------------------------------------------
//
// CLASS22: ahb_master_agent22
//
//------------------------------------------------------------------------------

class ahb_master_agent22 extends uvm_agent;

  //  This22 field determines22 whether22 an agent22 is active or passive22.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  ahb_master_monitor22 monitor22;
  ahb_master_sequencer22 sequencer;
  ahb_master_driver22 driver;
  
  /***************************************************************************
   IVB22-NOTE22 : OPTIONAL22 : master22 Agent22 : Agents22
   -------------------------------------------------------------------------
   Add master22 fields, events and methods22.
   For22 each field you add:
     o Update the `uvm_component_utils_begin macro22 to get various22 UVM utilities22
       for this attribute22.
   ***************************************************************************/

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(ahb_master_agent22)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : ahb_master_agent22

  // UVM build() phase
  function void ahb_master_agent22::build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor22 = ahb_master_monitor22::type_id::create("monitor22", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = ahb_master_sequencer22::type_id::create("sequencer", this);
      driver = ahb_master_driver22::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect() phase
  function void ahb_master_agent22::connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds22 the driver to the sequencer using consumer22-producer22 interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

`endif // AHB_MASTER_AGENT_SV22

