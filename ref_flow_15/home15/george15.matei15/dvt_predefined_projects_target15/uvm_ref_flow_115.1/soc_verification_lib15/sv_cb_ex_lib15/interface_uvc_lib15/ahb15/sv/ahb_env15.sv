// IVB15 checksum15: 2064975656
/*-----------------------------------------------------------------
File15 name     : ahb_env15.sv
Created15       : Wed15 May15 19 15:42:20 2010
Description15   : This15 file implements15 the OVC15 env15.
Notes15         :
-----------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV15
`define AHB_ENV_SV15

//------------------------------------------------------------------------------
//
// CLASS15: ahb_env15
//
//------------------------------------------------------------------------------

class ahb_env15 extends uvm_env;

  // Virtual Interface15 variable
  protected virtual interface ahb_if15 vif15;
 
  // The following15 two15 bits are used to control15 whether15 checks15 and coverage15 are
  // done both in the bus monitor15 class and the interface.
  bit checks_enable15 = 1; 
  bit coverage_enable15 = 1;

  // Components of the environment15
  ahb_master_agent15 master_agent15;
  ahb_slave_agent15 slave_agent15;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(ahb_env15)
    `uvm_field_int(checks_enable15, UVM_ALL_ON)
    `uvm_field_int(coverage_enable15, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor15 - required15 syntax15 for UVM automation15 and utilities15
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables15();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env15

  // UVM build() phase
  function void ahb_env15::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent15 = ahb_master_agent15::type_id::create("master_agent15", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if15)::get(this, "", "vif15", vif15))
   `uvm_fatal("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

  // Function15 to assign the checks15 and coverage15 bits
  task ahb_env15::update_vif_enables15();
    // Make15 assignments15 at time zero based upon15 config
    vif15.has_checks15 <= checks_enable15;
    vif15.has_coverage <= coverage_enable15;
    forever begin
      // Make15 assignments15 whenever15 enables15 change after time zero
      @(checks_enable15 || coverage_enable15);
      vif15.has_checks15 <= checks_enable15;
      vif15.has_coverage <= coverage_enable15;
    end
  endtask : update_vif_enables15

  // UVM run() phase
  task ahb_env15::run_phase(uvm_phase phase);
    fork
      update_vif_enables15();
    join_none
  endtask

`endif // AHB_ENV_SV15

