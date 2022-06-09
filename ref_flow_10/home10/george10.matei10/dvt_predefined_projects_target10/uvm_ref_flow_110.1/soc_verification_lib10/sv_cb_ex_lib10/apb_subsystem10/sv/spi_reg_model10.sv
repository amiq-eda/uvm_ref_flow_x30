`ifndef SPI_RDB_SV10
`define SPI_RDB_SV10

// Input10 File10: spi_rgm10.spirit10

// Number10 of addrMaps10 = 1
// Number10 of regFiles10 = 1
// Number10 of registers = 3
// Number10 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 23


class spi_ctrl_c10 extends uvm_reg;

  rand uvm_reg_field char_len10;
  rand uvm_reg_field go_bsy10;
  rand uvm_reg_field rx_neg10;
  rand uvm_reg_field tx_neg10;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie10;
  rand uvm_reg_field ass10;

  constraint c_char_len10 { char_len10.value == 7'b0001000; }
  constraint c_tx_neg10 { tx_neg10.value == 1'b1; }
  constraint c_rx_neg10 { rx_neg10.value == 1'b1; }
  constraint c_lsb10 { lsb.value == 1'b1; }
  constraint c_ie10 { ie10.value == 1'b1; }
  constraint c_ass10 { ass10.value == 1'b1; }
  virtual function void build();
    char_len10 = uvm_reg_field::type_id::create("char_len10");
    char_len10.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy10 = uvm_reg_field::type_id::create("go_bsy10");
    go_bsy10.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg10 = uvm_reg_field::type_id::create("rx_neg10");
    rx_neg10.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg10 = uvm_reg_field::type_id::create("tx_neg10");
    tx_neg10.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie10 = uvm_reg_field::type_id::create("ie10");
    ie10.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass10 = uvm_reg_field::type_id::create("ass10");
    ass10.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint char_len10.value[6:0];
    coverpoint go_bsy10.value[0:0];
    coverpoint rx_neg10.value[0:0];
    coverpoint tx_neg10.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie10.value[0:0];
    coverpoint ass10.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c10, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c10, uvm_reg)
  `uvm_object_utils(spi_ctrl_c10)
  function new(input string name="unnamed10-spi_ctrl_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : spi_ctrl_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 99


class spi_divider_c10 extends uvm_reg;

  rand uvm_reg_field divider10;

  constraint c_divider10 { divider10.value == 16'b1; }
  virtual function void build();
    divider10 = uvm_reg_field::type_id::create("divider10");
    divider10.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint divider10.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(spi_divider_c10, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c10, uvm_reg)
  `uvm_object_utils(spi_divider_c10)
  function new(input string name="unnamed10-spi_divider_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : spi_divider_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 122


class spi_ss_c10 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss10 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg10;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg10.sample();
  endfunction

  `uvm_register_cb(spi_ss_c10, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c10, uvm_reg)
  `uvm_object_utils(spi_ss_c10)
  function new(input string name="unnamed10-spi_ss_c10");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg10=new;
  endfunction : new
endclass : spi_ss_c10

class spi_regfile10 extends uvm_reg_block;

  rand spi_ctrl_c10 spi_ctrl10;
  rand spi_divider_c10 spi_divider10;
  rand spi_ss_c10 spi_ss10;

  virtual function void build();

    // Now10 create all registers

    spi_ctrl10 = spi_ctrl_c10::type_id::create("spi_ctrl10", , get_full_name());
    spi_divider10 = spi_divider_c10::type_id::create("spi_divider10", , get_full_name());
    spi_ss10 = spi_ss_c10::type_id::create("spi_ss10", , get_full_name());

    // Now10 build the registers. Set parent and hdl_paths

    spi_ctrl10.configure(this, null, "spi_ctrl_reg10");
    spi_ctrl10.build();
    spi_divider10.configure(this, null, "spi_divider_reg10");
    spi_divider10.build();
    spi_ss10.configure(this, null, "spi_ss_reg10");
    spi_ss10.build();
    // Now10 define address mappings10
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl10, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider10, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss10, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile10)
  function new(input string name="unnamed10-spi_rf10");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile10

//////////////////////////////////////////////////////////////////////////////
// Address_map10 definition10
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c10 extends uvm_reg_block;

  rand spi_regfile10 spi_rf10;

  function void build();
    // Now10 define address mappings10
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf10 = spi_regfile10::type_id::create("spi_rf10", , get_full_name());
    spi_rf10.configure(this, "rf210");
    spi_rf10.build();
    spi_rf10.lock_model();
    default_map.add_submap(spi_rf10.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c10");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c10)
  function new(input string name="unnamed10-spi_reg_model_c10");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c10

`endif // SPI_RDB_SV10
