`ifndef GPIO_RDB_SV16
`define GPIO_RDB_SV16

// Input16 File16: gpio_rgm16.spirit16

// Number16 of addrMaps16 = 1
// Number16 of regFiles16 = 1
// Number16 of registers = 5
// Number16 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 23


class bypass_mode_c16 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg16;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg16.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c16, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c16, uvm_reg)
  `uvm_object_utils(bypass_mode_c16)
  function new(input string name="unnamed16-bypass_mode_c16");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg16=new;
  endfunction : new
endclass : bypass_mode_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 38


class direction_mode_c16 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg16;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg16.sample();
  endfunction

  `uvm_register_cb(direction_mode_c16, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c16, uvm_reg)
  `uvm_object_utils(direction_mode_c16)
  function new(input string name="unnamed16-direction_mode_c16");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg16=new;
  endfunction : new
endclass : direction_mode_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 53


class output_enable_c16 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg16;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg16.sample();
  endfunction

  `uvm_register_cb(output_enable_c16, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c16, uvm_reg)
  `uvm_object_utils(output_enable_c16)
  function new(input string name="unnamed16-output_enable_c16");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg16=new;
  endfunction : new
endclass : output_enable_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 68


class output_value_c16 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg16;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg16.sample();
  endfunction

  `uvm_register_cb(output_value_c16, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c16, uvm_reg)
  `uvm_object_utils(output_value_c16)
  function new(input string name="unnamed16-output_value_c16");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg16=new;
  endfunction : new
endclass : output_value_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 83


class input_value_c16 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg16;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg16.sample();
  endfunction

  `uvm_register_cb(input_value_c16, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c16, uvm_reg)
  `uvm_object_utils(input_value_c16)
  function new(input string name="unnamed16-input_value_c16");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg16=new;
  endfunction : new
endclass : input_value_c16

class gpio_regfile16 extends uvm_reg_block;

  rand bypass_mode_c16 bypass_mode16;
  rand direction_mode_c16 direction_mode16;
  rand output_enable_c16 output_enable16;
  rand output_value_c16 output_value16;
  rand input_value_c16 input_value16;

  virtual function void build();

    // Now16 create all registers

    bypass_mode16 = bypass_mode_c16::type_id::create("bypass_mode16", , get_full_name());
    direction_mode16 = direction_mode_c16::type_id::create("direction_mode16", , get_full_name());
    output_enable16 = output_enable_c16::type_id::create("output_enable16", , get_full_name());
    output_value16 = output_value_c16::type_id::create("output_value16", , get_full_name());
    input_value16 = input_value_c16::type_id::create("input_value16", , get_full_name());

    // Now16 build the registers. Set parent and hdl_paths

    bypass_mode16.configure(this, null, "bypass_mode_reg16");
    bypass_mode16.build();
    direction_mode16.configure(this, null, "direction_mode_reg16");
    direction_mode16.build();
    output_enable16.configure(this, null, "output_enable_reg16");
    output_enable16.build();
    output_value16.configure(this, null, "output_value_reg16");
    output_value16.build();
    input_value16.configure(this, null, "input_value_reg16");
    input_value16.build();
    // Now16 define address mappings16
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode16, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode16, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable16, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value16, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value16, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile16)
  function new(input string name="unnamed16-gpio_rf16");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile16

//////////////////////////////////////////////////////////////////////////////
// Address_map16 definition16
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c16 extends uvm_reg_block;

  rand gpio_regfile16 gpio_rf16;

  function void build();
    // Now16 define address mappings16
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf16 = gpio_regfile16::type_id::create("gpio_rf16", , get_full_name());
    gpio_rf16.configure(this, "rf316");
    gpio_rf16.build();
    gpio_rf16.lock_model();
    default_map.add_submap(gpio_rf16.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c16");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c16)
  function new(input string name="unnamed16-gpio_reg_model_c16");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c16

`endif // GPIO_RDB_SV16
