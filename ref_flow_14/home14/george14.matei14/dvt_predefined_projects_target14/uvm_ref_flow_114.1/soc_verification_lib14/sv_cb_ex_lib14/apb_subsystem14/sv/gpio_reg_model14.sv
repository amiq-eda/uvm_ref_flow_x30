`ifndef GPIO_RDB_SV14
`define GPIO_RDB_SV14

// Input14 File14: gpio_rgm14.spirit14

// Number14 of addrMaps14 = 1
// Number14 of regFiles14 = 1
// Number14 of registers = 5
// Number14 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 23


class bypass_mode_c14 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c14, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c14, uvm_reg)
  `uvm_object_utils(bypass_mode_c14)
  function new(input string name="unnamed14-bypass_mode_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : bypass_mode_c14

//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 38


class direction_mode_c14 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(direction_mode_c14, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c14, uvm_reg)
  `uvm_object_utils(direction_mode_c14)
  function new(input string name="unnamed14-direction_mode_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : direction_mode_c14

//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 53


class output_enable_c14 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(output_enable_c14, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c14, uvm_reg)
  `uvm_object_utils(output_enable_c14)
  function new(input string name="unnamed14-output_enable_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : output_enable_c14

//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 68


class output_value_c14 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(output_value_c14, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c14, uvm_reg)
  `uvm_object_utils(output_value_c14)
  function new(input string name="unnamed14-output_value_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : output_value_c14

//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 83


class input_value_c14 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(input_value_c14, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c14, uvm_reg)
  `uvm_object_utils(input_value_c14)
  function new(input string name="unnamed14-input_value_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : input_value_c14

class gpio_regfile14 extends uvm_reg_block;

  rand bypass_mode_c14 bypass_mode14;
  rand direction_mode_c14 direction_mode14;
  rand output_enable_c14 output_enable14;
  rand output_value_c14 output_value14;
  rand input_value_c14 input_value14;

  virtual function void build();

    // Now14 create all registers

    bypass_mode14 = bypass_mode_c14::type_id::create("bypass_mode14", , get_full_name());
    direction_mode14 = direction_mode_c14::type_id::create("direction_mode14", , get_full_name());
    output_enable14 = output_enable_c14::type_id::create("output_enable14", , get_full_name());
    output_value14 = output_value_c14::type_id::create("output_value14", , get_full_name());
    input_value14 = input_value_c14::type_id::create("input_value14", , get_full_name());

    // Now14 build the registers. Set parent and hdl_paths

    bypass_mode14.configure(this, null, "bypass_mode_reg14");
    bypass_mode14.build();
    direction_mode14.configure(this, null, "direction_mode_reg14");
    direction_mode14.build();
    output_enable14.configure(this, null, "output_enable_reg14");
    output_enable14.build();
    output_value14.configure(this, null, "output_value_reg14");
    output_value14.build();
    input_value14.configure(this, null, "input_value_reg14");
    input_value14.build();
    // Now14 define address mappings14
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode14, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode14, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable14, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value14, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value14, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile14)
  function new(input string name="unnamed14-gpio_rf14");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile14

//////////////////////////////////////////////////////////////////////////////
// Address_map14 definition14
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c14 extends uvm_reg_block;

  rand gpio_regfile14 gpio_rf14;

  function void build();
    // Now14 define address mappings14
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf14 = gpio_regfile14::type_id::create("gpio_rf14", , get_full_name());
    gpio_rf14.configure(this, "rf314");
    gpio_rf14.build();
    gpio_rf14.lock_model();
    default_map.add_submap(gpio_rf14.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c14");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c14)
  function new(input string name="unnamed14-gpio_reg_model_c14");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c14

`endif // GPIO_RDB_SV14
