`ifndef GPIO_RDB_SV22
`define GPIO_RDB_SV22

// Input22 File22: gpio_rgm22.spirit22

// Number22 of addrMaps22 = 1
// Number22 of regFiles22 = 1
// Number22 of registers = 5
// Number22 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 23


class bypass_mode_c22 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c22, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c22, uvm_reg)
  `uvm_object_utils(bypass_mode_c22)
  function new(input string name="unnamed22-bypass_mode_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : bypass_mode_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 38


class direction_mode_c22 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(direction_mode_c22, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c22, uvm_reg)
  `uvm_object_utils(direction_mode_c22)
  function new(input string name="unnamed22-direction_mode_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : direction_mode_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 53


class output_enable_c22 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(output_enable_c22, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c22, uvm_reg)
  `uvm_object_utils(output_enable_c22)
  function new(input string name="unnamed22-output_enable_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : output_enable_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 68


class output_value_c22 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(output_value_c22, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c22, uvm_reg)
  `uvm_object_utils(output_value_c22)
  function new(input string name="unnamed22-output_value_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : output_value_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 83


class input_value_c22 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(input_value_c22, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c22, uvm_reg)
  `uvm_object_utils(input_value_c22)
  function new(input string name="unnamed22-input_value_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : input_value_c22

class gpio_regfile22 extends uvm_reg_block;

  rand bypass_mode_c22 bypass_mode22;
  rand direction_mode_c22 direction_mode22;
  rand output_enable_c22 output_enable22;
  rand output_value_c22 output_value22;
  rand input_value_c22 input_value22;

  virtual function void build();

    // Now22 create all registers

    bypass_mode22 = bypass_mode_c22::type_id::create("bypass_mode22", , get_full_name());
    direction_mode22 = direction_mode_c22::type_id::create("direction_mode22", , get_full_name());
    output_enable22 = output_enable_c22::type_id::create("output_enable22", , get_full_name());
    output_value22 = output_value_c22::type_id::create("output_value22", , get_full_name());
    input_value22 = input_value_c22::type_id::create("input_value22", , get_full_name());

    // Now22 build the registers. Set parent and hdl_paths

    bypass_mode22.configure(this, null, "bypass_mode_reg22");
    bypass_mode22.build();
    direction_mode22.configure(this, null, "direction_mode_reg22");
    direction_mode22.build();
    output_enable22.configure(this, null, "output_enable_reg22");
    output_enable22.build();
    output_value22.configure(this, null, "output_value_reg22");
    output_value22.build();
    input_value22.configure(this, null, "input_value_reg22");
    input_value22.build();
    // Now22 define address mappings22
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode22, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode22, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable22, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value22, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value22, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile22)
  function new(input string name="unnamed22-gpio_rf22");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile22

//////////////////////////////////////////////////////////////////////////////
// Address_map22 definition22
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c22 extends uvm_reg_block;

  rand gpio_regfile22 gpio_rf22;

  function void build();
    // Now22 define address mappings22
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf22 = gpio_regfile22::type_id::create("gpio_rf22", , get_full_name());
    gpio_rf22.configure(this, "rf322");
    gpio_rf22.build();
    gpio_rf22.lock_model();
    default_map.add_submap(gpio_rf22.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c22");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c22)
  function new(input string name="unnamed22-gpio_reg_model_c22");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c22

`endif // GPIO_RDB_SV22
