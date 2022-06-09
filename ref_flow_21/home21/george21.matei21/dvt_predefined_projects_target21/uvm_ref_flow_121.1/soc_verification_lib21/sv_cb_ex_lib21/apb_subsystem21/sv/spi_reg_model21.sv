`ifndef SPI_RDB_SV21
`define SPI_RDB_SV21

// Input21 File21: spi_rgm21.spirit21

// Number21 of addrMaps21 = 1
// Number21 of regFiles21 = 1
// Number21 of registers = 3
// Number21 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 23


class spi_ctrl_c21 extends uvm_reg;

  rand uvm_reg_field char_len21;
  rand uvm_reg_field go_bsy21;
  rand uvm_reg_field rx_neg21;
  rand uvm_reg_field tx_neg21;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie21;
  rand uvm_reg_field ass21;

  constraint c_char_len21 { char_len21.value == 7'b0001000; }
  constraint c_tx_neg21 { tx_neg21.value == 1'b1; }
  constraint c_rx_neg21 { rx_neg21.value == 1'b1; }
  constraint c_lsb21 { lsb.value == 1'b1; }
  constraint c_ie21 { ie21.value == 1'b1; }
  constraint c_ass21 { ass21.value == 1'b1; }
  virtual function void build();
    char_len21 = uvm_reg_field::type_id::create("char_len21");
    char_len21.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy21 = uvm_reg_field::type_id::create("go_bsy21");
    go_bsy21.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg21 = uvm_reg_field::type_id::create("rx_neg21");
    rx_neg21.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg21 = uvm_reg_field::type_id::create("tx_neg21");
    tx_neg21.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie21 = uvm_reg_field::type_id::create("ie21");
    ie21.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass21 = uvm_reg_field::type_id::create("ass21");
    ass21.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint char_len21.value[6:0];
    coverpoint go_bsy21.value[0:0];
    coverpoint rx_neg21.value[0:0];
    coverpoint tx_neg21.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie21.value[0:0];
    coverpoint ass21.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c21, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c21, uvm_reg)
  `uvm_object_utils(spi_ctrl_c21)
  function new(input string name="unnamed21-spi_ctrl_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : spi_ctrl_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 99


class spi_divider_c21 extends uvm_reg;

  rand uvm_reg_field divider21;

  constraint c_divider21 { divider21.value == 16'b1; }
  virtual function void build();
    divider21 = uvm_reg_field::type_id::create("divider21");
    divider21.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint divider21.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(spi_divider_c21, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c21, uvm_reg)
  `uvm_object_utils(spi_divider_c21)
  function new(input string name="unnamed21-spi_divider_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : spi_divider_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 122


class spi_ss_c21 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss21 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg21;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg21.sample();
  endfunction

  `uvm_register_cb(spi_ss_c21, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c21, uvm_reg)
  `uvm_object_utils(spi_ss_c21)
  function new(input string name="unnamed21-spi_ss_c21");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg21=new;
  endfunction : new
endclass : spi_ss_c21

class spi_regfile21 extends uvm_reg_block;

  rand spi_ctrl_c21 spi_ctrl21;
  rand spi_divider_c21 spi_divider21;
  rand spi_ss_c21 spi_ss21;

  virtual function void build();

    // Now21 create all registers

    spi_ctrl21 = spi_ctrl_c21::type_id::create("spi_ctrl21", , get_full_name());
    spi_divider21 = spi_divider_c21::type_id::create("spi_divider21", , get_full_name());
    spi_ss21 = spi_ss_c21::type_id::create("spi_ss21", , get_full_name());

    // Now21 build the registers. Set parent and hdl_paths

    spi_ctrl21.configure(this, null, "spi_ctrl_reg21");
    spi_ctrl21.build();
    spi_divider21.configure(this, null, "spi_divider_reg21");
    spi_divider21.build();
    spi_ss21.configure(this, null, "spi_ss_reg21");
    spi_ss21.build();
    // Now21 define address mappings21
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl21, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider21, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss21, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile21)
  function new(input string name="unnamed21-spi_rf21");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile21

//////////////////////////////////////////////////////////////////////////////
// Address_map21 definition21
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c21 extends uvm_reg_block;

  rand spi_regfile21 spi_rf21;

  function void build();
    // Now21 define address mappings21
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf21 = spi_regfile21::type_id::create("spi_rf21", , get_full_name());
    spi_rf21.configure(this, "rf221");
    spi_rf21.build();
    spi_rf21.lock_model();
    default_map.add_submap(spi_rf21.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c21");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c21)
  function new(input string name="unnamed21-spi_reg_model_c21");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c21

`endif // SPI_RDB_SV21
