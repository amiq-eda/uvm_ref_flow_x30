`ifndef SPI_RDB_SV4
`define SPI_RDB_SV4

// Input4 File4: spi_rgm4.spirit4

// Number4 of addrMaps4 = 1
// Number4 of regFiles4 = 1
// Number4 of registers = 3
// Number4 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 23


class spi_ctrl_c4 extends uvm_reg;

  rand uvm_reg_field char_len4;
  rand uvm_reg_field go_bsy4;
  rand uvm_reg_field rx_neg4;
  rand uvm_reg_field tx_neg4;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie4;
  rand uvm_reg_field ass4;

  constraint c_char_len4 { char_len4.value == 7'b0001000; }
  constraint c_tx_neg4 { tx_neg4.value == 1'b1; }
  constraint c_rx_neg4 { rx_neg4.value == 1'b1; }
  constraint c_lsb4 { lsb.value == 1'b1; }
  constraint c_ie4 { ie4.value == 1'b1; }
  constraint c_ass4 { ass4.value == 1'b1; }
  virtual function void build();
    char_len4 = uvm_reg_field::type_id::create("char_len4");
    char_len4.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy4 = uvm_reg_field::type_id::create("go_bsy4");
    go_bsy4.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg4 = uvm_reg_field::type_id::create("rx_neg4");
    rx_neg4.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg4 = uvm_reg_field::type_id::create("tx_neg4");
    tx_neg4.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie4 = uvm_reg_field::type_id::create("ie4");
    ie4.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass4 = uvm_reg_field::type_id::create("ass4");
    ass4.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint char_len4.value[6:0];
    coverpoint go_bsy4.value[0:0];
    coverpoint rx_neg4.value[0:0];
    coverpoint tx_neg4.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie4.value[0:0];
    coverpoint ass4.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c4, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c4, uvm_reg)
  `uvm_object_utils(spi_ctrl_c4)
  function new(input string name="unnamed4-spi_ctrl_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : spi_ctrl_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 99


class spi_divider_c4 extends uvm_reg;

  rand uvm_reg_field divider4;

  constraint c_divider4 { divider4.value == 16'b1; }
  virtual function void build();
    divider4 = uvm_reg_field::type_id::create("divider4");
    divider4.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint divider4.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(spi_divider_c4, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c4, uvm_reg)
  `uvm_object_utils(spi_divider_c4)
  function new(input string name="unnamed4-spi_divider_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : spi_divider_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 122


class spi_ss_c4 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss4 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(spi_ss_c4, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c4, uvm_reg)
  `uvm_object_utils(spi_ss_c4)
  function new(input string name="unnamed4-spi_ss_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : spi_ss_c4

class spi_regfile4 extends uvm_reg_block;

  rand spi_ctrl_c4 spi_ctrl4;
  rand spi_divider_c4 spi_divider4;
  rand spi_ss_c4 spi_ss4;

  virtual function void build();

    // Now4 create all registers

    spi_ctrl4 = spi_ctrl_c4::type_id::create("spi_ctrl4", , get_full_name());
    spi_divider4 = spi_divider_c4::type_id::create("spi_divider4", , get_full_name());
    spi_ss4 = spi_ss_c4::type_id::create("spi_ss4", , get_full_name());

    // Now4 build the registers. Set parent and hdl_paths

    spi_ctrl4.configure(this, null, "spi_ctrl_reg4");
    spi_ctrl4.build();
    spi_divider4.configure(this, null, "spi_divider_reg4");
    spi_divider4.build();
    spi_ss4.configure(this, null, "spi_ss_reg4");
    spi_ss4.build();
    // Now4 define address mappings4
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl4, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider4, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss4, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile4)
  function new(input string name="unnamed4-spi_rf4");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile4

//////////////////////////////////////////////////////////////////////////////
// Address_map4 definition4
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c4 extends uvm_reg_block;

  rand spi_regfile4 spi_rf4;

  function void build();
    // Now4 define address mappings4
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf4 = spi_regfile4::type_id::create("spi_rf4", , get_full_name());
    spi_rf4.configure(this, "rf24");
    spi_rf4.build();
    spi_rf4.lock_model();
    default_map.add_submap(spi_rf4.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c4");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c4)
  function new(input string name="unnamed4-spi_reg_model_c4");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c4

`endif // SPI_RDB_SV4
