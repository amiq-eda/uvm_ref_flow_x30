`ifndef GPIO_RDB_SV30
`define GPIO_RDB_SV30

// Input30 File30: gpio_rgm30.spirit30

// Number30 of addrMaps30 = 1
// Number30 of regFiles30 = 1
// Number30 of registers = 5
// Number30 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 23


class bypass_mode_c30 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c30, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c30, uvm_reg)
  `uvm_object_utils(bypass_mode_c30)
  function new(input string name="unnamed30-bypass_mode_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : bypass_mode_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 38


class direction_mode_c30 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(direction_mode_c30, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c30, uvm_reg)
  `uvm_object_utils(direction_mode_c30)
  function new(input string name="unnamed30-direction_mode_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : direction_mode_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 53


class output_enable_c30 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(output_enable_c30, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c30, uvm_reg)
  `uvm_object_utils(output_enable_c30)
  function new(input string name="unnamed30-output_enable_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : output_enable_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 68


class output_value_c30 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(output_value_c30, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c30, uvm_reg)
  `uvm_object_utils(output_value_c30)
  function new(input string name="unnamed30-output_value_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : output_value_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 83


class input_value_c30 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(input_value_c30, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c30, uvm_reg)
  `uvm_object_utils(input_value_c30)
  function new(input string name="unnamed30-input_value_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : input_value_c30

class gpio_regfile30 extends uvm_reg_block;

  rand bypass_mode_c30 bypass_mode30;
  rand direction_mode_c30 direction_mode30;
  rand output_enable_c30 output_enable30;
  rand output_value_c30 output_value30;
  rand input_value_c30 input_value30;

  virtual function void build();

    // Now30 create all registers

    bypass_mode30 = bypass_mode_c30::type_id::create("bypass_mode30", , get_full_name());
    direction_mode30 = direction_mode_c30::type_id::create("direction_mode30", , get_full_name());
    output_enable30 = output_enable_c30::type_id::create("output_enable30", , get_full_name());
    output_value30 = output_value_c30::type_id::create("output_value30", , get_full_name());
    input_value30 = input_value_c30::type_id::create("input_value30", , get_full_name());

    // Now30 build the registers. Set parent and hdl_paths

    bypass_mode30.configure(this, null, "bypass_mode_reg30");
    bypass_mode30.build();
    direction_mode30.configure(this, null, "direction_mode_reg30");
    direction_mode30.build();
    output_enable30.configure(this, null, "output_enable_reg30");
    output_enable30.build();
    output_value30.configure(this, null, "output_value_reg30");
    output_value30.build();
    input_value30.configure(this, null, "input_value_reg30");
    input_value30.build();
    // Now30 define address mappings30
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode30, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode30, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable30, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value30, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value30, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile30)
  function new(input string name="unnamed30-gpio_rf30");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile30

//////////////////////////////////////////////////////////////////////////////
// Address_map30 definition30
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c30 extends uvm_reg_block;

  rand gpio_regfile30 gpio_rf30;

  function void build();
    // Now30 define address mappings30
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf30 = gpio_regfile30::type_id::create("gpio_rf30", , get_full_name());
    gpio_rf30.configure(this, "rf330");
    gpio_rf30.build();
    gpio_rf30.lock_model();
    default_map.add_submap(gpio_rf30.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c30");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c30)
  function new(input string name="unnamed30-gpio_reg_model_c30");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c30

`endif // GPIO_RDB_SV30
