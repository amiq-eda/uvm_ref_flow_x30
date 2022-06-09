// This5 file is generated5 using Cadence5 iregGen5 version5 1.05

`ifndef UART_CTRL_REGS_SV5
`define UART_CTRL_REGS_SV5

// Input5 File5: uart_ctrl_regs5.xml5

// Number5 of AddrMaps5 = 1
// Number5 of RegFiles5 = 1
// Number5 of Registers5 = 6
// Number5 of Memories5 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 262


class ua_div_latch0_c5 extends uvm_reg;

  rand uvm_reg_field div_val5;

  constraint c_div_val5 { div_val5.value == 1; }
  virtual function void build();
    div_val5 = uvm_reg_field::type_id::create("div_val5");
    div_val5.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg5.set_inst_name($sformatf("%s.wcov5", get_full_name()));
    rd_cg5.set_inst_name($sformatf("%s.rcov5", get_full_name()));
  endfunction

  covergroup wr_cg5;
    option.per_instance=1;
    div_val5 : coverpoint div_val5.value[7:0];
  endgroup
  covergroup rd_cg5;
    option.per_instance=1;
    div_val5 : coverpoint div_val5.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg5.sample();
    if(is_read) rd_cg5.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c5, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c5, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c5)
  function new(input string name="unnamed5-ua_div_latch0_c5");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg5=new;
    rd_cg5=new;
  endfunction : new
endclass : ua_div_latch0_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 287


class ua_div_latch1_c5 extends uvm_reg;

  rand uvm_reg_field div_val5;

  constraint c_div_val5 { div_val5.value == 0; }
  virtual function void build();
    div_val5 = uvm_reg_field::type_id::create("div_val5");
    div_val5.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg5.set_inst_name($sformatf("%s.wcov5", get_full_name()));
    rd_cg5.set_inst_name($sformatf("%s.rcov5", get_full_name()));
  endfunction

  covergroup wr_cg5;
    option.per_instance=1;
    div_val5 : coverpoint div_val5.value[7:0];
  endgroup
  covergroup rd_cg5;
    option.per_instance=1;
    div_val5 : coverpoint div_val5.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg5.sample();
    if(is_read) rd_cg5.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c5, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c5, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c5)
  function new(input string name="unnamed5-ua_div_latch1_c5");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg5=new;
    rd_cg5=new;
  endfunction : new
endclass : ua_div_latch1_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 82


