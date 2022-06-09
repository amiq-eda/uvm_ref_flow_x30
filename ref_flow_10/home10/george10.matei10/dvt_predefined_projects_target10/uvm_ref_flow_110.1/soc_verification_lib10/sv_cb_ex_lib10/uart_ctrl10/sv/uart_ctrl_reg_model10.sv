// This10 file is generated10 using Cadence10 iregGen10 version10 1.05

`ifndef UART_CTRL_REGS_SV10
`define UART_CTRL_REGS_SV10

// Input10 File10: uart_ctrl_regs10.xml10

// Number10 of AddrMaps10 = 1
// Number10 of RegFiles10 = 1
// Number10 of Registers10 = 6
// Number10 of Memories10 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 262


class ua_div_latch0_c10 extends uvm_reg;

  rand uvm_reg_field div_val10;

  constraint c_div_val10 { div_val10.value == 1; }
  virtual function void build();
    div_val10 = uvm_reg_field::type_id::create("div_val10");
    div_val10.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg10.set_inst_name($sformatf("%s.wcov10", get_full_name()));
    rd_cg10.set_inst_name($sformatf("%s.rcov10", get_full_name()));
  endfunction

  covergroup wr_cg10;
    option.per_instance=1;
    div_val10 : coverpoint div_val10.value[7:0];
  endgroup
  covergroup rd_cg10;
    option.per_instance=1;
    div_val10 : coverpoint div_val10.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg10.sample();
    if(is_read) rd_cg10.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c10, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c10, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c10)
  function new(input string name="unnamed10-ua_div_latch0_c10");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg10=new;
    rd_cg10=new;
  endfunction : new
endclass : ua_div_latch0_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 287


class ua_div_latch1_c10 extends uvm_reg;

  rand uvm_reg_field div_val10;

  constraint c_div_val10 { div_val10.value == 0; }
  virtual function void build();
    div_val10 = uvm_reg_field::type_id::create("div_val10");
    div_val10.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg10.set_inst_name($sformatf("%s.wcov10", get_full_name()));
    rd_cg10.set_inst_name($sformatf("%s.rcov10", get_full_name()));
  endfunction

  covergroup wr_cg10;
    option.per_instance=1;
    div_val10 : coverpoint div_val10.value[7:0];
  endgroup
  covergroup rd_cg10;
    option.per_instance=1;
    div_val10 : coverpoint div_val10.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg10.sample();
    if(is_read) rd_cg10.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c10, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c10, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c10)
  function new(input string name="unnamed10-ua_div_latch1_c10");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg10=new;
    rd_cg10=new;
  endfunction : new
endclass : ua_div_latch1_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 82


