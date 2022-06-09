// This4 file is generated4 using Cadence4 iregGen4 version4 1.05

`ifndef UART_CTRL_REGS_SV4
`define UART_CTRL_REGS_SV4

// Input4 File4: uart_ctrl_regs4.xml4

// Number4 of AddrMaps4 = 1
// Number4 of RegFiles4 = 1
// Number4 of Registers4 = 6
// Number4 of Memories4 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 262


class ua_div_latch0_c4 extends uvm_reg;

  rand uvm_reg_field div_val4;

  constraint c_div_val4 { div_val4.value == 1; }
  virtual function void build();
    div_val4 = uvm_reg_field::type_id::create("div_val4");
    div_val4.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg4.set_inst_name($sformatf("%s.wcov4", get_full_name()));
    rd_cg4.set_inst_name($sformatf("%s.rcov4", get_full_name()));
  endfunction

  covergroup wr_cg4;
    option.per_instance=1;
    div_val4 : coverpoint div_val4.value[7:0];
  endgroup
  covergroup rd_cg4;
    option.per_instance=1;
    div_val4 : coverpoint div_val4.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg4.sample();
    if(is_read) rd_cg4.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c4, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c4, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c4)
  function new(input string name="unnamed4-ua_div_latch0_c4");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg4=new;
    rd_cg4=new;
  endfunction : new
endclass : ua_div_latch0_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 287


class ua_div_latch1_c4 extends uvm_reg;

  rand uvm_reg_field div_val4;

  constraint c_div_val4 { div_val4.value == 0; }
  virtual function void build();
    div_val4 = uvm_reg_field::type_id::create("div_val4");
    div_val4.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg4.set_inst_name($sformatf("%s.wcov4", get_full_name()));
    rd_cg4.set_inst_name($sformatf("%s.rcov4", get_full_name()));
  endfunction

  covergroup wr_cg4;
    option.per_instance=1;
    div_val4 : coverpoint div_val4.value[7:0];
  endgroup
  covergroup rd_cg4;
    option.per_instance=1;
    div_val4 : coverpoint div_val4.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg4.sample();
    if(is_read) rd_cg4.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c4, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c4, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c4)
  function new(input string name="unnamed4-ua_div_latch1_c4");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg4=new;
    rd_cg4=new;
  endfunction : new
endclass : ua_div_latch1_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 82


