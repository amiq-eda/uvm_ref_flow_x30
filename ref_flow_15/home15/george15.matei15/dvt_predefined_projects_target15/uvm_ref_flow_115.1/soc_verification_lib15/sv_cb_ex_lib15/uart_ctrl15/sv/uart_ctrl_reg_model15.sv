// This15 file is generated15 using Cadence15 iregGen15 version15 1.05

`ifndef UART_CTRL_REGS_SV15
`define UART_CTRL_REGS_SV15

// Input15 File15: uart_ctrl_regs15.xml15

// Number15 of AddrMaps15 = 1
// Number15 of RegFiles15 = 1
// Number15 of Registers15 = 6
// Number15 of Memories15 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 262


class ua_div_latch0_c15 extends uvm_reg;

  rand uvm_reg_field div_val15;

  constraint c_div_val15 { div_val15.value == 1; }
  virtual function void build();
    div_val15 = uvm_reg_field::type_id::create("div_val15");
    div_val15.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg15.set_inst_name($sformatf("%s.wcov15", get_full_name()));
    rd_cg15.set_inst_name($sformatf("%s.rcov15", get_full_name()));
  endfunction

  covergroup wr_cg15;
    option.per_instance=1;
    div_val15 : coverpoint div_val15.value[7:0];
  endgroup
  covergroup rd_cg15;
    option.per_instance=1;
    div_val15 : coverpoint div_val15.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg15.sample();
    if(is_read) rd_cg15.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c15, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c15, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c15)
  function new(input string name="unnamed15-ua_div_latch0_c15");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg15=new;
    rd_cg15=new;
  endfunction : new
endclass : ua_div_latch0_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 287


class ua_div_latch1_c15 extends uvm_reg;

  rand uvm_reg_field div_val15;

  constraint c_div_val15 { div_val15.value == 0; }
  virtual function void build();
    div_val15 = uvm_reg_field::type_id::create("div_val15");
    div_val15.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg15.set_inst_name($sformatf("%s.wcov15", get_full_name()));
    rd_cg15.set_inst_name($sformatf("%s.rcov15", get_full_name()));
  endfunction

  covergroup wr_cg15;
    option.per_instance=1;
    div_val15 : coverpoint div_val15.value[7:0];
  endgroup
  covergroup rd_cg15;
    option.per_instance=1;
    div_val15 : coverpoint div_val15.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg15.sample();
    if(is_read) rd_cg15.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c15, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c15, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c15)
  function new(input string name="unnamed15-ua_div_latch1_c15");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg15=new;
    rd_cg15=new;
  endfunction : new
endclass : ua_div_latch1_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 82


