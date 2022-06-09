// This12 file is generated12 using Cadence12 iregGen12 version12 1.05

`ifndef UART_CTRL_REGS_SV12
`define UART_CTRL_REGS_SV12

// Input12 File12: uart_ctrl_regs12.xml12

// Number12 of AddrMaps12 = 1
// Number12 of RegFiles12 = 1
// Number12 of Registers12 = 6
// Number12 of Memories12 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 262


class ua_div_latch0_c12 extends uvm_reg;

  rand uvm_reg_field div_val12;

  constraint c_div_val12 { div_val12.value == 1; }
  virtual function void build();
    div_val12 = uvm_reg_field::type_id::create("div_val12");
    div_val12.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg12.set_inst_name($sformatf("%s.wcov12", get_full_name()));
    rd_cg12.set_inst_name($sformatf("%s.rcov12", get_full_name()));
  endfunction

  covergroup wr_cg12;
    option.per_instance=1;
    div_val12 : coverpoint div_val12.value[7:0];
  endgroup
  covergroup rd_cg12;
    option.per_instance=1;
    div_val12 : coverpoint div_val12.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg12.sample();
    if(is_read) rd_cg12.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c12, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c12, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c12)
  function new(input string name="unnamed12-ua_div_latch0_c12");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg12=new;
    rd_cg12=new;
  endfunction : new
endclass : ua_div_latch0_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 287


class ua_div_latch1_c12 extends uvm_reg;

  rand uvm_reg_field div_val12;

  constraint c_div_val12 { div_val12.value == 0; }
  virtual function void build();
    div_val12 = uvm_reg_field::type_id::create("div_val12");
    div_val12.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg12.set_inst_name($sformatf("%s.wcov12", get_full_name()));
    rd_cg12.set_inst_name($sformatf("%s.rcov12", get_full_name()));
  endfunction

  covergroup wr_cg12;
    option.per_instance=1;
    div_val12 : coverpoint div_val12.value[7:0];
  endgroup
  covergroup rd_cg12;
    option.per_instance=1;
    div_val12 : coverpoint div_val12.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg12.sample();
    if(is_read) rd_cg12.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c12, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c12, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c12)
  function new(input string name="unnamed12-ua_div_latch1_c12");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg12=new;
    rd_cg12=new;
  endfunction : new
endclass : ua_div_latch1_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 82


