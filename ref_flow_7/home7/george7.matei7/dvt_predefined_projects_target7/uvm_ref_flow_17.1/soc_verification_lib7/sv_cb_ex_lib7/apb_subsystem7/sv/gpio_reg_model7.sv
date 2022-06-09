`ifndef GPIO_RDB_SV7
`define GPIO_RDB_SV7

// Input7 File7: gpio_rgm7.spirit7

// Number7 of addrMaps7 = 1
// Number7 of regFiles7 = 1
// Number7 of registers = 5
// Number7 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 23


class bypass_mode_c7 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c7, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c7, uvm_reg)
  `uvm_object_utils(bypass_mode_c7)
  function new(input string name="unnamed7-bypass_mode_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : bypass_mode_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 38


class direction_mode_c7 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(direction_mode_c7, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c7, uvm_reg)
  `uvm_object_utils(direction_mode_c7)
  function new(input string name="unnamed7-direction_mode_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : direction_mode_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 53


class output_enable_c7 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(output_enable_c7, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c7, uvm_reg)
  `uvm_object_utils(output_enable_c7)
  function new(input string name="unnamed7-output_enable_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : output_enable_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 68


class output_value_c7 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(output_value_c7, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c7, uvm_reg)
  `uvm_object_utils(output_value_c7)
  function new(input string name="unnamed7-output_value_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : output_value_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 83


class input_value_c7 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(input_value_c7, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c7, uvm_reg)
  `uvm_object_utils(input_value_c7)
  function new(input string name="unnamed7-input_value_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : input_value_c7

class gpio_regfile7 extends uvm_reg_block;

  rand bypass_mode_c7 bypass_mode7;
  rand direction_mode_c7 direction_mode7;
  rand output_enable_c7 output_enable7;
  rand output_value_c7 output_value7;
  rand input_value_c7 input_value7;

  virtual function void build();

    // Now7 create all registers

    bypass_mode7 = bypass_mode_c7::type_id::create("bypass_mode7", , get_full_name());
    direction_mode7 = direction_mode_c7::type_id::create("direction_mode7", , get_full_name());
    output_enable7 = output_enable_c7::type_id::create("output_enable7", , get_full_name());
    output_value7 = output_value_c7::type_id::create("output_value7", , get_full_name());
    input_value7 = input_value_c7::type_id::create("input_value7", , get_full_name());

    // Now7 build the registers. Set parent and hdl_paths

    bypass_mode7.configure(this, null, "bypass_mode_reg7");
    bypass_mode7.build();
    direction_mode7.configure(this, null, "direction_mode_reg7");
    direction_mode7.build();
    output_enable7.configure(this, null, "output_enable_reg7");
    output_enable7.build();
    output_value7.configure(this, null, "output_value_reg7");
    output_value7.build();
    input_value7.configure(this, null, "input_value_reg7");
    input_value7.build();
    // Now7 define address mappings7
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode7, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode7, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable7, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value7, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value7, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile7)
  function new(input string name="unnamed7-gpio_rf7");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile7

//////////////////////////////////////////////////////////////////////////////
// Address_map7 definition7
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c7 extends uvm_reg_block;

  rand gpio_regfile7 gpio_rf7;

  function void build();
    // Now7 define address mappings7
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf7 = gpio_regfile7::type_id::create("gpio_rf7", , get_full_name());
    gpio_rf7.configure(this, "rf37");
    gpio_rf7.build();
    gpio_rf7.lock_model();
    default_map.add_submap(gpio_rf7.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c7");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c7)
  function new(input string name="unnamed7-gpio_reg_model_c7");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c7

`endif // GPIO_RDB_SV7
