`ifndef GPIO_RDB_SV19
`define GPIO_RDB_SV19

// Input19 File19: gpio_rgm19.spirit19

// Number19 of addrMaps19 = 1
// Number19 of regFiles19 = 1
// Number19 of registers = 5
// Number19 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 23


class bypass_mode_c19 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c19, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c19, uvm_reg)
  `uvm_object_utils(bypass_mode_c19)
  function new(input string name="unnamed19-bypass_mode_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : bypass_mode_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 38


class direction_mode_c19 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(direction_mode_c19, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c19, uvm_reg)
  `uvm_object_utils(direction_mode_c19)
  function new(input string name="unnamed19-direction_mode_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : direction_mode_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 53


class output_enable_c19 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(output_enable_c19, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c19, uvm_reg)
  `uvm_object_utils(output_enable_c19)
  function new(input string name="unnamed19-output_enable_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : output_enable_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 68


class output_value_c19 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(output_value_c19, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c19, uvm_reg)
  `uvm_object_utils(output_value_c19)
  function new(input string name="unnamed19-output_value_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : output_value_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 83


class input_value_c19 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(input_value_c19, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c19, uvm_reg)
  `uvm_object_utils(input_value_c19)
  function new(input string name="unnamed19-input_value_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : input_value_c19

class gpio_regfile19 extends uvm_reg_block;

  rand bypass_mode_c19 bypass_mode19;
  rand direction_mode_c19 direction_mode19;
  rand output_enable_c19 output_enable19;
  rand output_value_c19 output_value19;
  rand input_value_c19 input_value19;

  virtual function void build();

    // Now19 create all registers

    bypass_mode19 = bypass_mode_c19::type_id::create("bypass_mode19", , get_full_name());
    direction_mode19 = direction_mode_c19::type_id::create("direction_mode19", , get_full_name());
    output_enable19 = output_enable_c19::type_id::create("output_enable19", , get_full_name());
    output_value19 = output_value_c19::type_id::create("output_value19", , get_full_name());
    input_value19 = input_value_c19::type_id::create("input_value19", , get_full_name());

    // Now19 build the registers. Set parent and hdl_paths

    bypass_mode19.configure(this, null, "bypass_mode_reg19");
    bypass_mode19.build();
    direction_mode19.configure(this, null, "direction_mode_reg19");
    direction_mode19.build();
    output_enable19.configure(this, null, "output_enable_reg19");
    output_enable19.build();
    output_value19.configure(this, null, "output_value_reg19");
    output_value19.build();
    input_value19.configure(this, null, "input_value_reg19");
    input_value19.build();
    // Now19 define address mappings19
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode19, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode19, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable19, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value19, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value19, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile19)
  function new(input string name="unnamed19-gpio_rf19");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile19

//////////////////////////////////////////////////////////////////////////////
// Address_map19 definition19
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c19 extends uvm_reg_block;

  rand gpio_regfile19 gpio_rf19;

  function void build();
    // Now19 define address mappings19
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf19 = gpio_regfile19::type_id::create("gpio_rf19", , get_full_name());
    gpio_rf19.configure(this, "rf319");
    gpio_rf19.build();
    gpio_rf19.lock_model();
    default_map.add_submap(gpio_rf19.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c19");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c19)
  function new(input string name="unnamed19-gpio_reg_model_c19");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c19

`endif // GPIO_RDB_SV19
