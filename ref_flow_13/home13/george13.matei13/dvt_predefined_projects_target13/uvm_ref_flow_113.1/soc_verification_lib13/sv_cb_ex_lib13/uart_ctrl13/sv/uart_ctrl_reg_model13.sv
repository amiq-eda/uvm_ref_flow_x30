// This13 file is generated13 using Cadence13 iregGen13 version13 1.05

`ifndef UART_CTRL_REGS_SV13
`define UART_CTRL_REGS_SV13

// Input13 File13: uart_ctrl_regs13.xml13

// Number13 of AddrMaps13 = 1
// Number13 of RegFiles13 = 1
// Number13 of Registers13 = 6
// Number13 of Memories13 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 262


class ua_div_latch0_c13 extends uvm_reg;

  rand uvm_reg_field div_val13;

  constraint c_div_val13 { div_val13.value == 1; }
  virtual function void build();
    div_val13 = uvm_reg_field::type_id::create("div_val13");
    div_val13.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg13.set_inst_name($sformatf("%s.wcov13", get_full_name()));
    rd_cg13.set_inst_name($sformatf("%s.rcov13", get_full_name()));
  endfunction

  covergroup wr_cg13;
    option.per_instance=1;
    div_val13 : coverpoint div_val13.value[7:0];
  endgroup
  covergroup rd_cg13;
    option.per_instance=1;
    div_val13 : coverpoint div_val13.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg13.sample();
    if(is_read) rd_cg13.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c13, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c13, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c13)
  function new(input string name="unnamed13-ua_div_latch0_c13");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg13=new;
    rd_cg13=new;
  endfunction : new
endclass : ua_div_latch0_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 287


class ua_div_latch1_c13 extends uvm_reg;

  rand uvm_reg_field div_val13;

  constraint c_div_val13 { div_val13.value == 0; }
  virtual function void build();
    div_val13 = uvm_reg_field::type_id::create("div_val13");
    div_val13.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg13.set_inst_name($sformatf("%s.wcov13", get_full_name()));
    rd_cg13.set_inst_name($sformatf("%s.rcov13", get_full_name()));
  endfunction

  covergroup wr_cg13;
    option.per_instance=1;
    div_val13 : coverpoint div_val13.value[7:0];
  endgroup
  covergroup rd_cg13;
    option.per_instance=1;
    div_val13 : coverpoint div_val13.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg13.sample();
    if(is_read) rd_cg13.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c13, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c13, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c13)
  function new(input string name="unnamed13-ua_div_latch1_c13");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg13=new;
    rd_cg13=new;
  endfunction : new
endclass : ua_div_latch1_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 82