class ua_int_id_c5 extends uvm_reg;

  uvm_reg_field priority_bit5;
  uvm_reg_field bit15;
  uvm_reg_field bit25;
  uvm_reg_field bit35;

  virtual function void build();
    priority_bit5 = uvm_reg_field::type_id::create("priority_bit5");
    priority_bit5.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit15 = uvm_reg_field::type_id::create("bit15");
    bit15.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit25 = uvm_reg_field::type_id::create("bit25");
    bit25.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit35 = uvm_reg_field::type_id::create("bit35");
    bit35.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg5.set_inst_name($sformatf("%s.rcov5", get_full_name()));
  endfunction

  covergroup rd_cg5;
    option.per_instance=1;
    priority_bit5 : coverpoint priority_bit5.value[0:0];
    bit15 : coverpoint bit15.value[0:0];
    bit25 : coverpoint bit25.value[0:0];
    bit35 : coverpoint bit35.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg5.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c5, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c5, uvm_reg)
  `uvm_object_utils(ua_int_id_c5)
  function new(input string name="unnamed5-ua_int_id_c5");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg5=new;
  endfunction : new
endclass : ua_int_id_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 139


class ua_fifo_ctrl_c5 extends uvm_reg;

  rand uvm_reg_field rx_clear5;
  rand uvm_reg_field tx_clear5;
  rand uvm_reg_field rx_fifo_int_trig_level5;

  virtual function void build();
    rx_clear5 = uvm_reg_field::type_id::create("rx_clear5");
    rx_clear5.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear5 = uvm_reg_field::type_id::create("tx_clear5");
    tx_clear5.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level5 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level5");
    rx_fifo_int_trig_level5.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg5.set_inst_name($sformatf("%s.wcov5", get_full_name()));
  endfunction

  covergroup wr_cg5;
    option.per_instance=1;
    rx_clear5 : coverpoint rx_clear5.value[0:0];
    tx_clear5 : coverpoint tx_clear5.value[0:0];
    rx_fifo_int_trig_level5 : coverpoint rx_fifo_int_trig_level5.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg5.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c5, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c5, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c5)
  function new(input string name="unnamed5-ua_fifo_ctrl_c5");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg5=new;
  endfunction : new
endclass : ua_fifo_ctrl_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 188


class ua_lcr_c5 extends uvm_reg;

  rand uvm_reg_field char_lngth5;
  rand uvm_reg_field num_stop_bits5;
  rand uvm_reg_field p_en5;
  rand uvm_reg_field parity_even5;
  rand uvm_reg_field parity_sticky5;
  rand uvm_reg_field break_ctrl5;
  rand uvm_reg_field div_latch_access5;

  constraint c_char_lngth5 { char_lngth5.value != 2'b00; }
  constraint c_break_ctrl5 { break_ctrl5.value == 1'b0; }
  virtual function void build();
    char_lngth5 = uvm_reg_field::type_id::create("char_lngth5");
    char_lngth5.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits5 = uvm_reg_field::type_id::create("num_stop_bits5");
    num_stop_bits5.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en5 = uvm_reg_field::type_id::create("p_en5");
    p_en5.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even5 = uvm_reg_field::type_id::create("parity_even5");
    parity_even5.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky5 = uvm_reg_field::type_id::create("parity_sticky5");
    parity_sticky5.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl5 = uvm_reg_field::type_id::create("break_ctrl5");
    break_ctrl5.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access5 = uvm_reg_field::type_id::create("div_latch_access5");
    div_latch_access5.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg5.set_inst_name($sformatf("%s.wcov5", get_full_name()));
    rd_cg5.set_inst_name($sformatf("%s.rcov5", get_full_name()));
  endfunction

  covergroup wr_cg5;
    option.per_instance=1;
    char_lngth5 : coverpoint char_lngth5.value[1:0];
    num_stop_bits5 : coverpoint num_stop_bits5.value[0:0];
    p_en5 : coverpoint p_en5.value[0:0];
    parity_even5 : coverpoint parity_even5.value[0:0];
    parity_sticky5 : coverpoint parity_sticky5.value[0:0];
    break_ctrl5 : coverpoint break_ctrl5.value[0:0];
    div_latch_access5 : coverpoint div_latch_access5.value[0:0];
  endgroup
  covergroup rd_cg5;
    option.per_instance=1;
    char_lngth5 : coverpoint char_lngth5.value[1:0];
    num_stop_bits5 : coverpoint num_stop_bits5.value[0:0];
    p_en5 : coverpoint p_en5.value[0:0];
    parity_even5 : coverpoint parity_even5.value[0:0];
    parity_sticky5 : coverpoint parity_sticky5.value[0:0];
    break_ctrl5 : coverpoint break_ctrl5.value[0:0];
    div_latch_access5 : coverpoint div_latch_access5.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg5.sample();
    if(is_read) rd_cg5.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c5, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c5, uvm_reg)
  `uvm_object_utils(ua_lcr_c5)
  function new(input string name="unnamed5-ua_lcr_c5");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg5=new;
    rd_cg5=new;
  endfunction : new
endclass : ua_lcr_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 25


