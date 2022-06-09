/*******************************************************************************
  FILE : apb_config9.sv
  This9 file contains9 multiple configuration classes9:
    apb_slave_config9 - for configuring9 an APB9 slave9 device9
    apb_master_config9 - for configuring9 an APB9 master9 device9
    apb_config9 - has 1 master9 config and N slave9 config's
    default_apb_config9 - configures9 for 1 master9 and 2 slaves9
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV9
`define APB_CONFIG_SV9

// APB9 Slave9 Configuration9 Information9
class apb_slave_config9 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address9;
  rand int end_address9;
  rand int psel_index9;

  constraint addr_cst9 { start_address9 <= end_address9; }
  constraint psel_cst9 { psel_index9 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config9)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address9, UVM_DEFAULT)
    `uvm_field_int(end_address9, UVM_DEFAULT)
    `uvm_field_int(psel_index9, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor9 - UVM required9 syntax9
  function new (string name = "apb_slave_config9");
    super.new(name);
  endfunction

  // Checks9 to see9 if an address is in the configured9 range
  function bit check_address_range9(int unsigned addr);
    return (!((start_address9 > addr) || (end_address9 < addr)));
  endfunction

endclass : apb_slave_config9

// APB9 Master9 Configuration9 Information9
class apb_master_config9 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed9-apb_master_config9");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config9)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config9

// APB9 Configuration9 Information9 
class apb_config9 extends uvm_object;

  // APB9 has one master9 and N slaves9
  apb_master_config9 master_config9;
  apb_slave_config9 slave_configs9[$];
  int num_slaves9;

  `uvm_object_utils_begin(apb_config9)
    `uvm_field_queue_object(slave_configs9, UVM_DEFAULT)
    `uvm_field_object(master_config9, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed9-apb_config9");
    super.new(name);
  endfunction

  // Additional9 class methods9
  extern function void add_slave9(string name, int start_addr9, int end_addr9,
            int psel_indx9, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master9(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr9(int addr);
  extern function string get_slave_name_by_addr9(int addr);
endclass  : apb_config9

// apb_config9 - Creates9 and configures9 a slave9 agent9 config and adds9 to a queue
function void apb_config9::add_slave9(string name, int start_addr9, int end_addr9,
            int psel_indx9, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config9 tmp_slave_cfg9;
  num_slaves9++;
  tmp_slave_cfg9 = apb_slave_config9::type_id::create("slave_config9");
  tmp_slave_cfg9.name = name;
  tmp_slave_cfg9.start_address9 = start_addr9;
  tmp_slave_cfg9.end_address9 = end_addr9;
  tmp_slave_cfg9.psel_index9 = psel_indx9;
  tmp_slave_cfg9.is_active = is_active;
  
  slave_configs9.push_back(tmp_slave_cfg9);
endfunction : add_slave9

// apb_config9 - Creates9 and configures9 a master9 agent9 configuration
function void apb_config9::add_master9(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config9 = apb_master_config9::type_id::create("master_config9");
  master_config9.name = name;
  master_config9.is_active = is_active;
endfunction : add_master9

// apb_config9 - Returns9 the slave9 psel9 index
function int apb_config9::get_slave_psel_by_addr9(int addr);
  for (int i = 0; i < slave_configs9.size(); i++)
    if(slave_configs9[i].check_address_range9(addr)) begin
      return slave_configs9[i].psel_index9;
    end
endfunction : get_slave_psel_by_addr9

// apb_config9 - Return9 the name of the slave9
function string apb_config9::get_slave_name_by_addr9(int addr);
  for (int i = 0; i < slave_configs9.size(); i++)
    if(slave_configs9[i].check_address_range9(addr)) begin
      return slave_configs9[i].name;
    end
endfunction : get_slave_name_by_addr9

//================================================================
// Default APB9 configuration - One9 Master9, Two9 slaves9
//================================================================
class default_apb_config9 extends apb_config9;

  `uvm_object_utils(default_apb_config9)

  function new(string name = "default_apb_config9-S0S19-master9");
    super.new(name);
    add_slave9("slave09", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave9("slave19", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master9("master9", UVM_ACTIVE);
  endfunction

endclass : default_apb_config9

`endif // APB_CONFIG_SV9
