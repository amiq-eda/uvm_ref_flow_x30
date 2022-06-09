`ifndef SPI_RDB_SV7
`define SPI_RDB_SV7

// Input7 File7: spi_rgm7.spirit7

// Number7 of addrMaps7 = 1
// Number7 of regFiles7 = 1
// Number7 of registers = 3
// Number7 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 23


class spi_ctrl_c7 extends uvm_reg;

  rand uvm_reg_field char_len7;
  rand uvm_reg_field go_bsy7;
  rand uvm_reg_field rx_neg7;
  rand uvm_reg_field tx_neg7;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie7;
  rand uvm_reg_field ass7;

  constraint c_char_len7 { char_len7.value == 7'b0001000; }
  constraint c_tx_neg7 { tx_neg7.value == 1'b1; }
  constraint c_rx_neg7 { rx_neg7.value == 1'b1; }
  constraint c_lsb7 { lsb.value == 1'b1; }
  constraint c_ie7 { ie7.value == 1'b1; }
  constraint c_ass7 { ass7.value == 1'b1; }
  virtual function void build();
    char_len7 = uvm_reg_field::type_id::create("char_len7");
    char_len7.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy7 = uvm_reg_field::type_id::create("go_bsy7");
    go_bsy7.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg7 = uvm_reg_field::type_id::create("rx_neg7");
    rx_neg7.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg7 = uvm_reg_field::type_id::create("tx_neg7");
    tx_neg7.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie7 = uvm_reg_field::type_id::create("ie7");
    ie7.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass7 = uvm_reg_field::type_id::create("ass7");
    ass7.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint char_len7.value[6:0];
    coverpoint go_bsy7.value[0:0];
    coverpoint rx_neg7.value[0:0];
    coverpoint tx_neg7.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie7.value[0:0];
    coverpoint ass7.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c7, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c7, uvm_reg)
  `uvm_object_utils(spi_ctrl_c7)
  function new(input string name="unnamed7-spi_ctrl_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : spi_ctrl_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 99


class spi_divider_c7 extends uvm_reg;

  rand uvm_reg_field divider7;

  constraint c_divider7 { divider7.value == 16'b1; }
  virtual function void build();
    divider7 = uvm_reg_field::type_id::create("divider7");
    divider7.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint divider7.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(spi_divider_c7, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c7, uvm_reg)
  `uvm_object_utils(spi_divider_c7)
  function new(input string name="unnamed7-spi_divider_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : spi_divider_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 122


class spi_ss_c7 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss7 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg7;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg7.sample();
  endfunction

  `uvm_register_cb(spi_ss_c7, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c7, uvm_reg)
  `uvm_object_utils(spi_ss_c7)
  function new(input string name="unnamed7-spi_ss_c7");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg7=new;
  endfunction : new
endclass : spi_ss_c7

class spi_regfile7 extends uvm_reg_block;

  rand spi_ctrl_c7 spi_ctrl7;
  rand spi_divider_c7 spi_divider7;
  rand spi_ss_c7 spi_ss7;

  virtual function void build();

    // Now7 create all registers

    spi_ctrl7 = spi_ctrl_c7::type_id::create("spi_ctrl7", , get_full_name());
    spi_divider7 = spi_divider_c7::type_id::create("spi_divider7", , get_full_name());
    spi_ss7 = spi_ss_c7::type_id::create("spi_ss7", , get_full_name());

    // Now7 build the registers. Set parent and hdl_paths

    spi_ctrl7.configure(this, null, "spi_ctrl_reg7");
    spi_ctrl7.build();
    spi_divider7.configure(this, null, "spi_divider_reg7");
    spi_divider7.build();
    spi_ss7.configure(this, null, "spi_ss_reg7");
    spi_ss7.build();
    // Now7 define address mappings7
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl7, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider7, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss7, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile7)
  function new(input string name="unnamed7-spi_rf7");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile7

//////////////////////////////////////////////////////////////////////////////
// Address_map7 definition7
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c7 extends uvm_reg_block;

  rand spi_regfile7 spi_rf7;

  function void build();
    // Now7 define address mappings7
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf7 = spi_regfile7::type_id::create("spi_rf7", , get_full_name());
    spi_rf7.configure(this, "rf27");
    spi_rf7.build();
    spi_rf7.lock_model();
    default_map.add_submap(spi_rf7.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c7");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c7)
  function new(input string name="unnamed7-spi_reg_model_c7");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c7

`endif // SPI_RDB_SV7
