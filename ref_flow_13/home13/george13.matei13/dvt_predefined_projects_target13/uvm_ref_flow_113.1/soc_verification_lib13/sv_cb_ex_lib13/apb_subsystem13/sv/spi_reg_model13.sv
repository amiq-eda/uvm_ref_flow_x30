`ifndef SPI_RDB_SV13
`define SPI_RDB_SV13

// Input13 File13: spi_rgm13.spirit13

// Number13 of addrMaps13 = 1
// Number13 of regFiles13 = 1
// Number13 of registers = 3
// Number13 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 23


class spi_ctrl_c13 extends uvm_reg;

  rand uvm_reg_field char_len13;
  rand uvm_reg_field go_bsy13;
  rand uvm_reg_field rx_neg13;
  rand uvm_reg_field tx_neg13;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie13;
  rand uvm_reg_field ass13;

  constraint c_char_len13 { char_len13.value == 7'b0001000; }
  constraint c_tx_neg13 { tx_neg13.value == 1'b1; }
  constraint c_rx_neg13 { rx_neg13.value == 1'b1; }
  constraint c_lsb13 { lsb.value == 1'b1; }
  constraint c_ie13 { ie13.value == 1'b1; }
  constraint c_ass13 { ass13.value == 1'b1; }
  virtual function void build();
    char_len13 = uvm_reg_field::type_id::create("char_len13");
    char_len13.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy13 = uvm_reg_field::type_id::create("go_bsy13");
    go_bsy13.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg13 = uvm_reg_field::type_id::create("rx_neg13");
    rx_neg13.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg13 = uvm_reg_field::type_id::create("tx_neg13");
    tx_neg13.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie13 = uvm_reg_field::type_id::create("ie13");
    ie13.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass13 = uvm_reg_field::type_id::create("ass13");
    ass13.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint char_len13.value[6:0];
    coverpoint go_bsy13.value[0:0];
    coverpoint rx_neg13.value[0:0];
    coverpoint tx_neg13.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie13.value[0:0];
    coverpoint ass13.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c13, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c13, uvm_reg)
  `uvm_object_utils(spi_ctrl_c13)
  function new(input string name="unnamed13-spi_ctrl_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : spi_ctrl_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 99


class spi_divider_c13 extends uvm_reg;

  rand uvm_reg_field divider13;

  constraint c_divider13 { divider13.value == 16'b1; }
  virtual function void build();
    divider13 = uvm_reg_field::type_id::create("divider13");
    divider13.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint divider13.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(spi_divider_c13, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c13, uvm_reg)
  `uvm_object_utils(spi_divider_c13)
  function new(input string name="unnamed13-spi_divider_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : spi_divider_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 122


class spi_ss_c13 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss13 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(spi_ss_c13, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c13, uvm_reg)
  `uvm_object_utils(spi_ss_c13)
  function new(input string name="unnamed13-spi_ss_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : spi_ss_c13

class spi_regfile13 extends uvm_reg_block;

  rand spi_ctrl_c13 spi_ctrl13;
  rand spi_divider_c13 spi_divider13;
  rand spi_ss_c13 spi_ss13;

  virtual function void build();

    // Now13 create all registers

    spi_ctrl13 = spi_ctrl_c13::type_id::create("spi_ctrl13", , get_full_name());
    spi_divider13 = spi_divider_c13::type_id::create("spi_divider13", , get_full_name());
    spi_ss13 = spi_ss_c13::type_id::create("spi_ss13", , get_full_name());

    // Now13 build the registers. Set parent and hdl_paths

    spi_ctrl13.configure(this, null, "spi_ctrl_reg13");
    spi_ctrl13.build();
    spi_divider13.configure(this, null, "spi_divider_reg13");
    spi_divider13.build();
    spi_ss13.configure(this, null, "spi_ss_reg13");
    spi_ss13.build();
    // Now13 define address mappings13
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl13, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider13, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss13, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile13)
  function new(input string name="unnamed13-spi_rf13");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile13

//////////////////////////////////////////////////////////////////////////////
// Address_map13 definition13
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c13 extends uvm_reg_block;

  rand spi_regfile13 spi_rf13;

  function void build();
    // Now13 define address mappings13
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf13 = spi_regfile13::type_id::create("spi_rf13", , get_full_name());
    spi_rf13.configure(this, "rf213");
    spi_rf13.build();
    spi_rf13.lock_model();
    default_map.add_submap(spi_rf13.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c13");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c13)
  function new(input string name="unnamed13-spi_reg_model_c13");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c13

`endif // SPI_RDB_SV13
