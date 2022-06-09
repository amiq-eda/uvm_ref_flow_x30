// IVB2 checksum2: 2064975656
/*-----------------------------------------------------------------
File2 name     : ahb_env2.sv
Created2       : Wed2 May2 19 15:42:20 2010
Description2   : This2 file implements2 the OVC2 env2.
Notes2         :
-----------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV2
`define AHB_ENV_SV2

//------------------------------------------------------------------------------
//
// CLASS2: ahb_env2
//
//------------------------------------------------------------------------------

class ahb_env2 extends uvm_env;

  // Virtual Interface2 variable
  protected virtual interface ahb_if2 vif2;
 
  // The following2 two2 bits are used to control2 whether2 checks2 and coverage2 are
  // done both in the bus monitor2 class and the interface.
  bit checks_enable2 = 1; 
  bit coverage_enable2 = 1;

  // Components of the environment2
  ahb_master_agent2 master_agent2;
  ahb_slave_agent2 slave_agent2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(ahb_env2)
    `uvm_field_int(checks_enable2, UVM_ALL_ON)
    `uvm_field_int(coverage_enable2, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor2 - required2 syntax2 for UVM automation2 and utilities2
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables2();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env2

  // UVM build() phase
  function void ahb_env2::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent2 = ahb_master_agent2::type_id::create("master_agent2", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if2)::get(this, "", "vif2", vif2))
   `uvm_fatal("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

  // Function2 to assign the checks2 and coverage2 bits
  task ahb_env2::update_vif_enables2();
    // Make2 assignments2 at time zero based upon2 config
    vif2.has_checks2 <= checks_enable2;
    vif2.has_coverage <= coverage_enable2;
    forever begin
      // Make2 assignments2 whenever2 enables2 change after time zero
      @(checks_enable2 || coverage_enable2);
      vif2.has_checks2 <= checks_enable2;
      vif2.has_coverage <= coverage_enable2;
    end
  endtask : update_vif_enables2

  // UVM run() phase
  task ahb_env2::run_phase(uvm_phase phase);
    fork
      update_vif_enables2();
    join_none
  endtask

`endif // AHB_ENV_SV2

