`ifndef SPI_RDB_SV8
`define SPI_RDB_SV8

// Input8 File8: spi_rgm8.spirit8

// Number8 of addrMaps8 = 1
// Number8 of regFiles8 = 1
// Number8 of registers = 3
// Number8 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 23


class spi_ctrl_c8 extends uvm_reg;

  rand uvm_reg_field char_len8;
  rand uvm_reg_field go_bsy8;
  rand uvm_reg_field rx_neg8;
  rand uvm_reg_field tx_neg8;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie8;
  rand uvm_reg_field ass8;

  constraint c_char_len8 { char_len8.value == 7'b0001000; }
  constraint c_tx_neg8 { tx_neg8.value == 1'b1; }
  constraint c_rx_neg8 { rx_neg8.value == 1'b1; }
  constraint c_lsb8 { lsb.value == 1'b1; }
  constraint c_ie8 { ie8.value == 1'b1; }
  constraint c_ass8 { ass8.value == 1'b1; }
  virtual function void build();
    char_len8 = uvm_reg_field::type_id::create("char_len8");
    char_len8.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy8 = uvm_reg_field::type_id::create("go_bsy8");
    go_bsy8.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg8 = uvm_reg_field::type_id::create("rx_neg8");
    rx_neg8.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg8 = uvm_reg_field::type_id::create("tx_neg8");
    tx_neg8.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie8 = uvm_reg_field::type_id::create("ie8");
    ie8.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass8 = uvm_reg_field::type_id::create("ass8");
    ass8.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint char_len8.value[6:0];
    coverpoint go_bsy8.value[0:0];
    coverpoint rx_neg8.value[0:0];
    coverpoint tx_neg8.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie8.value[0:0];
    coverpoint ass8.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c8, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c8, uvm_reg)
  `uvm_object_utils(spi_ctrl_c8)
  function new(input string name="unnamed8-spi_ctrl_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : spi_ctrl_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 99


class spi_divider_c8 extends uvm_reg;

  rand uvm_reg_field divider8;

  constraint c_divider8 { divider8.value == 16'b1; }
  virtual function void build();
    divider8 = uvm_reg_field::type_id::create("divider8");
    divider8.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint divider8.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(spi_divider_c8, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c8, uvm_reg)
  `uvm_object_utils(spi_divider_c8)
  function new(input string name="unnamed8-spi_divider_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : spi_divider_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 122


class spi_ss_c8 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss8 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg8;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg8.sample();
  endfunction

  `uvm_register_cb(spi_ss_c8, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c8, uvm_reg)
  `uvm_object_utils(spi_ss_c8)
  function new(input string name="unnamed8-spi_ss_c8");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg8=new;
  endfunction : new
endclass : spi_ss_c8

class spi_regfile8 extends uvm_reg_block;

  rand spi_ctrl_c8 spi_ctrl8;
  rand spi_divider_c8 spi_divider8;
  rand spi_ss_c8 spi_ss8;

  virtual function void build();

    // Now8 create all registers

    spi_ctrl8 = spi_ctrl_c8::type_id::create("spi_ctrl8", , get_full_name());
    spi_divider8 = spi_divider_c8::type_id::create("spi_divider8", , get_full_name());
    spi_ss8 = spi_ss_c8::type_id::create("spi_ss8", , get_full_name());

    // Now8 build the registers. Set parent and hdl_paths

    spi_ctrl8.configure(this, null, "spi_ctrl_reg8");
    spi_ctrl8.build();
    spi_divider8.configure(this, null, "spi_divider_reg8");
    spi_divider8.build();
    spi_ss8.configure(this, null, "spi_ss_reg8");
    spi_ss8.build();
    // Now8 define address mappings8
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl8, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider8, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss8, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile8)
  function new(input string name="unnamed8-spi_rf8");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile8

//////////////////////////////////////////////////////////////////////////////
// Address_map8 definition8
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c8 extends uvm_reg_block;

  rand spi_regfile8 spi_rf8;

  function void build();
    // Now8 define address mappings8
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf8 = spi_regfile8::type_id::create("spi_rf8", , get_full_name());
    spi_rf8.configure(this, "rf28");
    spi_rf8.build();
    spi_rf8.lock_model();
    default_map.add_submap(spi_rf8.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c8");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c8)
  function new(input string name="unnamed8-spi_reg_model_c8");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c8

`endif // SPI_RDB_SV8
