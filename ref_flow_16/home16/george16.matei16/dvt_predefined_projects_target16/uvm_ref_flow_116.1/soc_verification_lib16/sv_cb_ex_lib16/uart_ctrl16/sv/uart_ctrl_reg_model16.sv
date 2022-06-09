// This16 file is generated16 using Cadence16 iregGen16 version16 1.05

`ifndef UART_CTRL_REGS_SV16
`define UART_CTRL_REGS_SV16

// Input16 File16: uart_ctrl_regs16.xml16

// Number16 of AddrMaps16 = 1
// Number16 of RegFiles16 = 1
// Number16 of Registers16 = 6
// Number16 of Memories16 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 262


class ua_div_latch0_c16 extends uvm_reg;

  rand uvm_reg_field div_val16;

  constraint c_div_val16 { div_val16.value == 1; }
  virtual function void build();
    div_val16 = uvm_reg_field::type_id::create("div_val16");
    div_val16.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg16.set_inst_name($sformatf("%s.wcov16", get_full_name()));
    rd_cg16.set_inst_name($sformatf("%s.rcov16", get_full_name()));
  endfunction

  covergroup wr_cg16;
    option.per_instance=1;
    div_val16 : coverpoint div_val16.value[7:0];
  endgroup
  covergroup rd_cg16;
    option.per_instance=1;
    div_val16 : coverpoint div_val16.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg16.sample();
    if(is_read) rd_cg16.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c16, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c16, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c16)
  function new(input string name="unnamed16-ua_div_latch0_c16");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg16=new;
    rd_cg16=new;
  endfunction : new
endclass : ua_div_latch0_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 287


class ua_div_latch1_c16 extends uvm_reg;

  rand uvm_reg_field div_val16;

  constraint c_div_val16 { div_val16.value == 0; }
  virtual function void build();
    div_val16 = uvm_reg_field::type_id::create("div_val16");
    div_val16.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg16.set_inst_name($sformatf("%s.wcov16", get_full_name()));
    rd_cg16.set_inst_name($sformatf("%s.rcov16", get_full_name()));
  endfunction

  covergroup wr_cg16;
    option.per_instance=1;
    div_val16 : coverpoint div_val16.value[7:0];
  endgroup
  covergroup rd_cg16;
    option.per_instance=1;
    div_val16 : coverpoint div_val16.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg16.sample();
    if(is_read) rd_cg16.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c16, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c16, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c16)
  function new(input string name="unnamed16-ua_div_latch1_c16");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg16=new;
    rd_cg16=new;
  endfunction : new
endclass : ua_div_latch1_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 82


