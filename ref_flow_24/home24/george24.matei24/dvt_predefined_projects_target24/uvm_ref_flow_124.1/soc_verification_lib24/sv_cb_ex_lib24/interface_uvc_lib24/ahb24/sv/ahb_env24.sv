// IVB24 checksum24: 2064975656
/*-----------------------------------------------------------------
File24 name     : ahb_env24.sv
Created24       : Wed24 May24 19 15:42:20 2010
Description24   : This24 file implements24 the OVC24 env24.
Notes24         :
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV24
`define AHB_ENV_SV24

//------------------------------------------------------------------------------
//
// CLASS24: ahb_env24
//
//------------------------------------------------------------------------------

class ahb_env24 extends uvm_env;

  // Virtual Interface24 variable
  protected virtual interface ahb_if24 vif24;
 
  // The following24 two24 bits are used to control24 whether24 checks24 and coverage24 are
  // done both in the bus monitor24 class and the interface.
  bit checks_enable24 = 1; 
  bit coverage_enable24 = 1;

  // Components of the environment24
  ahb_master_agent24 master_agent24;
  ahb_slave_agent24 slave_agent24;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(ahb_env24)
    `uvm_field_int(checks_enable24, UVM_ALL_ON)
    `uvm_field_int(coverage_enable24, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor24 - required24 syntax24 for UVM automation24 and utilities24
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables24();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env24

  // UVM build() phase
  function void ahb_env24::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent24 = ahb_master_agent24::type_id::create("master_agent24", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if24)::get(this, "", "vif24", vif24))
   `uvm_fatal("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

  // Function24 to assign the checks24 and coverage24 bits
  task ahb_env24::update_vif_enables24();
    // Make24 assignments24 at time zero based upon24 config
    vif24.has_checks24 <= checks_enable24;
    vif24.has_coverage <= coverage_enable24;
    forever begin
      // Make24 assignments24 whenever24 enables24 change after time zero
      @(checks_enable24 || coverage_enable24);
      vif24.has_checks24 <= checks_enable24;
      vif24.has_coverage <= coverage_enable24;
    end
  endtask : update_vif_enables24

  // UVM run() phase
  task ahb_env24::run_phase(uvm_phase phase);
    fork
      update_vif_enables24();
    join_none
  endtask

`endif // AHB_ENV_SV24

