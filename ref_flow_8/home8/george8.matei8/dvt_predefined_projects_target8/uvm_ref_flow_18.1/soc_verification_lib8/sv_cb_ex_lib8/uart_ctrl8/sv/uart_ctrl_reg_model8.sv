// This8 file is generated8 using Cadence8 iregGen8 version8 1.05

`ifndef UART_CTRL_REGS_SV8
`define UART_CTRL_REGS_SV8

// Input8 File8: uart_ctrl_regs8.xml8

// Number8 of AddrMaps8 = 1
// Number8 of RegFiles8 = 1
// Number8 of Registers8 = 6
// Number8 of Memories8 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 262


class ua_div_latch0_c8 extends uvm_reg;

  rand uvm_reg_field div_val8;

  constraint c_div_val8 { div_val8.value == 1; }
  virtual function void build();
    div_val8 = uvm_reg_field::type_id::create("div_val8");
    div_val8.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg8.set_inst_name($sformatf("%s.wcov8", get_full_name()));
    rd_cg8.set_inst_name($sformatf("%s.rcov8", get_full_name()));
  endfunction

  covergroup wr_cg8;
    option.per_instance=1;
    div_val8 : coverpoint div_val8.value[7:0];
  endgroup
  covergroup rd_cg8;
    option.per_instance=1;
    div_val8 : coverpoint div_val8.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg8.sample();
    if(is_read) rd_cg8.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c8, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c8, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c8)
  function new(input string name="unnamed8-ua_div_latch0_c8");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg8=new;
    rd_cg8=new;
  endfunction : new
endclass : ua_div_latch0_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 287


class ua_div_latch1_c8 extends uvm_reg;

  rand uvm_reg_field div_val8;

  constraint c_div_val8 { div_val8.value == 0; }
  virtual function void build();
    div_val8 = uvm_reg_field::type_id::create("div_val8");
    div_val8.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg8.set_inst_name($sformatf("%s.wcov8", get_full_name()));
    rd_cg8.set_inst_name($sformatf("%s.rcov8", get_full_name()));
  endfunction

  covergroup wr_cg8;
    option.per_instance=1;
    div_val8 : coverpoint div_val8.value[7:0];
  endgroup
  covergroup rd_cg8;
    option.per_instance=1;
    div_val8 : coverpoint div_val8.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg8.sample();
    if(is_read) rd_cg8.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c8, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c8, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c8)
  function new(input string name="unnamed8-ua_div_latch1_c8");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg8=new;
    rd_cg8=new;
  endfunction : new
endclass : ua_div_latch1_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 82


