// This3 file is generated3 using Cadence3 iregGen3 version3 1.05

`ifndef UART_CTRL_REGS_SV3
`define UART_CTRL_REGS_SV3

// Input3 File3: uart_ctrl_regs3.xml3

// Number3 of AddrMaps3 = 1
// Number3 of RegFiles3 = 1
// Number3 of Registers3 = 6
// Number3 of Memories3 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 262


class ua_div_latch0_c3 extends uvm_reg;

  rand uvm_reg_field div_val3;

  constraint c_div_val3 { div_val3.value == 1; }
  virtual function void build();
    div_val3 = uvm_reg_field::type_id::create("div_val3");
    div_val3.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg3.set_inst_name($sformatf("%s.wcov3", get_full_name()));
    rd_cg3.set_inst_name($sformatf("%s.rcov3", get_full_name()));
  endfunction

  covergroup wr_cg3;
    option.per_instance=1;
    div_val3 : coverpoint div_val3.value[7:0];
  endgroup
  covergroup rd_cg3;
    option.per_instance=1;
    div_val3 : coverpoint div_val3.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg3.sample();
    if(is_read) rd_cg3.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c3, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c3, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c3)
  function new(input string name="unnamed3-ua_div_latch0_c3");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg3=new;
    rd_cg3=new;
  endfunction : new
endclass : ua_div_latch0_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 287


class ua_div_latch1_c3 extends uvm_reg;

  rand uvm_reg_field div_val3;

  constraint c_div_val3 { div_val3.value == 0; }
  virtual function void build();
    div_val3 = uvm_reg_field::type_id::create("div_val3");
    div_val3.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg3.set_inst_name($sformatf("%s.wcov3", get_full_name()));
    rd_cg3.set_inst_name($sformatf("%s.rcov3", get_full_name()));
  endfunction

  covergroup wr_cg3;
    option.per_instance=1;
    div_val3 : coverpoint div_val3.value[7:0];
  endgroup
  covergroup rd_cg3;
    option.per_instance=1;
    div_val3 : coverpoint div_val3.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg3.sample();
    if(is_read) rd_cg3.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c3, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c3, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c3)
  function new(input string name="unnamed3-ua_div_latch1_c3");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg3=new;
    rd_cg3=new;
  endfunction : new
endclass : ua_div_latch1_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 82


