`ifndef GPIO_RDB_SV5
`define GPIO_RDB_SV5

// Input5 File5: gpio_rgm5.spirit5

// Number5 of addrMaps5 = 1
// Number5 of regFiles5 = 1
// Number5 of registers = 5
// Number5 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 23


class bypass_mode_c5 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c5, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c5, uvm_reg)
  `uvm_object_utils(bypass_mode_c5)
  function new(input string name="unnamed5-bypass_mode_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : bypass_mode_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 38


class direction_mode_c5 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(direction_mode_c5, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c5, uvm_reg)
  `uvm_object_utils(direction_mode_c5)
  function new(input string name="unnamed5-direction_mode_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : direction_mode_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 53


class output_enable_c5 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(output_enable_c5, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c5, uvm_reg)
  `uvm_object_utils(output_enable_c5)
  function new(input string name="unnamed5-output_enable_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : output_enable_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 68


class output_value_c5 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(output_value_c5, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c5, uvm_reg)
  `uvm_object_utils(output_value_c5)
  function new(input string name="unnamed5-output_value_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : output_value_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 83


class input_value_c5 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(input_value_c5, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c5, uvm_reg)
  `uvm_object_utils(input_value_c5)
  function new(input string name="unnamed5-input_value_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : input_value_c5

class gpio_regfile5 extends uvm_reg_block;

  rand bypass_mode_c5 bypass_mode5;
  rand direction_mode_c5 direction_mode5;
  rand output_enable_c5 output_enable5;
  rand output_value_c5 output_value5;
  rand input_value_c5 input_value5;

  virtual function void build();

    // Now5 create all registers

    bypass_mode5 = bypass_mode_c5::type_id::create("bypass_mode5", , get_full_name());
    direction_mode5 = direction_mode_c5::type_id::create("direction_mode5", , get_full_name());
    output_enable5 = output_enable_c5::type_id::create("output_enable5", , get_full_name());
    output_value5 = output_value_c5::type_id::create("output_value5", , get_full_name());
    input_value5 = input_value_c5::type_id::create("input_value5", , get_full_name());

    // Now5 build the registers. Set parent and hdl_paths

    bypass_mode5.configure(this, null, "bypass_mode_reg5");
    bypass_mode5.build();
    direction_mode5.configure(this, null, "direction_mode_reg5");
    direction_mode5.build();
    output_enable5.configure(this, null, "output_enable_reg5");
    output_enable5.build();
    output_value5.configure(this, null, "output_value_reg5");
    output_value5.build();
    input_value5.configure(this, null, "input_value_reg5");
    input_value5.build();
    // Now5 define address mappings5
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode5, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode5, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable5, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value5, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value5, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile5)
  function new(input string name="unnamed5-gpio_rf5");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile5

//////////////////////////////////////////////////////////////////////////////
// Address_map5 definition5
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c5 extends uvm_reg_block;

  rand gpio_regfile5 gpio_rf5;

  function void build();
    // Now5 define address mappings5
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf5 = gpio_regfile5::type_id::create("gpio_rf5", , get_full_name());
    gpio_rf5.configure(this, "rf35");
    gpio_rf5.build();
    gpio_rf5.lock_model();
    default_map.add_submap(gpio_rf5.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c5");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c5)
  function new(input string name="unnamed5-gpio_reg_model_c5");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c5

`endif // GPIO_RDB_SV5
