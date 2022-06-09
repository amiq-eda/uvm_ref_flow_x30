/*******************************************************************************
  FILE : apb_config8.sv
  This8 file contains8 multiple configuration classes8:
    apb_slave_config8 - for configuring8 an APB8 slave8 device8
    apb_master_config8 - for configuring8 an APB8 master8 device8
    apb_config8 - has 1 master8 config and N slave8 config's
    default_apb_config8 - configures8 for 1 master8 and 2 slaves8
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV8
`define APB_CONFIG_SV8

// APB8 Slave8 Configuration8 Information8
class apb_slave_config8 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address8;
  rand int end_address8;
  rand int psel_index8;

  constraint addr_cst8 { start_address8 <= end_address8; }
  constraint psel_cst8 { psel_index8 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config8)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address8, UVM_DEFAULT)
    `uvm_field_int(end_address8, UVM_DEFAULT)
    `uvm_field_int(psel_index8, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor8 - UVM required8 syntax8
  function new (string name = "apb_slave_config8");
    super.new(name);
  endfunction

  // Checks8 to see8 if an address is in the configured8 range
  function bit check_address_range8(int unsigned addr);
    return (!((start_address8 > addr) || (end_address8 < addr)));
  endfunction

endclass : apb_slave_config8

// APB8 Master8 Configuration8 Information8
class apb_master_config8 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed8-apb_master_config8");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config8)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config8

// APB8 Configuration8 Information8 
class apb_config8 extends uvm_object;

  // APB8 has one master8 and N slaves8
  apb_master_config8 master_config8;
  apb_slave_config8 slave_configs8[$];
  int num_slaves8;

  `uvm_object_utils_begin(apb_config8)
    `uvm_field_queue_object(slave_configs8, UVM_DEFAULT)
    `uvm_field_object(master_config8, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed8-apb_config8");
    super.new(name);
  endfunction

  // Additional8 class methods8
  extern function void add_slave8(string name, int start_addr8, int end_addr8,
            int psel_indx8, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master8(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr8(int addr);
  extern function string get_slave_name_by_addr8(int addr);
endclass  : apb_config8

// apb_config8 - Creates8 and configures8 a slave8 agent8 config and adds8 to a queue
function void apb_config8::add_slave8(string name, int start_addr8, int end_addr8,
            int psel_indx8, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config8 tmp_slave_cfg8;
  num_slaves8++;
  tmp_slave_cfg8 = apb_slave_config8::type_id::create("slave_config8");
  tmp_slave_cfg8.name = name;
  tmp_slave_cfg8.start_address8 = start_addr8;
  tmp_slave_cfg8.end_address8 = end_addr8;
  tmp_slave_cfg8.psel_index8 = psel_indx8;
  tmp_slave_cfg8.is_active = is_active;
  
  slave_configs8.push_back(tmp_slave_cfg8);
endfunction : add_slave8

// apb_config8 - Creates8 and configures8 a master8 agent8 configuration
function void apb_config8::add_master8(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config8 = apb_master_config8::type_id::create("master_config8");
  master_config8.name = name;
  master_config8.is_active = is_active;
endfunction : add_master8

// apb_config8 - Returns8 the slave8 psel8 index
function int apb_config8::get_slave_psel_by_addr8(int addr);
  for (int i = 0; i < slave_configs8.size(); i++)
    if(slave_configs8[i].check_address_range8(addr)) begin
      return slave_configs8[i].psel_index8;
    end
endfunction : get_slave_psel_by_addr8

// apb_config8 - Return8 the name of the slave8
function string apb_config8::get_slave_name_by_addr8(int addr);
  for (int i = 0; i < slave_configs8.size(); i++)
    if(slave_configs8[i].check_address_range8(addr)) begin
      return slave_configs8[i].name;
    end
endfunction : get_slave_name_by_addr8

//================================================================
// Default APB8 configuration - One8 Master8, Two8 slaves8
//================================================================
class default_apb_config8 extends apb_config8;

  `uvm_object_utils(default_apb_config8)

  function new(string name = "default_apb_config8-S0S18-master8");
    super.new(name);
    add_slave8("slave08", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave8("slave18", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master8("master8", UVM_ACTIVE);
  endfunction

endclass : default_apb_config8

`endif // APB_CONFIG_SV8