class ua_int_id_c4 extends uvm_reg;

  uvm_reg_field priority_bit4;
  uvm_reg_field bit14;
  uvm_reg_field bit24;
  uvm_reg_field bit34;

  virtual function void build();
    priority_bit4 = uvm_reg_field::type_id::create("priority_bit4");
    priority_bit4.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit14 = uvm_reg_field::type_id::create("bit14");
    bit14.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit24 = uvm_reg_field::type_id::create("bit24");
    bit24.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit34 = uvm_reg_field::type_id::create("bit34");
    bit34.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg4.set_inst_name($sformatf("%s.rcov4", get_full_name()));
  endfunction

  covergroup rd_cg4;
    option.per_instance=1;
    priority_bit4 : coverpoint priority_bit4.value[0:0];
    bit14 : coverpoint bit14.value[0:0];
    bit24 : coverpoint bit24.value[0:0];
    bit34 : coverpoint bit34.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg4.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c4, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c4, uvm_reg)
  `uvm_object_utils(ua_int_id_c4)
  function new(input string name="unnamed4-ua_int_id_c4");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg4=new;
  endfunction : new
endclass : ua_int_id_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 139


class ua_fifo_ctrl_c4 extends uvm_reg;

  rand uvm_reg_field rx_clear4;
  rand uvm_reg_field tx_clear4;
  rand uvm_reg_field rx_fifo_int_trig_level4;

  virtual function void build();
    rx_clear4 = uvm_reg_field::type_id::create("rx_clear4");
    rx_clear4.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear4 = uvm_reg_field::type_id::create("tx_clear4");
    tx_clear4.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level4 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level4");
    rx_fifo_int_trig_level4.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg4.set_inst_name($sformatf("%s.wcov4", get_full_name()));
  endfunction

  covergroup wr_cg4;
    option.per_instance=1;
    rx_clear4 : coverpoint rx_clear4.value[0:0];
    tx_clear4 : coverpoint tx_clear4.value[0:0];
    rx_fifo_int_trig_level4 : coverpoint rx_fifo_int_trig_level4.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg4.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c4, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c4, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c4)
  function new(input string name="unnamed4-ua_fifo_ctrl_c4");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg4=new;
  endfunction : new
endclass : ua_fifo_ctrl_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 188


class ua_lcr_c4 extends uvm_reg;

  rand uvm_reg_field char_lngth4;
  rand uvm_reg_field num_stop_bits4;
  rand uvm_reg_field p_en4;
  rand uvm_reg_field parity_even4;
  rand uvm_reg_field parity_sticky4;
  rand uvm_reg_field break_ctrl4;
  rand uvm_reg_field div_latch_access4;

  constraint c_char_lngth4 { char_lngth4.value != 2'b00; }
  constraint c_break_ctrl4 { break_ctrl4.value == 1'b0; }
  virtual function void build();
    char_lngth4 = uvm_reg_field::type_id::create("char_lngth4");
    char_lngth4.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits4 = uvm_reg_field::type_id::create("num_stop_bits4");
    num_stop_bits4.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en4 = uvm_reg_field::type_id::create("p_en4");
    p_en4.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even4 = uvm_reg_field::type_id::create("parity_even4");
    parity_even4.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky4 = uvm_reg_field::type_id::create("parity_sticky4");
    parity_sticky4.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl4 = uvm_reg_field::type_id::create("break_ctrl4");
    break_ctrl4.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access4 = uvm_reg_field::type_id::create("div_latch_access4");
    div_latch_access4.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg4.set_inst_name($sformatf("%s.wcov4", get_full_name()));
    rd_cg4.set_inst_name($sformatf("%s.rcov4", get_full_name()));
  endfunction

  covergroup wr_cg4;
    option.per_instance=1;
    char_lngth4 : coverpoint char_lngth4.value[1:0];
    num_stop_bits4 : coverpoint num_stop_bits4.value[0:0];
    p_en4 : coverpoint p_en4.value[0:0];
    parity_even4 : coverpoint parity_even4.value[0:0];
    parity_sticky4 : coverpoint parity_sticky4.value[0:0];
    break_ctrl4 : coverpoint break_ctrl4.value[0:0];
    div_latch_access4 : coverpoint div_latch_access4.value[0:0];
  endgroup
  covergroup rd_cg4;
    option.per_instance=1;
    char_lngth4 : coverpoint char_lngth4.value[1:0];
    num_stop_bits4 : coverpoint num_stop_bits4.value[0:0];
    p_en4 : coverpoint p_en4.value[0:0];
    parity_even4 : coverpoint parity_even4.value[0:0];
    parity_sticky4 : coverpoint parity_sticky4.value[0:0];
    break_ctrl4 : coverpoint break_ctrl4.value[0:0];
    div_latch_access4 : coverpoint div_latch_access4.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg4.sample();
    if(is_read) rd_cg4.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c4, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c4, uvm_reg)
  `uvm_object_utils(ua_lcr_c4)
  function new(input string name="unnamed4-ua_lcr_c4");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg4=new;
    rd_cg4=new;
  endfunction : new
endclass : ua_lcr_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 25


