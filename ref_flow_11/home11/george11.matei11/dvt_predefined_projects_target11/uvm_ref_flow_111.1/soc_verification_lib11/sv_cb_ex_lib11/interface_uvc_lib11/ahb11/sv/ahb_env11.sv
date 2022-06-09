// IVB11 checksum11: 2064975656
/*-----------------------------------------------------------------
File11 name     : ahb_env11.sv
Created11       : Wed11 May11 19 15:42:20 2010
Description11   : This11 file implements11 the OVC11 env11.
Notes11         :
-----------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV11
`define AHB_ENV_SV11

//------------------------------------------------------------------------------
//
// CLASS11: ahb_env11
//
//------------------------------------------------------------------------------

class ahb_env11 extends uvm_env;

  // Virtual Interface11 variable
  protected virtual interface ahb_if11 vif11;
 
  // The following11 two11 bits are used to control11 whether11 checks11 and coverage11 are
  // done both in the bus monitor11 class and the interface.
  bit checks_enable11 = 1; 
  bit coverage_enable11 = 1;

  // Components of the environment11
  ahb_master_agent11 master_agent11;
  ahb_slave_agent11 slave_agent11;

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(ahb_env11)
    `uvm_field_int(checks_enable11, UVM_ALL_ON)
    `uvm_field_int(coverage_enable11, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor11 - required11 syntax11 for UVM automation11 and utilities11
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables11();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env11

  // UVM build() phase
  function void ahb_env11::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent11 = ahb_master_agent11::type_id::create("master_agent11", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if11)::get(this, "", "vif11", vif11))
   `uvm_fatal("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

  // Function11 to assign the checks11 and coverage11 bits
  task ahb_env11::update_vif_enables11();
    // Make11 assignments11 at time zero based upon11 config
    vif11.has_checks11 <= checks_enable11;
    vif11.has_coverage <= coverage_enable11;
    forever begin
      // Make11 assignments11 whenever11 enables11 change after time zero
      @(checks_enable11 || coverage_enable11);
      vif11.has_checks11 <= checks_enable11;
      vif11.has_coverage <= coverage_enable11;
    end
  endtask : update_vif_enables11

  // UVM run() phase
  task ahb_env11::run_phase(uvm_phase phase);
    fork
      update_vif_enables11();
    join_none
  endtask

`endif // AHB_ENV_SV11

