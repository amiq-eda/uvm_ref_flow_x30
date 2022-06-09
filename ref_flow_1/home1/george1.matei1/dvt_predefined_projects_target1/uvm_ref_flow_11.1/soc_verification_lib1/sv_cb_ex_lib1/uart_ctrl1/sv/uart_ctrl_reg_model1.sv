// This1 file is generated1 using Cadence1 iregGen1 version1 1.05

`ifndef UART_CTRL_REGS_SV1
`define UART_CTRL_REGS_SV1

// Input1 File1: uart_ctrl_regs1.xml1

// Number1 of AddrMaps1 = 1
// Number1 of RegFiles1 = 1
// Number1 of Registers1 = 6
// Number1 of Memories1 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 262


class ua_div_latch0_c1 extends uvm_reg;

  rand uvm_reg_field div_val1;

  constraint c_div_val1 { div_val1.value == 1; }
  virtual function void build();
    div_val1 = uvm_reg_field::type_id::create("div_val1");
    div_val1.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg1.set_inst_name($sformatf("%s.wcov1", get_full_name()));
    rd_cg1.set_inst_name($sformatf("%s.rcov1", get_full_name()));
  endfunction

  covergroup wr_cg1;
    option.per_instance=1;
    div_val1 : coverpoint div_val1.value[7:0];
  endgroup
  covergroup rd_cg1;
    option.per_instance=1;
    div_val1 : coverpoint div_val1.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg1.sample();
    if(is_read) rd_cg1.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c1, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c1, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c1)
  function new(input string name="unnamed1-ua_div_latch0_c1");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg1=new;
    rd_cg1=new;
  endfunction : new
endclass : ua_div_latch0_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 287


class ua_div_latch1_c1 extends uvm_reg;

  rand uvm_reg_field div_val1;

  constraint c_div_val1 { div_val1.value == 0; }
  virtual function void build();
    div_val1 = uvm_reg_field::type_id::create("div_val1");
    div_val1.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg1.set_inst_name($sformatf("%s.wcov1", get_full_name()));
    rd_cg1.set_inst_name($sformatf("%s.rcov1", get_full_name()));
  endfunction

  covergroup wr_cg1;
    option.per_instance=1;
    div_val1 : coverpoint div_val1.value[7:0];
  endgroup
  covergroup rd_cg1;
    option.per_instance=1;
    div_val1 : coverpoint div_val1.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg1.sample();
    if(is_read) rd_cg1.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c1, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c1, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c1)
  function new(input string name="unnamed1-ua_div_latch1_c1");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg1=new;
    rd_cg1=new;
  endfunction : new
endclass : ua_div_latch1_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 82


