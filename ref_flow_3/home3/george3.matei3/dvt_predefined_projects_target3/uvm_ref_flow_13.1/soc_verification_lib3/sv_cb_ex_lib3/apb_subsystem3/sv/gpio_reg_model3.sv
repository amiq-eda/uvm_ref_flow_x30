`ifndef GPIO_RDB_SV3
`define GPIO_RDB_SV3

// Input3 File3: gpio_rgm3.spirit3

// Number3 of addrMaps3 = 1
// Number3 of regFiles3 = 1
// Number3 of registers = 5
// Number3 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 23


class bypass_mode_c3 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c3, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c3, uvm_reg)
  `uvm_object_utils(bypass_mode_c3)
  function new(input string name="unnamed3-bypass_mode_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : bypass_mode_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 38


class direction_mode_c3 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(direction_mode_c3, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c3, uvm_reg)
  `uvm_object_utils(direction_mode_c3)
  function new(input string name="unnamed3-direction_mode_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : direction_mode_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 53


class output_enable_c3 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(output_enable_c3, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c3, uvm_reg)
  `uvm_object_utils(output_enable_c3)
  function new(input string name="unnamed3-output_enable_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : output_enable_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 68


class output_value_c3 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(output_value_c3, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c3, uvm_reg)
  `uvm_object_utils(output_value_c3)
  function new(input string name="unnamed3-output_value_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : output_value_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 83


class input_value_c3 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(input_value_c3, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c3, uvm_reg)
  `uvm_object_utils(input_value_c3)
  function new(input string name="unnamed3-input_value_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : input_value_c3

class gpio_regfile3 extends uvm_reg_block;

  rand bypass_mode_c3 bypass_mode3;
  rand direction_mode_c3 direction_mode3;
  rand output_enable_c3 output_enable3;
  rand output_value_c3 output_value3;
  rand input_value_c3 input_value3;

  virtual function void build();

    // Now3 create all registers

    bypass_mode3 = bypass_mode_c3::type_id::create("bypass_mode3", , get_full_name());
    direction_mode3 = direction_mode_c3::type_id::create("direction_mode3", , get_full_name());
    output_enable3 = output_enable_c3::type_id::create("output_enable3", , get_full_name());
    output_value3 = output_value_c3::type_id::create("output_value3", , get_full_name());
    input_value3 = input_value_c3::type_id::create("input_value3", , get_full_name());

    // Now3 build the registers. Set parent and hdl_paths

    bypass_mode3.configure(this, null, "bypass_mode_reg3");
    bypass_mode3.build();
    direction_mode3.configure(this, null, "direction_mode_reg3");
    direction_mode3.build();
    output_enable3.configure(this, null, "output_enable_reg3");
    output_enable3.build();
    output_value3.configure(this, null, "output_value_reg3");
    output_value3.build();
    input_value3.configure(this, null, "input_value_reg3");
    input_value3.build();
    // Now3 define address mappings3
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode3, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode3, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable3, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value3, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value3, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile3)
  function new(input string name="unnamed3-gpio_rf3");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile3

//////////////////////////////////////////////////////////////////////////////
// Address_map3 definition3
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c3 extends uvm_reg_block;

  rand gpio_regfile3 gpio_rf3;

  function void build();
    // Now3 define address mappings3
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf3 = gpio_regfile3::type_id::create("gpio_rf3", , get_full_name());
    gpio_rf3.configure(this, "rf33");
    gpio_rf3.build();
    gpio_rf3.lock_model();
    default_map.add_submap(gpio_rf3.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c3");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c3)
  function new(input string name="unnamed3-gpio_reg_model_c3");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c3

`endif // GPIO_RDB_SV3