class ua_int_id_c8 extends uvm_reg;

  uvm_reg_field priority_bit8;
  uvm_reg_field bit18;
  uvm_reg_field bit28;
  uvm_reg_field bit38;

  virtual function void build();
    priority_bit8 = uvm_reg_field::type_id::create("priority_bit8");
    priority_bit8.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit18 = uvm_reg_field::type_id::create("bit18");
    bit18.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit28 = uvm_reg_field::type_id::create("bit28");
    bit28.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit38 = uvm_reg_field::type_id::create("bit38");
    bit38.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg8.set_inst_name($sformatf("%s.rcov8", get_full_name()));
  endfunction

  covergroup rd_cg8;
    option.per_instance=1;
    priority_bit8 : coverpoint priority_bit8.value[0:0];
    bit18 : coverpoint bit18.value[0:0];
    bit28 : coverpoint bit28.value[0:0];
    bit38 : coverpoint bit38.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg8.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c8, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c8, uvm_reg)
  `uvm_object_utils(ua_int_id_c8)
  function new(input string name="unnamed8-ua_int_id_c8");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg8=new;
  endfunction : new
endclass : ua_int_id_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 139


class ua_fifo_ctrl_c8 extends uvm_reg;

  rand uvm_reg_field rx_clear8;
  rand uvm_reg_field tx_clear8;
  rand uvm_reg_field rx_fifo_int_trig_level8;

  virtual function void build();
    rx_clear8 = uvm_reg_field::type_id::create("rx_clear8");
    rx_clear8.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear8 = uvm_reg_field::type_id::create("tx_clear8");
    tx_clear8.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level8 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level8");
    rx_fifo_int_trig_level8.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg8.set_inst_name($sformatf("%s.wcov8", get_full_name()));
  endfunction

  covergroup wr_cg8;
    option.per_instance=1;
    rx_clear8 : coverpoint rx_clear8.value[0:0];
    tx_clear8 : coverpoint tx_clear8.value[0:0];
    rx_fifo_int_trig_level8 : coverpoint rx_fifo_int_trig_level8.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg8.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c8, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c8, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c8)
  function new(input string name="unnamed8-ua_fifo_ctrl_c8");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg8=new;
  endfunction : new
endclass : ua_fifo_ctrl_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 188


class ua_lcr_c8 extends uvm_reg;

  rand uvm_reg_field char_lngth8;
  rand uvm_reg_field num_stop_bits8;
  rand uvm_reg_field p_en8;
  rand uvm_reg_field parity_even8;
  rand uvm_reg_field parity_sticky8;
  rand uvm_reg_field break_ctrl8;
  rand uvm_reg_field div_latch_access8;

  constraint c_char_lngth8 { char_lngth8.value != 2'b00; }
  constraint c_break_ctrl8 { break_ctrl8.value == 1'b0; }
  virtual function void build();
    char_lngth8 = uvm_reg_field::type_id::create("char_lngth8");
    char_lngth8.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits8 = uvm_reg_field::type_id::create("num_stop_bits8");
    num_stop_bits8.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en8 = uvm_reg_field::type_id::create("p_en8");
    p_en8.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even8 = uvm_reg_field::type_id::create("parity_even8");
    parity_even8.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky8 = uvm_reg_field::type_id::create("parity_sticky8");
    parity_sticky8.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl8 = uvm_reg_field::type_id::create("break_ctrl8");
    break_ctrl8.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access8 = uvm_reg_field::type_id::create("div_latch_access8");
    div_latch_access8.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg8.set_inst_name($sformatf("%s.wcov8", get_full_name()));
    rd_cg8.set_inst_name($sformatf("%s.rcov8", get_full_name()));
  endfunction

  covergroup wr_cg8;
    option.per_instance=1;
    char_lngth8 : coverpoint char_lngth8.value[1:0];
    num_stop_bits8 : coverpoint num_stop_bits8.value[0:0];
    p_en8 : coverpoint p_en8.value[0:0];
    parity_even8 : coverpoint parity_even8.value[0:0];
    parity_sticky8 : coverpoint parity_sticky8.value[0:0];
    break_ctrl8 : coverpoint break_ctrl8.value[0:0];
    div_latch_access8 : coverpoint div_latch_access8.value[0:0];
  endgroup
  covergroup rd_cg8;
    option.per_instance=1;
    char_lngth8 : coverpoint char_lngth8.value[1:0];
    num_stop_bits8 : coverpoint num_stop_bits8.value[0:0];
    p_en8 : coverpoint p_en8.value[0:0];
    parity_even8 : coverpoint parity_even8.value[0:0];
    parity_sticky8 : coverpoint parity_sticky8.value[0:0];
    break_ctrl8 : coverpoint break_ctrl8.value[0:0];
    div_latch_access8 : coverpoint div_latch_access8.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg8.sample();
    if(is_read) rd_cg8.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c8, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c8, uvm_reg)
  `uvm_object_utils(ua_lcr_c8)
  function new(input string name="unnamed8-ua_lcr_c8");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg8=new;
    rd_cg8=new;
  endfunction : new
endclass : ua_lcr_c8

//////////////////////////////////////////////////////////////////////////////
// Register definition8
//////////////////////////////////////////////////////////////////////////////
// Line8 Number8: 25


