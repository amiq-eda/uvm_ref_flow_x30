/*******************************************************************************
  FILE : apb_config17.sv
  This17 file contains17 multiple configuration classes17:
    apb_slave_config17 - for configuring17 an APB17 slave17 device17
    apb_master_config17 - for configuring17 an APB17 master17 device17
    apb_config17 - has 1 master17 config and N slave17 config's
    default_apb_config17 - configures17 for 1 master17 and 2 slaves17
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV17
`define APB_CONFIG_SV17

// APB17 Slave17 Configuration17 Information17
class apb_slave_config17 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address17;
  rand int end_address17;
  rand int psel_index17;

  constraint addr_cst17 { start_address17 <= end_address17; }
  constraint psel_cst17 { psel_index17 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config17)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address17, UVM_DEFAULT)
    `uvm_field_int(end_address17, UVM_DEFAULT)
    `uvm_field_int(psel_index17, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor17 - UVM required17 syntax17
  function new (string name = "apb_slave_config17");
    super.new(name);
  endfunction

  // Checks17 to see17 if an address is in the configured17 range
  function bit check_address_range17(int unsigned addr);
    return (!((start_address17 > addr) || (end_address17 < addr)));
  endfunction

endclass : apb_slave_config17

// APB17 Master17 Configuration17 Information17
class apb_master_config17 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed17-apb_master_config17");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config17)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config17

// APB17 Configuration17 Information17 
class apb_config17 extends uvm_object;

  // APB17 has one master17 and N slaves17
  apb_master_config17 master_config17;
  apb_slave_config17 slave_configs17[$];
  int num_slaves17;

  `uvm_object_utils_begin(apb_config17)
    `uvm_field_queue_object(slave_configs17, UVM_DEFAULT)
    `uvm_field_object(master_config17, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed17-apb_config17");
    super.new(name);
  endfunction

  // Additional17 class methods17
  extern function void add_slave17(string name, int start_addr17, int end_addr17,
            int psel_indx17, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master17(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr17(int addr);
  extern function string get_slave_name_by_addr17(int addr);
endclass  : apb_config17

// apb_config17 - Creates17 and configures17 a slave17 agent17 config and adds17 to a queue
function void apb_config17::add_slave17(string name, int start_addr17, int end_addr17,
            int psel_indx17, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config17 tmp_slave_cfg17;
  num_slaves17++;
  tmp_slave_cfg17 = apb_slave_config17::type_id::create("slave_config17");
  tmp_slave_cfg17.name = name;
  tmp_slave_cfg17.start_address17 = start_addr17;
  tmp_slave_cfg17.end_address17 = end_addr17;
  tmp_slave_cfg17.psel_index17 = psel_indx17;
  tmp_slave_cfg17.is_active = is_active;
  
  slave_configs17.push_back(tmp_slave_cfg17);
endfunction : add_slave17

// apb_config17 - Creates17 and configures17 a master17 agent17 configuration
function void apb_config17::add_master17(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config17 = apb_master_config17::type_id::create("master_config17");
  master_config17.name = name;
  master_config17.is_active = is_active;
endfunction : add_master17

// apb_config17 - Returns17 the slave17 psel17 index
function int apb_config17::get_slave_psel_by_addr17(int addr);
  for (int i = 0; i < slave_configs17.size(); i++)
    if(slave_configs17[i].check_address_range17(addr)) begin
      return slave_configs17[i].psel_index17;
    end
endfunction : get_slave_psel_by_addr17

// apb_config17 - Return17 the name of the slave17
function string apb_config17::get_slave_name_by_addr17(int addr);
  for (int i = 0; i < slave_configs17.size(); i++)
    if(slave_configs17[i].check_address_range17(addr)) begin
      return slave_configs17[i].name;
    end
endfunction : get_slave_name_by_addr17

//================================================================
// Default APB17 configuration - One17 Master17, Two17 slaves17
//================================================================
class default_apb_config17 extends apb_config17;

  `uvm_object_utils(default_apb_config17)

  function new(string name = "default_apb_config17-S0S117-master17");
    super.new(name);
    add_slave17("slave017", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave17("slave117", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master17("master17", UVM_ACTIVE);
  endfunction

endclass : default_apb_config17

`endif // APB_CONFIG_SV17
