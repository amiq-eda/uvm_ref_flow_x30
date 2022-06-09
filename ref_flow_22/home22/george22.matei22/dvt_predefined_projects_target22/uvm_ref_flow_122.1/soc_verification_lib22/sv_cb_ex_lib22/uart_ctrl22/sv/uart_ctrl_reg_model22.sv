// This22 file is generated22 using Cadence22 iregGen22 version22 1.05

`ifndef UART_CTRL_REGS_SV22
`define UART_CTRL_REGS_SV22

// Input22 File22: uart_ctrl_regs22.xml22

// Number22 of AddrMaps22 = 1
// Number22 of RegFiles22 = 1
// Number22 of Registers22 = 6
// Number22 of Memories22 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 262


class ua_div_latch0_c22 extends uvm_reg;

  rand uvm_reg_field div_val22;

  constraint c_div_val22 { div_val22.value == 1; }
  virtual function void build();
    div_val22 = uvm_reg_field::type_id::create("div_val22");
    div_val22.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg22.set_inst_name($sformatf("%s.wcov22", get_full_name()));
    rd_cg22.set_inst_name($sformatf("%s.rcov22", get_full_name()));
  endfunction

  covergroup wr_cg22;
    option.per_instance=1;
    div_val22 : coverpoint div_val22.value[7:0];
  endgroup
  covergroup rd_cg22;
    option.per_instance=1;
    div_val22 : coverpoint div_val22.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg22.sample();
    if(is_read) rd_cg22.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c22, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c22, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c22)
  function new(input string name="unnamed22-ua_div_latch0_c22");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg22=new;
    rd_cg22=new;
  endfunction : new
endclass : ua_div_latch0_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 287


class ua_div_latch1_c22 extends uvm_reg;

  rand uvm_reg_field div_val22;

  constraint c_div_val22 { div_val22.value == 0; }
  virtual function void build();
    div_val22 = uvm_reg_field::type_id::create("div_val22");
    div_val22.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg22.set_inst_name($sformatf("%s.wcov22", get_full_name()));
    rd_cg22.set_inst_name($sformatf("%s.rcov22", get_full_name()));
  endfunction

  covergroup wr_cg22;
    option.per_instance=1;
    div_val22 : coverpoint div_val22.value[7:0];
  endgroup
  covergroup rd_cg22;
    option.per_instance=1;
    div_val22 : coverpoint div_val22.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg22.sample();
    if(is_read) rd_cg22.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c22, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c22, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c22)
  function new(input string name="unnamed22-ua_div_latch1_c22");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg22=new;
    rd_cg22=new;
  endfunction : new
endclass : ua_div_latch1_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 82


