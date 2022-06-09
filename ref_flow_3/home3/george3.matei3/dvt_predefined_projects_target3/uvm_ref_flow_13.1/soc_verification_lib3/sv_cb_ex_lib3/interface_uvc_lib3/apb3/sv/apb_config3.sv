/*******************************************************************************
  FILE : apb_config3.sv
  This3 file contains3 multiple configuration classes3:
    apb_slave_config3 - for configuring3 an APB3 slave3 device3
    apb_master_config3 - for configuring3 an APB3 master3 device3
    apb_config3 - has 1 master3 config and N slave3 config's
    default_apb_config3 - configures3 for 1 master3 and 2 slaves3
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV3
`define APB_CONFIG_SV3

// APB3 Slave3 Configuration3 Information3
class apb_slave_config3 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address3;
  rand int end_address3;
  rand int psel_index3;

  constraint addr_cst3 { start_address3 <= end_address3; }
  constraint psel_cst3 { psel_index3 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config3)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address3, UVM_DEFAULT)
    `uvm_field_int(end_address3, UVM_DEFAULT)
    `uvm_field_int(psel_index3, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor3 - UVM required3 syntax3
  function new (string name = "apb_slave_config3");
    super.new(name);
  endfunction

  // Checks3 to see3 if an address is in the configured3 range
  function bit check_address_range3(int unsigned addr);
    return (!((start_address3 > addr) || (end_address3 < addr)));
  endfunction

endclass : apb_slave_config3

// APB3 Master3 Configuration3 Information3
class apb_master_config3 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed3-apb_master_config3");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config3)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config3

// APB3 Configuration3 Information3 
class apb_config3 extends uvm_object;

  // APB3 has one master3 and N slaves3
  apb_master_config3 master_config3;
  apb_slave_config3 slave_configs3[$];
  int num_slaves3;

  `uvm_object_utils_begin(apb_config3)
    `uvm_field_queue_object(slave_configs3, UVM_DEFAULT)
    `uvm_field_object(master_config3, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed3-apb_config3");
    super.new(name);
  endfunction

  // Additional3 class methods3
  extern function void add_slave3(string name, int start_addr3, int end_addr3,
            int psel_indx3, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master3(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr3(int addr);
  extern function string get_slave_name_by_addr3(int addr);
endclass  : apb_config3

// apb_config3 - Creates3 and configures3 a slave3 agent3 config and adds3 to a queue
function void apb_config3::add_slave3(string name, int start_addr3, int end_addr3,
            int psel_indx3, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config3 tmp_slave_cfg3;
  num_slaves3++;
  tmp_slave_cfg3 = apb_slave_config3::type_id::create("slave_config3");
  tmp_slave_cfg3.name = name;
  tmp_slave_cfg3.start_address3 = start_addr3;
  tmp_slave_cfg3.end_address3 = end_addr3;
  tmp_slave_cfg3.psel_index3 = psel_indx3;
  tmp_slave_cfg3.is_active = is_active;
  
  slave_configs3.push_back(tmp_slave_cfg3);
endfunction : add_slave3

// apb_config3 - Creates3 and configures3 a master3 agent3 configuration
function void apb_config3::add_master3(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config3 = apb_master_config3::type_id::create("master_config3");
  master_config3.name = name;
  master_config3.is_active = is_active;
endfunction : add_master3

// apb_config3 - Returns3 the slave3 psel3 index
function int apb_config3::get_slave_psel_by_addr3(int addr);
  for (int i = 0; i < slave_configs3.size(); i++)
    if(slave_configs3[i].check_address_range3(addr)) begin
      return slave_configs3[i].psel_index3;
    end
endfunction : get_slave_psel_by_addr3

// apb_config3 - Return3 the name of the slave3
function string apb_config3::get_slave_name_by_addr3(int addr);
  for (int i = 0; i < slave_configs3.size(); i++)
    if(slave_configs3[i].check_address_range3(addr)) begin
      return slave_configs3[i].name;
    end
endfunction : get_slave_name_by_addr3

//================================================================
// Default APB3 configuration - One3 Master3, Two3 slaves3
//================================================================
class default_apb_config3 extends apb_config3;

  `uvm_object_utils(default_apb_config3)

  function new(string name = "default_apb_config3-S0S13-master3");
    super.new(name);
    add_slave3("slave03", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave3("slave13", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master3("master3", UVM_ACTIVE);
  endfunction

endclass : default_apb_config3

`endif // APB_CONFIG_SV3
