/******************************************************************************
  FILE : apb_master_agent21.sv
 ******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV21
`define APB_MASTER_AGENT_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_master_agent21
//------------------------------------------------------------------------------

class apb_master_agent21 extends uvm_agent;

  // This21 field determines21 whether21 an agent21 is active or passive21.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration21 information: (master_config21: name, is_active)
  apb_config21 cfg;

  apb_monitor21   monitor21;
  apb_collector21 collector21;
  apb_master_sequencer21 sequencer;
  apb_master_driver21    driver;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent21)
    `uvm_field_object(monitor21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config21(input apb_config21 cfg);

endclass : apb_master_agent21

// UVM build_phase
function void apb_master_agent21::build_phase(uvm_phase phase);
  uvm_object config_obj21;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config21)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG21", 
          "Config21 not set for master21 agent21, using default is_active field")
    end
  else is_active = cfg.master_config21.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer21::type_id::create("sequencer",this);
    driver = apb_master_driver21::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect21 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config21() 
function void apb_master_agent21::update_config21(input apb_config21 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config21

`endif // APB_MASTER_AGENT_SV21
