`ifndef GPIO_RDB_SV1
`define GPIO_RDB_SV1

// Input1 File1: gpio_rgm1.spirit1

// Number1 of addrMaps1 = 1
// Number1 of regFiles1 = 1
// Number1 of registers = 5
// Number1 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 23


class bypass_mode_c1 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c1, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c1, uvm_reg)
  `uvm_object_utils(bypass_mode_c1)
  function new(input string name="unnamed1-bypass_mode_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : bypass_mode_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 38


class direction_mode_c1 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(direction_mode_c1, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c1, uvm_reg)
  `uvm_object_utils(direction_mode_c1)
  function new(input string name="unnamed1-direction_mode_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : direction_mode_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 53


class output_enable_c1 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(output_enable_c1, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c1, uvm_reg)
  `uvm_object_utils(output_enable_c1)
  function new(input string name="unnamed1-output_enable_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : output_enable_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 68


class output_value_c1 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(output_value_c1, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c1, uvm_reg)
  `uvm_object_utils(output_value_c1)
  function new(input string name="unnamed1-output_value_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : output_value_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 83


class input_value_c1 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(input_value_c1, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c1, uvm_reg)
  `uvm_object_utils(input_value_c1)
  function new(input string name="unnamed1-input_value_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : input_value_c1

class gpio_regfile1 extends uvm_reg_block;

  rand bypass_mode_c1 bypass_mode1;
  rand direction_mode_c1 direction_mode1;
  rand output_enable_c1 output_enable1;
  rand output_value_c1 output_value1;
  rand input_value_c1 input_value1;

  virtual function void build();

    // Now1 create all registers

    bypass_mode1 = bypass_mode_c1::type_id::create("bypass_mode1", , get_full_name());
    direction_mode1 = direction_mode_c1::type_id::create("direction_mode1", , get_full_name());
    output_enable1 = output_enable_c1::type_id::create("output_enable1", , get_full_name());
    output_value1 = output_value_c1::type_id::create("output_value1", , get_full_name());
    input_value1 = input_value_c1::type_id::create("input_value1", , get_full_name());

    // Now1 build the registers. Set parent and hdl_paths

    bypass_mode1.configure(this, null, "bypass_mode_reg1");
    bypass_mode1.build();
    direction_mode1.configure(this, null, "direction_mode_reg1");
    direction_mode1.build();
    output_enable1.configure(this, null, "output_enable_reg1");
    output_enable1.build();
    output_value1.configure(this, null, "output_value_reg1");
    output_value1.build();
    input_value1.configure(this, null, "input_value_reg1");
    input_value1.build();
    // Now1 define address mappings1
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode1, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode1, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable1, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value1, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value1, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile1)
  function new(input string name="unnamed1-gpio_rf1");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile1

//////////////////////////////////////////////////////////////////////////////
// Address_map1 definition1
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c1 extends uvm_reg_block;

  rand gpio_regfile1 gpio_rf1;

  function void build();
    // Now1 define address mappings1
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf1 = gpio_regfile1::type_id::create("gpio_rf1", , get_full_name());
    gpio_rf1.configure(this, "rf31");
    gpio_rf1.build();
    gpio_rf1.lock_model();
    default_map.add_submap(gpio_rf1.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c1");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c1)
  function new(input string name="unnamed1-gpio_reg_model_c1");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c1

`endif // GPIO_RDB_SV1
