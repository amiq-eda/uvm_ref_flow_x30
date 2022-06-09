/*******************************************************************************
  FILE : apb_config20.sv
  This20 file contains20 multiple configuration classes20:
    apb_slave_config20 - for configuring20 an APB20 slave20 device20
    apb_master_config20 - for configuring20 an APB20 master20 device20
    apb_config20 - has 1 master20 config and N slave20 config's
    default_apb_config20 - configures20 for 1 master20 and 2 slaves20
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV20
`define APB_CONFIG_SV20

// APB20 Slave20 Configuration20 Information20
class apb_slave_config20 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address20;
  rand int end_address20;
  rand int psel_index20;

  constraint addr_cst20 { start_address20 <= end_address20; }
  constraint psel_cst20 { psel_index20 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config20)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address20, UVM_DEFAULT)
    `uvm_field_int(end_address20, UVM_DEFAULT)
    `uvm_field_int(psel_index20, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor20 - UVM required20 syntax20
  function new (string name = "apb_slave_config20");
    super.new(name);
  endfunction

  // Checks20 to see20 if an address is in the configured20 range
  function bit check_address_range20(int unsigned addr);
    return (!((start_address20 > addr) || (end_address20 < addr)));
  endfunction

endclass : apb_slave_config20

// APB20 Master20 Configuration20 Information20
class apb_master_config20 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed20-apb_master_config20");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config20)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config20

// APB20 Configuration20 Information20 
class apb_config20 extends uvm_object;

  // APB20 has one master20 and N slaves20
  apb_master_config20 master_config20;
  apb_slave_config20 slave_configs20[$];
  int num_slaves20;

  `uvm_object_utils_begin(apb_config20)
    `uvm_field_queue_object(slave_configs20, UVM_DEFAULT)
    `uvm_field_object(master_config20, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed20-apb_config20");
    super.new(name);
  endfunction

  // Additional20 class methods20
  extern function void add_slave20(string name, int start_addr20, int end_addr20,
            int psel_indx20, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master20(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr20(int addr);
  extern function string get_slave_name_by_addr20(int addr);
endclass  : apb_config20

// apb_config20 - Creates20 and configures20 a slave20 agent20 config and adds20 to a queue
function void apb_config20::add_slave20(string name, int start_addr20, int end_addr20,
            int psel_indx20, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config20 tmp_slave_cfg20;
  num_slaves20++;
  tmp_slave_cfg20 = apb_slave_config20::type_id::create("slave_config20");
  tmp_slave_cfg20.name = name;
  tmp_slave_cfg20.start_address20 = start_addr20;
  tmp_slave_cfg20.end_address20 = end_addr20;
  tmp_slave_cfg20.psel_index20 = psel_indx20;
  tmp_slave_cfg20.is_active = is_active;
  
  slave_configs20.push_back(tmp_slave_cfg20);
endfunction : add_slave20

// apb_config20 - Creates20 and configures20 a master20 agent20 configuration
function void apb_config20::add_master20(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config20 = apb_master_config20::type_id::create("master_config20");
  master_config20.name = name;
  master_config20.is_active = is_active;
endfunction : add_master20

// apb_config20 - Returns20 the slave20 psel20 index
function int apb_config20::get_slave_psel_by_addr20(int addr);
  for (int i = 0; i < slave_configs20.size(); i++)
    if(slave_configs20[i].check_address_range20(addr)) begin
      return slave_configs20[i].psel_index20;
    end
endfunction : get_slave_psel_by_addr20

// apb_config20 - Return20 the name of the slave20
function string apb_config20::get_slave_name_by_addr20(int addr);
  for (int i = 0; i < slave_configs20.size(); i++)
    if(slave_configs20[i].check_address_range20(addr)) begin
      return slave_configs20[i].name;
    end
endfunction : get_slave_name_by_addr20

//================================================================
// Default APB20 configuration - One20 Master20, Two20 slaves20
//================================================================
class default_apb_config20 extends apb_config20;

  `uvm_object_utils(default_apb_config20)

  function new(string name = "default_apb_config20-S0S120-master20");
    super.new(name);
    add_slave20("slave020", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave20("slave120", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master20("master20", UVM_ACTIVE);
  endfunction

endclass : default_apb_config20

`endif // APB_CONFIG_SV20
