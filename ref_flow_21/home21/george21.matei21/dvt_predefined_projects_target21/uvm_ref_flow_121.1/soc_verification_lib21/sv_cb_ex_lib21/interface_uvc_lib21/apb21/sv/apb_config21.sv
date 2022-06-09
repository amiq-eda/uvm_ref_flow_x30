/*******************************************************************************
  FILE : apb_config21.sv
  This21 file contains21 multiple configuration classes21:
    apb_slave_config21 - for configuring21 an APB21 slave21 device21
    apb_master_config21 - for configuring21 an APB21 master21 device21
    apb_config21 - has 1 master21 config and N slave21 config's
    default_apb_config21 - configures21 for 1 master21 and 2 slaves21
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV21
`define APB_CONFIG_SV21

// APB21 Slave21 Configuration21 Information21
class apb_slave_config21 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address21;
  rand int end_address21;
  rand int psel_index21;

  constraint addr_cst21 { start_address21 <= end_address21; }
  constraint psel_cst21 { psel_index21 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config21)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address21, UVM_DEFAULT)
    `uvm_field_int(end_address21, UVM_DEFAULT)
    `uvm_field_int(psel_index21, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor21 - UVM required21 syntax21
  function new (string name = "apb_slave_config21");
    super.new(name);
  endfunction

  // Checks21 to see21 if an address is in the configured21 range
  function bit check_address_range21(int unsigned addr);
    return (!((start_address21 > addr) || (end_address21 < addr)));
  endfunction

endclass : apb_slave_config21

// APB21 Master21 Configuration21 Information21
class apb_master_config21 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed21-apb_master_config21");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config21)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config21

// APB21 Configuration21 Information21 
class apb_config21 extends uvm_object;

  // APB21 has one master21 and N slaves21
  apb_master_config21 master_config21;
  apb_slave_config21 slave_configs21[$];
  int num_slaves21;

  `uvm_object_utils_begin(apb_config21)
    `uvm_field_queue_object(slave_configs21, UVM_DEFAULT)
    `uvm_field_object(master_config21, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed21-apb_config21");
    super.new(name);
  endfunction

  // Additional21 class methods21
  extern function void add_slave21(string name, int start_addr21, int end_addr21,
            int psel_indx21, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master21(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr21(int addr);
  extern function string get_slave_name_by_addr21(int addr);
endclass  : apb_config21

// apb_config21 - Creates21 and configures21 a slave21 agent21 config and adds21 to a queue
function void apb_config21::add_slave21(string name, int start_addr21, int end_addr21,
            int psel_indx21, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config21 tmp_slave_cfg21;
  num_slaves21++;
  tmp_slave_cfg21 = apb_slave_config21::type_id::create("slave_config21");
  tmp_slave_cfg21.name = name;
  tmp_slave_cfg21.start_address21 = start_addr21;
  tmp_slave_cfg21.end_address21 = end_addr21;
  tmp_slave_cfg21.psel_index21 = psel_indx21;
  tmp_slave_cfg21.is_active = is_active;
  
  slave_configs21.push_back(tmp_slave_cfg21);
endfunction : add_slave21

// apb_config21 - Creates21 and configures21 a master21 agent21 configuration
function void apb_config21::add_master21(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config21 = apb_master_config21::type_id::create("master_config21");
  master_config21.name = name;
  master_config21.is_active = is_active;
endfunction : add_master21

// apb_config21 - Returns21 the slave21 psel21 index
function int apb_config21::get_slave_psel_by_addr21(int addr);
  for (int i = 0; i < slave_configs21.size(); i++)
    if(slave_configs21[i].check_address_range21(addr)) begin
      return slave_configs21[i].psel_index21;
    end
endfunction : get_slave_psel_by_addr21

// apb_config21 - Return21 the name of the slave21
function string apb_config21::get_slave_name_by_addr21(int addr);
  for (int i = 0; i < slave_configs21.size(); i++)
    if(slave_configs21[i].check_address_range21(addr)) begin
      return slave_configs21[i].name;
    end
endfunction : get_slave_name_by_addr21

//================================================================
// Default APB21 configuration - One21 Master21, Two21 slaves21
//================================================================
class default_apb_config21 extends apb_config21;

  `uvm_object_utils(default_apb_config21)

  function new(string name = "default_apb_config21-S0S121-master21");
    super.new(name);
    add_slave21("slave021", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave21("slave121", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master21("master21", UVM_ACTIVE);
  endfunction

endclass : default_apb_config21

`endif // APB_CONFIG_SV21
