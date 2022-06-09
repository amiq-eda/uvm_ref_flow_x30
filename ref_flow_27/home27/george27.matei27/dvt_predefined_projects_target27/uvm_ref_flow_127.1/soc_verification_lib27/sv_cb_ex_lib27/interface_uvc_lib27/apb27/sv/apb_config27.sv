/*******************************************************************************
  FILE : apb_config27.sv
  This27 file contains27 multiple configuration classes27:
    apb_slave_config27 - for configuring27 an APB27 slave27 device27
    apb_master_config27 - for configuring27 an APB27 master27 device27
    apb_config27 - has 1 master27 config and N slave27 config's
    default_apb_config27 - configures27 for 1 master27 and 2 slaves27
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV27
`define APB_CONFIG_SV27

// APB27 Slave27 Configuration27 Information27
class apb_slave_config27 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address27;
  rand int end_address27;
  rand int psel_index27;

  constraint addr_cst27 { start_address27 <= end_address27; }
  constraint psel_cst27 { psel_index27 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config27)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address27, UVM_DEFAULT)
    `uvm_field_int(end_address27, UVM_DEFAULT)
    `uvm_field_int(psel_index27, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor27 - UVM required27 syntax27
  function new (string name = "apb_slave_config27");
    super.new(name);
  endfunction

  // Checks27 to see27 if an address is in the configured27 range
  function bit check_address_range27(int unsigned addr);
    return (!((start_address27 > addr) || (end_address27 < addr)));
  endfunction

endclass : apb_slave_config27

// APB27 Master27 Configuration27 Information27
class apb_master_config27 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed27-apb_master_config27");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config27)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config27

// APB27 Configuration27 Information27 
class apb_config27 extends uvm_object;

  // APB27 has one master27 and N slaves27
  apb_master_config27 master_config27;
  apb_slave_config27 slave_configs27[$];
  int num_slaves27;

  `uvm_object_utils_begin(apb_config27)
    `uvm_field_queue_object(slave_configs27, UVM_DEFAULT)
    `uvm_field_object(master_config27, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed27-apb_config27");
    super.new(name);
  endfunction

  // Additional27 class methods27
  extern function void add_slave27(string name, int start_addr27, int end_addr27,
            int psel_indx27, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master27(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr27(int addr);
  extern function string get_slave_name_by_addr27(int addr);
endclass  : apb_config27

// apb_config27 - Creates27 and configures27 a slave27 agent27 config and adds27 to a queue
function void apb_config27::add_slave27(string name, int start_addr27, int end_addr27,
            int psel_indx27, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config27 tmp_slave_cfg27;
  num_slaves27++;
  tmp_slave_cfg27 = apb_slave_config27::type_id::create("slave_config27");
  tmp_slave_cfg27.name = name;
  tmp_slave_cfg27.start_address27 = start_addr27;
  tmp_slave_cfg27.end_address27 = end_addr27;
  tmp_slave_cfg27.psel_index27 = psel_indx27;
  tmp_slave_cfg27.is_active = is_active;
  
  slave_configs27.push_back(tmp_slave_cfg27);
endfunction : add_slave27

// apb_config27 - Creates27 and configures27 a master27 agent27 configuration
function void apb_config27::add_master27(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config27 = apb_master_config27::type_id::create("master_config27");
  master_config27.name = name;
  master_config27.is_active = is_active;
endfunction : add_master27

// apb_config27 - Returns27 the slave27 psel27 index
function int apb_config27::get_slave_psel_by_addr27(int addr);
  for (int i = 0; i < slave_configs27.size(); i++)
    if(slave_configs27[i].check_address_range27(addr)) begin
      return slave_configs27[i].psel_index27;
    end
endfunction : get_slave_psel_by_addr27

// apb_config27 - Return27 the name of the slave27
function string apb_config27::get_slave_name_by_addr27(int addr);
  for (int i = 0; i < slave_configs27.size(); i++)
    if(slave_configs27[i].check_address_range27(addr)) begin
      return slave_configs27[i].name;
    end
endfunction : get_slave_name_by_addr27

//================================================================
// Default APB27 configuration - One27 Master27, Two27 slaves27
//================================================================
class default_apb_config27 extends apb_config27;

  `uvm_object_utils(default_apb_config27)

  function new(string name = "default_apb_config27-S0S127-master27");
    super.new(name);
    add_slave27("slave027", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave27("slave127", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master27("master27", UVM_ACTIVE);
  endfunction

endclass : default_apb_config27

`endif // APB_CONFIG_SV27
