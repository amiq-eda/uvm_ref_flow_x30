`ifndef GPIO_RDB_SV8
`define GPIO_RDB_SV8

// Input8 File8: gpio_rgm8.spirit8

// Number8 of addrMaps8 = 1
// Number8 of regFiles8 = 1
// Number8 of registers = 5
// Number8 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 23


class bypass_mode_c8 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c8, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c8, uvm_reg)
  `uvm_object_utils(bypass_mode_c8)
  function new(input string name="unnamed8-bypass_mode_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : bypass_mode_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 38


class direction_mode_c8 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(direction_mode_c8, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c8, uvm_reg)
  `uvm_object_utils(direction_mode_c8)
  function new(input string name="unnamed8-direction_mode_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : direction_mode_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 53


class output_enable_c8 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(output_enable_c8, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c8, uvm_reg)
  `uvm_object_utils(output_enable_c8)
  function new(input string name="unnamed8-output_enable_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : output_enable_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 68


class output_value_c8 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(output_value_c8, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c8, uvm_reg)
  `uvm_object_utils(output_value_c8)
  function new(input string name="unnamed8-output_value_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : output_value_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 83


class input_value_c8 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(input_value_c8, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c8, uvm_reg)
  `uvm_object_utils(input_value_c8)
  function new(input string name="unnamed8-input_value_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : input_value_c8

class gpio_regfile8 extends uvm_reg_block;

  rand bypass_mode_c8 bypass_mode8;
  rand direction_mode_c8 direction_mode8;
  rand output_enable_c8 output_enable8;
  rand output_value_c8 output_value8;
  rand input_value_c8 input_value8;

  virtual function void build();

    // Now8 create all registers

    bypass_mode8 = bypass_mode_c8::type_id::create("bypass_mode8", , get_full_name());
    direction_mode8 = direction_mode_c8::type_id::create("direction_mode8", , get_full_name());
    output_enable8 = output_enable_c8::type_id::create("output_enable8", , get_full_name());
    output_value8 = output_value_c8::type_id::create("output_value8", , get_full_name());
    input_value8 = input_value_c8::type_id::create("input_value8", , get_full_name());

    // Now8 build the registers. Set parent and hdl_paths

    bypass_mode8.configure(this, null, "bypass_mode_reg8");
    bypass_mode8.build();
    direction_mode8.configure(this, null, "direction_mode_reg8");
    direction_mode8.build();
    output_enable8.configure(this, null, "output_enable_reg8");
    output_enable8.build();
    output_value8.configure(this, null, "output_value_reg8");
    output_value8.build();
    input_value8.configure(this, null, "input_value_reg8");
    input_value8.build();
    // Now8 define address mappings8
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode8, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode8, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable8, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value8, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value8, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile8)
  function new(input string name="unnamed8-gpio_rf8");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile8

//////////////////////////////////////////////////////////////////////////////
// Address_map8 definition8
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c8 extends uvm_reg_block;

  rand gpio_regfile8 gpio_rf8;

  function void build();
    // Now8 define address mappings8
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf8 = gpio_regfile8::type_id::create("gpio_rf8", , get_full_name());
    gpio_rf8.configure(this, "rf38");
    gpio_rf8.build();
    gpio_rf8.lock_model();
    default_map.add_submap(gpio_rf8.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c8");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c8)
  function new(input string name="unnamed8-gpio_reg_model_c8");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c8

`endif // GPIO_RDB_SV8
