// IVB1 checksum1: 2064975656
/*-----------------------------------------------------------------
File1 name     : ahb_env1.sv
Created1       : Wed1 May1 19 15:42:20 2010
Description1   : This1 file implements1 the OVC1 env1.
Notes1         :
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV1
`define AHB_ENV_SV1

//------------------------------------------------------------------------------
//
// CLASS1: ahb_env1
//
//------------------------------------------------------------------------------

class ahb_env1 extends uvm_env;

  // Virtual Interface1 variable
  protected virtual interface ahb_if1 vif1;
 
  // The following1 two1 bits are used to control1 whether1 checks1 and coverage1 are
  // done both in the bus monitor1 class and the interface.
  bit checks_enable1 = 1; 
  bit coverage_enable1 = 1;

  // Components of the environment1
  ahb_master_agent1 master_agent1;
  ahb_slave_agent1 slave_agent1;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(ahb_env1)
    `uvm_field_int(checks_enable1, UVM_ALL_ON)
    `uvm_field_int(coverage_enable1, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor1 - required1 syntax1 for UVM automation1 and utilities1
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables1();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env1

  // UVM build() phase
  function void ahb_env1::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent1 = ahb_master_agent1::type_id::create("master_agent1", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if1)::get(this, "", "vif1", vif1))
   `uvm_fatal("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

  // Function1 to assign the checks1 and coverage1 bits
  task ahb_env1::update_vif_enables1();
    // Make1 assignments1 at time zero based upon1 config
    vif1.has_checks1 <= checks_enable1;
    vif1.has_coverage <= coverage_enable1;
    forever begin
      // Make1 assignments1 whenever1 enables1 change after time zero
      @(checks_enable1 || coverage_enable1);
      vif1.has_checks1 <= checks_enable1;
      vif1.has_coverage <= coverage_enable1;
    end
  endtask : update_vif_enables1

  // UVM run() phase
  task ahb_env1::run_phase(uvm_phase phase);
    fork
      update_vif_enables1();
    join_none
  endtask

`endif // AHB_ENV_SV1

