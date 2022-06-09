/*******************************************************************************
  FILE : apb_env2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`ifndef APB_ENV_SV2
`define APB_ENV_SV2

//------------------------------------------------------------------------------
// CLASS2: apb_env2
//------------------------------------------------------------------------------

class apb_env2 extends uvm_env;

  // Virtual interface for this environment2. This2 should only be done if the
  // same interface is used for all masters2/slaves2 in the environment2. Otherwise2,
  // Each agent2 should have its interface independently2 set.
  protected virtual interface apb_if2 vif2;

  // Environment2 Configuration2 Parameters2
  apb_config2 cfg;     // APB2 configuration object

  // The following2 two2 bits are used to control2 whether2 checks2 and coverage2 are
  // done both in the bus monitor2 class and the interface.
  bit checks_enable2 = 1; 
  bit coverage_enable2 = 1;

  // Components of the environment2
  apb_monitor2 bus_monitor2;
  apb_collector2 bus_collector2;
  apb_master_agent2 master2;
  apb_slave_agent2 slaves2[];

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(apb_env2)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable2, UVM_DEFAULT)
    `uvm_field_int(coverage_enable2, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor2 - Required2 UVM syntax2
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config2(apb_config2 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables2();

endclass : apb_env2

// UVM build_phase
function void apb_env2::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create2 the APB2 UVC2 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config2)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG2", "Using default_apb_config2", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config2","cfg"));
  end
  // set the master2 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave2 configs2
  foreach(cfg.slave_configs2[i]) begin
    string sname;
    sname = $psprintf("slave2[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs2[i]);
  end

  bus_monitor2 = apb_monitor2::type_id::create("bus_monitor2",this);
  bus_collector2 = apb_collector2::type_id::create("bus_collector2",this);
  master2 = apb_master_agent2::type_id::create(cfg.master_config2.name,this);
  slaves2 = new[cfg.slave_configs2.size()];
  for(int i = 0; i < cfg.slave_configs2.size(); i++) begin
    slaves2[i] = apb_slave_agent2::type_id::create($psprintf("slave2[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get2 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if2)::get(this, "", "vif2", vif2))
    `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
  bus_collector2.item_collected_port2.connect(bus_monitor2.coll_mon_port2);
  bus_monitor2.addr_trans_port2.connect(bus_collector2.addr_trans_export2);
  master2.monitor2 = bus_monitor2;
  master2.collector2 = bus_collector2;
  foreach(slaves2[i]) begin
    slaves2[i].monitor2 = bus_monitor2;
    slaves2[i].collector2 = bus_collector2;
    if (slaves2[i].is_active == UVM_ACTIVE)
      slaves2[i].sequencer.addr_trans_port2.connect(bus_monitor2.addr_trans_export2);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env2::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR2", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET2", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config2() method
function void apb_env2::update_config2(apb_config2 cfg);
  bus_monitor2.cfg = cfg;
  bus_collector2.cfg = cfg;
  master2.update_config2(cfg);
  foreach(slaves2[i])
    slaves2[i].update_config2(cfg.slave_configs2[i]);
endfunction : update_config2

// update_vif_enables2
task apb_env2::update_vif_enables2();
  vif2.has_checks2 <= checks_enable2;
  vif2.has_coverage <= coverage_enable2;
  forever begin
    @(checks_enable2 || coverage_enable2);
    vif2.has_checks2 <= checks_enable2;
    vif2.has_coverage <= coverage_enable2;
  end
endtask : update_vif_enables2

//UVM run_phase()
task apb_env2::run_phase(uvm_phase phase);
  fork
    update_vif_enables2();
  join
endtask : run_phase

`endif // APB_ENV_SV2