class ua_ier_c8 extends uvm_reg;

  rand uvm_reg_field rx_data8;
  rand uvm_reg_field tx_data8;
  rand uvm_reg_field rx_line_sts8;
  rand uvm_reg_field mdm_sts8;

  virtual function void build();
    rx_data8 = uvm_reg_field::type_id::create("rx_data8");
    rx_data8.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data8 = uvm_reg_field::type_id::create("tx_data8");
    tx_data8.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts8 = uvm_reg_field::type_id::create("rx_line_sts8");
    rx_line_sts8.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts8 = uvm_reg_field::type_id::create("mdm_sts8");
    mdm_sts8.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg8.set_inst_name($sformatf("%s.wcov8", get_full_name()));
    rd_cg8.set_inst_name($sformatf("%s.rcov8", get_full_name()));
  endfunction

  covergroup wr_cg8;
    option.per_instance=1;
    rx_data8 : coverpoint rx_data8.value[0:0];
    tx_data8 : coverpoint tx_data8.value[0:0];
    rx_line_sts8 : coverpoint rx_line_sts8.value[0:0];
    mdm_sts8 : coverpoint mdm_sts8.value[0:0];
  endgroup
  covergroup rd_cg8;
    option.per_instance=1;
    rx_data8 : coverpoint rx_data8.value[0:0];
    tx_data8 : coverpoint tx_data8.value[0:0];
    rx_line_sts8 : coverpoint rx_line_sts8.value[0:0];
    mdm_sts8 : coverpoint mdm_sts8.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg8.sample();
    if(is_read) rd_cg8.sample();
  endfunction

  `uvm_register_cb(ua_ier_c8, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c8, uvm_reg)
  `uvm_object_utils(ua_ier_c8)
  function new(input string name="unnamed8-ua_ier_c8");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg8=new;
    rd_cg8=new;
  endfunction : new
endclass : ua_ier_c8

class uart_ctrl_rf_c8 extends uvm_reg_block;

  rand ua_div_latch0_c8 ua_div_latch08;
  rand ua_div_latch1_c8 ua_div_latch18;
  rand ua_int_id_c8 ua_int_id8;
  rand ua_fifo_ctrl_c8 ua_fifo_ctrl8;
  rand ua_lcr_c8 ua_lcr8;
  rand ua_ier_c8 ua_ier8;

  virtual function void build();

    // Now8 create all registers

    ua_div_latch08 = ua_div_latch0_c8::type_id::create("ua_div_latch08", , get_full_name());
    ua_div_latch18 = ua_div_latch1_c8::type_id::create("ua_div_latch18", , get_full_name());
    ua_int_id8 = ua_int_id_c8::type_id::create("ua_int_id8", , get_full_name());
    ua_fifo_ctrl8 = ua_fifo_ctrl_c8::type_id::create("ua_fifo_ctrl8", , get_full_name());
    ua_lcr8 = ua_lcr_c8::type_id::create("ua_lcr8", , get_full_name());
    ua_ier8 = ua_ier_c8::type_id::create("ua_ier8", , get_full_name());

    // Now8 build the registers. Set parent and hdl_paths

    ua_div_latch08.configure(this, null, "dl8[7:0]");
    ua_div_latch08.build();
    ua_div_latch18.configure(this, null, "dl8[15;8]");
    ua_div_latch18.build();
    ua_int_id8.configure(this, null, "iir8");
    ua_int_id8.build();
    ua_fifo_ctrl8.configure(this, null, "fcr8");
    ua_fifo_ctrl8.build();
    ua_lcr8.configure(this, null, "lcr8");
    ua_lcr8.build();
    ua_ier8.configure(this, null, "ier8");
    ua_ier8.build();
    // Now8 define address mappings8
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch08, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch18, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id8, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl8, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr8, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier8, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c8)
  function new(input string name="unnamed8-uart_ctrl_rf8");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c8

//////////////////////////////////////////////////////////////////////////////
// Address_map8 definition8
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c8 extends uvm_reg_block;

  rand uart_ctrl_rf_c8 uart_ctrl_rf8;

  function void build();
    // Now8 define address mappings8
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf8 = uart_ctrl_rf_c8::type_id::create("uart_ctrl_rf8", , get_full_name());
    uart_ctrl_rf8.configure(this, "regs");
    uart_ctrl_rf8.build();
    uart_ctrl_rf8.lock_model();
    default_map.add_submap(uart_ctrl_rf8.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top8.uart_dut8");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c8)
  function new(input string name="unnamed8-uart_ctrl_reg_model_c8");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c8

`endif // UART_CTRL_REGS_SV8
