// IVB5 checksum5: 2064975656
/*-----------------------------------------------------------------
File5 name     : ahb_env5.sv
Created5       : Wed5 May5 19 15:42:20 2010
Description5   : This5 file implements5 the OVC5 env5.
Notes5         :
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV5
`define AHB_ENV_SV5

//------------------------------------------------------------------------------
//
// CLASS5: ahb_env5
//
//------------------------------------------------------------------------------

class ahb_env5 extends uvm_env;

  // Virtual Interface5 variable
  protected virtual interface ahb_if5 vif5;
 
  // The following5 two5 bits are used to control5 whether5 checks5 and coverage5 are
  // done both in the bus monitor5 class and the interface.
  bit checks_enable5 = 1; 
  bit coverage_enable5 = 1;

  // Components of the environment5
  ahb_master_agent5 master_agent5;
  ahb_slave_agent5 slave_agent5;

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(ahb_env5)
    `uvm_field_int(checks_enable5, UVM_ALL_ON)
    `uvm_field_int(coverage_enable5, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables5();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env5

  // UVM build() phase
  function void ahb_env5::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent5 = ahb_master_agent5::type_id::create("master_agent5", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if5)::get(this, "", "vif5", vif5))
   `uvm_fatal("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

  // Function5 to assign the checks5 and coverage5 bits
  task ahb_env5::update_vif_enables5();
    // Make5 assignments5 at time zero based upon5 config
    vif5.has_checks5 <= checks_enable5;
    vif5.has_coverage <= coverage_enable5;
    forever begin
      // Make5 assignments5 whenever5 enables5 change after time zero
      @(checks_enable5 || coverage_enable5);
      vif5.has_checks5 <= checks_enable5;
      vif5.has_coverage <= coverage_enable5;
    end
  endtask : update_vif_enables5

  // UVM run() phase
  task ahb_env5::run_phase(uvm_phase phase);
    fork
      update_vif_enables5();
    join_none
  endtask

`endif // AHB_ENV_SV5

