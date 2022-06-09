`ifndef SPI_RDB_SV23
`define SPI_RDB_SV23

// Input23 File23: spi_rgm23.spirit23

// Number23 of addrMaps23 = 1
// Number23 of regFiles23 = 1
// Number23 of registers = 3
// Number23 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 23


class spi_ctrl_c23 extends uvm_reg;

  rand uvm_reg_field char_len23;
  rand uvm_reg_field go_bsy23;
  rand uvm_reg_field rx_neg23;
  rand uvm_reg_field tx_neg23;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie23;
  rand uvm_reg_field ass23;

  constraint c_char_len23 { char_len23.value == 7'b0001000; }
  constraint c_tx_neg23 { tx_neg23.value == 1'b1; }
  constraint c_rx_neg23 { rx_neg23.value == 1'b1; }
  constraint c_lsb23 { lsb.value == 1'b1; }
  constraint c_ie23 { ie23.value == 1'b1; }
  constraint c_ass23 { ass23.value == 1'b1; }
  virtual function void build();
    char_len23 = uvm_reg_field::type_id::create("char_len23");
    char_len23.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy23 = uvm_reg_field::type_id::create("go_bsy23");
    go_bsy23.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg23 = uvm_reg_field::type_id::create("rx_neg23");
    rx_neg23.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg23 = uvm_reg_field::type_id::create("tx_neg23");
    tx_neg23.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie23 = uvm_reg_field::type_id::create("ie23");
    ie23.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass23 = uvm_reg_field::type_id::create("ass23");
    ass23.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint char_len23.value[6:0];
    coverpoint go_bsy23.value[0:0];
    coverpoint rx_neg23.value[0:0];
    coverpoint tx_neg23.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie23.value[0:0];
    coverpoint ass23.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c23, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c23, uvm_reg)
  `uvm_object_utils(spi_ctrl_c23)
  function new(input string name="unnamed23-spi_ctrl_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : spi_ctrl_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 99


class spi_divider_c23 extends uvm_reg;

  rand uvm_reg_field divider23;

  constraint c_divider23 { divider23.value == 16'b1; }
  virtual function void build();
    divider23 = uvm_reg_field::type_id::create("divider23");
    divider23.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint divider23.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(spi_divider_c23, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c23, uvm_reg)
  `uvm_object_utils(spi_divider_c23)
  function new(input string name="unnamed23-spi_divider_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : spi_divider_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 122


class spi_ss_c23 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss23 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(spi_ss_c23, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c23, uvm_reg)
  `uvm_object_utils(spi_ss_c23)
  function new(input string name="unnamed23-spi_ss_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : spi_ss_c23

class spi_regfile23 extends uvm_reg_block;

  rand spi_ctrl_c23 spi_ctrl23;
  rand spi_divider_c23 spi_divider23;
  rand spi_ss_c23 spi_ss23;

  virtual function void build();

    // Now23 create all registers

    spi_ctrl23 = spi_ctrl_c23::type_id::create("spi_ctrl23", , get_full_name());
    spi_divider23 = spi_divider_c23::type_id::create("spi_divider23", , get_full_name());
    spi_ss23 = spi_ss_c23::type_id::create("spi_ss23", , get_full_name());

    // Now23 build the registers. Set parent and hdl_paths

    spi_ctrl23.configure(this, null, "spi_ctrl_reg23");
    spi_ctrl23.build();
    spi_divider23.configure(this, null, "spi_divider_reg23");
    spi_divider23.build();
    spi_ss23.configure(this, null, "spi_ss_reg23");
    spi_ss23.build();
    // Now23 define address mappings23
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl23, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider23, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss23, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile23)
  function new(input string name="unnamed23-spi_rf23");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile23

//////////////////////////////////////////////////////////////////////////////
// Address_map23 definition23
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c23 extends uvm_reg_block;

  rand spi_regfile23 spi_rf23;

  function void build();
    // Now23 define address mappings23
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf23 = spi_regfile23::type_id::create("spi_rf23", , get_full_name());
    spi_rf23.configure(this, "rf223");
    spi_rf23.build();
    spi_rf23.lock_model();
    default_map.add_submap(spi_rf23.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c23");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c23)
  function new(input string name="unnamed23-spi_reg_model_c23");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c23

`endif // SPI_RDB_SV23
