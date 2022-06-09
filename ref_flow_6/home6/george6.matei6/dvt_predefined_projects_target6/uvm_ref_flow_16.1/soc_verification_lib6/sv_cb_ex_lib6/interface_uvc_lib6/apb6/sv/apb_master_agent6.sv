/******************************************************************************
  FILE : apb_master_agent6.sv
 ******************************************************************************/
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


`ifndef APB_MASTER_AGENT_SV6
`define APB_MASTER_AGENT_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_master_agent6
//------------------------------------------------------------------------------

class apb_master_agent6 extends uvm_agent;

  // This6 field determines6 whether6 an agent6 is active or passive6.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration6 information: (master_config6: name, is_active)
  apb_config6 cfg;

  apb_monitor6   monitor6;
  apb_collector6 collector6;
  apb_master_sequencer6 sequencer;
  apb_master_driver6    driver;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent6)
    `uvm_field_object(monitor6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config6(input apb_config6 cfg);

endclass : apb_master_agent6

// UVM build_phase
function void apb_master_agent6::build_phase(uvm_phase phase);
  uvm_object config_obj6;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config6)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG6", 
          "Config6 not set for master6 agent6, using default is_active field")
    end
  else is_active = cfg.master_config6.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer6::type_id::create("sequencer",this);
    driver = apb_master_driver6::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect6 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config6() 
function void apb_master_agent6::update_config6(input apb_config6 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config6

`endif // APB_MASTER_AGENT_SV6
