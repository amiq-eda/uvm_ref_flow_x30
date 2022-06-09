`ifndef SPI_RDB_SV11
`define SPI_RDB_SV11

// Input11 File11: spi_rgm11.spirit11

// Number11 of addrMaps11 = 1
// Number11 of regFiles11 = 1
// Number11 of registers = 3
// Number11 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 23


class spi_ctrl_c11 extends uvm_reg;

  rand uvm_reg_field char_len11;
  rand uvm_reg_field go_bsy11;
  rand uvm_reg_field rx_neg11;
  rand uvm_reg_field tx_neg11;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie11;
  rand uvm_reg_field ass11;

  constraint c_char_len11 { char_len11.value == 7'b0001000; }
  constraint c_tx_neg11 { tx_neg11.value == 1'b1; }
  constraint c_rx_neg11 { rx_neg11.value == 1'b1; }
  constraint c_lsb11 { lsb.value == 1'b1; }
  constraint c_ie11 { ie11.value == 1'b1; }
  constraint c_ass11 { ass11.value == 1'b1; }
  virtual function void build();
    char_len11 = uvm_reg_field::type_id::create("char_len11");
    char_len11.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy11 = uvm_reg_field::type_id::create("go_bsy11");
    go_bsy11.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg11 = uvm_reg_field::type_id::create("rx_neg11");
    rx_neg11.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg11 = uvm_reg_field::type_id::create("tx_neg11");
    tx_neg11.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie11 = uvm_reg_field::type_id::create("ie11");
    ie11.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass11 = uvm_reg_field::type_id::create("ass11");
    ass11.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint char_len11.value[6:0];
    coverpoint go_bsy11.value[0:0];
    coverpoint rx_neg11.value[0:0];
    coverpoint tx_neg11.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie11.value[0:0];
    coverpoint ass11.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c11, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c11, uvm_reg)
  `uvm_object_utils(spi_ctrl_c11)
  function new(input string name="unnamed11-spi_ctrl_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : spi_ctrl_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 99


class spi_divider_c11 extends uvm_reg;

  rand uvm_reg_field divider11;

  constraint c_divider11 { divider11.value == 16'b1; }
  virtual function void build();
    divider11 = uvm_reg_field::type_id::create("divider11");
    divider11.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint divider11.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(spi_divider_c11, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c11, uvm_reg)
  `uvm_object_utils(spi_divider_c11)
  function new(input string name="unnamed11-spi_divider_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : spi_divider_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 122


class spi_ss_c11 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss11 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(spi_ss_c11, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c11, uvm_reg)
  `uvm_object_utils(spi_ss_c11)
  function new(input string name="unnamed11-spi_ss_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : spi_ss_c11

class spi_regfile11 extends uvm_reg_block;

  rand spi_ctrl_c11 spi_ctrl11;
  rand spi_divider_c11 spi_divider11;
  rand spi_ss_c11 spi_ss11;

  virtual function void build();

    // Now11 create all registers

    spi_ctrl11 = spi_ctrl_c11::type_id::create("spi_ctrl11", , get_full_name());
    spi_divider11 = spi_divider_c11::type_id::create("spi_divider11", , get_full_name());
    spi_ss11 = spi_ss_c11::type_id::create("spi_ss11", , get_full_name());

    // Now11 build the registers. Set parent and hdl_paths

    spi_ctrl11.configure(this, null, "spi_ctrl_reg11");
    spi_ctrl11.build();
    spi_divider11.configure(this, null, "spi_divider_reg11");
    spi_divider11.build();
    spi_ss11.configure(this, null, "spi_ss_reg11");
    spi_ss11.build();
    // Now11 define address mappings11
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl11, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider11, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss11, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile11)
  function new(input string name="unnamed11-spi_rf11");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile11

//////////////////////////////////////////////////////////////////////////////
// Address_map11 definition11
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c11 extends uvm_reg_block;

  rand spi_regfile11 spi_rf11;

  function void build();
    // Now11 define address mappings11
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf11 = spi_regfile11::type_id::create("spi_rf11", , get_full_name());
    spi_rf11.configure(this, "rf211");
    spi_rf11.build();
    spi_rf11.lock_model();
    default_map.add_submap(spi_rf11.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c11");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c11)
  function new(input string name="unnamed11-spi_reg_model_c11");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c11

`endif // SPI_RDB_SV11
