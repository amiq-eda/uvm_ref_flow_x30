`ifndef GPIO_RDB_SV18
`define GPIO_RDB_SV18

// Input18 File18: gpio_rgm18.spirit18

// Number18 of addrMaps18 = 1
// Number18 of regFiles18 = 1
// Number18 of registers = 5
// Number18 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 23


class bypass_mode_c18 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c18, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c18, uvm_reg)
  `uvm_object_utils(bypass_mode_c18)
  function new(input string name="unnamed18-bypass_mode_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : bypass_mode_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 38


class direction_mode_c18 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(direction_mode_c18, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c18, uvm_reg)
  `uvm_object_utils(direction_mode_c18)
  function new(input string name="unnamed18-direction_mode_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : direction_mode_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 53


class output_enable_c18 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(output_enable_c18, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c18, uvm_reg)
  `uvm_object_utils(output_enable_c18)
  function new(input string name="unnamed18-output_enable_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : output_enable_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 68


class output_value_c18 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(output_value_c18, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c18, uvm_reg)
  `uvm_object_utils(output_value_c18)
  function new(input string name="unnamed18-output_value_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : output_value_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 83


class input_value_c18 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(input_value_c18, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c18, uvm_reg)
  `uvm_object_utils(input_value_c18)
  function new(input string name="unnamed18-input_value_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : input_value_c18

class gpio_regfile18 extends uvm_reg_block;

  rand bypass_mode_c18 bypass_mode18;
  rand direction_mode_c18 direction_mode18;
  rand output_enable_c18 output_enable18;
  rand output_value_c18 output_value18;
  rand input_value_c18 input_value18;

  virtual function void build();

    // Now18 create all registers

    bypass_mode18 = bypass_mode_c18::type_id::create("bypass_mode18", , get_full_name());
    direction_mode18 = direction_mode_c18::type_id::create("direction_mode18", , get_full_name());
    output_enable18 = output_enable_c18::type_id::create("output_enable18", , get_full_name());
    output_value18 = output_value_c18::type_id::create("output_value18", , get_full_name());
    input_value18 = input_value_c18::type_id::create("input_value18", , get_full_name());

    // Now18 build the registers. Set parent and hdl_paths

    bypass_mode18.configure(this, null, "bypass_mode_reg18");
    bypass_mode18.build();
    direction_mode18.configure(this, null, "direction_mode_reg18");
    direction_mode18.build();
    output_enable18.configure(this, null, "output_enable_reg18");
    output_enable18.build();
    output_value18.configure(this, null, "output_value_reg18");
    output_value18.build();
    input_value18.configure(this, null, "input_value_reg18");
    input_value18.build();
    // Now18 define address mappings18
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode18, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode18, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable18, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value18, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value18, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile18)
  function new(input string name="unnamed18-gpio_rf18");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile18

//////////////////////////////////////////////////////////////////////////////
// Address_map18 definition18
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c18 extends uvm_reg_block;

  rand gpio_regfile18 gpio_rf18;

  function void build();
    // Now18 define address mappings18
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf18 = gpio_regfile18::type_id::create("gpio_rf18", , get_full_name());
    gpio_rf18.configure(this, "rf318");
    gpio_rf18.build();
    gpio_rf18.lock_model();
    default_map.add_submap(gpio_rf18.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c18");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c18)
  function new(input string name="unnamed18-gpio_reg_model_c18");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c18

`endif // GPIO_RDB_SV18
