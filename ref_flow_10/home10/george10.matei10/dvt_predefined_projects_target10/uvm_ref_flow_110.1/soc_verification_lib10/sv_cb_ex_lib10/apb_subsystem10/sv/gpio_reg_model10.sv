`ifndef GPIO_RDB_SV10
`define GPIO_RDB_SV10

// Input10 File10: gpio_rgm10.spirit10

// Number10 of addrMaps10 = 1
// Number10 of regFiles10 = 1
// Number10 of registers = 5
// Number10 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 23


class bypass_mode_c10 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c10, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c10, uvm_reg)
  `uvm_object_utils(bypass_mode_c10)
  function new(input string name="unnamed10-bypass_mode_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : bypass_mode_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 38


class direction_mode_c10 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(direction_mode_c10, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c10, uvm_reg)
  `uvm_object_utils(direction_mode_c10)
  function new(input string name="unnamed10-direction_mode_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : direction_mode_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 53


class output_enable_c10 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(output_enable_c10, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c10, uvm_reg)
  `uvm_object_utils(output_enable_c10)
  function new(input string name="unnamed10-output_enable_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : output_enable_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 68


class output_value_c10 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(output_value_c10, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c10, uvm_reg)
  `uvm_object_utils(output_value_c10)
  function new(input string name="unnamed10-output_value_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : output_value_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 83


class input_value_c10 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(input_value_c10, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c10, uvm_reg)
  `uvm_object_utils(input_value_c10)
  function new(input string name="unnamed10-input_value_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : input_value_c10

class gpio_regfile10 extends uvm_reg_block;

  rand bypass_mode_c10 bypass_mode10;
  rand direction_mode_c10 direction_mode10;
  rand output_enable_c10 output_enable10;
  rand output_value_c10 output_value10;
  rand input_value_c10 input_value10;

  virtual function void build();

    // Now10 create all registers

    bypass_mode10 = bypass_mode_c10::type_id::create("bypass_mode10", , get_full_name());
    direction_mode10 = direction_mode_c10::type_id::create("direction_mode10", , get_full_name());
    output_enable10 = output_enable_c10::type_id::create("output_enable10", , get_full_name());
    output_value10 = output_value_c10::type_id::create("output_value10", , get_full_name());
    input_value10 = input_value_c10::type_id::create("input_value10", , get_full_name());

    // Now10 build the registers. Set parent and hdl_paths

    bypass_mode10.configure(this, null, "bypass_mode_reg10");
    bypass_mode10.build();
    direction_mode10.configure(this, null, "direction_mode_reg10");
    direction_mode10.build();
    output_enable10.configure(this, null, "output_enable_reg10");
    output_enable10.build();
    output_value10.configure(this, null, "output_value_reg10");
    output_value10.build();
    input_value10.configure(this, null, "input_value_reg10");
    input_value10.build();
    // Now10 define address mappings10
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode10, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode10, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable10, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value10, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value10, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile10)
  function new(input string name="unnamed10-gpio_rf10");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile10

//////////////////////////////////////////////////////////////////////////////
// Address_map10 definition10
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c10 extends uvm_reg_block;

  rand gpio_regfile10 gpio_rf10;

  function void build();
    // Now10 define address mappings10
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf10 = gpio_regfile10::type_id::create("gpio_rf10", , get_full_name());
    gpio_rf10.configure(this, "rf310");
    gpio_rf10.build();
    gpio_rf10.lock_model();
    default_map.add_submap(gpio_rf10.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c10");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c10)
  function new(input string name="unnamed10-gpio_reg_model_c10");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c10

`endif // GPIO_RDB_SV10
