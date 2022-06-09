/*******************************************************************************
  FILE : apb_config15.sv
  This15 file contains15 multiple configuration classes15:
    apb_slave_config15 - for configuring15 an APB15 slave15 device15
    apb_master_config15 - for configuring15 an APB15 master15 device15
    apb_config15 - has 1 master15 config and N slave15 config's
    default_apb_config15 - configures15 for 1 master15 and 2 slaves15
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV15
`define APB_CONFIG_SV15

// APB15 Slave15 Configuration15 Information15
class apb_slave_config15 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address15;
  rand int end_address15;
  rand int psel_index15;

  constraint addr_cst15 { start_address15 <= end_address15; }
  constraint psel_cst15 { psel_index15 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config15)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address15, UVM_DEFAULT)
    `uvm_field_int(end_address15, UVM_DEFAULT)
    `uvm_field_int(psel_index15, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor15 - UVM required15 syntax15
  function new (string name = "apb_slave_config15");
    super.new(name);
  endfunction

  // Checks15 to see15 if an address is in the configured15 range
  function bit check_address_range15(int unsigned addr);
    return (!((start_address15 > addr) || (end_address15 < addr)));
  endfunction

endclass : apb_slave_config15

// APB15 Master15 Configuration15 Information15
class apb_master_config15 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed15-apb_master_config15");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config15)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config15

// APB15 Configuration15 Information15 
class apb_config15 extends uvm_object;

  // APB15 has one master15 and N slaves15
  apb_master_config15 master_config15;
  apb_slave_config15 slave_configs15[$];
  int num_slaves15;

  `uvm_object_utils_begin(apb_config15)
    `uvm_field_queue_object(slave_configs15, UVM_DEFAULT)
    `uvm_field_object(master_config15, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed15-apb_config15");
    super.new(name);
  endfunction

  // Additional15 class methods15
  extern function void add_slave15(string name, int start_addr15, int end_addr15,
            int psel_indx15, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master15(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr15(int addr);
  extern function string get_slave_name_by_addr15(int addr);
endclass  : apb_config15

// apb_config15 - Creates15 and configures15 a slave15 agent15 config and adds15 to a queue
function void apb_config15::add_slave15(string name, int start_addr15, int end_addr15,
            int psel_indx15, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config15 tmp_slave_cfg15;
  num_slaves15++;
  tmp_slave_cfg15 = apb_slave_config15::type_id::create("slave_config15");
  tmp_slave_cfg15.name = name;
  tmp_slave_cfg15.start_address15 = start_addr15;
  tmp_slave_cfg15.end_address15 = end_addr15;
  tmp_slave_cfg15.psel_index15 = psel_indx15;
  tmp_slave_cfg15.is_active = is_active;
  
  slave_configs15.push_back(tmp_slave_cfg15);
endfunction : add_slave15

// apb_config15 - Creates15 and configures15 a master15 agent15 configuration
function void apb_config15::add_master15(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config15 = apb_master_config15::type_id::create("master_config15");
  master_config15.name = name;
  master_config15.is_active = is_active;
endfunction : add_master15

// apb_config15 - Returns15 the slave15 psel15 index
function int apb_config15::get_slave_psel_by_addr15(int addr);
  for (int i = 0; i < slave_configs15.size(); i++)
    if(slave_configs15[i].check_address_range15(addr)) begin
      return slave_configs15[i].psel_index15;
    end
endfunction : get_slave_psel_by_addr15

// apb_config15 - Return15 the name of the slave15
function string apb_config15::get_slave_name_by_addr15(int addr);
  for (int i = 0; i < slave_configs15.size(); i++)
    if(slave_configs15[i].check_address_range15(addr)) begin
      return slave_configs15[i].name;
    end
endfunction : get_slave_name_by_addr15

//================================================================
// Default APB15 configuration - One15 Master15, Two15 slaves15
//================================================================
class default_apb_config15 extends apb_config15;

  `uvm_object_utils(default_apb_config15)

  function new(string name = "default_apb_config15-S0S115-master15");
    super.new(name);
    add_slave15("slave015", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave15("slave115", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master15("master15", UVM_ACTIVE);
  endfunction

endclass : default_apb_config15

`endif // APB_CONFIG_SV15