class ua_int_id_c16 extends uvm_reg;

  uvm_reg_field priority_bit16;
  uvm_reg_field bit116;
  uvm_reg_field bit216;
  uvm_reg_field bit316;

  virtual function void build();
    priority_bit16 = uvm_reg_field::type_id::create("priority_bit16");
    priority_bit16.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit116 = uvm_reg_field::type_id::create("bit116");
    bit116.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit216 = uvm_reg_field::type_id::create("bit216");
    bit216.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit316 = uvm_reg_field::type_id::create("bit316");
    bit316.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg16.set_inst_name($sformatf("%s.rcov16", get_full_name()));
  endfunction

  covergroup rd_cg16;
    option.per_instance=1;
    priority_bit16 : coverpoint priority_bit16.value[0:0];
    bit116 : coverpoint bit116.value[0:0];
    bit216 : coverpoint bit216.value[0:0];
    bit316 : coverpoint bit316.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg16.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c16, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c16, uvm_reg)
  `uvm_object_utils(ua_int_id_c16)
  function new(input string name="unnamed16-ua_int_id_c16");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg16=new;
  endfunction : new
endclass : ua_int_id_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 139


class ua_fifo_ctrl_c16 extends uvm_reg;

  rand uvm_reg_field rx_clear16;
  rand uvm_reg_field tx_clear16;
  rand uvm_reg_field rx_fifo_int_trig_level16;

  virtual function void build();
    rx_clear16 = uvm_reg_field::type_id::create("rx_clear16");
    rx_clear16.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear16 = uvm_reg_field::type_id::create("tx_clear16");
    tx_clear16.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level16 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level16");
    rx_fifo_int_trig_level16.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg16.set_inst_name($sformatf("%s.wcov16", get_full_name()));
  endfunction

  covergroup wr_cg16;
    option.per_instance=1;
    rx_clear16 : coverpoint rx_clear16.value[0:0];
    tx_clear16 : coverpoint tx_clear16.value[0:0];
    rx_fifo_int_trig_level16 : coverpoint rx_fifo_int_trig_level16.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg16.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c16, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c16, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c16)
  function new(input string name="unnamed16-ua_fifo_ctrl_c16");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg16=new;
  endfunction : new
endclass : ua_fifo_ctrl_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 188


class ua_lcr_c16 extends uvm_reg;

  rand uvm_reg_field char_lngth16;
  rand uvm_reg_field num_stop_bits16;
  rand uvm_reg_field p_en16;
  rand uvm_reg_field parity_even16;
  rand uvm_reg_field parity_sticky16;
  rand uvm_reg_field break_ctrl16;
  rand uvm_reg_field div_latch_access16;

  constraint c_char_lngth16 { char_lngth16.value != 2'b00; }
  constraint c_break_ctrl16 { break_ctrl16.value == 1'b0; }
  virtual function void build();
    char_lngth16 = uvm_reg_field::type_id::create("char_lngth16");
    char_lngth16.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits16 = uvm_reg_field::type_id::create("num_stop_bits16");
    num_stop_bits16.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en16 = uvm_reg_field::type_id::create("p_en16");
    p_en16.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even16 = uvm_reg_field::type_id::create("parity_even16");
    parity_even16.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky16 = uvm_reg_field::type_id::create("parity_sticky16");
    parity_sticky16.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl16 = uvm_reg_field::type_id::create("break_ctrl16");
    break_ctrl16.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access16 = uvm_reg_field::type_id::create("div_latch_access16");
    div_latch_access16.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg16.set_inst_name($sformatf("%s.wcov16", get_full_name()));
    rd_cg16.set_inst_name($sformatf("%s.rcov16", get_full_name()));
  endfunction

  covergroup wr_cg16;
    option.per_instance=1;
    char_lngth16 : coverpoint char_lngth16.value[1:0];
    num_stop_bits16 : coverpoint num_stop_bits16.value[0:0];
    p_en16 : coverpoint p_en16.value[0:0];
    parity_even16 : coverpoint parity_even16.value[0:0];
    parity_sticky16 : coverpoint parity_sticky16.value[0:0];
    break_ctrl16 : coverpoint break_ctrl16.value[0:0];
    div_latch_access16 : coverpoint div_latch_access16.value[0:0];
  endgroup
  covergroup rd_cg16;
    option.per_instance=1;
    char_lngth16 : coverpoint char_lngth16.value[1:0];
    num_stop_bits16 : coverpoint num_stop_bits16.value[0:0];
    p_en16 : coverpoint p_en16.value[0:0];
    parity_even16 : coverpoint parity_even16.value[0:0];
    parity_sticky16 : coverpoint parity_sticky16.value[0:0];
    break_ctrl16 : coverpoint break_ctrl16.value[0:0];
    div_latch_access16 : coverpoint div_latch_access16.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg16.sample();
    if(is_read) rd_cg16.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c16, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c16, uvm_reg)
  `uvm_object_utils(ua_lcr_c16)
  function new(input string name="unnamed16-ua_lcr_c16");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg16=new;
    rd_cg16=new;
  endfunction : new
endclass : ua_lcr_c16

//////////////////////////////////////////////////////////////////////////////
// Register definition16
//////////////////////////////////////////////////////////////////////////////
// Line16 Number16: 25


