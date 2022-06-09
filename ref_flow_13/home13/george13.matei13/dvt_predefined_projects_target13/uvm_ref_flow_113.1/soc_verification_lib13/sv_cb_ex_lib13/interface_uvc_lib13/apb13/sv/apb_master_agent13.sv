/******************************************************************************
  FILE : apb_master_agent13.sv
 ******************************************************************************/
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


`ifndef APB_MASTER_AGENT_SV13
`define APB_MASTER_AGENT_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_master_agent13
//------------------------------------------------------------------------------

class apb_master_agent13 extends uvm_agent;

  // This13 field determines13 whether13 an agent13 is active or passive13.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration13 information: (master_config13: name, is_active)
  apb_config13 cfg;

  apb_monitor13   monitor13;
  apb_collector13 collector13;
  apb_master_sequencer13 sequencer;
  apb_master_driver13    driver;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent13)
    `uvm_field_object(monitor13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config13(input apb_config13 cfg);

endclass : apb_master_agent13

// UVM build_phase
function void apb_master_agent13::build_phase(uvm_phase phase);
  uvm_object config_obj13;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config13)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG13", 
          "Config13 not set for master13 agent13, using default is_active field")
    end
  else is_active = cfg.master_config13.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer13::type_id::create("sequencer",this);
    driver = apb_master_driver13::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect13 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config13() 
function void apb_master_agent13::update_config13(input apb_config13 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config13

`endif // APB_MASTER_AGENT_SV13