class ua_ier_c4 extends uvm_reg;

  rand uvm_reg_field rx_data4;
  rand uvm_reg_field tx_data4;
  rand uvm_reg_field rx_line_sts4;
  rand uvm_reg_field mdm_sts4;

  virtual function void build();
    rx_data4 = uvm_reg_field::type_id::create("rx_data4");
    rx_data4.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data4 = uvm_reg_field::type_id::create("tx_data4");
    tx_data4.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts4 = uvm_reg_field::type_id::create("rx_line_sts4");
    rx_line_sts4.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts4 = uvm_reg_field::type_id::create("mdm_sts4");
    mdm_sts4.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg4.set_inst_name($sformatf("%s.wcov4", get_full_name()));
    rd_cg4.set_inst_name($sformatf("%s.rcov4", get_full_name()));
  endfunction

  covergroup wr_cg4;
    option.per_instance=1;
    rx_data4 : coverpoint rx_data4.value[0:0];
    tx_data4 : coverpoint tx_data4.value[0:0];
    rx_line_sts4 : coverpoint rx_line_sts4.value[0:0];
    mdm_sts4 : coverpoint mdm_sts4.value[0:0];
  endgroup
  covergroup rd_cg4;
    option.per_instance=1;
    rx_data4 : coverpoint rx_data4.value[0:0];
    tx_data4 : coverpoint tx_data4.value[0:0];
    rx_line_sts4 : coverpoint rx_line_sts4.value[0:0];
    mdm_sts4 : coverpoint mdm_sts4.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg4.sample();
    if(is_read) rd_cg4.sample();
  endfunction

  `uvm_register_cb(ua_ier_c4, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c4, uvm_reg)
  `uvm_object_utils(ua_ier_c4)
  function new(input string name="unnamed4-ua_ier_c4");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg4=new;
    rd_cg4=new;
  endfunction : new
endclass : ua_ier_c4

class uart_ctrl_rf_c4 extends uvm_reg_block;

  rand ua_div_latch0_c4 ua_div_latch04;
  rand ua_div_latch1_c4 ua_div_latch14;
  rand ua_int_id_c4 ua_int_id4;
  rand ua_fifo_ctrl_c4 ua_fifo_ctrl4;
  rand ua_lcr_c4 ua_lcr4;
  rand ua_ier_c4 ua_ier4;

  virtual function void build();

    // Now4 create all registers

    ua_div_latch04 = ua_div_latch0_c4::type_id::create("ua_div_latch04", , get_full_name());
    ua_div_latch14 = ua_div_latch1_c4::type_id::create("ua_div_latch14", , get_full_name());
    ua_int_id4 = ua_int_id_c4::type_id::create("ua_int_id4", , get_full_name());
    ua_fifo_ctrl4 = ua_fifo_ctrl_c4::type_id::create("ua_fifo_ctrl4", , get_full_name());
    ua_lcr4 = ua_lcr_c4::type_id::create("ua_lcr4", , get_full_name());
    ua_ier4 = ua_ier_c4::type_id::create("ua_ier4", , get_full_name());

    // Now4 build the registers. Set parent and hdl_paths

    ua_div_latch04.configure(this, null, "dl4[7:0]");
    ua_div_latch04.build();
    ua_div_latch14.configure(this, null, "dl4[15;8]");
    ua_div_latch14.build();
    ua_int_id4.configure(this, null, "iir4");
    ua_int_id4.build();
    ua_fifo_ctrl4.configure(this, null, "fcr4");
    ua_fifo_ctrl4.build();
    ua_lcr4.configure(this, null, "lcr4");
    ua_lcr4.build();
    ua_ier4.configure(this, null, "ier4");
    ua_ier4.build();
    // Now4 define address mappings4
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch04, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch14, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id4, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl4, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr4, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier4, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c4)
  function new(input string name="unnamed4-uart_ctrl_rf4");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c4

//////////////////////////////////////////////////////////////////////////////
// Address_map4 definition4
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c4 extends uvm_reg_block;

  rand uart_ctrl_rf_c4 uart_ctrl_rf4;

  function void build();
    // Now4 define address mappings4
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf4 = uart_ctrl_rf_c4::type_id::create("uart_ctrl_rf4", , get_full_name());
    uart_ctrl_rf4.configure(this, "regs");
    uart_ctrl_rf4.build();
    uart_ctrl_rf4.lock_model();
    default_map.add_submap(uart_ctrl_rf4.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top4.uart_dut4");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c4)
  function new(input string name="unnamed4-uart_ctrl_reg_model_c4");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c4

`endif // UART_CTRL_REGS_SV4
