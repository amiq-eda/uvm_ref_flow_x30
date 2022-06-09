// IVB21 checksum21: 2064975656
/*-----------------------------------------------------------------
File21 name     : ahb_env21.sv
Created21       : Wed21 May21 19 15:42:20 2010
Description21   : This21 file implements21 the OVC21 env21.
Notes21         :
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV21
`define AHB_ENV_SV21

//------------------------------------------------------------------------------
//
// CLASS21: ahb_env21
//
//------------------------------------------------------------------------------

class ahb_env21 extends uvm_env;

  // Virtual Interface21 variable
  protected virtual interface ahb_if21 vif21;
 
  // The following21 two21 bits are used to control21 whether21 checks21 and coverage21 are
  // done both in the bus monitor21 class and the interface.
  bit checks_enable21 = 1; 
  bit coverage_enable21 = 1;

  // Components of the environment21
  ahb_master_agent21 master_agent21;
  ahb_slave_agent21 slave_agent21;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(ahb_env21)
    `uvm_field_int(checks_enable21, UVM_ALL_ON)
    `uvm_field_int(coverage_enable21, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor21 - required21 syntax21 for UVM automation21 and utilities21
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables21();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env21

  // UVM build() phase
  function void ahb_env21::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent21 = ahb_master_agent21::type_id::create("master_agent21", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if21)::get(this, "", "vif21", vif21))
   `uvm_fatal("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

  // Function21 to assign the checks21 and coverage21 bits
  task ahb_env21::update_vif_enables21();
    // Make21 assignments21 at time zero based upon21 config
    vif21.has_checks21 <= checks_enable21;
    vif21.has_coverage <= coverage_enable21;
    forever begin
      // Make21 assignments21 whenever21 enables21 change after time zero
      @(checks_enable21 || coverage_enable21);
      vif21.has_checks21 <= checks_enable21;
      vif21.has_coverage <= coverage_enable21;
    end
  endtask : update_vif_enables21

  // UVM run() phase
  task ahb_env21::run_phase(uvm_phase phase);
    fork
      update_vif_enables21();
    join_none
  endtask

`endif // AHB_ENV_SV21

