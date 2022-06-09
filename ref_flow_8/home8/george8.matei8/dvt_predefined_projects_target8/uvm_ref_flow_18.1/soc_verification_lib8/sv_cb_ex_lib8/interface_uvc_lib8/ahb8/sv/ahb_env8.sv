// IVB8 checksum8: 2064975656
/*-----------------------------------------------------------------
File8 name     : ahb_env8.sv
Created8       : Wed8 May8 19 15:42:20 2010
Description8   : This8 file implements8 the OVC8 env8.
Notes8         :
-----------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV8
`define AHB_ENV_SV8

//------------------------------------------------------------------------------
//
// CLASS8: ahb_env8
//
//------------------------------------------------------------------------------

class ahb_env8 extends uvm_env;

  // Virtual Interface8 variable
  protected virtual interface ahb_if8 vif8;
 
  // The following8 two8 bits are used to control8 whether8 checks8 and coverage8 are
  // done both in the bus monitor8 class and the interface.
  bit checks_enable8 = 1; 
  bit coverage_enable8 = 1;

  // Components of the environment8
  ahb_master_agent8 master_agent8;
  ahb_slave_agent8 slave_agent8;

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(ahb_env8)
    `uvm_field_int(checks_enable8, UVM_ALL_ON)
    `uvm_field_int(coverage_enable8, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor8 - required8 syntax8 for UVM automation8 and utilities8
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables8();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env8

  // UVM build() phase
  function void ahb_env8::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent8 = ahb_master_agent8::type_id::create("master_agent8", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if8)::get(this, "", "vif8", vif8))
   `uvm_fatal("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

  // Function8 to assign the checks8 and coverage8 bits
  task ahb_env8::update_vif_enables8();
    // Make8 assignments8 at time zero based upon8 config
    vif8.has_checks8 <= checks_enable8;
    vif8.has_coverage <= coverage_enable8;
    forever begin
      // Make8 assignments8 whenever8 enables8 change after time zero
      @(checks_enable8 || coverage_enable8);
      vif8.has_checks8 <= checks_enable8;
      vif8.has_coverage <= coverage_enable8;
    end
  endtask : update_vif_enables8

  // UVM run() phase
  task ahb_env8::run_phase(uvm_phase phase);
    fork
      update_vif_enables8();
    join_none
  endtask

`endif // AHB_ENV_SV8

