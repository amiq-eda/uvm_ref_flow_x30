/*******************************************************************************
  FILE : apb_config2.sv
  This2 file contains2 multiple configuration classes2:
    apb_slave_config2 - for configuring2 an APB2 slave2 device2
    apb_master_config2 - for configuring2 an APB2 master2 device2
    apb_config2 - has 1 master2 config and N slave2 config's
    default_apb_config2 - configures2 for 1 master2 and 2 slaves2
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV2
`define APB_CONFIG_SV2

// APB2 Slave2 Configuration2 Information2
class apb_slave_config2 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address2;
  rand int end_address2;
  rand int psel_index2;

  constraint addr_cst2 { start_address2 <= end_address2; }
  constraint psel_cst2 { psel_index2 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config2)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address2, UVM_DEFAULT)
    `uvm_field_int(end_address2, UVM_DEFAULT)
    `uvm_field_int(psel_index2, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor2 - UVM required2 syntax2
  function new (string name = "apb_slave_config2");
    super.new(name);
  endfunction

  // Checks2 to see2 if an address is in the configured2 range
  function bit check_address_range2(int unsigned addr);
    return (!((start_address2 > addr) || (end_address2 < addr)));
  endfunction

endclass : apb_slave_config2

// APB2 Master2 Configuration2 Information2
class apb_master_config2 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed2-apb_master_config2");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config2)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config2

// APB2 Configuration2 Information2 
class apb_config2 extends uvm_object;

  // APB2 has one master2 and N slaves2
  apb_master_config2 master_config2;
  apb_slave_config2 slave_configs2[$];
  int num_slaves2;

  `uvm_object_utils_begin(apb_config2)
    `uvm_field_queue_object(slave_configs2, UVM_DEFAULT)
    `uvm_field_object(master_config2, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed2-apb_config2");
    super.new(name);
  endfunction

  // Additional2 class methods2
  extern function void add_slave2(string name, int start_addr2, int end_addr2,
            int psel_indx2, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master2(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr2(int addr);
  extern function string get_slave_name_by_addr2(int addr);
endclass  : apb_config2

// apb_config2 - Creates2 and configures2 a slave2 agent2 config and adds2 to a queue
function void apb_config2::add_slave2(string name, int start_addr2, int end_addr2,
            int psel_indx2, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config2 tmp_slave_cfg2;
  num_slaves2++;
  tmp_slave_cfg2 = apb_slave_config2::type_id::create("slave_config2");
  tmp_slave_cfg2.name = name;
  tmp_slave_cfg2.start_address2 = start_addr2;
  tmp_slave_cfg2.end_address2 = end_addr2;
  tmp_slave_cfg2.psel_index2 = psel_indx2;
  tmp_slave_cfg2.is_active = is_active;
  
  slave_configs2.push_back(tmp_slave_cfg2);
endfunction : add_slave2

// apb_config2 - Creates2 and configures2 a master2 agent2 configuration
function void apb_config2::add_master2(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config2 = apb_master_config2::type_id::create("master_config2");
  master_config2.name = name;
  master_config2.is_active = is_active;
endfunction : add_master2

// apb_config2 - Returns2 the slave2 psel2 index
function int apb_config2::get_slave_psel_by_addr2(int addr);
  for (int i = 0; i < slave_configs2.size(); i++)
    if(slave_configs2[i].check_address_range2(addr)) begin
      return slave_configs2[i].psel_index2;
    end
endfunction : get_slave_psel_by_addr2

// apb_config2 - Return2 the name of the slave2
function string apb_config2::get_slave_name_by_addr2(int addr);
  for (int i = 0; i < slave_configs2.size(); i++)
    if(slave_configs2[i].check_address_range2(addr)) begin
      return slave_configs2[i].name;
    end
endfunction : get_slave_name_by_addr2

//================================================================
// Default APB2 configuration - One2 Master2, Two2 slaves2
//================================================================
class default_apb_config2 extends apb_config2;

  `uvm_object_utils(default_apb_config2)

  function new(string name = "default_apb_config2-S0S12-master2");
    super.new(name);
    add_slave2("slave02", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave2("slave12", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master2("master2", UVM_ACTIVE);
  endfunction

endclass : default_apb_config2

`endif // APB_CONFIG_SV2