class ua_int_id_c15 extends uvm_reg;

  uvm_reg_field priority_bit15;
  uvm_reg_field bit115;
  uvm_reg_field bit215;
  uvm_reg_field bit315;

  virtual function void build();
    priority_bit15 = uvm_reg_field::type_id::create("priority_bit15");
    priority_bit15.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit115 = uvm_reg_field::type_id::create("bit115");
    bit115.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit215 = uvm_reg_field::type_id::create("bit215");
    bit215.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit315 = uvm_reg_field::type_id::create("bit315");
    bit315.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg15.set_inst_name($sformatf("%s.rcov15", get_full_name()));
  endfunction

  covergroup rd_cg15;
    option.per_instance=1;
    priority_bit15 : coverpoint priority_bit15.value[0:0];
    bit115 : coverpoint bit115.value[0:0];
    bit215 : coverpoint bit215.value[0:0];
    bit315 : coverpoint bit315.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg15.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c15, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c15, uvm_reg)
  `uvm_object_utils(ua_int_id_c15)
  function new(input string name="unnamed15-ua_int_id_c15");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg15=new;
  endfunction : new
endclass : ua_int_id_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 139


class ua_fifo_ctrl_c15 extends uvm_reg;

  rand uvm_reg_field rx_clear15;
  rand uvm_reg_field tx_clear15;
  rand uvm_reg_field rx_fifo_int_trig_level15;

  virtual function void build();
    rx_clear15 = uvm_reg_field::type_id::create("rx_clear15");
    rx_clear15.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear15 = uvm_reg_field::type_id::create("tx_clear15");
    tx_clear15.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level15 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level15");
    rx_fifo_int_trig_level15.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg15.set_inst_name($sformatf("%s.wcov15", get_full_name()));
  endfunction

  covergroup wr_cg15;
    option.per_instance=1;
    rx_clear15 : coverpoint rx_clear15.value[0:0];
    tx_clear15 : coverpoint tx_clear15.value[0:0];
    rx_fifo_int_trig_level15 : coverpoint rx_fifo_int_trig_level15.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg15.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c15, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c15, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c15)
  function new(input string name="unnamed15-ua_fifo_ctrl_c15");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg15=new;
  endfunction : new
endclass : ua_fifo_ctrl_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 188


class ua_lcr_c15 extends uvm_reg;

  rand uvm_reg_field char_lngth15;
  rand uvm_reg_field num_stop_bits15;
  rand uvm_reg_field p_en15;
  rand uvm_reg_field parity_even15;
  rand uvm_reg_field parity_sticky15;
  rand uvm_reg_field break_ctrl15;
  rand uvm_reg_field div_latch_access15;

  constraint c_char_lngth15 { char_lngth15.value != 2'b00; }
  constraint c_break_ctrl15 { break_ctrl15.value == 1'b0; }
  virtual function void build();
    char_lngth15 = uvm_reg_field::type_id::create("char_lngth15");
    char_lngth15.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits15 = uvm_reg_field::type_id::create("num_stop_bits15");
    num_stop_bits15.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en15 = uvm_reg_field::type_id::create("p_en15");
    p_en15.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even15 = uvm_reg_field::type_id::create("parity_even15");
    parity_even15.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky15 = uvm_reg_field::type_id::create("parity_sticky15");
    parity_sticky15.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl15 = uvm_reg_field::type_id::create("break_ctrl15");
    break_ctrl15.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access15 = uvm_reg_field::type_id::create("div_latch_access15");
    div_latch_access15.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg15.set_inst_name($sformatf("%s.wcov15", get_full_name()));
    rd_cg15.set_inst_name($sformatf("%s.rcov15", get_full_name()));
  endfunction

  covergroup wr_cg15;
    option.per_instance=1;
    char_lngth15 : coverpoint char_lngth15.value[1:0];
    num_stop_bits15 : coverpoint num_stop_bits15.value[0:0];
    p_en15 : coverpoint p_en15.value[0:0];
    parity_even15 : coverpoint parity_even15.value[0:0];
    parity_sticky15 : coverpoint parity_sticky15.value[0:0];
    break_ctrl15 : coverpoint break_ctrl15.value[0:0];
    div_latch_access15 : coverpoint div_latch_access15.value[0:0];
  endgroup
  covergroup rd_cg15;
    option.per_instance=1;
    char_lngth15 : coverpoint char_lngth15.value[1:0];
    num_stop_bits15 : coverpoint num_stop_bits15.value[0:0];
    p_en15 : coverpoint p_en15.value[0:0];
    parity_even15 : coverpoint parity_even15.value[0:0];
    parity_sticky15 : coverpoint parity_sticky15.value[0:0];
    break_ctrl15 : coverpoint break_ctrl15.value[0:0];
    div_latch_access15 : coverpoint div_latch_access15.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg15.sample();
    if(is_read) rd_cg15.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c15, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c15, uvm_reg)
  `uvm_object_utils(ua_lcr_c15)
  function new(input string name="unnamed15-ua_lcr_c15");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg15=new;
    rd_cg15=new;
  endfunction : new
endclass : ua_lcr_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 25