class ua_int_id_c1 extends uvm_reg;

  uvm_reg_field priority_bit1;
  uvm_reg_field bit11;
  uvm_reg_field bit21;
  uvm_reg_field bit31;

  virtual function void build();
    priority_bit1 = uvm_reg_field::type_id::create("priority_bit1");
    priority_bit1.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit11 = uvm_reg_field::type_id::create("bit11");
    bit11.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit21 = uvm_reg_field::type_id::create("bit21");
    bit21.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit31 = uvm_reg_field::type_id::create("bit31");
    bit31.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg1.set_inst_name($sformatf("%s.rcov1", get_full_name()));
  endfunction

  covergroup rd_cg1;
    option.per_instance=1;
    priority_bit1 : coverpoint priority_bit1.value[0:0];
    bit11 : coverpoint bit11.value[0:0];
    bit21 : coverpoint bit21.value[0:0];
    bit31 : coverpoint bit31.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg1.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c1, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c1, uvm_reg)
  `uvm_object_utils(ua_int_id_c1)
  function new(input string name="unnamed1-ua_int_id_c1");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg1=new;
  endfunction : new
endclass : ua_int_id_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 139


class ua_fifo_ctrl_c1 extends uvm_reg;

  rand uvm_reg_field rx_clear1;
  rand uvm_reg_field tx_clear1;
  rand uvm_reg_field rx_fifo_int_trig_level1;

  virtual function void build();
    rx_clear1 = uvm_reg_field::type_id::create("rx_clear1");
    rx_clear1.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear1 = uvm_reg_field::type_id::create("tx_clear1");
    tx_clear1.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level1 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level1");
    rx_fifo_int_trig_level1.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg1.set_inst_name($sformatf("%s.wcov1", get_full_name()));
  endfunction

  covergroup wr_cg1;
    option.per_instance=1;
    rx_clear1 : coverpoint rx_clear1.value[0:0];
    tx_clear1 : coverpoint tx_clear1.value[0:0];
    rx_fifo_int_trig_level1 : coverpoint rx_fifo_int_trig_level1.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg1.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c1, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c1, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c1)
  function new(input string name="unnamed1-ua_fifo_ctrl_c1");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg1=new;
  endfunction : new
endclass : ua_fifo_ctrl_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 188


class ua_lcr_c1 extends uvm_reg;

  rand uvm_reg_field char_lngth1;
  rand uvm_reg_field num_stop_bits1;
  rand uvm_reg_field p_en1;
  rand uvm_reg_field parity_even1;
  rand uvm_reg_field parity_sticky1;
  rand uvm_reg_field break_ctrl1;
  rand uvm_reg_field div_latch_access1;

  constraint c_char_lngth1 { char_lngth1.value != 2'b00; }
  constraint c_break_ctrl1 { break_ctrl1.value == 1'b0; }
  virtual function void build();
    char_lngth1 = uvm_reg_field::type_id::create("char_lngth1");
    char_lngth1.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits1 = uvm_reg_field::type_id::create("num_stop_bits1");
    num_stop_bits1.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en1 = uvm_reg_field::type_id::create("p_en1");
    p_en1.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even1 = uvm_reg_field::type_id::create("parity_even1");
    parity_even1.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky1 = uvm_reg_field::type_id::create("parity_sticky1");
    parity_sticky1.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl1 = uvm_reg_field::type_id::create("break_ctrl1");
    break_ctrl1.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access1 = uvm_reg_field::type_id::create("div_latch_access1");
    div_latch_access1.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg1.set_inst_name($sformatf("%s.wcov1", get_full_name()));
    rd_cg1.set_inst_name($sformatf("%s.rcov1", get_full_name()));
  endfunction

  covergroup wr_cg1;
    option.per_instance=1;
    char_lngth1 : coverpoint char_lngth1.value[1:0];
    num_stop_bits1 : coverpoint num_stop_bits1.value[0:0];
    p_en1 : coverpoint p_en1.value[0:0];
    parity_even1 : coverpoint parity_even1.value[0:0];
    parity_sticky1 : coverpoint parity_sticky1.value[0:0];
    break_ctrl1 : coverpoint break_ctrl1.value[0:0];
    div_latch_access1 : coverpoint div_latch_access1.value[0:0];
  endgroup
  covergroup rd_cg1;
    option.per_instance=1;
    char_lngth1 : coverpoint char_lngth1.value[1:0];
    num_stop_bits1 : coverpoint num_stop_bits1.value[0:0];
    p_en1 : coverpoint p_en1.value[0:0];
    parity_even1 : coverpoint parity_even1.value[0:0];
    parity_sticky1 : coverpoint parity_sticky1.value[0:0];
    break_ctrl1 : coverpoint break_ctrl1.value[0:0];
    div_latch_access1 : coverpoint div_latch_access1.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg1.sample();
    if(is_read) rd_cg1.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c1, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c1, uvm_reg)
  `uvm_object_utils(ua_lcr_c1)
  function new(input string name="unnamed1-ua_lcr_c1");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg1=new;
    rd_cg1=new;
  endfunction : new
endclass : ua_lcr_c1

//////////////////////////////////////////////////////////////////////////////
// Register definition1
//////////////////////////////////////////////////////////////////////////////
// Line1 Number1: 25