class ua_int_id_c13 extends uvm_reg;

  uvm_reg_field priority_bit13;
  uvm_reg_field bit113;
  uvm_reg_field bit213;
  uvm_reg_field bit313;

  virtual function void build();
    priority_bit13 = uvm_reg_field::type_id::create("priority_bit13");
    priority_bit13.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit113 = uvm_reg_field::type_id::create("bit113");
    bit113.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit213 = uvm_reg_field::type_id::create("bit213");
    bit213.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit313 = uvm_reg_field::type_id::create("bit313");
    bit313.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg13.set_inst_name($sformatf("%s.rcov13", get_full_name()));
  endfunction

  covergroup rd_cg13;
    option.per_instance=1;
    priority_bit13 : coverpoint priority_bit13.value[0:0];
    bit113 : coverpoint bit113.value[0:0];
    bit213 : coverpoint bit213.value[0:0];
    bit313 : coverpoint bit313.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg13.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c13, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c13, uvm_reg)
  `uvm_object_utils(ua_int_id_c13)
  function new(input string name="unnamed13-ua_int_id_c13");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg13=new;
  endfunction : new
endclass : ua_int_id_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 139


class ua_fifo_ctrl_c13 extends uvm_reg;

  rand uvm_reg_field rx_clear13;
  rand uvm_reg_field tx_clear13;
  rand uvm_reg_field rx_fifo_int_trig_level13;

  virtual function void build();
    rx_clear13 = uvm_reg_field::type_id::create("rx_clear13");
    rx_clear13.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear13 = uvm_reg_field::type_id::create("tx_clear13");
    tx_clear13.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level13 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level13");
    rx_fifo_int_trig_level13.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg13.set_inst_name($sformatf("%s.wcov13", get_full_name()));
  endfunction

  covergroup wr_cg13;
    option.per_instance=1;
    rx_clear13 : coverpoint rx_clear13.value[0:0];
    tx_clear13 : coverpoint tx_clear13.value[0:0];
    rx_fifo_int_trig_level13 : coverpoint rx_fifo_int_trig_level13.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg13.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c13, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c13, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c13)
  function new(input string name="unnamed13-ua_fifo_ctrl_c13");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg13=new;
  endfunction : new
endclass : ua_fifo_ctrl_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 188


class ua_lcr_c13 extends uvm_reg;

  rand uvm_reg_field char_lngth13;
  rand uvm_reg_field num_stop_bits13;
  rand uvm_reg_field p_en13;
  rand uvm_reg_field parity_even13;
  rand uvm_reg_field parity_sticky13;
  rand uvm_reg_field break_ctrl13;
  rand uvm_reg_field div_latch_access13;

  constraint c_char_lngth13 { char_lngth13.value != 2'b00; }
  constraint c_break_ctrl13 { break_ctrl13.value == 1'b0; }
  virtual function void build();
    char_lngth13 = uvm_reg_field::type_id::create("char_lngth13");
    char_lngth13.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits13 = uvm_reg_field::type_id::create("num_stop_bits13");
    num_stop_bits13.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en13 = uvm_reg_field::type_id::create("p_en13");
    p_en13.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even13 = uvm_reg_field::type_id::create("parity_even13");
    parity_even13.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky13 = uvm_reg_field::type_id::create("parity_sticky13");
    parity_sticky13.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl13 = uvm_reg_field::type_id::create("break_ctrl13");
    break_ctrl13.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access13 = uvm_reg_field::type_id::create("div_latch_access13");
    div_latch_access13.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg13.set_inst_name($sformatf("%s.wcov13", get_full_name()));
    rd_cg13.set_inst_name($sformatf("%s.rcov13", get_full_name()));
  endfunction

  covergroup wr_cg13;
    option.per_instance=1;
    char_lngth13 : coverpoint char_lngth13.value[1:0];
    num_stop_bits13 : coverpoint num_stop_bits13.value[0:0];
    p_en13 : coverpoint p_en13.value[0:0];
    parity_even13 : coverpoint parity_even13.value[0:0];
    parity_sticky13 : coverpoint parity_sticky13.value[0:0];
    break_ctrl13 : coverpoint break_ctrl13.value[0:0];
    div_latch_access13 : coverpoint div_latch_access13.value[0:0];
  endgroup
  covergroup rd_cg13;
    option.per_instance=1;
    char_lngth13 : coverpoint char_lngth13.value[1:0];
    num_stop_bits13 : coverpoint num_stop_bits13.value[0:0];
    p_en13 : coverpoint p_en13.value[0:0];
    parity_even13 : coverpoint parity_even13.value[0:0];
    parity_sticky13 : coverpoint parity_sticky13.value[0:0];
    break_ctrl13 : coverpoint break_ctrl13.value[0:0];
    div_latch_access13 : coverpoint div_latch_access13.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg13.sample();
    if(is_read) rd_cg13.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c13, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c13, uvm_reg)
  `uvm_object_utils(ua_lcr_c13)
  function new(input string name="unnamed13-ua_lcr_c13");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg13=new;
    rd_cg13=new;
  endfunction : new
endclass : ua_lcr_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 25


