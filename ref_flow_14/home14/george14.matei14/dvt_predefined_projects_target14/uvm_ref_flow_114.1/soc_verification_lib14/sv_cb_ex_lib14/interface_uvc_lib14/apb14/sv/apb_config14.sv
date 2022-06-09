/*******************************************************************************
  FILE : apb_config14.sv
  This14 file contains14 multiple configuration classes14:
    apb_slave_config14 - for configuring14 an APB14 slave14 device14
    apb_master_config14 - for configuring14 an APB14 master14 device14
    apb_config14 - has 1 master14 config and N slave14 config's
    default_apb_config14 - configures14 for 1 master14 and 2 slaves14
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV14
`define APB_CONFIG_SV14

// APB14 Slave14 Configuration14 Information14
class apb_slave_config14 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address14;
  rand int end_address14;
  rand int psel_index14;

  constraint addr_cst14 { start_address14 <= end_address14; }
  constraint psel_cst14 { psel_index14 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config14)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address14, UVM_DEFAULT)
    `uvm_field_int(end_address14, UVM_DEFAULT)
    `uvm_field_int(psel_index14, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor14 - UVM required14 syntax14
  function new (string name = "apb_slave_config14");
    super.new(name);
  endfunction

  // Checks14 to see14 if an address is in the configured14 range
  function bit check_address_range14(int unsigned addr);
    return (!((start_address14 > addr) || (end_address14 < addr)));
  endfunction

endclass : apb_slave_config14

// APB14 Master14 Configuration14 Information14
class apb_master_config14 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed14-apb_master_config14");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config14)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config14

// APB14 Configuration14 Information14 
class apb_config14 extends uvm_object;

  // APB14 has one master14 and N slaves14
  apb_master_config14 master_config14;
  apb_slave_config14 slave_configs14[$];
  int num_slaves14;

  `uvm_object_utils_begin(apb_config14)
    `uvm_field_queue_object(slave_configs14, UVM_DEFAULT)
    `uvm_field_object(master_config14, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed14-apb_config14");
    super.new(name);
  endfunction

  // Additional14 class methods14
  extern function void add_slave14(string name, int start_addr14, int end_addr14,
            int psel_indx14, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master14(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr14(int addr);
  extern function string get_slave_name_by_addr14(int addr);
endclass  : apb_config14

// apb_config14 - Creates14 and configures14 a slave14 agent14 config and adds14 to a queue
function void apb_config14::add_slave14(string name, int start_addr14, int end_addr14,
            int psel_indx14, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config14 tmp_slave_cfg14;
  num_slaves14++;
  tmp_slave_cfg14 = apb_slave_config14::type_id::create("slave_config14");
  tmp_slave_cfg14.name = name;
  tmp_slave_cfg14.start_address14 = start_addr14;
  tmp_slave_cfg14.end_address14 = end_addr14;
  tmp_slave_cfg14.psel_index14 = psel_indx14;
  tmp_slave_cfg14.is_active = is_active;
  
  slave_configs14.push_back(tmp_slave_cfg14);
endfunction : add_slave14

// apb_config14 - Creates14 and configures14 a master14 agent14 configuration
function void apb_config14::add_master14(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config14 = apb_master_config14::type_id::create("master_config14");
  master_config14.name = name;
  master_config14.is_active = is_active;
endfunction : add_master14

// apb_config14 - Returns14 the slave14 psel14 index
function int apb_config14::get_slave_psel_by_addr14(int addr);
  for (int i = 0; i < slave_configs14.size(); i++)
    if(slave_configs14[i].check_address_range14(addr)) begin
      return slave_configs14[i].psel_index14;
    end
endfunction : get_slave_psel_by_addr14

// apb_config14 - Return14 the name of the slave14
function string apb_config14::get_slave_name_by_addr14(int addr);
  for (int i = 0; i < slave_configs14.size(); i++)
    if(slave_configs14[i].check_address_range14(addr)) begin
      return slave_configs14[i].name;
    end
endfunction : get_slave_name_by_addr14

//================================================================
// Default APB14 configuration - One14 Master14, Two14 slaves14
//================================================================
class default_apb_config14 extends apb_config14;

  `uvm_object_utils(default_apb_config14)

  function new(string name = "default_apb_config14-S0S114-master14");
    super.new(name);
    add_slave14("slave014", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave14("slave114", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master14("master14", UVM_ACTIVE);
  endfunction

endclass : default_apb_config14

`endif // APB_CONFIG_SV14