class ua_int_id_c3 extends uvm_reg;

  uvm_reg_field priority_bit3;
  uvm_reg_field bit13;
  uvm_reg_field bit23;
  uvm_reg_field bit33;

  virtual function void build();
    priority_bit3 = uvm_reg_field::type_id::create("priority_bit3");
    priority_bit3.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit13 = uvm_reg_field::type_id::create("bit13");
    bit13.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit23 = uvm_reg_field::type_id::create("bit23");
    bit23.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit33 = uvm_reg_field::type_id::create("bit33");
    bit33.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg3.set_inst_name($sformatf("%s.rcov3", get_full_name()));
  endfunction

  covergroup rd_cg3;
    option.per_instance=1;
    priority_bit3 : coverpoint priority_bit3.value[0:0];
    bit13 : coverpoint bit13.value[0:0];
    bit23 : coverpoint bit23.value[0:0];
    bit33 : coverpoint bit33.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg3.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c3, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c3, uvm_reg)
  `uvm_object_utils(ua_int_id_c3)
  function new(input string name="unnamed3-ua_int_id_c3");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg3=new;
  endfunction : new
endclass : ua_int_id_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 139


class ua_fifo_ctrl_c3 extends uvm_reg;

  rand uvm_reg_field rx_clear3;
  rand uvm_reg_field tx_clear3;
  rand uvm_reg_field rx_fifo_int_trig_level3;

  virtual function void build();
    rx_clear3 = uvm_reg_field::type_id::create("rx_clear3");
    rx_clear3.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear3 = uvm_reg_field::type_id::create("tx_clear3");
    tx_clear3.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level3 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level3");
    rx_fifo_int_trig_level3.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg3.set_inst_name($sformatf("%s.wcov3", get_full_name()));
  endfunction

  covergroup wr_cg3;
    option.per_instance=1;
    rx_clear3 : coverpoint rx_clear3.value[0:0];
    tx_clear3 : coverpoint tx_clear3.value[0:0];
    rx_fifo_int_trig_level3 : coverpoint rx_fifo_int_trig_level3.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg3.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c3, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c3, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c3)
  function new(input string name="unnamed3-ua_fifo_ctrl_c3");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg3=new;
  endfunction : new
endclass : ua_fifo_ctrl_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 188


class ua_lcr_c3 extends uvm_reg;

  rand uvm_reg_field char_lngth3;
  rand uvm_reg_field num_stop_bits3;
  rand uvm_reg_field p_en3;
  rand uvm_reg_field parity_even3;
  rand uvm_reg_field parity_sticky3;
  rand uvm_reg_field break_ctrl3;
  rand uvm_reg_field div_latch_access3;

  constraint c_char_lngth3 { char_lngth3.value != 2'b00; }
  constraint c_break_ctrl3 { break_ctrl3.value == 1'b0; }
  virtual function void build();
    char_lngth3 = uvm_reg_field::type_id::create("char_lngth3");
    char_lngth3.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits3 = uvm_reg_field::type_id::create("num_stop_bits3");
    num_stop_bits3.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en3 = uvm_reg_field::type_id::create("p_en3");
    p_en3.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even3 = uvm_reg_field::type_id::create("parity_even3");
    parity_even3.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky3 = uvm_reg_field::type_id::create("parity_sticky3");
    parity_sticky3.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl3 = uvm_reg_field::type_id::create("break_ctrl3");
    break_ctrl3.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access3 = uvm_reg_field::type_id::create("div_latch_access3");
    div_latch_access3.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg3.set_inst_name($sformatf("%s.wcov3", get_full_name()));
    rd_cg3.set_inst_name($sformatf("%s.rcov3", get_full_name()));
  endfunction

  covergroup wr_cg3;
    option.per_instance=1;
    char_lngth3 : coverpoint char_lngth3.value[1:0];
    num_stop_bits3 : coverpoint num_stop_bits3.value[0:0];
    p_en3 : coverpoint p_en3.value[0:0];
    parity_even3 : coverpoint parity_even3.value[0:0];
    parity_sticky3 : coverpoint parity_sticky3.value[0:0];
    break_ctrl3 : coverpoint break_ctrl3.value[0:0];
    div_latch_access3 : coverpoint div_latch_access3.value[0:0];
  endgroup
  covergroup rd_cg3;
    option.per_instance=1;
    char_lngth3 : coverpoint char_lngth3.value[1:0];
    num_stop_bits3 : coverpoint num_stop_bits3.value[0:0];
    p_en3 : coverpoint p_en3.value[0:0];
    parity_even3 : coverpoint parity_even3.value[0:0];
    parity_sticky3 : coverpoint parity_sticky3.value[0:0];
    break_ctrl3 : coverpoint break_ctrl3.value[0:0];
    div_latch_access3 : coverpoint div_latch_access3.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg3.sample();
    if(is_read) rd_cg3.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c3, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c3, uvm_reg)
  `uvm_object_utils(ua_lcr_c3)
  function new(input string name="unnamed3-ua_lcr_c3");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg3=new;
    rd_cg3=new;
  endfunction : new
endclass : ua_lcr_c3

//////////////////////////////////////////////////////////////////////////////
// Register definition3
//////////////////////////////////////////////////////////////////////////////
// Line3 Number3: 25