class ua_int_id_c12 extends uvm_reg;

  uvm_reg_field priority_bit12;
  uvm_reg_field bit112;
  uvm_reg_field bit212;
  uvm_reg_field bit312;

  virtual function void build();
    priority_bit12 = uvm_reg_field::type_id::create("priority_bit12");
    priority_bit12.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit112 = uvm_reg_field::type_id::create("bit112");
    bit112.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit212 = uvm_reg_field::type_id::create("bit212");
    bit212.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit312 = uvm_reg_field::type_id::create("bit312");
    bit312.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg12.set_inst_name($sformatf("%s.rcov12", get_full_name()));
  endfunction

  covergroup rd_cg12;
    option.per_instance=1;
    priority_bit12 : coverpoint priority_bit12.value[0:0];
    bit112 : coverpoint bit112.value[0:0];
    bit212 : coverpoint bit212.value[0:0];
    bit312 : coverpoint bit312.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg12.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c12, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c12, uvm_reg)
  `uvm_object_utils(ua_int_id_c12)
  function new(input string name="unnamed12-ua_int_id_c12");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg12=new;
  endfunction : new
endclass : ua_int_id_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 139


class ua_fifo_ctrl_c12 extends uvm_reg;

  rand uvm_reg_field rx_clear12;
  rand uvm_reg_field tx_clear12;
  rand uvm_reg_field rx_fifo_int_trig_level12;

  virtual function void build();
    rx_clear12 = uvm_reg_field::type_id::create("rx_clear12");
    rx_clear12.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear12 = uvm_reg_field::type_id::create("tx_clear12");
    tx_clear12.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level12 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level12");
    rx_fifo_int_trig_level12.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg12.set_inst_name($sformatf("%s.wcov12", get_full_name()));
  endfunction

  covergroup wr_cg12;
    option.per_instance=1;
    rx_clear12 : coverpoint rx_clear12.value[0:0];
    tx_clear12 : coverpoint tx_clear12.value[0:0];
    rx_fifo_int_trig_level12 : coverpoint rx_fifo_int_trig_level12.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg12.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c12, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c12, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c12)
  function new(input string name="unnamed12-ua_fifo_ctrl_c12");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg12=new;
  endfunction : new
endclass : ua_fifo_ctrl_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 188


class ua_lcr_c12 extends uvm_reg;

  rand uvm_reg_field char_lngth12;
  rand uvm_reg_field num_stop_bits12;
  rand uvm_reg_field p_en12;
  rand uvm_reg_field parity_even12;
  rand uvm_reg_field parity_sticky12;
  rand uvm_reg_field break_ctrl12;
  rand uvm_reg_field div_latch_access12;

  constraint c_char_lngth12 { char_lngth12.value != 2'b00; }
  constraint c_break_ctrl12 { break_ctrl12.value == 1'b0; }
  virtual function void build();
    char_lngth12 = uvm_reg_field::type_id::create("char_lngth12");
    char_lngth12.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits12 = uvm_reg_field::type_id::create("num_stop_bits12");
    num_stop_bits12.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en12 = uvm_reg_field::type_id::create("p_en12");
    p_en12.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even12 = uvm_reg_field::type_id::create("parity_even12");
    parity_even12.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky12 = uvm_reg_field::type_id::create("parity_sticky12");
    parity_sticky12.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl12 = uvm_reg_field::type_id::create("break_ctrl12");
    break_ctrl12.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access12 = uvm_reg_field::type_id::create("div_latch_access12");
    div_latch_access12.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg12.set_inst_name($sformatf("%s.wcov12", get_full_name()));
    rd_cg12.set_inst_name($sformatf("%s.rcov12", get_full_name()));
  endfunction

  covergroup wr_cg12;
    option.per_instance=1;
    char_lngth12 : coverpoint char_lngth12.value[1:0];
    num_stop_bits12 : coverpoint num_stop_bits12.value[0:0];
    p_en12 : coverpoint p_en12.value[0:0];
    parity_even12 : coverpoint parity_even12.value[0:0];
    parity_sticky12 : coverpoint parity_sticky12.value[0:0];
    break_ctrl12 : coverpoint break_ctrl12.value[0:0];
    div_latch_access12 : coverpoint div_latch_access12.value[0:0];
  endgroup
  covergroup rd_cg12;
    option.per_instance=1;
    char_lngth12 : coverpoint char_lngth12.value[1:0];
    num_stop_bits12 : coverpoint num_stop_bits12.value[0:0];
    p_en12 : coverpoint p_en12.value[0:0];
    parity_even12 : coverpoint parity_even12.value[0:0];
    parity_sticky12 : coverpoint parity_sticky12.value[0:0];
    break_ctrl12 : coverpoint break_ctrl12.value[0:0];
    div_latch_access12 : coverpoint div_latch_access12.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg12.sample();
    if(is_read) rd_cg12.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c12, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c12, uvm_reg)
  `uvm_object_utils(ua_lcr_c12)
  function new(input string name="unnamed12-ua_lcr_c12");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg12=new;
    rd_cg12=new;
  endfunction : new
endclass : ua_lcr_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 25


