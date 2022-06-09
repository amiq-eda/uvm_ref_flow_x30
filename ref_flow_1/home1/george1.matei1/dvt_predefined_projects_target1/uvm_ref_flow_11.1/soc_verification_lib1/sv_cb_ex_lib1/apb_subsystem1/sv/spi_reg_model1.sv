`ifndef SPI_RDB_SV1
`define SPI_RDB_SV1

// Input1 File1: spi_rgm1.spirit1

// Number1 of addrMaps1 = 1
// Number1 of regFiles1 = 1
// Number1 of registers = 3
// Number1 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 23


class spi_ctrl_c1 extends uvm_reg;

  rand uvm_reg_field char_len1;
  rand uvm_reg_field go_bsy1;
  rand uvm_reg_field rx_neg1;
  rand uvm_reg_field tx_neg1;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie1;
  rand uvm_reg_field ass1;

  constraint c_char_len1 { char_len1.value == 7'b0001000; }
  constraint c_tx_neg1 { tx_neg1.value == 1'b1; }
  constraint c_rx_neg1 { rx_neg1.value == 1'b1; }
  constraint c_lsb1 { lsb.value == 1'b1; }
  constraint c_ie1 { ie1.value == 1'b1; }
  constraint c_ass1 { ass1.value == 1'b1; }
  virtual function void build();
    char_len1 = uvm_reg_field::type_id::create("char_len1");
    char_len1.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy1 = uvm_reg_field::type_id::create("go_bsy1");
    go_bsy1.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg1 = uvm_reg_field::type_id::create("rx_neg1");
    rx_neg1.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg1 = uvm_reg_field::type_id::create("tx_neg1");
    tx_neg1.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie1 = uvm_reg_field::type_id::create("ie1");
    ie1.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass1 = uvm_reg_field::type_id::create("ass1");
    ass1.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint char_len1.value[6:0];
    coverpoint go_bsy1.value[0:0];
    coverpoint rx_neg1.value[0:0];
    coverpoint tx_neg1.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie1.value[0:0];
    coverpoint ass1.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c1, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c1, uvm_reg)
  `uvm_object_utils(spi_ctrl_c1)
  function new(input string name="unnamed1-spi_ctrl_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : spi_ctrl_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 99


class spi_divider_c1 extends uvm_reg;

  rand uvm_reg_field divider1;

  constraint c_divider1 { divider1.value == 16'b1; }
  virtual function void build();
    divider1 = uvm_reg_field::type_id::create("divider1");
    divider1.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint divider1.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(spi_divider_c1, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c1, uvm_reg)
  `uvm_object_utils(spi_divider_c1)
  function new(input string name="unnamed1-spi_divider_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : spi_divider_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 122


class spi_ss_c1 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss1 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg1;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg1.sample();
  endfunction

  `uvm_register_cb(spi_ss_c1, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c1, uvm_reg)
  `uvm_object_utils(spi_ss_c1)
  function new(input string name="unnamed1-spi_ss_c1");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg1=new;
  endfunction : new
endclass : spi_ss_c1

class spi_regfile1 extends uvm_reg_block;

  rand spi_ctrl_c1 spi_ctrl1;
  rand spi_divider_c1 spi_divider1;
  rand spi_ss_c1 spi_ss1;

  virtual function void build();

    // Now1 create all registers

    spi_ctrl1 = spi_ctrl_c1::type_id::create("spi_ctrl1", , get_full_name());
    spi_divider1 = spi_divider_c1::type_id::create("spi_divider1", , get_full_name());
    spi_ss1 = spi_ss_c1::type_id::create("spi_ss1", , get_full_name());

    // Now1 build the registers. Set parent and hdl_paths

    spi_ctrl1.configure(this, null, "spi_ctrl_reg1");
    spi_ctrl1.build();
    spi_divider1.configure(this, null, "spi_divider_reg1");
    spi_divider1.build();
    spi_ss1.configure(this, null, "spi_ss_reg1");
    spi_ss1.build();
    // Now1 define address mappings1
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl1, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider1, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss1, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile1)
  function new(input string name="unnamed1-spi_rf1");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile1

//////////////////////////////////////////////////////////////////////////////
// Address_map1 definition1
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c1 extends uvm_reg_block;

  rand spi_regfile1 spi_rf1;

  function void build();
    // Now1 define address mappings1
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf1 = spi_regfile1::type_id::create("spi_rf1", , get_full_name());
    spi_rf1.configure(this, "rf21");
    spi_rf1.build();
    spi_rf1.lock_model();
    default_map.add_submap(spi_rf1.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c1");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c1)
  function new(input string name="unnamed1-spi_reg_model_c1");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c1

`endif // SPI_RDB_SV1