class ua_ier_c3 extends uvm_reg;

  rand uvm_reg_field rx_data3;
  rand uvm_reg_field tx_data3;
  rand uvm_reg_field rx_line_sts3;
  rand uvm_reg_field mdm_sts3;

  virtual function void build();
    rx_data3 = uvm_reg_field::type_id::create("rx_data3");
    rx_data3.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data3 = uvm_reg_field::type_id::create("tx_data3");
    tx_data3.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts3 = uvm_reg_field::type_id::create("rx_line_sts3");
    rx_line_sts3.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts3 = uvm_reg_field::type_id::create("mdm_sts3");
    mdm_sts3.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg3.set_inst_name($sformatf("%s.wcov3", get_full_name()));
    rd_cg3.set_inst_name($sformatf("%s.rcov3", get_full_name()));
  endfunction

  covergroup wr_cg3;
    option.per_instance=1;
    rx_data3 : coverpoint rx_data3.value[0:0];
    tx_data3 : coverpoint tx_data3.value[0:0];
    rx_line_sts3 : coverpoint rx_line_sts3.value[0:0];
    mdm_sts3 : coverpoint mdm_sts3.value[0:0];
  endgroup
  covergroup rd_cg3;
    option.per_instance=1;
    rx_data3 : coverpoint rx_data3.value[0:0];
    tx_data3 : coverpoint tx_data3.value[0:0];
    rx_line_sts3 : coverpoint rx_line_sts3.value[0:0];
    mdm_sts3 : coverpoint mdm_sts3.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg3.sample();
    if(is_read) rd_cg3.sample();
  endfunction

  `uvm_register_cb(ua_ier_c3, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c3, uvm_reg)
  `uvm_object_utils(ua_ier_c3)
  function new(input string name="unnamed3-ua_ier_c3");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg3=new;
    rd_cg3=new;
  endfunction : new
endclass : ua_ier_c3

class uart_ctrl_rf_c3 extends uvm_reg_block;

  rand ua_div_latch0_c3 ua_div_latch03;
  rand ua_div_latch1_c3 ua_div_latch13;
  rand ua_int_id_c3 ua_int_id3;
  rand ua_fifo_ctrl_c3 ua_fifo_ctrl3;
  rand ua_lcr_c3 ua_lcr3;
  rand ua_ier_c3 ua_ier3;

  virtual function void build();

    // Now3 create all registers

    ua_div_latch03 = ua_div_latch0_c3::type_id::create("ua_div_latch03", , get_full_name());
    ua_div_latch13 = ua_div_latch1_c3::type_id::create("ua_div_latch13", , get_full_name());
    ua_int_id3 = ua_int_id_c3::type_id::create("ua_int_id3", , get_full_name());
    ua_fifo_ctrl3 = ua_fifo_ctrl_c3::type_id::create("ua_fifo_ctrl3", , get_full_name());
    ua_lcr3 = ua_lcr_c3::type_id::create("ua_lcr3", , get_full_name());
    ua_ier3 = ua_ier_c3::type_id::create("ua_ier3", , get_full_name());

    // Now3 build the registers. Set parent and hdl_paths

    ua_div_latch03.configure(this, null, "dl3[7:0]");
    ua_div_latch03.build();
    ua_div_latch13.configure(this, null, "dl3[15;8]");
    ua_div_latch13.build();
    ua_int_id3.configure(this, null, "iir3");
    ua_int_id3.build();
    ua_fifo_ctrl3.configure(this, null, "fcr3");
    ua_fifo_ctrl3.build();
    ua_lcr3.configure(this, null, "lcr3");
    ua_lcr3.build();
    ua_ier3.configure(this, null, "ier3");
    ua_ier3.build();
    // Now3 define address mappings3
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch03, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch13, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id3, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl3, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr3, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier3, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c3)
  function new(input string name="unnamed3-uart_ctrl_rf3");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c3

//////////////////////////////////////////////////////////////////////////////
// Address_map3 definition3
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c3 extends uvm_reg_block;

  rand uart_ctrl_rf_c3 uart_ctrl_rf3;

  function void build();
    // Now3 define address mappings3
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf3 = uart_ctrl_rf_c3::type_id::create("uart_ctrl_rf3", , get_full_name());
    uart_ctrl_rf3.configure(this, "regs");
    uart_ctrl_rf3.build();
    uart_ctrl_rf3.lock_model();
    default_map.add_submap(uart_ctrl_rf3.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top3.uart_dut3");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c3)
  function new(input string name="unnamed3-uart_ctrl_reg_model_c3");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c3

`endif // UART_CTRL_REGS_SV3
