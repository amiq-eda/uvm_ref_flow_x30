// IVB27 checksum27: 2064975656
/*-----------------------------------------------------------------
File27 name     : ahb_env27.sv
Created27       : Wed27 May27 19 15:42:20 2010
Description27   : This27 file implements27 the OVC27 env27.
Notes27         :
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV27
`define AHB_ENV_SV27

//------------------------------------------------------------------------------
//
// CLASS27: ahb_env27
//
//------------------------------------------------------------------------------

class ahb_env27 extends uvm_env;

  // Virtual Interface27 variable
  protected virtual interface ahb_if27 vif27;
 
  // The following27 two27 bits are used to control27 whether27 checks27 and coverage27 are
  // done both in the bus monitor27 class and the interface.
  bit checks_enable27 = 1; 
  bit coverage_enable27 = 1;

  // Components of the environment27
  ahb_master_agent27 master_agent27;
  ahb_slave_agent27 slave_agent27;

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(ahb_env27)
    `uvm_field_int(checks_enable27, UVM_ALL_ON)
    `uvm_field_int(coverage_enable27, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor27 - required27 syntax27 for UVM automation27 and utilities27
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables27();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env27

  // UVM build() phase
  function void ahb_env27::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent27 = ahb_master_agent27::type_id::create("master_agent27", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if27)::get(this, "", "vif27", vif27))
   `uvm_fatal("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

  // Function27 to assign the checks27 and coverage27 bits
  task ahb_env27::update_vif_enables27();
    // Make27 assignments27 at time zero based upon27 config
    vif27.has_checks27 <= checks_enable27;
    vif27.has_coverage <= coverage_enable27;
    forever begin
      // Make27 assignments27 whenever27 enables27 change after time zero
      @(checks_enable27 || coverage_enable27);
      vif27.has_checks27 <= checks_enable27;
      vif27.has_coverage <= coverage_enable27;
    end
  endtask : update_vif_enables27

  // UVM run() phase
  task ahb_env27::run_phase(uvm_phase phase);
    fork
      update_vif_enables27();
    join_none
  endtask

`endif // AHB_ENV_SV27

