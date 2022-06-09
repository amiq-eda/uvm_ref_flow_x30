`ifndef SPI_RDB_SV19
`define SPI_RDB_SV19

// Input19 File19: spi_rgm19.spirit19

// Number19 of addrMaps19 = 1
// Number19 of regFiles19 = 1
// Number19 of registers = 3
// Number19 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 23


class spi_ctrl_c19 extends uvm_reg;

  rand uvm_reg_field char_len19;
  rand uvm_reg_field go_bsy19;
  rand uvm_reg_field rx_neg19;
  rand uvm_reg_field tx_neg19;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie19;
  rand uvm_reg_field ass19;

  constraint c_char_len19 { char_len19.value == 7'b0001000; }
  constraint c_tx_neg19 { tx_neg19.value == 1'b1; }
  constraint c_rx_neg19 { rx_neg19.value == 1'b1; }
  constraint c_lsb19 { lsb.value == 1'b1; }
  constraint c_ie19 { ie19.value == 1'b1; }
  constraint c_ass19 { ass19.value == 1'b1; }
  virtual function void build();
    char_len19 = uvm_reg_field::type_id::create("char_len19");
    char_len19.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy19 = uvm_reg_field::type_id::create("go_bsy19");
    go_bsy19.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg19 = uvm_reg_field::type_id::create("rx_neg19");
    rx_neg19.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg19 = uvm_reg_field::type_id::create("tx_neg19");
    tx_neg19.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie19 = uvm_reg_field::type_id::create("ie19");
    ie19.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass19 = uvm_reg_field::type_id::create("ass19");
    ass19.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint char_len19.value[6:0];
    coverpoint go_bsy19.value[0:0];
    coverpoint rx_neg19.value[0:0];
    coverpoint tx_neg19.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie19.value[0:0];
    coverpoint ass19.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c19, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c19, uvm_reg)
  `uvm_object_utils(spi_ctrl_c19)
  function new(input string name="unnamed19-spi_ctrl_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : spi_ctrl_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 99


class spi_divider_c19 extends uvm_reg;

  rand uvm_reg_field divider19;

  constraint c_divider19 { divider19.value == 16'b1; }
  virtual function void build();
    divider19 = uvm_reg_field::type_id::create("divider19");
    divider19.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint divider19.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(spi_divider_c19, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c19, uvm_reg)
  `uvm_object_utils(spi_divider_c19)
  function new(input string name="unnamed19-spi_divider_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : spi_divider_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 122


class spi_ss_c19 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss19 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg19;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg19.sample();
  endfunction

  `uvm_register_cb(spi_ss_c19, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c19, uvm_reg)
  `uvm_object_utils(spi_ss_c19)
  function new(input string name="unnamed19-spi_ss_c19");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg19=new;
  endfunction : new
endclass : spi_ss_c19

class spi_regfile19 extends uvm_reg_block;

  rand spi_ctrl_c19 spi_ctrl19;
  rand spi_divider_c19 spi_divider19;
  rand spi_ss_c19 spi_ss19;

  virtual function void build();

    // Now19 create all registers

    spi_ctrl19 = spi_ctrl_c19::type_id::create("spi_ctrl19", , get_full_name());
    spi_divider19 = spi_divider_c19::type_id::create("spi_divider19", , get_full_name());
    spi_ss19 = spi_ss_c19::type_id::create("spi_ss19", , get_full_name());

    // Now19 build the registers. Set parent and hdl_paths

    spi_ctrl19.configure(this, null, "spi_ctrl_reg19");
    spi_ctrl19.build();
    spi_divider19.configure(this, null, "spi_divider_reg19");
    spi_divider19.build();
    spi_ss19.configure(this, null, "spi_ss_reg19");
    spi_ss19.build();
    // Now19 define address mappings19
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl19, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider19, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss19, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile19)
  function new(input string name="unnamed19-spi_rf19");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile19

//////////////////////////////////////////////////////////////////////////////
// Address_map19 definition19
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c19 extends uvm_reg_block;

  rand spi_regfile19 spi_rf19;

  function void build();
    // Now19 define address mappings19
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf19 = spi_regfile19::type_id::create("spi_rf19", , get_full_name());
    spi_rf19.configure(this, "rf219");
    spi_rf19.build();
    spi_rf19.lock_model();
    default_map.add_submap(spi_rf19.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c19");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c19)
  function new(input string name="unnamed19-spi_reg_model_c19");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c19

`endif // SPI_RDB_SV19