class ua_int_id_c22 extends uvm_reg;

  uvm_reg_field priority_bit22;
  uvm_reg_field bit122;
  uvm_reg_field bit222;
  uvm_reg_field bit322;

  virtual function void build();
    priority_bit22 = uvm_reg_field::type_id::create("priority_bit22");
    priority_bit22.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit122 = uvm_reg_field::type_id::create("bit122");
    bit122.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit222 = uvm_reg_field::type_id::create("bit222");
    bit222.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit322 = uvm_reg_field::type_id::create("bit322");
    bit322.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg22.set_inst_name($sformatf("%s.rcov22", get_full_name()));
  endfunction

  covergroup rd_cg22;
    option.per_instance=1;
    priority_bit22 : coverpoint priority_bit22.value[0:0];
    bit122 : coverpoint bit122.value[0:0];
    bit222 : coverpoint bit222.value[0:0];
    bit322 : coverpoint bit322.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg22.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c22, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c22, uvm_reg)
  `uvm_object_utils(ua_int_id_c22)
  function new(input string name="unnamed22-ua_int_id_c22");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg22=new;
  endfunction : new
endclass : ua_int_id_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 139


class ua_fifo_ctrl_c22 extends uvm_reg;

  rand uvm_reg_field rx_clear22;
  rand uvm_reg_field tx_clear22;
  rand uvm_reg_field rx_fifo_int_trig_level22;

  virtual function void build();
    rx_clear22 = uvm_reg_field::type_id::create("rx_clear22");
    rx_clear22.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear22 = uvm_reg_field::type_id::create("tx_clear22");
    tx_clear22.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level22 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level22");
    rx_fifo_int_trig_level22.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg22.set_inst_name($sformatf("%s.wcov22", get_full_name()));
  endfunction

  covergroup wr_cg22;
    option.per_instance=1;
    rx_clear22 : coverpoint rx_clear22.value[0:0];
    tx_clear22 : coverpoint tx_clear22.value[0:0];
    rx_fifo_int_trig_level22 : coverpoint rx_fifo_int_trig_level22.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg22.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c22, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c22, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c22)
  function new(input string name="unnamed22-ua_fifo_ctrl_c22");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg22=new;
  endfunction : new
endclass : ua_fifo_ctrl_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 188


class ua_lcr_c22 extends uvm_reg;

  rand uvm_reg_field char_lngth22;
  rand uvm_reg_field num_stop_bits22;
  rand uvm_reg_field p_en22;
  rand uvm_reg_field parity_even22;
  rand uvm_reg_field parity_sticky22;
  rand uvm_reg_field break_ctrl22;
  rand uvm_reg_field div_latch_access22;

  constraint c_char_lngth22 { char_lngth22.value != 2'b00; }
  constraint c_break_ctrl22 { break_ctrl22.value == 1'b0; }
  virtual function void build();
    char_lngth22 = uvm_reg_field::type_id::create("char_lngth22");
    char_lngth22.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits22 = uvm_reg_field::type_id::create("num_stop_bits22");
    num_stop_bits22.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en22 = uvm_reg_field::type_id::create("p_en22");
    p_en22.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even22 = uvm_reg_field::type_id::create("parity_even22");
    parity_even22.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky22 = uvm_reg_field::type_id::create("parity_sticky22");
    parity_sticky22.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl22 = uvm_reg_field::type_id::create("break_ctrl22");
    break_ctrl22.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access22 = uvm_reg_field::type_id::create("div_latch_access22");
    div_latch_access22.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg22.set_inst_name($sformatf("%s.wcov22", get_full_name()));
    rd_cg22.set_inst_name($sformatf("%s.rcov22", get_full_name()));
  endfunction

  covergroup wr_cg22;
    option.per_instance=1;
    char_lngth22 : coverpoint char_lngth22.value[1:0];
    num_stop_bits22 : coverpoint num_stop_bits22.value[0:0];
    p_en22 : coverpoint p_en22.value[0:0];
    parity_even22 : coverpoint parity_even22.value[0:0];
    parity_sticky22 : coverpoint parity_sticky22.value[0:0];
    break_ctrl22 : coverpoint break_ctrl22.value[0:0];
    div_latch_access22 : coverpoint div_latch_access22.value[0:0];
  endgroup
  covergroup rd_cg22;
    option.per_instance=1;
    char_lngth22 : coverpoint char_lngth22.value[1:0];
    num_stop_bits22 : coverpoint num_stop_bits22.value[0:0];
    p_en22 : coverpoint p_en22.value[0:0];
    parity_even22 : coverpoint parity_even22.value[0:0];
    parity_sticky22 : coverpoint parity_sticky22.value[0:0];
    break_ctrl22 : coverpoint break_ctrl22.value[0:0];
    div_latch_access22 : coverpoint div_latch_access22.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg22.sample();
    if(is_read) rd_cg22.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c22, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c22, uvm_reg)
  `uvm_object_utils(ua_lcr_c22)
  function new(input string name="unnamed22-ua_lcr_c22");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg22=new;
    rd_cg22=new;
  endfunction : new
endclass : ua_lcr_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 25


