/*******************************************************************************
  FILE : apb_config22.sv
  This22 file contains22 multiple configuration classes22:
    apb_slave_config22 - for configuring22 an APB22 slave22 device22
    apb_master_config22 - for configuring22 an APB22 master22 device22
    apb_config22 - has 1 master22 config and N slave22 config's
    default_apb_config22 - configures22 for 1 master22 and 2 slaves22
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV22
`define APB_CONFIG_SV22

// APB22 Slave22 Configuration22 Information22
class apb_slave_config22 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address22;
  rand int end_address22;
  rand int psel_index22;

  constraint addr_cst22 { start_address22 <= end_address22; }
  constraint psel_cst22 { psel_index22 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config22)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address22, UVM_DEFAULT)
    `uvm_field_int(end_address22, UVM_DEFAULT)
    `uvm_field_int(psel_index22, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor22 - UVM required22 syntax22
  function new (string name = "apb_slave_config22");
    super.new(name);
  endfunction

  // Checks22 to see22 if an address is in the configured22 range
  function bit check_address_range22(int unsigned addr);
    return (!((start_address22 > addr) || (end_address22 < addr)));
  endfunction

endclass : apb_slave_config22

// APB22 Master22 Configuration22 Information22
class apb_master_config22 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed22-apb_master_config22");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config22)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config22

// APB22 Configuration22 Information22 
class apb_config22 extends uvm_object;

  // APB22 has one master22 and N slaves22
  apb_master_config22 master_config22;
  apb_slave_config22 slave_configs22[$];
  int num_slaves22;

  `uvm_object_utils_begin(apb_config22)
    `uvm_field_queue_object(slave_configs22, UVM_DEFAULT)
    `uvm_field_object(master_config22, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed22-apb_config22");
    super.new(name);
  endfunction

  // Additional22 class methods22
  extern function void add_slave22(string name, int start_addr22, int end_addr22,
            int psel_indx22, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master22(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr22(int addr);
  extern function string get_slave_name_by_addr22(int addr);
endclass  : apb_config22

// apb_config22 - Creates22 and configures22 a slave22 agent22 config and adds22 to a queue
function void apb_config22::add_slave22(string name, int start_addr22, int end_addr22,
            int psel_indx22, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config22 tmp_slave_cfg22;
  num_slaves22++;
  tmp_slave_cfg22 = apb_slave_config22::type_id::create("slave_config22");
  tmp_slave_cfg22.name = name;
  tmp_slave_cfg22.start_address22 = start_addr22;
  tmp_slave_cfg22.end_address22 = end_addr22;
  tmp_slave_cfg22.psel_index22 = psel_indx22;
  tmp_slave_cfg22.is_active = is_active;
  
  slave_configs22.push_back(tmp_slave_cfg22);
endfunction : add_slave22

// apb_config22 - Creates22 and configures22 a master22 agent22 configuration
function void apb_config22::add_master22(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config22 = apb_master_config22::type_id::create("master_config22");
  master_config22.name = name;
  master_config22.is_active = is_active;
endfunction : add_master22

// apb_config22 - Returns22 the slave22 psel22 index
function int apb_config22::get_slave_psel_by_addr22(int addr);
  for (int i = 0; i < slave_configs22.size(); i++)
    if(slave_configs22[i].check_address_range22(addr)) begin
      return slave_configs22[i].psel_index22;
    end
endfunction : get_slave_psel_by_addr22

// apb_config22 - Return22 the name of the slave22
function string apb_config22::get_slave_name_by_addr22(int addr);
  for (int i = 0; i < slave_configs22.size(); i++)
    if(slave_configs22[i].check_address_range22(addr)) begin
      return slave_configs22[i].name;
    end
endfunction : get_slave_name_by_addr22

//================================================================
// Default APB22 configuration - One22 Master22, Two22 slaves22
//================================================================
class default_apb_config22 extends apb_config22;

  `uvm_object_utils(default_apb_config22)

  function new(string name = "default_apb_config22-S0S122-master22");
    super.new(name);
    add_slave22("slave022", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave22("slave122", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master22("master22", UVM_ACTIVE);
  endfunction

endclass : default_apb_config22

`endif // APB_CONFIG_SV22
