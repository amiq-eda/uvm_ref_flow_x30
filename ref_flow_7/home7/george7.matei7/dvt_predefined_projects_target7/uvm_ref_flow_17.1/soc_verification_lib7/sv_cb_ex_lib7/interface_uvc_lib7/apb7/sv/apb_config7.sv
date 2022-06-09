/*******************************************************************************
  FILE : apb_config7.sv
  This7 file contains7 multiple configuration classes7:
    apb_slave_config7 - for configuring7 an APB7 slave7 device7
    apb_master_config7 - for configuring7 an APB7 master7 device7
    apb_config7 - has 1 master7 config and N slave7 config's
    default_apb_config7 - configures7 for 1 master7 and 2 slaves7
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV7
`define APB_CONFIG_SV7

// APB7 Slave7 Configuration7 Information7
class apb_slave_config7 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address7;
  rand int end_address7;
  rand int psel_index7;

  constraint addr_cst7 { start_address7 <= end_address7; }
  constraint psel_cst7 { psel_index7 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config7)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address7, UVM_DEFAULT)
    `uvm_field_int(end_address7, UVM_DEFAULT)
    `uvm_field_int(psel_index7, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor7 - UVM required7 syntax7
  function new (string name = "apb_slave_config7");
    super.new(name);
  endfunction

  // Checks7 to see7 if an address is in the configured7 range
  function bit check_address_range7(int unsigned addr);
    return (!((start_address7 > addr) || (end_address7 < addr)));
  endfunction

endclass : apb_slave_config7

// APB7 Master7 Configuration7 Information7
class apb_master_config7 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed7-apb_master_config7");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config7)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config7

// APB7 Configuration7 Information7 
class apb_config7 extends uvm_object;

  // APB7 has one master7 and N slaves7
  apb_master_config7 master_config7;
  apb_slave_config7 slave_configs7[$];
  int num_slaves7;

  `uvm_object_utils_begin(apb_config7)
    `uvm_field_queue_object(slave_configs7, UVM_DEFAULT)
    `uvm_field_object(master_config7, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed7-apb_config7");
    super.new(name);
  endfunction

  // Additional7 class methods7
  extern function void add_slave7(string name, int start_addr7, int end_addr7,
            int psel_indx7, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master7(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr7(int addr);
  extern function string get_slave_name_by_addr7(int addr);
endclass  : apb_config7

// apb_config7 - Creates7 and configures7 a slave7 agent7 config and adds7 to a queue
function void apb_config7::add_slave7(string name, int start_addr7, int end_addr7,
            int psel_indx7, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config7 tmp_slave_cfg7;
  num_slaves7++;
  tmp_slave_cfg7 = apb_slave_config7::type_id::create("slave_config7");
  tmp_slave_cfg7.name = name;
  tmp_slave_cfg7.start_address7 = start_addr7;
  tmp_slave_cfg7.end_address7 = end_addr7;
  tmp_slave_cfg7.psel_index7 = psel_indx7;
  tmp_slave_cfg7.is_active = is_active;
  
  slave_configs7.push_back(tmp_slave_cfg7);
endfunction : add_slave7

// apb_config7 - Creates7 and configures7 a master7 agent7 configuration
function void apb_config7::add_master7(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config7 = apb_master_config7::type_id::create("master_config7");
  master_config7.name = name;
  master_config7.is_active = is_active;
endfunction : add_master7

// apb_config7 - Returns7 the slave7 psel7 index
function int apb_config7::get_slave_psel_by_addr7(int addr);
  for (int i = 0; i < slave_configs7.size(); i++)
    if(slave_configs7[i].check_address_range7(addr)) begin
      return slave_configs7[i].psel_index7;
    end
endfunction : get_slave_psel_by_addr7

// apb_config7 - Return7 the name of the slave7
function string apb_config7::get_slave_name_by_addr7(int addr);
  for (int i = 0; i < slave_configs7.size(); i++)
    if(slave_configs7[i].check_address_range7(addr)) begin
      return slave_configs7[i].name;
    end
endfunction : get_slave_name_by_addr7

//================================================================
// Default APB7 configuration - One7 Master7, Two7 slaves7
//================================================================
class default_apb_config7 extends apb_config7;

  `uvm_object_utils(default_apb_config7)

  function new(string name = "default_apb_config7-S0S17-master7");
    super.new(name);
    add_slave7("slave07", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave7("slave17", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master7("master7", UVM_ACTIVE);
  endfunction

endclass : default_apb_config7

`endif // APB_CONFIG_SV7
