`ifndef SPI_RDB_SV30
`define SPI_RDB_SV30

// Input30 File30: spi_rgm30.spirit30

// Number30 of addrMaps30 = 1
// Number30 of regFiles30 = 1
// Number30 of registers = 3
// Number30 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 23


class spi_ctrl_c30 extends uvm_reg;

  rand uvm_reg_field char_len30;
  rand uvm_reg_field go_bsy30;
  rand uvm_reg_field rx_neg30;
  rand uvm_reg_field tx_neg30;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie30;
  rand uvm_reg_field ass30;

  constraint c_char_len30 { char_len30.value == 7'b0001000; }
  constraint c_tx_neg30 { tx_neg30.value == 1'b1; }
  constraint c_rx_neg30 { rx_neg30.value == 1'b1; }
  constraint c_lsb30 { lsb.value == 1'b1; }
  constraint c_ie30 { ie30.value == 1'b1; }
  constraint c_ass30 { ass30.value == 1'b1; }
  virtual function void build();
    char_len30 = uvm_reg_field::type_id::create("char_len30");
    char_len30.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy30 = uvm_reg_field::type_id::create("go_bsy30");
    go_bsy30.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg30 = uvm_reg_field::type_id::create("rx_neg30");
    rx_neg30.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg30 = uvm_reg_field::type_id::create("tx_neg30");
    tx_neg30.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie30 = uvm_reg_field::type_id::create("ie30");
    ie30.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass30 = uvm_reg_field::type_id::create("ass30");
    ass30.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint char_len30.value[6:0];
    coverpoint go_bsy30.value[0:0];
    coverpoint rx_neg30.value[0:0];
    coverpoint tx_neg30.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie30.value[0:0];
    coverpoint ass30.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c30, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c30, uvm_reg)
  `uvm_object_utils(spi_ctrl_c30)
  function new(input string name="unnamed30-spi_ctrl_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : spi_ctrl_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 99


class spi_divider_c30 extends uvm_reg;

  rand uvm_reg_field divider30;

  constraint c_divider30 { divider30.value == 16'b1; }
  virtual function void build();
    divider30 = uvm_reg_field::type_id::create("divider30");
    divider30.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint divider30.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(spi_divider_c30, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c30, uvm_reg)
  `uvm_object_utils(spi_divider_c30)
  function new(input string name="unnamed30-spi_divider_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : spi_divider_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 122


class spi_ss_c30 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss30 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg30;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg30.sample();
  endfunction

  `uvm_register_cb(spi_ss_c30, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c30, uvm_reg)
  `uvm_object_utils(spi_ss_c30)
  function new(input string name="unnamed30-spi_ss_c30");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg30=new;
  endfunction : new
endclass : spi_ss_c30

class spi_regfile30 extends uvm_reg_block;

  rand spi_ctrl_c30 spi_ctrl30;
  rand spi_divider_c30 spi_divider30;
  rand spi_ss_c30 spi_ss30;

  virtual function void build();

    // Now30 create all registers

    spi_ctrl30 = spi_ctrl_c30::type_id::create("spi_ctrl30", , get_full_name());
    spi_divider30 = spi_divider_c30::type_id::create("spi_divider30", , get_full_name());
    spi_ss30 = spi_ss_c30::type_id::create("spi_ss30", , get_full_name());

    // Now30 build the registers. Set parent and hdl_paths

    spi_ctrl30.configure(this, null, "spi_ctrl_reg30");
    spi_ctrl30.build();
    spi_divider30.configure(this, null, "spi_divider_reg30");
    spi_divider30.build();
    spi_ss30.configure(this, null, "spi_ss_reg30");
    spi_ss30.build();
    // Now30 define address mappings30
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl30, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider30, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss30, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile30)
  function new(input string name="unnamed30-spi_rf30");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile30

//////////////////////////////////////////////////////////////////////////////
// Address_map30 definition30
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c30 extends uvm_reg_block;

  rand spi_regfile30 spi_rf30;

  function void build();
    // Now30 define address mappings30
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf30 = spi_regfile30::type_id::create("spi_rf30", , get_full_name());
    spi_rf30.configure(this, "rf230");
    spi_rf30.build();
    spi_rf30.lock_model();
    default_map.add_submap(spi_rf30.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c30");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c30)
  function new(input string name="unnamed30-spi_reg_model_c30");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c30

`endif // SPI_RDB_SV30
