`ifndef GPIO_RDB_SV21
`define GPIO_RDB_SV21

// Input21 File21: gpio_rgm21.spirit21

// Number21 of addrMaps21 = 1
// Number21 of regFiles21 = 1
// Number21 of registers = 5
// Number21 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 23


class bypass_mode_c21 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c21, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c21, uvm_reg)
  `uvm_object_utils(bypass_mode_c21)
  function new(input string name="unnamed21-bypass_mode_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : bypass_mode_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 38


class direction_mode_c21 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(direction_mode_c21, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c21, uvm_reg)
  `uvm_object_utils(direction_mode_c21)
  function new(input string name="unnamed21-direction_mode_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : direction_mode_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 53


class output_enable_c21 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(output_enable_c21, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c21, uvm_reg)
  `uvm_object_utils(output_enable_c21)
  function new(input string name="unnamed21-output_enable_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : output_enable_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 68


class output_value_c21 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(output_value_c21, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c21, uvm_reg)
  `uvm_object_utils(output_value_c21)
  function new(input string name="unnamed21-output_value_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : output_value_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 83


class input_value_c21 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(input_value_c21, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c21, uvm_reg)
  `uvm_object_utils(input_value_c21)
  function new(input string name="unnamed21-input_value_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : input_value_c21

class gpio_regfile21 extends uvm_reg_block;

  rand bypass_mode_c21 bypass_mode21;
  rand direction_mode_c21 direction_mode21;
  rand output_enable_c21 output_enable21;
  rand output_value_c21 output_value21;
  rand input_value_c21 input_value21;

  virtual function void build();

    // Now21 create all registers

    bypass_mode21 = bypass_mode_c21::type_id::create("bypass_mode21", , get_full_name());
    direction_mode21 = direction_mode_c21::type_id::create("direction_mode21", , get_full_name());
    output_enable21 = output_enable_c21::type_id::create("output_enable21", , get_full_name());
    output_value21 = output_value_c21::type_id::create("output_value21", , get_full_name());
    input_value21 = input_value_c21::type_id::create("input_value21", , get_full_name());

    // Now21 build the registers. Set parent and hdl_paths

    bypass_mode21.configure(this, null, "bypass_mode_reg21");
    bypass_mode21.build();
    direction_mode21.configure(this, null, "direction_mode_reg21");
    direction_mode21.build();
    output_enable21.configure(this, null, "output_enable_reg21");
    output_enable21.build();
    output_value21.configure(this, null, "output_value_reg21");
    output_value21.build();
    input_value21.configure(this, null, "input_value_reg21");
    input_value21.build();
    // Now21 define address mappings21
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode21, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode21, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable21, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value21, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value21, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile21)
  function new(input string name="unnamed21-gpio_rf21");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile21

//////////////////////////////////////////////////////////////////////////////
// Address_map21 definition21
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c21 extends uvm_reg_block;

  rand gpio_regfile21 gpio_rf21;

  function void build();
    // Now21 define address mappings21
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf21 = gpio_regfile21::type_id::create("gpio_rf21", , get_full_name());
    gpio_rf21.configure(this, "rf321");
    gpio_rf21.build();
    gpio_rf21.lock_model();
    default_map.add_submap(gpio_rf21.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c21");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c21)
  function new(input string name="unnamed21-gpio_reg_model_c21");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c21

`endif // GPIO_RDB_SV21
