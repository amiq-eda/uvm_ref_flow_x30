/******************************************************************************
  FILE : apb_master_agent30.sv
 ******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV30
`define APB_MASTER_AGENT_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_master_agent30
//------------------------------------------------------------------------------

class apb_master_agent30 extends uvm_agent;

  // This30 field determines30 whether30 an agent30 is active or passive30.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration30 information: (master_config30: name, is_active)
  apb_config30 cfg;

  apb_monitor30   monitor30;
  apb_collector30 collector30;
  apb_master_sequencer30 sequencer;
  apb_master_driver30    driver;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent30)
    `uvm_field_object(monitor30, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector30, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config30(input apb_config30 cfg);

endclass : apb_master_agent30

// UVM build_phase
function void apb_master_agent30::build_phase(uvm_phase phase);
  uvm_object config_obj30;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config30)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG30", 
          "Config30 not set for master30 agent30, using default is_active field")
    end
  else is_active = cfg.master_config30.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer30::type_id::create("sequencer",this);
    driver = apb_master_driver30::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect30 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config30() 
function void apb_master_agent30::update_config30(input apb_config30 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config30

`endif // APB_MASTER_AGENT_SV30