class ua_ier_c22 extends uvm_reg;

  rand uvm_reg_field rx_data22;
  rand uvm_reg_field tx_data22;
  rand uvm_reg_field rx_line_sts22;
  rand uvm_reg_field mdm_sts22;

  virtual function void build();
    rx_data22 = uvm_reg_field::type_id::create("rx_data22");
    rx_data22.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data22 = uvm_reg_field::type_id::create("tx_data22");
    tx_data22.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts22 = uvm_reg_field::type_id::create("rx_line_sts22");
    rx_line_sts22.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts22 = uvm_reg_field::type_id::create("mdm_sts22");
    mdm_sts22.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg22.set_inst_name($sformatf("%s.wcov22", get_full_name()));
    rd_cg22.set_inst_name($sformatf("%s.rcov22", get_full_name()));
  endfunction

  covergroup wr_cg22;
    option.per_instance=1;
    rx_data22 : coverpoint rx_data22.value[0:0];
    tx_data22 : coverpoint tx_data22.value[0:0];
    rx_line_sts22 : coverpoint rx_line_sts22.value[0:0];
    mdm_sts22 : coverpoint mdm_sts22.value[0:0];
  endgroup
  covergroup rd_cg22;
    option.per_instance=1;
    rx_data22 : coverpoint rx_data22.value[0:0];
    tx_data22 : coverpoint tx_data22.value[0:0];
    rx_line_sts22 : coverpoint rx_line_sts22.value[0:0];
    mdm_sts22 : coverpoint mdm_sts22.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg22.sample();
    if(is_read) rd_cg22.sample();
  endfunction

  `uvm_register_cb(ua_ier_c22, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c22, uvm_reg)
  `uvm_object_utils(ua_ier_c22)
  function new(input string name="unnamed22-ua_ier_c22");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg22=new;
    rd_cg22=new;
  endfunction : new
endclass : ua_ier_c22

class uart_ctrl_rf_c22 extends uvm_reg_block;

  rand ua_div_latch0_c22 ua_div_latch022;
  rand ua_div_latch1_c22 ua_div_latch122;
  rand ua_int_id_c22 ua_int_id22;
  rand ua_fifo_ctrl_c22 ua_fifo_ctrl22;
  rand ua_lcr_c22 ua_lcr22;
  rand ua_ier_c22 ua_ier22;

  virtual function void build();

    // Now22 create all registers

    ua_div_latch022 = ua_div_latch0_c22::type_id::create("ua_div_latch022", , get_full_name());
    ua_div_latch122 = ua_div_latch1_c22::type_id::create("ua_div_latch122", , get_full_name());
    ua_int_id22 = ua_int_id_c22::type_id::create("ua_int_id22", , get_full_name());
    ua_fifo_ctrl22 = ua_fifo_ctrl_c22::type_id::create("ua_fifo_ctrl22", , get_full_name());
    ua_lcr22 = ua_lcr_c22::type_id::create("ua_lcr22", , get_full_name());
    ua_ier22 = ua_ier_c22::type_id::create("ua_ier22", , get_full_name());

    // Now22 build the registers. Set parent and hdl_paths

    ua_div_latch022.configure(this, null, "dl22[7:0]");
    ua_div_latch022.build();
    ua_div_latch122.configure(this, null, "dl22[15;8]");
    ua_div_latch122.build();
    ua_int_id22.configure(this, null, "iir22");
    ua_int_id22.build();
    ua_fifo_ctrl22.configure(this, null, "fcr22");
    ua_fifo_ctrl22.build();
    ua_lcr22.configure(this, null, "lcr22");
    ua_lcr22.build();
    ua_ier22.configure(this, null, "ier22");
    ua_ier22.build();
    // Now22 define address mappings22
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch022, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch122, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id22, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl22, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr22, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier22, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c22)
  function new(input string name="unnamed22-uart_ctrl_rf22");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c22

//////////////////////////////////////////////////////////////////////////////
// Address_map22 definition22
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c22 extends uvm_reg_block;

  rand uart_ctrl_rf_c22 uart_ctrl_rf22;

  function void build();
    // Now22 define address mappings22
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf22 = uart_ctrl_rf_c22::type_id::create("uart_ctrl_rf22", , get_full_name());
    uart_ctrl_rf22.configure(this, "regs");
    uart_ctrl_rf22.build();
    uart_ctrl_rf22.lock_model();
    default_map.add_submap(uart_ctrl_rf22.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top22.uart_dut22");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c22)
  function new(input string name="unnamed22-uart_ctrl_reg_model_c22");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c22

`endif // UART_CTRL_REGS_SV22