class ua_ier_c12 extends uvm_reg;

  rand uvm_reg_field rx_data12;
  rand uvm_reg_field tx_data12;
  rand uvm_reg_field rx_line_sts12;
  rand uvm_reg_field mdm_sts12;

  virtual function void build();
    rx_data12 = uvm_reg_field::type_id::create("rx_data12");
    rx_data12.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data12 = uvm_reg_field::type_id::create("tx_data12");
    tx_data12.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts12 = uvm_reg_field::type_id::create("rx_line_sts12");
    rx_line_sts12.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts12 = uvm_reg_field::type_id::create("mdm_sts12");
    mdm_sts12.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg12.set_inst_name($sformatf("%s.wcov12", get_full_name()));
    rd_cg12.set_inst_name($sformatf("%s.rcov12", get_full_name()));
  endfunction

  covergroup wr_cg12;
    option.per_instance=1;
    rx_data12 : coverpoint rx_data12.value[0:0];
    tx_data12 : coverpoint tx_data12.value[0:0];
    rx_line_sts12 : coverpoint rx_line_sts12.value[0:0];
    mdm_sts12 : coverpoint mdm_sts12.value[0:0];
  endgroup
  covergroup rd_cg12;
    option.per_instance=1;
    rx_data12 : coverpoint rx_data12.value[0:0];
    tx_data12 : coverpoint tx_data12.value[0:0];
    rx_line_sts12 : coverpoint rx_line_sts12.value[0:0];
    mdm_sts12 : coverpoint mdm_sts12.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg12.sample();
    if(is_read) rd_cg12.sample();
  endfunction

  `uvm_register_cb(ua_ier_c12, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c12, uvm_reg)
  `uvm_object_utils(ua_ier_c12)
  function new(input string name="unnamed12-ua_ier_c12");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg12=new;
    rd_cg12=new;
  endfunction : new
endclass : ua_ier_c12

class uart_ctrl_rf_c12 extends uvm_reg_block;

  rand ua_div_latch0_c12 ua_div_latch012;
  rand ua_div_latch1_c12 ua_div_latch112;
  rand ua_int_id_c12 ua_int_id12;
  rand ua_fifo_ctrl_c12 ua_fifo_ctrl12;
  rand ua_lcr_c12 ua_lcr12;
  rand ua_ier_c12 ua_ier12;

  virtual function void build();

    // Now12 create all registers

    ua_div_latch012 = ua_div_latch0_c12::type_id::create("ua_div_latch012", , get_full_name());
    ua_div_latch112 = ua_div_latch1_c12::type_id::create("ua_div_latch112", , get_full_name());
    ua_int_id12 = ua_int_id_c12::type_id::create("ua_int_id12", , get_full_name());
    ua_fifo_ctrl12 = ua_fifo_ctrl_c12::type_id::create("ua_fifo_ctrl12", , get_full_name());
    ua_lcr12 = ua_lcr_c12::type_id::create("ua_lcr12", , get_full_name());
    ua_ier12 = ua_ier_c12::type_id::create("ua_ier12", , get_full_name());

    // Now12 build the registers. Set parent and hdl_paths

    ua_div_latch012.configure(this, null, "dl12[7:0]");
    ua_div_latch012.build();
    ua_div_latch112.configure(this, null, "dl12[15;8]");
    ua_div_latch112.build();
    ua_int_id12.configure(this, null, "iir12");
    ua_int_id12.build();
    ua_fifo_ctrl12.configure(this, null, "fcr12");
    ua_fifo_ctrl12.build();
    ua_lcr12.configure(this, null, "lcr12");
    ua_lcr12.build();
    ua_ier12.configure(this, null, "ier12");
    ua_ier12.build();
    // Now12 define address mappings12
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch012, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch112, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id12, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl12, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr12, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier12, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c12)
  function new(input string name="unnamed12-uart_ctrl_rf12");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c12

//////////////////////////////////////////////////////////////////////////////
// Address_map12 definition12
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c12 extends uvm_reg_block;

  rand uart_ctrl_rf_c12 uart_ctrl_rf12;

  function void build();
    // Now12 define address mappings12
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf12 = uart_ctrl_rf_c12::type_id::create("uart_ctrl_rf12", , get_full_name());
    uart_ctrl_rf12.configure(this, "regs");
    uart_ctrl_rf12.build();
    uart_ctrl_rf12.lock_model();
    default_map.add_submap(uart_ctrl_rf12.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top12.uart_dut12");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c12)
  function new(input string name="unnamed12-uart_ctrl_reg_model_c12");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c12

`endif // UART_CTRL_REGS_SV12