class ua_ier_c16 extends uvm_reg;

  rand uvm_reg_field rx_data16;
  rand uvm_reg_field tx_data16;
  rand uvm_reg_field rx_line_sts16;
  rand uvm_reg_field mdm_sts16;

  virtual function void build();
    rx_data16 = uvm_reg_field::type_id::create("rx_data16");
    rx_data16.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data16 = uvm_reg_field::type_id::create("tx_data16");
    tx_data16.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts16 = uvm_reg_field::type_id::create("rx_line_sts16");
    rx_line_sts16.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts16 = uvm_reg_field::type_id::create("mdm_sts16");
    mdm_sts16.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg16.set_inst_name($sformatf("%s.wcov16", get_full_name()));
    rd_cg16.set_inst_name($sformatf("%s.rcov16", get_full_name()));
  endfunction

  covergroup wr_cg16;
    option.per_instance=1;
    rx_data16 : coverpoint rx_data16.value[0:0];
    tx_data16 : coverpoint tx_data16.value[0:0];
    rx_line_sts16 : coverpoint rx_line_sts16.value[0:0];
    mdm_sts16 : coverpoint mdm_sts16.value[0:0];
  endgroup
  covergroup rd_cg16;
    option.per_instance=1;
    rx_data16 : coverpoint rx_data16.value[0:0];
    tx_data16 : coverpoint tx_data16.value[0:0];
    rx_line_sts16 : coverpoint rx_line_sts16.value[0:0];
    mdm_sts16 : coverpoint mdm_sts16.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg16.sample();
    if(is_read) rd_cg16.sample();
  endfunction

  `uvm_register_cb(ua_ier_c16, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c16, uvm_reg)
  `uvm_object_utils(ua_ier_c16)
  function new(input string name="unnamed16-ua_ier_c16");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg16=new;
    rd_cg16=new;
  endfunction : new
endclass : ua_ier_c16

class uart_ctrl_rf_c16 extends uvm_reg_block;

  rand ua_div_latch0_c16 ua_div_latch016;
  rand ua_div_latch1_c16 ua_div_latch116;
  rand ua_int_id_c16 ua_int_id16;
  rand ua_fifo_ctrl_c16 ua_fifo_ctrl16;
  rand ua_lcr_c16 ua_lcr16;
  rand ua_ier_c16 ua_ier16;

  virtual function void build();

    // Now16 create all registers

    ua_div_latch016 = ua_div_latch0_c16::type_id::create("ua_div_latch016", , get_full_name());
    ua_div_latch116 = ua_div_latch1_c16::type_id::create("ua_div_latch116", , get_full_name());
    ua_int_id16 = ua_int_id_c16::type_id::create("ua_int_id16", , get_full_name());
    ua_fifo_ctrl16 = ua_fifo_ctrl_c16::type_id::create("ua_fifo_ctrl16", , get_full_name());
    ua_lcr16 = ua_lcr_c16::type_id::create("ua_lcr16", , get_full_name());
    ua_ier16 = ua_ier_c16::type_id::create("ua_ier16", , get_full_name());

    // Now16 build the registers. Set parent and hdl_paths

    ua_div_latch016.configure(this, null, "dl16[7:0]");
    ua_div_latch016.build();
    ua_div_latch116.configure(this, null, "dl16[15;8]");
    ua_div_latch116.build();
    ua_int_id16.configure(this, null, "iir16");
    ua_int_id16.build();
    ua_fifo_ctrl16.configure(this, null, "fcr16");
    ua_fifo_ctrl16.build();
    ua_lcr16.configure(this, null, "lcr16");
    ua_lcr16.build();
    ua_ier16.configure(this, null, "ier16");
    ua_ier16.build();
    // Now16 define address mappings16
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch016, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch116, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id16, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl16, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr16, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier16, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c16)
  function new(input string name="unnamed16-uart_ctrl_rf16");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c16

//////////////////////////////////////////////////////////////////////////////
// Address_map16 definition16
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c16 extends uvm_reg_block;

  rand uart_ctrl_rf_c16 uart_ctrl_rf16;

  function void build();
    // Now16 define address mappings16
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf16 = uart_ctrl_rf_c16::type_id::create("uart_ctrl_rf16", , get_full_name());
    uart_ctrl_rf16.configure(this, "regs");
    uart_ctrl_rf16.build();
    uart_ctrl_rf16.lock_model();
    default_map.add_submap(uart_ctrl_rf16.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top16.uart_dut16");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c16)
  function new(input string name="unnamed16-uart_ctrl_reg_model_c16");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c16

`endif // UART_CTRL_REGS_SV16
