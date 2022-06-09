`ifndef SPI_RDB_SV3
`define SPI_RDB_SV3

// Input3 File3: spi_rgm3.spirit3

// Number3 of addrMaps3 = 1
// Number3 of regFiles3 = 1
// Number3 of registers = 3
// Number3 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 23


class spi_ctrl_c3 extends uvm_reg;

  rand uvm_reg_field char_len3;
  rand uvm_reg_field go_bsy3;
  rand uvm_reg_field rx_neg3;
  rand uvm_reg_field tx_neg3;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie3;
  rand uvm_reg_field ass3;

  constraint c_char_len3 { char_len3.value == 7'b0001000; }
  constraint c_tx_neg3 { tx_neg3.value == 1'b1; }
  constraint c_rx_neg3 { rx_neg3.value == 1'b1; }
  constraint c_lsb3 { lsb.value == 1'b1; }
  constraint c_ie3 { ie3.value == 1'b1; }
  constraint c_ass3 { ass3.value == 1'b1; }
  virtual function void build();
    char_len3 = uvm_reg_field::type_id::create("char_len3");
    char_len3.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy3 = uvm_reg_field::type_id::create("go_bsy3");
    go_bsy3.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg3 = uvm_reg_field::type_id::create("rx_neg3");
    rx_neg3.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg3 = uvm_reg_field::type_id::create("tx_neg3");
    tx_neg3.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie3 = uvm_reg_field::type_id::create("ie3");
    ie3.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass3 = uvm_reg_field::type_id::create("ass3");
    ass3.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint char_len3.value[6:0];
    coverpoint go_bsy3.value[0:0];
    coverpoint rx_neg3.value[0:0];
    coverpoint tx_neg3.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie3.value[0:0];
    coverpoint ass3.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c3, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c3, uvm_reg)
  `uvm_object_utils(spi_ctrl_c3)
  function new(input string name="unnamed3-spi_ctrl_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : spi_ctrl_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 99


class spi_divider_c3 extends uvm_reg;

  rand uvm_reg_field divider3;

  constraint c_divider3 { divider3.value == 16'b1; }
  virtual function void build();
    divider3 = uvm_reg_field::type_id::create("divider3");
    divider3.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint divider3.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(spi_divider_c3, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c3, uvm_reg)
  `uvm_object_utils(spi_divider_c3)
  function new(input string name="unnamed3-spi_divider_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : spi_divider_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 122


class spi_ss_c3 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss3 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg3;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg3.sample();
  endfunction

  `uvm_register_cb(spi_ss_c3, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c3, uvm_reg)
  `uvm_object_utils(spi_ss_c3)
  function new(input string name="unnamed3-spi_ss_c3");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg3=new;
  endfunction : new
endclass : spi_ss_c3

class spi_regfile3 extends uvm_reg_block;

  rand spi_ctrl_c3 spi_ctrl3;
  rand spi_divider_c3 spi_divider3;
  rand spi_ss_c3 spi_ss3;

  virtual function void build();

    // Now3 create all registers

    spi_ctrl3 = spi_ctrl_c3::type_id::create("spi_ctrl3", , get_full_name());
    spi_divider3 = spi_divider_c3::type_id::create("spi_divider3", , get_full_name());
    spi_ss3 = spi_ss_c3::type_id::create("spi_ss3", , get_full_name());

    // Now3 build the registers. Set parent and hdl_paths

    spi_ctrl3.configure(this, null, "spi_ctrl_reg3");
    spi_ctrl3.build();
    spi_divider3.configure(this, null, "spi_divider_reg3");
    spi_divider3.build();
    spi_ss3.configure(this, null, "spi_ss_reg3");
    spi_ss3.build();
    // Now3 define address mappings3
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl3, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider3, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss3, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile3)
  function new(input string name="unnamed3-spi_rf3");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile3

//////////////////////////////////////////////////////////////////////////////
// Address_map3 definition3
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c3 extends uvm_reg_block;

  rand spi_regfile3 spi_rf3;

  function void build();
    // Now3 define address mappings3
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf3 = spi_regfile3::type_id::create("spi_rf3", , get_full_name());
    spi_rf3.configure(this, "rf23");
    spi_rf3.build();
    spi_rf3.lock_model();
    default_map.add_submap(spi_rf3.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c3");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c3)
  function new(input string name="unnamed3-spi_reg_model_c3");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c3

`endif // SPI_RDB_SV3
