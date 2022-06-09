// IVB29 checksum29: 2064975656
/*-----------------------------------------------------------------
File29 name     : ahb_env29.sv
Created29       : Wed29 May29 19 15:42:20 2010
Description29   : This29 file implements29 the OVC29 env29.
Notes29         :
-----------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV29
`define AHB_ENV_SV29

//------------------------------------------------------------------------------
//
// CLASS29: ahb_env29
//
//------------------------------------------------------------------------------

class ahb_env29 extends uvm_env;

  // Virtual Interface29 variable
  protected virtual interface ahb_if29 vif29;
 
  // The following29 two29 bits are used to control29 whether29 checks29 and coverage29 are
  // done both in the bus monitor29 class and the interface.
  bit checks_enable29 = 1; 
  bit coverage_enable29 = 1;

  // Components of the environment29
  ahb_master_agent29 master_agent29;
  ahb_slave_agent29 slave_agent29;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(ahb_env29)
    `uvm_field_int(checks_enable29, UVM_ALL_ON)
    `uvm_field_int(coverage_enable29, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor29 - required29 syntax29 for UVM automation29 and utilities29
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables29();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env29

  // UVM build() phase
  function void ahb_env29::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent29 = ahb_master_agent29::type_id::create("master_agent29", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if29)::get(this, "", "vif29", vif29))
   `uvm_fatal("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

  // Function29 to assign the checks29 and coverage29 bits
  task ahb_env29::update_vif_enables29();
    // Make29 assignments29 at time zero based upon29 config
    vif29.has_checks29 <= checks_enable29;
    vif29.has_coverage <= coverage_enable29;
    forever begin
      // Make29 assignments29 whenever29 enables29 change after time zero
      @(checks_enable29 || coverage_enable29);
      vif29.has_checks29 <= checks_enable29;
      vif29.has_coverage <= coverage_enable29;
    end
  endtask : update_vif_enables29

  // UVM run() phase
  task ahb_env29::run_phase(uvm_phase phase);
    fork
      update_vif_enables29();
    join_none
  endtask

`endif // AHB_ENV_SV29