class ua_ier_c15 extends uvm_reg;

  rand uvm_reg_field rx_data15;
  rand uvm_reg_field tx_data15;
  rand uvm_reg_field rx_line_sts15;
  rand uvm_reg_field mdm_sts15;

  virtual function void build();
    rx_data15 = uvm_reg_field::type_id::create("rx_data15");
    rx_data15.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data15 = uvm_reg_field::type_id::create("tx_data15");
    tx_data15.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts15 = uvm_reg_field::type_id::create("rx_line_sts15");
    rx_line_sts15.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts15 = uvm_reg_field::type_id::create("mdm_sts15");
    mdm_sts15.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg15.set_inst_name($sformatf("%s.wcov15", get_full_name()));
    rd_cg15.set_inst_name($sformatf("%s.rcov15", get_full_name()));
  endfunction

  covergroup wr_cg15;
    option.per_instance=1;
    rx_data15 : coverpoint rx_data15.value[0:0];
    tx_data15 : coverpoint tx_data15.value[0:0];
    rx_line_sts15 : coverpoint rx_line_sts15.value[0:0];
    mdm_sts15 : coverpoint mdm_sts15.value[0:0];
  endgroup
  covergroup rd_cg15;
    option.per_instance=1;
    rx_data15 : coverpoint rx_data15.value[0:0];
    tx_data15 : coverpoint tx_data15.value[0:0];
    rx_line_sts15 : coverpoint rx_line_sts15.value[0:0];
    mdm_sts15 : coverpoint mdm_sts15.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg15.sample();
    if(is_read) rd_cg15.sample();
  endfunction

  `uvm_register_cb(ua_ier_c15, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c15, uvm_reg)
  `uvm_object_utils(ua_ier_c15)
  function new(input string name="unnamed15-ua_ier_c15");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg15=new;
    rd_cg15=new;
  endfunction : new
endclass : ua_ier_c15

class uart_ctrl_rf_c15 extends uvm_reg_block;

  rand ua_div_latch0_c15 ua_div_latch015;
  rand ua_div_latch1_c15 ua_div_latch115;
  rand ua_int_id_c15 ua_int_id15;
  rand ua_fifo_ctrl_c15 ua_fifo_ctrl15;
  rand ua_lcr_c15 ua_lcr15;
  rand ua_ier_c15 ua_ier15;

  virtual function void build();

    // Now15 create all registers

    ua_div_latch015 = ua_div_latch0_c15::type_id::create("ua_div_latch015", , get_full_name());
    ua_div_latch115 = ua_div_latch1_c15::type_id::create("ua_div_latch115", , get_full_name());
    ua_int_id15 = ua_int_id_c15::type_id::create("ua_int_id15", , get_full_name());
    ua_fifo_ctrl15 = ua_fifo_ctrl_c15::type_id::create("ua_fifo_ctrl15", , get_full_name());
    ua_lcr15 = ua_lcr_c15::type_id::create("ua_lcr15", , get_full_name());
    ua_ier15 = ua_ier_c15::type_id::create("ua_ier15", , get_full_name());

    // Now15 build the registers. Set parent and hdl_paths

    ua_div_latch015.configure(this, null, "dl15[7:0]");
    ua_div_latch015.build();
    ua_div_latch115.configure(this, null, "dl15[15;8]");
    ua_div_latch115.build();
    ua_int_id15.configure(this, null, "iir15");
    ua_int_id15.build();
    ua_fifo_ctrl15.configure(this, null, "fcr15");
    ua_fifo_ctrl15.build();
    ua_lcr15.configure(this, null, "lcr15");
    ua_lcr15.build();
    ua_ier15.configure(this, null, "ier15");
    ua_ier15.build();
    // Now15 define address mappings15
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch015, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch115, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id15, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl15, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr15, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier15, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c15)
  function new(input string name="unnamed15-uart_ctrl_rf15");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c15

//////////////////////////////////////////////////////////////////////////////
// Address_map15 definition15
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c15 extends uvm_reg_block;

  rand uart_ctrl_rf_c15 uart_ctrl_rf15;

  function void build();
    // Now15 define address mappings15
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf15 = uart_ctrl_rf_c15::type_id::create("uart_ctrl_rf15", , get_full_name());
    uart_ctrl_rf15.configure(this, "regs");
    uart_ctrl_rf15.build();
    uart_ctrl_rf15.lock_model();
    default_map.add_submap(uart_ctrl_rf15.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top15.uart_dut15");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c15)
  function new(input string name="unnamed15-uart_ctrl_reg_model_c15");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c15

`endif // UART_CTRL_REGS_SV15