class ua_ier_c13 extends uvm_reg;

  rand uvm_reg_field rx_data13;
  rand uvm_reg_field tx_data13;
  rand uvm_reg_field rx_line_sts13;
  rand uvm_reg_field mdm_sts13;

  virtual function void build();
    rx_data13 = uvm_reg_field::type_id::create("rx_data13");
    rx_data13.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data13 = uvm_reg_field::type_id::create("tx_data13");
    tx_data13.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts13 = uvm_reg_field::type_id::create("rx_line_sts13");
    rx_line_sts13.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts13 = uvm_reg_field::type_id::create("mdm_sts13");
    mdm_sts13.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg13.set_inst_name($sformatf("%s.wcov13", get_full_name()));
    rd_cg13.set_inst_name($sformatf("%s.rcov13", get_full_name()));
  endfunction

  covergroup wr_cg13;
    option.per_instance=1;
    rx_data13 : coverpoint rx_data13.value[0:0];
    tx_data13 : coverpoint tx_data13.value[0:0];
    rx_line_sts13 : coverpoint rx_line_sts13.value[0:0];
    mdm_sts13 : coverpoint mdm_sts13.value[0:0];
  endgroup
  covergroup rd_cg13;
    option.per_instance=1;
    rx_data13 : coverpoint rx_data13.value[0:0];
    tx_data13 : coverpoint tx_data13.value[0:0];
    rx_line_sts13 : coverpoint rx_line_sts13.value[0:0];
    mdm_sts13 : coverpoint mdm_sts13.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg13.sample();
    if(is_read) rd_cg13.sample();
  endfunction

  `uvm_register_cb(ua_ier_c13, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c13, uvm_reg)
  `uvm_object_utils(ua_ier_c13)
  function new(input string name="unnamed13-ua_ier_c13");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg13=new;
    rd_cg13=new;
  endfunction : new
endclass : ua_ier_c13

class uart_ctrl_rf_c13 extends uvm_reg_block;

  rand ua_div_latch0_c13 ua_div_latch013;
  rand ua_div_latch1_c13 ua_div_latch113;
  rand ua_int_id_c13 ua_int_id13;
  rand ua_fifo_ctrl_c13 ua_fifo_ctrl13;
  rand ua_lcr_c13 ua_lcr13;
  rand ua_ier_c13 ua_ier13;

  virtual function void build();

    // Now13 create all registers

    ua_div_latch013 = ua_div_latch0_c13::type_id::create("ua_div_latch013", , get_full_name());
    ua_div_latch113 = ua_div_latch1_c13::type_id::create("ua_div_latch113", , get_full_name());
    ua_int_id13 = ua_int_id_c13::type_id::create("ua_int_id13", , get_full_name());
    ua_fifo_ctrl13 = ua_fifo_ctrl_c13::type_id::create("ua_fifo_ctrl13", , get_full_name());
    ua_lcr13 = ua_lcr_c13::type_id::create("ua_lcr13", , get_full_name());
    ua_ier13 = ua_ier_c13::type_id::create("ua_ier13", , get_full_name());

    // Now13 build the registers. Set parent and hdl_paths

    ua_div_latch013.configure(this, null, "dl13[7:0]");
    ua_div_latch013.build();
    ua_div_latch113.configure(this, null, "dl13[15;8]");
    ua_div_latch113.build();
    ua_int_id13.configure(this, null, "iir13");
    ua_int_id13.build();
    ua_fifo_ctrl13.configure(this, null, "fcr13");
    ua_fifo_ctrl13.build();
    ua_lcr13.configure(this, null, "lcr13");
    ua_lcr13.build();
    ua_ier13.configure(this, null, "ier13");
    ua_ier13.build();
    // Now13 define address mappings13
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch013, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch113, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id13, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl13, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr13, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier13, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c13)
  function new(input string name="unnamed13-uart_ctrl_rf13");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c13

//////////////////////////////////////////////////////////////////////////////
// Address_map13 definition13
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c13 extends uvm_reg_block;

  rand uart_ctrl_rf_c13 uart_ctrl_rf13;

  function void build();
    // Now13 define address mappings13
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf13 = uart_ctrl_rf_c13::type_id::create("uart_ctrl_rf13", , get_full_name());
    uart_ctrl_rf13.configure(this, "regs");
    uart_ctrl_rf13.build();
    uart_ctrl_rf13.lock_model();
    default_map.add_submap(uart_ctrl_rf13.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top13.uart_dut13");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c13)
  function new(input string name="unnamed13-uart_ctrl_reg_model_c13");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c13

`endif // UART_CTRL_REGS_SV13
