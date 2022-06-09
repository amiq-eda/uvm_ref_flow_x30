// IVB10 checksum10: 2064975656
/*-----------------------------------------------------------------
File10 name     : ahb_env10.sv
Created10       : Wed10 May10 19 15:42:20 2010
Description10   : This10 file implements10 the OVC10 env10.
Notes10         :
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV10
`define AHB_ENV_SV10

//------------------------------------------------------------------------------
//
// CLASS10: ahb_env10
//
//------------------------------------------------------------------------------

class ahb_env10 extends uvm_env;

  // Virtual Interface10 variable
  protected virtual interface ahb_if10 vif10;
 
  // The following10 two10 bits are used to control10 whether10 checks10 and coverage10 are
  // done both in the bus monitor10 class and the interface.
  bit checks_enable10 = 1; 
  bit coverage_enable10 = 1;

  // Components of the environment10
  ahb_master_agent10 master_agent10;
  ahb_slave_agent10 slave_agent10;

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(ahb_env10)
    `uvm_field_int(checks_enable10, UVM_ALL_ON)
    `uvm_field_int(coverage_enable10, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor10 - required10 syntax10 for UVM automation10 and utilities10
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables10();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env10

  // UVM build() phase
  function void ahb_env10::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent10 = ahb_master_agent10::type_id::create("master_agent10", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if10)::get(this, "", "vif10", vif10))
   `uvm_fatal("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

  // Function10 to assign the checks10 and coverage10 bits
  task ahb_env10::update_vif_enables10();
    // Make10 assignments10 at time zero based upon10 config
    vif10.has_checks10 <= checks_enable10;
    vif10.has_coverage <= coverage_enable10;
    forever begin
      // Make10 assignments10 whenever10 enables10 change after time zero
      @(checks_enable10 || coverage_enable10);
      vif10.has_checks10 <= checks_enable10;
      vif10.has_coverage <= coverage_enable10;
    end
  endtask : update_vif_enables10

  // UVM run() phase
  task ahb_env10::run_phase(uvm_phase phase);
    fork
      update_vif_enables10();
    join_none
  endtask

`endif // AHB_ENV_SV10

