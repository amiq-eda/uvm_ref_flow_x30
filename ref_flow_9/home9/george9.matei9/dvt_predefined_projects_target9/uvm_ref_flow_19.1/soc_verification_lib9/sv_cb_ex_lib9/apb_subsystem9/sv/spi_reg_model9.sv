`ifndef SPI_RDB_SV9
`define SPI_RDB_SV9

// Input9 File9: spi_rgm9.spirit9

// Number9 of addrMaps9 = 1
// Number9 of regFiles9 = 1
// Number9 of registers = 3
// Number9 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 23


class spi_ctrl_c9 extends uvm_reg;

  rand uvm_reg_field char_len9;
  rand uvm_reg_field go_bsy9;
  rand uvm_reg_field rx_neg9;
  rand uvm_reg_field tx_neg9;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie9;
  rand uvm_reg_field ass9;

  constraint c_char_len9 { char_len9.value == 7'b0001000; }
  constraint c_tx_neg9 { tx_neg9.value == 1'b1; }
  constraint c_rx_neg9 { rx_neg9.value == 1'b1; }
  constraint c_lsb9 { lsb.value == 1'b1; }
  constraint c_ie9 { ie9.value == 1'b1; }
  constraint c_ass9 { ass9.value == 1'b1; }
  virtual function void build();
    char_len9 = uvm_reg_field::type_id::create("char_len9");
    char_len9.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy9 = uvm_reg_field::type_id::create("go_bsy9");
    go_bsy9.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg9 = uvm_reg_field::type_id::create("rx_neg9");
    rx_neg9.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg9 = uvm_reg_field::type_id::create("tx_neg9");
    tx_neg9.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie9 = uvm_reg_field::type_id::create("ie9");
    ie9.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass9 = uvm_reg_field::type_id::create("ass9");
    ass9.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint char_len9.value[6:0];
    coverpoint go_bsy9.value[0:0];
    coverpoint rx_neg9.value[0:0];
    coverpoint tx_neg9.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie9.value[0:0];
    coverpoint ass9.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c9, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c9, uvm_reg)
  `uvm_object_utils(spi_ctrl_c9)
  function new(input string name="unnamed9-spi_ctrl_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : spi_ctrl_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 99


class spi_divider_c9 extends uvm_reg;

  rand uvm_reg_field divider9;

  constraint c_divider9 { divider9.value == 16'b1; }
  virtual function void build();
    divider9 = uvm_reg_field::type_id::create("divider9");
    divider9.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint divider9.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(spi_divider_c9, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c9, uvm_reg)
  `uvm_object_utils(spi_divider_c9)
  function new(input string name="unnamed9-spi_divider_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : spi_divider_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 122


class spi_ss_c9 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss9 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg9;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg9.sample();
  endfunction

  `uvm_register_cb(spi_ss_c9, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c9, uvm_reg)
  `uvm_object_utils(spi_ss_c9)
  function new(input string name="unnamed9-spi_ss_c9");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg9=new;
  endfunction : new
endclass : spi_ss_c9

class spi_regfile9 extends uvm_reg_block;

  rand spi_ctrl_c9 spi_ctrl9;
  rand spi_divider_c9 spi_divider9;
  rand spi_ss_c9 spi_ss9;

  virtual function void build();

    // Now9 create all registers

    spi_ctrl9 = spi_ctrl_c9::type_id::create("spi_ctrl9", , get_full_name());
    spi_divider9 = spi_divider_c9::type_id::create("spi_divider9", , get_full_name());
    spi_ss9 = spi_ss_c9::type_id::create("spi_ss9", , get_full_name());

    // Now9 build the registers. Set parent and hdl_paths

    spi_ctrl9.configure(this, null, "spi_ctrl_reg9");
    spi_ctrl9.build();
    spi_divider9.configure(this, null, "spi_divider_reg9");
    spi_divider9.build();
    spi_ss9.configure(this, null, "spi_ss_reg9");
    spi_ss9.build();
    // Now9 define address mappings9
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl9, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider9, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss9, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile9)
  function new(input string name="unnamed9-spi_rf9");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile9

//////////////////////////////////////////////////////////////////////////////
// Address_map9 definition9
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c9 extends uvm_reg_block;

  rand spi_regfile9 spi_rf9;

  function void build();
    // Now9 define address mappings9
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf9 = spi_regfile9::type_id::create("spi_rf9", , get_full_name());
    spi_rf9.configure(this, "rf29");
    spi_rf9.build();
    spi_rf9.lock_model();
    default_map.add_submap(spi_rf9.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c9");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c9)
  function new(input string name="unnamed9-spi_reg_model_c9");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c9

`endif // SPI_RDB_SV9
