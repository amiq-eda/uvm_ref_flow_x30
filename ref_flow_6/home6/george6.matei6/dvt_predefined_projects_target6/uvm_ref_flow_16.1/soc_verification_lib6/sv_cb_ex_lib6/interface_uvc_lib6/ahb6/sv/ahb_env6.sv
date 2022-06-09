// IVB6 checksum6: 2064975656
/*-----------------------------------------------------------------
File6 name     : ahb_env6.sv
Created6       : Wed6 May6 19 15:42:20 2010
Description6   : This6 file implements6 the OVC6 env6.
Notes6         :
-----------------------------------------------------------------*/
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


`ifndef AHB_ENV_SV6
`define AHB_ENV_SV6

//------------------------------------------------------------------------------
//
// CLASS6: ahb_env6
//
//------------------------------------------------------------------------------

class ahb_env6 extends uvm_env;

  // Virtual Interface6 variable
  protected virtual interface ahb_if6 vif6;
 
  // The following6 two6 bits are used to control6 whether6 checks6 and coverage6 are
  // done both in the bus monitor6 class and the interface.
  bit checks_enable6 = 1; 
  bit coverage_enable6 = 1;

  // Components of the environment6
  ahb_master_agent6 master_agent6;
  ahb_slave_agent6 slave_agent6;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(ahb_env6)
    `uvm_field_int(checks_enable6, UVM_ALL_ON)
    `uvm_field_int(coverage_enable6, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor6 - required6 syntax6 for UVM automation6 and utilities6
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables6();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env6

  // UVM build() phase
  function void ahb_env6::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent6 = ahb_master_agent6::type_id::create("master_agent6", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if6)::get(this, "", "vif6", vif6))
   `uvm_fatal("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

  // Function6 to assign the checks6 and coverage6 bits
  task ahb_env6::update_vif_enables6();
    // Make6 assignments6 at time zero based upon6 config
    vif6.has_checks6 <= checks_enable6;
    vif6.has_coverage <= coverage_enable6;
    forever begin
      // Make6 assignments6 whenever6 enables6 change after time zero
      @(checks_enable6 || coverage_enable6);
      vif6.has_checks6 <= checks_enable6;
      vif6.has_coverage <= coverage_enable6;
    end
  endtask : update_vif_enables6

  // UVM run() phase
  task ahb_env6::run_phase(uvm_phase phase);
    fork
      update_vif_enables6();
    join_none
  endtask

`endif // AHB_ENV_SV6

