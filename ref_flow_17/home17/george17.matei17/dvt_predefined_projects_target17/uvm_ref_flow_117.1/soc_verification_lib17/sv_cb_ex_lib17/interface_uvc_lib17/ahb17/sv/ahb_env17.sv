// IVB17 checksum17: 2064975656
/*-----------------------------------------------------------------
File17 name     : ahb_env17.sv
Created17       : Wed17 May17 19 15:42:20 2010
Description17   : This17 file implements17 the OVC17 env17.
Notes17         :
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV17
`define AHB_ENV_SV17

//------------------------------------------------------------------------------
//
// CLASS17: ahb_env17
//
//------------------------------------------------------------------------------

class ahb_env17 extends uvm_env;

  // Virtual Interface17 variable
  protected virtual interface ahb_if17 vif17;
 
  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done both in the bus monitor17 class and the interface.
  bit checks_enable17 = 1; 
  bit coverage_enable17 = 1;

  // Components of the environment17
  ahb_master_agent17 master_agent17;
  ahb_slave_agent17 slave_agent17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(ahb_env17)
    `uvm_field_int(checks_enable17, UVM_ALL_ON)
    `uvm_field_int(coverage_enable17, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables17();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env17

  // UVM build() phase
  function void ahb_env17::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent17 = ahb_master_agent17::type_id::create("master_agent17", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if17)::get(this, "", "vif17", vif17))
   `uvm_fatal("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

  // Function17 to assign the checks17 and coverage17 bits
  task ahb_env17::update_vif_enables17();
    // Make17 assignments17 at time zero based upon17 config
    vif17.has_checks17 <= checks_enable17;
    vif17.has_coverage <= coverage_enable17;
    forever begin
      // Make17 assignments17 whenever17 enables17 change after time zero
      @(checks_enable17 || coverage_enable17);
      vif17.has_checks17 <= checks_enable17;
      vif17.has_coverage <= coverage_enable17;
    end
  endtask : update_vif_enables17

  // UVM run() phase
  task ahb_env17::run_phase(uvm_phase phase);
    fork
      update_vif_enables17();
    join_none
  endtask

`endif // AHB_ENV_SV17

