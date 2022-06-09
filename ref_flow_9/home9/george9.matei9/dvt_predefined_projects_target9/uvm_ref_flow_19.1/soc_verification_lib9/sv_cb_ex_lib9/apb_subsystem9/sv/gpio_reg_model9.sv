`ifndef GPIO_RDB_SV9
`define GPIO_RDB_SV9

// Input9 File9: gpio_rgm9.spirit9

// Number9 of addrMaps9 = 1
// Number9 of regFiles9 = 1
// Number9 of registers = 5
// Number9 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 23


class bypass_mode_c9 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c9, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c9, uvm_reg)
  `uvm_object_utils(bypass_mode_c9)
  function new(input string name="unnamed9-bypass_mode_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : bypass_mode_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 38


class direction_mode_c9 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(direction_mode_c9, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c9, uvm_reg)
  `uvm_object_utils(direction_mode_c9)
  function new(input string name="unnamed9-direction_mode_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : direction_mode_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 53


class output_enable_c9 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(output_enable_c9, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c9, uvm_reg)
  `uvm_object_utils(output_enable_c9)
  function new(input string name="unnamed9-output_enable_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : output_enable_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 68


class output_value_c9 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(output_value_c9, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c9, uvm_reg)
  `uvm_object_utils(output_value_c9)
  function new(input string name="unnamed9-output_value_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : output_value_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 83


class input_value_c9 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(input_value_c9, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c9, uvm_reg)
  `uvm_object_utils(input_value_c9)
  function new(input string name="unnamed9-input_value_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : input_value_c9

class gpio_regfile9 extends uvm_reg_block;

  rand bypass_mode_c9 bypass_mode9;
  rand direction_mode_c9 direction_mode9;
  rand output_enable_c9 output_enable9;
  rand output_value_c9 output_value9;
  rand input_value_c9 input_value9;

  virtual function void build();

    // Now9 create all registers

    bypass_mode9 = bypass_mode_c9::type_id::create("bypass_mode9", , get_full_name());
    direction_mode9 = direction_mode_c9::type_id::create("direction_mode9", , get_full_name());
    output_enable9 = output_enable_c9::type_id::create("output_enable9", , get_full_name());
    output_value9 = output_value_c9::type_id::create("output_value9", , get_full_name());
    input_value9 = input_value_c9::type_id::create("input_value9", , get_full_name());

    // Now9 build the registers. Set parent and hdl_paths

    bypass_mode9.configure(this, null, "bypass_mode_reg9");
    bypass_mode9.build();
    direction_mode9.configure(this, null, "direction_mode_reg9");
    direction_mode9.build();
    output_enable9.configure(this, null, "output_enable_reg9");
    output_enable9.build();
    output_value9.configure(this, null, "output_value_reg9");
    output_value9.build();
    input_value9.configure(this, null, "input_value_reg9");
    input_value9.build();
    // Now9 define address mappings9
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode9, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode9, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable9, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value9, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value9, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile9)
  function new(input string name="unnamed9-gpio_rf9");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile9

//////////////////////////////////////////////////////////////////////////////
// Address_map9 definition9
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c9 extends uvm_reg_block;

  rand gpio_regfile9 gpio_rf9;

  function void build();
    // Now9 define address mappings9
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf9 = gpio_regfile9::type_id::create("gpio_rf9", , get_full_name());
    gpio_rf9.configure(this, "rf39");
    gpio_rf9.build();
    gpio_rf9.lock_model();
    default_map.add_submap(gpio_rf9.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c9");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c9)
  function new(input string name="unnamed9-gpio_reg_model_c9");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c9

`endif // GPIO_RDB_SV9
