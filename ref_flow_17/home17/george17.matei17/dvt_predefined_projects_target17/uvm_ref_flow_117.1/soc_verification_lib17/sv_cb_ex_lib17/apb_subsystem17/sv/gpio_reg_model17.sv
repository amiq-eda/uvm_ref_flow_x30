`ifndef GPIO_RDB_SV17
`define GPIO_RDB_SV17

// Input17 File17: gpio_rgm17.spirit17

// Number17 of addrMaps17 = 1
// Number17 of regFiles17 = 1
// Number17 of registers = 5
// Number17 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 23


class bypass_mode_c17 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c17, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c17, uvm_reg)
  `uvm_object_utils(bypass_mode_c17)
  function new(input string name="unnamed17-bypass_mode_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : bypass_mode_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 38


class direction_mode_c17 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(direction_mode_c17, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c17, uvm_reg)
  `uvm_object_utils(direction_mode_c17)
  function new(input string name="unnamed17-direction_mode_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : direction_mode_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 53


class output_enable_c17 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(output_enable_c17, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c17, uvm_reg)
  `uvm_object_utils(output_enable_c17)
  function new(input string name="unnamed17-output_enable_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : output_enable_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 68


class output_value_c17 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(output_value_c17, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c17, uvm_reg)
  `uvm_object_utils(output_value_c17)
  function new(input string name="unnamed17-output_value_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : output_value_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 83


class input_value_c17 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(input_value_c17, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c17, uvm_reg)
  `uvm_object_utils(input_value_c17)
  function new(input string name="unnamed17-input_value_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : input_value_c17

class gpio_regfile17 extends uvm_reg_block;

  rand bypass_mode_c17 bypass_mode17;
  rand direction_mode_c17 direction_mode17;
  rand output_enable_c17 output_enable17;
  rand output_value_c17 output_value17;
  rand input_value_c17 input_value17;

  virtual function void build();

    // Now17 create all registers

    bypass_mode17 = bypass_mode_c17::type_id::create("bypass_mode17", , get_full_name());
    direction_mode17 = direction_mode_c17::type_id::create("direction_mode17", , get_full_name());
    output_enable17 = output_enable_c17::type_id::create("output_enable17", , get_full_name());
    output_value17 = output_value_c17::type_id::create("output_value17", , get_full_name());
    input_value17 = input_value_c17::type_id::create("input_value17", , get_full_name());

    // Now17 build the registers. Set parent and hdl_paths

    bypass_mode17.configure(this, null, "bypass_mode_reg17");
    bypass_mode17.build();
    direction_mode17.configure(this, null, "direction_mode_reg17");
    direction_mode17.build();
    output_enable17.configure(this, null, "output_enable_reg17");
    output_enable17.build();
    output_value17.configure(this, null, "output_value_reg17");
    output_value17.build();
    input_value17.configure(this, null, "input_value_reg17");
    input_value17.build();
    // Now17 define address mappings17
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode17, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode17, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable17, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value17, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value17, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile17)
  function new(input string name="unnamed17-gpio_rf17");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile17

//////////////////////////////////////////////////////////////////////////////
// Address_map17 definition17
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c17 extends uvm_reg_block;

  rand gpio_regfile17 gpio_rf17;

  function void build();
    // Now17 define address mappings17
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf17 = gpio_regfile17::type_id::create("gpio_rf17", , get_full_name());
    gpio_rf17.configure(this, "rf317");
    gpio_rf17.build();
    gpio_rf17.lock_model();
    default_map.add_submap(gpio_rf17.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c17");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c17)
  function new(input string name="unnamed17-gpio_reg_model_c17");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c17

`endif // GPIO_RDB_SV17
