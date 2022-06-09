/*******************************************************************************
  FILE : apb_config23.sv
  This23 file contains23 multiple configuration classes23:
    apb_slave_config23 - for configuring23 an APB23 slave23 device23
    apb_master_config23 - for configuring23 an APB23 master23 device23
    apb_config23 - has 1 master23 config and N slave23 config's
    default_apb_config23 - configures23 for 1 master23 and 2 slaves23
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV23
`define APB_CONFIG_SV23

// APB23 Slave23 Configuration23 Information23
class apb_slave_config23 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address23;
  rand int end_address23;
  rand int psel_index23;

  constraint addr_cst23 { start_address23 <= end_address23; }
  constraint psel_cst23 { psel_index23 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config23)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address23, UVM_DEFAULT)
    `uvm_field_int(end_address23, UVM_DEFAULT)
    `uvm_field_int(psel_index23, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor23 - UVM required23 syntax23
  function new (string name = "apb_slave_config23");
    super.new(name);
  endfunction

  // Checks23 to see23 if an address is in the configured23 range
  function bit check_address_range23(int unsigned addr);
    return (!((start_address23 > addr) || (end_address23 < addr)));
  endfunction

endclass : apb_slave_config23

// APB23 Master23 Configuration23 Information23
class apb_master_config23 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed23-apb_master_config23");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config23)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config23

// APB23 Configuration23 Information23 
class apb_config23 extends uvm_object;

  // APB23 has one master23 and N slaves23
  apb_master_config23 master_config23;
  apb_slave_config23 slave_configs23[$];
  int num_slaves23;

  `uvm_object_utils_begin(apb_config23)
    `uvm_field_queue_object(slave_configs23, UVM_DEFAULT)
    `uvm_field_object(master_config23, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed23-apb_config23");
    super.new(name);
  endfunction

  // Additional23 class methods23
  extern function void add_slave23(string name, int start_addr23, int end_addr23,
            int psel_indx23, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master23(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr23(int addr);
  extern function string get_slave_name_by_addr23(int addr);
endclass  : apb_config23

// apb_config23 - Creates23 and configures23 a slave23 agent23 config and adds23 to a queue
function void apb_config23::add_slave23(string name, int start_addr23, int end_addr23,
            int psel_indx23, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config23 tmp_slave_cfg23;
  num_slaves23++;
  tmp_slave_cfg23 = apb_slave_config23::type_id::create("slave_config23");
  tmp_slave_cfg23.name = name;
  tmp_slave_cfg23.start_address23 = start_addr23;
  tmp_slave_cfg23.end_address23 = end_addr23;
  tmp_slave_cfg23.psel_index23 = psel_indx23;
  tmp_slave_cfg23.is_active = is_active;
  
  slave_configs23.push_back(tmp_slave_cfg23);
endfunction : add_slave23

// apb_config23 - Creates23 and configures23 a master23 agent23 configuration
function void apb_config23::add_master23(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config23 = apb_master_config23::type_id::create("master_config23");
  master_config23.name = name;
  master_config23.is_active = is_active;
endfunction : add_master23

// apb_config23 - Returns23 the slave23 psel23 index
function int apb_config23::get_slave_psel_by_addr23(int addr);
  for (int i = 0; i < slave_configs23.size(); i++)
    if(slave_configs23[i].check_address_range23(addr)) begin
      return slave_configs23[i].psel_index23;
    end
endfunction : get_slave_psel_by_addr23

// apb_config23 - Return23 the name of the slave23
function string apb_config23::get_slave_name_by_addr23(int addr);
  for (int i = 0; i < slave_configs23.size(); i++)
    if(slave_configs23[i].check_address_range23(addr)) begin
      return slave_configs23[i].name;
    end
endfunction : get_slave_name_by_addr23

//================================================================
// Default APB23 configuration - One23 Master23, Two23 slaves23
//================================================================
class default_apb_config23 extends apb_config23;

  `uvm_object_utils(default_apb_config23)

  function new(string name = "default_apb_config23-S0S123-master23");
    super.new(name);
    add_slave23("slave023", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave23("slave123", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master23("master23", UVM_ACTIVE);
  endfunction

endclass : default_apb_config23

`endif // APB_CONFIG_SV23
