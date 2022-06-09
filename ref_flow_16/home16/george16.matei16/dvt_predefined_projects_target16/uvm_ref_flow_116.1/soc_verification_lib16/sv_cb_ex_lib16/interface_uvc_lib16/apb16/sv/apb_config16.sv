/*******************************************************************************
  FILE : apb_config16.sv
  This16 file contains16 multiple configuration classes16:
    apb_slave_config16 - for configuring16 an APB16 slave16 device16
    apb_master_config16 - for configuring16 an APB16 master16 device16
    apb_config16 - has 1 master16 config and N slave16 config's
    default_apb_config16 - configures16 for 1 master16 and 2 slaves16
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV16
`define APB_CONFIG_SV16

// APB16 Slave16 Configuration16 Information16
class apb_slave_config16 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address16;
  rand int end_address16;
  rand int psel_index16;

  constraint addr_cst16 { start_address16 <= end_address16; }
  constraint psel_cst16 { psel_index16 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config16)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address16, UVM_DEFAULT)
    `uvm_field_int(end_address16, UVM_DEFAULT)
    `uvm_field_int(psel_index16, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor16 - UVM required16 syntax16
  function new (string name = "apb_slave_config16");
    super.new(name);
  endfunction

  // Checks16 to see16 if an address is in the configured16 range
  function bit check_address_range16(int unsigned addr);
    return (!((start_address16 > addr) || (end_address16 < addr)));
  endfunction

endclass : apb_slave_config16

// APB16 Master16 Configuration16 Information16
class apb_master_config16 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed16-apb_master_config16");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config16)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config16

// APB16 Configuration16 Information16 
class apb_config16 extends uvm_object;

  // APB16 has one master16 and N slaves16
  apb_master_config16 master_config16;
  apb_slave_config16 slave_configs16[$];
  int num_slaves16;

  `uvm_object_utils_begin(apb_config16)
    `uvm_field_queue_object(slave_configs16, UVM_DEFAULT)
    `uvm_field_object(master_config16, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed16-apb_config16");
    super.new(name);
  endfunction

  // Additional16 class methods16
  extern function void add_slave16(string name, int start_addr16, int end_addr16,
            int psel_indx16, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master16(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr16(int addr);
  extern function string get_slave_name_by_addr16(int addr);
endclass  : apb_config16

// apb_config16 - Creates16 and configures16 a slave16 agent16 config and adds16 to a queue
function void apb_config16::add_slave16(string name, int start_addr16, int end_addr16,
            int psel_indx16, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config16 tmp_slave_cfg16;
  num_slaves16++;
  tmp_slave_cfg16 = apb_slave_config16::type_id::create("slave_config16");
  tmp_slave_cfg16.name = name;
  tmp_slave_cfg16.start_address16 = start_addr16;
  tmp_slave_cfg16.end_address16 = end_addr16;
  tmp_slave_cfg16.psel_index16 = psel_indx16;
  tmp_slave_cfg16.is_active = is_active;
  
  slave_configs16.push_back(tmp_slave_cfg16);
endfunction : add_slave16

// apb_config16 - Creates16 and configures16 a master16 agent16 configuration
function void apb_config16::add_master16(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config16 = apb_master_config16::type_id::create("master_config16");
  master_config16.name = name;
  master_config16.is_active = is_active;
endfunction : add_master16

// apb_config16 - Returns16 the slave16 psel16 index
function int apb_config16::get_slave_psel_by_addr16(int addr);
  for (int i = 0; i < slave_configs16.size(); i++)
    if(slave_configs16[i].check_address_range16(addr)) begin
      return slave_configs16[i].psel_index16;
    end
endfunction : get_slave_psel_by_addr16

// apb_config16 - Return16 the name of the slave16
function string apb_config16::get_slave_name_by_addr16(int addr);
  for (int i = 0; i < slave_configs16.size(); i++)
    if(slave_configs16[i].check_address_range16(addr)) begin
      return slave_configs16[i].name;
    end
endfunction : get_slave_name_by_addr16

//================================================================
// Default APB16 configuration - One16 Master16, Two16 slaves16
//================================================================
class default_apb_config16 extends apb_config16;

  `uvm_object_utils(default_apb_config16)

  function new(string name = "default_apb_config16-S0S116-master16");
    super.new(name);
    add_slave16("slave016", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave16("slave116", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master16("master16", UVM_ACTIVE);
  endfunction

endclass : default_apb_config16

`endif // APB_CONFIG_SV16
