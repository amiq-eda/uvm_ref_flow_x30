/******************************************************************************
  FILE : apb_master_agent28.sv
 ******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV28
`define APB_MASTER_AGENT_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_master_agent28
//------------------------------------------------------------------------------

class apb_master_agent28 extends uvm_agent;

  // This28 field determines28 whether28 an agent28 is active or passive28.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration28 information: (master_config28: name, is_active)
  apb_config28 cfg;

  apb_monitor28   monitor28;
  apb_collector28 collector28;
  apb_master_sequencer28 sequencer;
  apb_master_driver28    driver;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent28)
    `uvm_field_object(monitor28, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector28, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config28(input apb_config28 cfg);

endclass : apb_master_agent28

// UVM build_phase
function void apb_master_agent28::build_phase(uvm_phase phase);
  uvm_object config_obj28;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config28)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG28", 
          "Config28 not set for master28 agent28, using default is_active field")
    end
  else is_active = cfg.master_config28.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer28::type_id::create("sequencer",this);
    driver = apb_master_driver28::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect28 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config28() 
function void apb_master_agent28::update_config28(input apb_config28 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config28

`endif // APB_MASTER_AGENT_SV28