class ua_ier_c1 extends uvm_reg;

  rand uvm_reg_field rx_data1;
  rand uvm_reg_field tx_data1;
  rand uvm_reg_field rx_line_sts1;
  rand uvm_reg_field mdm_sts1;

  virtual function void build();
    rx_data1 = uvm_reg_field::type_id::create("rx_data1");
    rx_data1.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data1 = uvm_reg_field::type_id::create("tx_data1");
    tx_data1.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts1 = uvm_reg_field::type_id::create("rx_line_sts1");
    rx_line_sts1.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts1 = uvm_reg_field::type_id::create("mdm_sts1");
    mdm_sts1.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg1.set_inst_name($sformatf("%s.wcov1", get_full_name()));
    rd_cg1.set_inst_name($sformatf("%s.rcov1", get_full_name()));
  endfunction

  covergroup wr_cg1;
    option.per_instance=1;
    rx_data1 : coverpoint rx_data1.value[0:0];
    tx_data1 : coverpoint tx_data1.value[0:0];
    rx_line_sts1 : coverpoint rx_line_sts1.value[0:0];
    mdm_sts1 : coverpoint mdm_sts1.value[0:0];
  endgroup
  covergroup rd_cg1;
    option.per_instance=1;
    rx_data1 : coverpoint rx_data1.value[0:0];
    tx_data1 : coverpoint tx_data1.value[0:0];
    rx_line_sts1 : coverpoint rx_line_sts1.value[0:0];
    mdm_sts1 : coverpoint mdm_sts1.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg1.sample();
    if(is_read) rd_cg1.sample();
  endfunction

  `uvm_register_cb(ua_ier_c1, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c1, uvm_reg)
  `uvm_object_utils(ua_ier_c1)
  function new(input string name="unnamed1-ua_ier_c1");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg1=new;
    rd_cg1=new;
  endfunction : new
endclass : ua_ier_c1

class uart_ctrl_rf_c1 extends uvm_reg_block;

  rand ua_div_latch0_c1 ua_div_latch01;
  rand ua_div_latch1_c1 ua_div_latch11;
  rand ua_int_id_c1 ua_int_id1;
  rand ua_fifo_ctrl_c1 ua_fifo_ctrl1;
  rand ua_lcr_c1 ua_lcr1;
  rand ua_ier_c1 ua_ier1;

  virtual function void build();

    // Now1 create all registers

    ua_div_latch01 = ua_div_latch0_c1::type_id::create("ua_div_latch01", , get_full_name());
    ua_div_latch11 = ua_div_latch1_c1::type_id::create("ua_div_latch11", , get_full_name());
    ua_int_id1 = ua_int_id_c1::type_id::create("ua_int_id1", , get_full_name());
    ua_fifo_ctrl1 = ua_fifo_ctrl_c1::type_id::create("ua_fifo_ctrl1", , get_full_name());
    ua_lcr1 = ua_lcr_c1::type_id::create("ua_lcr1", , get_full_name());
    ua_ier1 = ua_ier_c1::type_id::create("ua_ier1", , get_full_name());

    // Now1 build the registers. Set parent and hdl_paths

    ua_div_latch01.configure(this, null, "dl1[7:0]");
    ua_div_latch01.build();
    ua_div_latch11.configure(this, null, "dl1[15;8]");
    ua_div_latch11.build();
    ua_int_id1.configure(this, null, "iir1");
    ua_int_id1.build();
    ua_fifo_ctrl1.configure(this, null, "fcr1");
    ua_fifo_ctrl1.build();
    ua_lcr1.configure(this, null, "lcr1");
    ua_lcr1.build();
    ua_ier1.configure(this, null, "ier1");
    ua_ier1.build();
    // Now1 define address mappings1
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch01, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch11, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id1, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl1, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr1, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier1, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c1)
  function new(input string name="unnamed1-uart_ctrl_rf1");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c1

//////////////////////////////////////////////////////////////////////////////
// Address_map1 definition1
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c1 extends uvm_reg_block;

  rand uart_ctrl_rf_c1 uart_ctrl_rf1;

  function void build();
    // Now1 define address mappings1
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf1 = uart_ctrl_rf_c1::type_id::create("uart_ctrl_rf1", , get_full_name());
    uart_ctrl_rf1.configure(this, "regs");
    uart_ctrl_rf1.build();
    uart_ctrl_rf1.lock_model();
    default_map.add_submap(uart_ctrl_rf1.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top1.uart_dut1");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c1)
  function new(input string name="unnamed1-uart_ctrl_reg_model_c1");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c1

`endif // UART_CTRL_REGS_SV1
