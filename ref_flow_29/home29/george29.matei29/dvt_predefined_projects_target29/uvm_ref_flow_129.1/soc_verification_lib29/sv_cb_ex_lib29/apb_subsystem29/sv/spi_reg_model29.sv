`ifndef SPI_RDB_SV29
`define SPI_RDB_SV29

// Input29 File29: spi_rgm29.spirit29

// Number29 of addrMaps29 = 1
// Number29 of regFiles29 = 1
// Number29 of registers = 3
// Number29 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 23


class spi_ctrl_c29 extends uvm_reg;

  rand uvm_reg_field char_len29;
  rand uvm_reg_field go_bsy29;
  rand uvm_reg_field rx_neg29;
  rand uvm_reg_field tx_neg29;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie29;
  rand uvm_reg_field ass29;

  constraint c_char_len29 { char_len29.value == 7'b0001000; }
  constraint c_tx_neg29 { tx_neg29.value == 1'b1; }
  constraint c_rx_neg29 { rx_neg29.value == 1'b1; }
  constraint c_lsb29 { lsb.value == 1'b1; }
  constraint c_ie29 { ie29.value == 1'b1; }
  constraint c_ass29 { ass29.value == 1'b1; }
  virtual function void build();
    char_len29 = uvm_reg_field::type_id::create("char_len29");
    char_len29.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy29 = uvm_reg_field::type_id::create("go_bsy29");
    go_bsy29.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg29 = uvm_reg_field::type_id::create("rx_neg29");
    rx_neg29.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg29 = uvm_reg_field::type_id::create("tx_neg29");
    tx_neg29.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie29 = uvm_reg_field::type_id::create("ie29");
    ie29.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass29 = uvm_reg_field::type_id::create("ass29");
    ass29.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint char_len29.value[6:0];
    coverpoint go_bsy29.value[0:0];
    coverpoint rx_neg29.value[0:0];
    coverpoint tx_neg29.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie29.value[0:0];
    coverpoint ass29.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c29, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c29, uvm_reg)
  `uvm_object_utils(spi_ctrl_c29)
  function new(input string name="unnamed29-spi_ctrl_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : spi_ctrl_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 99


class spi_divider_c29 extends uvm_reg;

  rand uvm_reg_field divider29;

  constraint c_divider29 { divider29.value == 16'b1; }
  virtual function void build();
    divider29 = uvm_reg_field::type_id::create("divider29");
    divider29.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint divider29.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(spi_divider_c29, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c29, uvm_reg)
  `uvm_object_utils(spi_divider_c29)
  function new(input string name="unnamed29-spi_divider_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : spi_divider_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 122


class spi_ss_c29 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss29 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(spi_ss_c29, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c29, uvm_reg)
  `uvm_object_utils(spi_ss_c29)
  function new(input string name="unnamed29-spi_ss_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : spi_ss_c29

class spi_regfile29 extends uvm_reg_block;

  rand spi_ctrl_c29 spi_ctrl29;
  rand spi_divider_c29 spi_divider29;
  rand spi_ss_c29 spi_ss29;

  virtual function void build();

    // Now29 create all registers

    spi_ctrl29 = spi_ctrl_c29::type_id::create("spi_ctrl29", , get_full_name());
    spi_divider29 = spi_divider_c29::type_id::create("spi_divider29", , get_full_name());
    spi_ss29 = spi_ss_c29::type_id::create("spi_ss29", , get_full_name());

    // Now29 build the registers. Set parent and hdl_paths

    spi_ctrl29.configure(this, null, "spi_ctrl_reg29");
    spi_ctrl29.build();
    spi_divider29.configure(this, null, "spi_divider_reg29");
    spi_divider29.build();
    spi_ss29.configure(this, null, "spi_ss_reg29");
    spi_ss29.build();
    // Now29 define address mappings29
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl29, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider29, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss29, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile29)
  function new(input string name="unnamed29-spi_rf29");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile29

//////////////////////////////////////////////////////////////////////////////
// Address_map29 definition29
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c29 extends uvm_reg_block;

  rand spi_regfile29 spi_rf29;

  function void build();
    // Now29 define address mappings29
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf29 = spi_regfile29::type_id::create("spi_rf29", , get_full_name());
    spi_rf29.configure(this, "rf229");
    spi_rf29.build();
    spi_rf29.lock_model();
    default_map.add_submap(spi_rf29.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c29");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c29)
  function new(input string name="unnamed29-spi_reg_model_c29");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c29

`endif // SPI_RDB_SV29
