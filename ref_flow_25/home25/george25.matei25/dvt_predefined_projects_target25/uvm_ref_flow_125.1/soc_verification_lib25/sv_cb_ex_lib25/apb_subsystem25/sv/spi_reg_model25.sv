`ifndef SPI_RDB_SV25
`define SPI_RDB_SV25

// Input25 File25: spi_rgm25.spirit25

// Number25 of addrMaps25 = 1
// Number25 of regFiles25 = 1
// Number25 of registers = 3
// Number25 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 23


class spi_ctrl_c25 extends uvm_reg;

  rand uvm_reg_field char_len25;
  rand uvm_reg_field go_bsy25;
  rand uvm_reg_field rx_neg25;
  rand uvm_reg_field tx_neg25;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie25;
  rand uvm_reg_field ass25;

  constraint c_char_len25 { char_len25.value == 7'b0001000; }
  constraint c_tx_neg25 { tx_neg25.value == 1'b1; }
  constraint c_rx_neg25 { rx_neg25.value == 1'b1; }
  constraint c_lsb25 { lsb.value == 1'b1; }
  constraint c_ie25 { ie25.value == 1'b1; }
  constraint c_ass25 { ass25.value == 1'b1; }
  virtual function void build();
    char_len25 = uvm_reg_field::type_id::create("char_len25");
    char_len25.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy25 = uvm_reg_field::type_id::create("go_bsy25");
    go_bsy25.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg25 = uvm_reg_field::type_id::create("rx_neg25");
    rx_neg25.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg25 = uvm_reg_field::type_id::create("tx_neg25");
    tx_neg25.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie25 = uvm_reg_field::type_id::create("ie25");
    ie25.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass25 = uvm_reg_field::type_id::create("ass25");
    ass25.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint char_len25.value[6:0];
    coverpoint go_bsy25.value[0:0];
    coverpoint rx_neg25.value[0:0];
    coverpoint tx_neg25.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie25.value[0:0];
    coverpoint ass25.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c25, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c25, uvm_reg)
  `uvm_object_utils(spi_ctrl_c25)
  function new(input string name="unnamed25-spi_ctrl_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : spi_ctrl_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 99


class spi_divider_c25 extends uvm_reg;

  rand uvm_reg_field divider25;

  constraint c_divider25 { divider25.value == 16'b1; }
  virtual function void build();
    divider25 = uvm_reg_field::type_id::create("divider25");
    divider25.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint divider25.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(spi_divider_c25, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c25, uvm_reg)
  `uvm_object_utils(spi_divider_c25)
  function new(input string name="unnamed25-spi_divider_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : spi_divider_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 122


class spi_ss_c25 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss25 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(spi_ss_c25, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c25, uvm_reg)
  `uvm_object_utils(spi_ss_c25)
  function new(input string name="unnamed25-spi_ss_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : spi_ss_c25

class spi_regfile25 extends uvm_reg_block;

  rand spi_ctrl_c25 spi_ctrl25;
  rand spi_divider_c25 spi_divider25;
  rand spi_ss_c25 spi_ss25;

  virtual function void build();

    // Now25 create all registers

    spi_ctrl25 = spi_ctrl_c25::type_id::create("spi_ctrl25", , get_full_name());
    spi_divider25 = spi_divider_c25::type_id::create("spi_divider25", , get_full_name());
    spi_ss25 = spi_ss_c25::type_id::create("spi_ss25", , get_full_name());

    // Now25 build the registers. Set parent and hdl_paths

    spi_ctrl25.configure(this, null, "spi_ctrl_reg25");
    spi_ctrl25.build();
    spi_divider25.configure(this, null, "spi_divider_reg25");
    spi_divider25.build();
    spi_ss25.configure(this, null, "spi_ss_reg25");
    spi_ss25.build();
    // Now25 define address mappings25
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl25, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider25, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss25, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile25)
  function new(input string name="unnamed25-spi_rf25");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile25

//////////////////////////////////////////////////////////////////////////////
// Address_map25 definition25
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c25 extends uvm_reg_block;

  rand spi_regfile25 spi_rf25;

  function void build();
    // Now25 define address mappings25
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf25 = spi_regfile25::type_id::create("spi_rf25", , get_full_name());
    spi_rf25.configure(this, "rf225");
    spi_rf25.build();
    spi_rf25.lock_model();
    default_map.add_submap(spi_rf25.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c25");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c25)
  function new(input string name="unnamed25-spi_reg_model_c25");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c25

`endif // SPI_RDB_SV25