class ua_int_id_c10 extends uvm_reg;

  uvm_reg_field priority_bit10;
  uvm_reg_field bit110;
  uvm_reg_field bit210;
  uvm_reg_field bit310;

  virtual function void build();
    priority_bit10 = uvm_reg_field::type_id::create("priority_bit10");
    priority_bit10.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit110 = uvm_reg_field::type_id::create("bit110");
    bit110.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit210 = uvm_reg_field::type_id::create("bit210");
    bit210.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit310 = uvm_reg_field::type_id::create("bit310");
    bit310.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg10.set_inst_name($sformatf("%s.rcov10", get_full_name()));
  endfunction

  covergroup rd_cg10;
    option.per_instance=1;
    priority_bit10 : coverpoint priority_bit10.value[0:0];
    bit110 : coverpoint bit110.value[0:0];
    bit210 : coverpoint bit210.value[0:0];
    bit310 : coverpoint bit310.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg10.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c10, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c10, uvm_reg)
  `uvm_object_utils(ua_int_id_c10)
  function new(input string name="unnamed10-ua_int_id_c10");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg10=new;
  endfunction : new
endclass : ua_int_id_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 139


class ua_fifo_ctrl_c10 extends uvm_reg;

  rand uvm_reg_field rx_clear10;
  rand uvm_reg_field tx_clear10;
  rand uvm_reg_field rx_fifo_int_trig_level10;

  virtual function void build();
    rx_clear10 = uvm_reg_field::type_id::create("rx_clear10");
    rx_clear10.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear10 = uvm_reg_field::type_id::create("tx_clear10");
    tx_clear10.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level10 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level10");
    rx_fifo_int_trig_level10.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg10.set_inst_name($sformatf("%s.wcov10", get_full_name()));
  endfunction

  covergroup wr_cg10;
    option.per_instance=1;
    rx_clear10 : coverpoint rx_clear10.value[0:0];
    tx_clear10 : coverpoint tx_clear10.value[0:0];
    rx_fifo_int_trig_level10 : coverpoint rx_fifo_int_trig_level10.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg10.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c10, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c10, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c10)
  function new(input string name="unnamed10-ua_fifo_ctrl_c10");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg10=new;
  endfunction : new
endclass : ua_fifo_ctrl_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 188


class ua_lcr_c10 extends uvm_reg;

  rand uvm_reg_field char_lngth10;
  rand uvm_reg_field num_stop_bits10;
  rand uvm_reg_field p_en10;
  rand uvm_reg_field parity_even10;
  rand uvm_reg_field parity_sticky10;
  rand uvm_reg_field break_ctrl10;
  rand uvm_reg_field div_latch_access10;

  constraint c_char_lngth10 { char_lngth10.value != 2'b00; }
  constraint c_break_ctrl10 { break_ctrl10.value == 1'b0; }
  virtual function void build();
    char_lngth10 = uvm_reg_field::type_id::create("char_lngth10");
    char_lngth10.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits10 = uvm_reg_field::type_id::create("num_stop_bits10");
    num_stop_bits10.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en10 = uvm_reg_field::type_id::create("p_en10");
    p_en10.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even10 = uvm_reg_field::type_id::create("parity_even10");
    parity_even10.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky10 = uvm_reg_field::type_id::create("parity_sticky10");
    parity_sticky10.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl10 = uvm_reg_field::type_id::create("break_ctrl10");
    break_ctrl10.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access10 = uvm_reg_field::type_id::create("div_latch_access10");
    div_latch_access10.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg10.set_inst_name($sformatf("%s.wcov10", get_full_name()));
    rd_cg10.set_inst_name($sformatf("%s.rcov10", get_full_name()));
  endfunction

  covergroup wr_cg10;
    option.per_instance=1;
    char_lngth10 : coverpoint char_lngth10.value[1:0];
    num_stop_bits10 : coverpoint num_stop_bits10.value[0:0];
    p_en10 : coverpoint p_en10.value[0:0];
    parity_even10 : coverpoint parity_even10.value[0:0];
    parity_sticky10 : coverpoint parity_sticky10.value[0:0];
    break_ctrl10 : coverpoint break_ctrl10.value[0:0];
    div_latch_access10 : coverpoint div_latch_access10.value[0:0];
  endgroup
  covergroup rd_cg10;
    option.per_instance=1;
    char_lngth10 : coverpoint char_lngth10.value[1:0];
    num_stop_bits10 : coverpoint num_stop_bits10.value[0:0];
    p_en10 : coverpoint p_en10.value[0:0];
    parity_even10 : coverpoint parity_even10.value[0:0];
    parity_sticky10 : coverpoint parity_sticky10.value[0:0];
    break_ctrl10 : coverpoint break_ctrl10.value[0:0];
    div_latch_access10 : coverpoint div_latch_access10.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg10.sample();
    if(is_read) rd_cg10.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c10, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c10, uvm_reg)
  `uvm_object_utils(ua_lcr_c10)
  function new(input string name="unnamed10-ua_lcr_c10");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg10=new;
    rd_cg10=new;
  endfunction : new
endclass : ua_lcr_c10

//////////////////////////////////////////////////////////////////////////////
// Register definition10
//////////////////////////////////////////////////////////////////////////////
// Line10 Number10: 25


