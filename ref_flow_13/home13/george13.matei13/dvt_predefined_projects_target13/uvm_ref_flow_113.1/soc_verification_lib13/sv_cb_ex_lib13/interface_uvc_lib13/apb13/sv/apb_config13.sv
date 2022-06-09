/*******************************************************************************
  FILE : apb_config13.sv
  This13 file contains13 multiple configuration classes13:
    apb_slave_config13 - for configuring13 an APB13 slave13 device13
    apb_master_config13 - for configuring13 an APB13 master13 device13
    apb_config13 - has 1 master13 config and N slave13 config's
    default_apb_config13 - configures13 for 1 master13 and 2 slaves13
*******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV13
`define APB_CONFIG_SV13

// APB13 Slave13 Configuration13 Information13
class apb_slave_config13 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address13;
  rand int end_address13;
  rand int psel_index13;

  constraint addr_cst13 { start_address13 <= end_address13; }
  constraint psel_cst13 { psel_index13 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config13)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address13, UVM_DEFAULT)
    `uvm_field_int(end_address13, UVM_DEFAULT)
    `uvm_field_int(psel_index13, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor13 - UVM required13 syntax13
  function new (string name = "apb_slave_config13");
    super.new(name);
  endfunction

  // Checks13 to see13 if an address is in the configured13 range
  function bit check_address_range13(int unsigned addr);
    return (!((start_address13 > addr) || (end_address13 < addr)));
  endfunction

endclass : apb_slave_config13

// APB13 Master13 Configuration13 Information13
class apb_master_config13 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed13-apb_master_config13");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config13)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config13

// APB13 Configuration13 Information13 
class apb_config13 extends uvm_object;

  // APB13 has one master13 and N slaves13
  apb_master_config13 master_config13;
  apb_slave_config13 slave_configs13[$];
  int num_slaves13;

  `uvm_object_utils_begin(apb_config13)
    `uvm_field_queue_object(slave_configs13, UVM_DEFAULT)
    `uvm_field_object(master_config13, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed13-apb_config13");
    super.new(name);
  endfunction

  // Additional13 class methods13
  extern function void add_slave13(string name, int start_addr13, int end_addr13,
            int psel_indx13, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master13(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr13(int addr);
  extern function string get_slave_name_by_addr13(int addr);
endclass  : apb_config13

// apb_config13 - Creates13 and configures13 a slave13 agent13 config and adds13 to a queue
function void apb_config13::add_slave13(string name, int start_addr13, int end_addr13,
            int psel_indx13, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config13 tmp_slave_cfg13;
  num_slaves13++;
  tmp_slave_cfg13 = apb_slave_config13::type_id::create("slave_config13");
  tmp_slave_cfg13.name = name;
  tmp_slave_cfg13.start_address13 = start_addr13;
  tmp_slave_cfg13.end_address13 = end_addr13;
  tmp_slave_cfg13.psel_index13 = psel_indx13;
  tmp_slave_cfg13.is_active = is_active;
  
  slave_configs13.push_back(tmp_slave_cfg13);
endfunction : add_slave13

// apb_config13 - Creates13 and configures13 a master13 agent13 configuration
function void apb_config13::add_master13(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config13 = apb_master_config13::type_id::create("master_config13");
  master_config13.name = name;
  master_config13.is_active = is_active;
endfunction : add_master13

// apb_config13 - Returns13 the slave13 psel13 index
function int apb_config13::get_slave_psel_by_addr13(int addr);
  for (int i = 0; i < slave_configs13.size(); i++)
    if(slave_configs13[i].check_address_range13(addr)) begin
      return slave_configs13[i].psel_index13;
    end
endfunction : get_slave_psel_by_addr13

// apb_config13 - Return13 the name of the slave13
function string apb_config13::get_slave_name_by_addr13(int addr);
  for (int i = 0; i < slave_configs13.size(); i++)
    if(slave_configs13[i].check_address_range13(addr)) begin
      return slave_configs13[i].name;
    end
endfunction : get_slave_name_by_addr13

//================================================================
// Default APB13 configuration - One13 Master13, Two13 slaves13
//================================================================
class default_apb_config13 extends apb_config13;

  `uvm_object_utils(default_apb_config13)

  function new(string name = "default_apb_config13-S0S113-master13");
    super.new(name);
    add_slave13("slave013", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave13("slave113", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master13("master13", UVM_ACTIVE);
  endfunction

endclass : default_apb_config13

`endif // APB_CONFIG_SV13