class ua_ier_c5 extends uvm_reg;

  rand uvm_reg_field rx_data5;
  rand uvm_reg_field tx_data5;
  rand uvm_reg_field rx_line_sts5;
  rand uvm_reg_field mdm_sts5;

  virtual function void build();
    rx_data5 = uvm_reg_field::type_id::create("rx_data5");
    rx_data5.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data5 = uvm_reg_field::type_id::create("tx_data5");
    tx_data5.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts5 = uvm_reg_field::type_id::create("rx_line_sts5");
    rx_line_sts5.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts5 = uvm_reg_field::type_id::create("mdm_sts5");
    mdm_sts5.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg5.set_inst_name($sformatf("%s.wcov5", get_full_name()));
    rd_cg5.set_inst_name($sformatf("%s.rcov5", get_full_name()));
  endfunction

  covergroup wr_cg5;
    option.per_instance=1;
    rx_data5 : coverpoint rx_data5.value[0:0];
    tx_data5 : coverpoint tx_data5.value[0:0];
    rx_line_sts5 : coverpoint rx_line_sts5.value[0:0];
    mdm_sts5 : coverpoint mdm_sts5.value[0:0];
  endgroup
  covergroup rd_cg5;
    option.per_instance=1;
    rx_data5 : coverpoint rx_data5.value[0:0];
    tx_data5 : coverpoint tx_data5.value[0:0];
    rx_line_sts5 : coverpoint rx_line_sts5.value[0:0];
    mdm_sts5 : coverpoint mdm_sts5.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg5.sample();
    if(is_read) rd_cg5.sample();
  endfunction

  `uvm_register_cb(ua_ier_c5, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c5, uvm_reg)
  `uvm_object_utils(ua_ier_c5)
  function new(input string name="unnamed5-ua_ier_c5");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg5=new;
    rd_cg5=new;
  endfunction : new
endclass : ua_ier_c5

class uart_ctrl_rf_c5 extends uvm_reg_block;

  rand ua_div_latch0_c5 ua_div_latch05;
  rand ua_div_latch1_c5 ua_div_latch15;
  rand ua_int_id_c5 ua_int_id5;
  rand ua_fifo_ctrl_c5 ua_fifo_ctrl5;
  rand ua_lcr_c5 ua_lcr5;
  rand ua_ier_c5 ua_ier5;

  virtual function void build();

    // Now5 create all registers

    ua_div_latch05 = ua_div_latch0_c5::type_id::create("ua_div_latch05", , get_full_name());
    ua_div_latch15 = ua_div_latch1_c5::type_id::create("ua_div_latch15", , get_full_name());
    ua_int_id5 = ua_int_id_c5::type_id::create("ua_int_id5", , get_full_name());
    ua_fifo_ctrl5 = ua_fifo_ctrl_c5::type_id::create("ua_fifo_ctrl5", , get_full_name());
    ua_lcr5 = ua_lcr_c5::type_id::create("ua_lcr5", , get_full_name());
    ua_ier5 = ua_ier_c5::type_id::create("ua_ier5", , get_full_name());

    // Now5 build the registers. Set parent and hdl_paths

    ua_div_latch05.configure(this, null, "dl5[7:0]");
    ua_div_latch05.build();
    ua_div_latch15.configure(this, null, "dl5[15;8]");
    ua_div_latch15.build();
    ua_int_id5.configure(this, null, "iir5");
    ua_int_id5.build();
    ua_fifo_ctrl5.configure(this, null, "fcr5");
    ua_fifo_ctrl5.build();
    ua_lcr5.configure(this, null, "lcr5");
    ua_lcr5.build();
    ua_ier5.configure(this, null, "ier5");
    ua_ier5.build();
    // Now5 define address mappings5
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch05, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch15, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id5, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl5, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr5, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier5, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c5)
  function new(input string name="unnamed5-uart_ctrl_rf5");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c5

//////////////////////////////////////////////////////////////////////////////
// Address_map5 definition5
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c5 extends uvm_reg_block;

  rand uart_ctrl_rf_c5 uart_ctrl_rf5;

  function void build();
    // Now5 define address mappings5
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf5 = uart_ctrl_rf_c5::type_id::create("uart_ctrl_rf5", , get_full_name());
    uart_ctrl_rf5.configure(this, "regs");
    uart_ctrl_rf5.build();
    uart_ctrl_rf5.lock_model();
    default_map.add_submap(uart_ctrl_rf5.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top5.uart_dut5");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c5)
  function new(input string name="unnamed5-uart_ctrl_reg_model_c5");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c5

`endif // UART_CTRL_REGS_SV5