class ua_ier_c10 extends uvm_reg;

  rand uvm_reg_field rx_data10;
  rand uvm_reg_field tx_data10;
  rand uvm_reg_field rx_line_sts10;
  rand uvm_reg_field mdm_sts10;

  virtual function void build();
    rx_data10 = uvm_reg_field::type_id::create("rx_data10");
    rx_data10.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data10 = uvm_reg_field::type_id::create("tx_data10");
    tx_data10.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts10 = uvm_reg_field::type_id::create("rx_line_sts10");
    rx_line_sts10.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts10 = uvm_reg_field::type_id::create("mdm_sts10");
    mdm_sts10.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg10.set_inst_name($sformatf("%s.wcov10", get_full_name()));
    rd_cg10.set_inst_name($sformatf("%s.rcov10", get_full_name()));
  endfunction

  covergroup wr_cg10;
    option.per_instance=1;
    rx_data10 : coverpoint rx_data10.value[0:0];
    tx_data10 : coverpoint tx_data10.value[0:0];
    rx_line_sts10 : coverpoint rx_line_sts10.value[0:0];
    mdm_sts10 : coverpoint mdm_sts10.value[0:0];
  endgroup
  covergroup rd_cg10;
    option.per_instance=1;
    rx_data10 : coverpoint rx_data10.value[0:0];
    tx_data10 : coverpoint tx_data10.value[0:0];
    rx_line_sts10 : coverpoint rx_line_sts10.value[0:0];
    mdm_sts10 : coverpoint mdm_sts10.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg10.sample();
    if(is_read) rd_cg10.sample();
  endfunction

  `uvm_register_cb(ua_ier_c10, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c10, uvm_reg)
  `uvm_object_utils(ua_ier_c10)
  function new(input string name="unnamed10-ua_ier_c10");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg10=new;
    rd_cg10=new;
  endfunction : new
endclass : ua_ier_c10

class uart_ctrl_rf_c10 extends uvm_reg_block;

  rand ua_div_latch0_c10 ua_div_latch010;
  rand ua_div_latch1_c10 ua_div_latch110;
  rand ua_int_id_c10 ua_int_id10;
  rand ua_fifo_ctrl_c10 ua_fifo_ctrl10;
  rand ua_lcr_c10 ua_lcr10;
  rand ua_ier_c10 ua_ier10;

  virtual function void build();

    // Now10 create all registers

    ua_div_latch010 = ua_div_latch0_c10::type_id::create("ua_div_latch010", , get_full_name());
    ua_div_latch110 = ua_div_latch1_c10::type_id::create("ua_div_latch110", , get_full_name());
    ua_int_id10 = ua_int_id_c10::type_id::create("ua_int_id10", , get_full_name());
    ua_fifo_ctrl10 = ua_fifo_ctrl_c10::type_id::create("ua_fifo_ctrl10", , get_full_name());
    ua_lcr10 = ua_lcr_c10::type_id::create("ua_lcr10", , get_full_name());
    ua_ier10 = ua_ier_c10::type_id::create("ua_ier10", , get_full_name());

    // Now10 build the registers. Set parent and hdl_paths

    ua_div_latch010.configure(this, null, "dl10[7:0]");
    ua_div_latch010.build();
    ua_div_latch110.configure(this, null, "dl10[15;8]");
    ua_div_latch110.build();
    ua_int_id10.configure(this, null, "iir10");
    ua_int_id10.build();
    ua_fifo_ctrl10.configure(this, null, "fcr10");
    ua_fifo_ctrl10.build();
    ua_lcr10.configure(this, null, "lcr10");
    ua_lcr10.build();
    ua_ier10.configure(this, null, "ier10");
    ua_ier10.build();
    // Now10 define address mappings10
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch010, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch110, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id10, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl10, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr10, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier10, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c10)
  function new(input string name="unnamed10-uart_ctrl_rf10");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c10

//////////////////////////////////////////////////////////////////////////////
// Address_map10 definition10
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c10 extends uvm_reg_block;

  rand uart_ctrl_rf_c10 uart_ctrl_rf10;

  function void build();
    // Now10 define address mappings10
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf10 = uart_ctrl_rf_c10::type_id::create("uart_ctrl_rf10", , get_full_name());
    uart_ctrl_rf10.configure(this, "regs");
    uart_ctrl_rf10.build();
    uart_ctrl_rf10.lock_model();
    default_map.add_submap(uart_ctrl_rf10.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top10.uart_dut10");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c10)
  function new(input string name="unnamed10-uart_ctrl_reg_model_c10");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c10

`endif // UART_CTRL_REGS_SV10
