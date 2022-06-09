// This23 file is generated23 using Cadence23 iregGen23 version23 1.05

`ifndef UART_CTRL_REGS_SV23
`define UART_CTRL_REGS_SV23

// Input23 File23: uart_ctrl_regs23.xml23

// Number23 of AddrMaps23 = 1
// Number23 of RegFiles23 = 1
// Number23 of Registers23 = 6
// Number23 of Memories23 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 262


class ua_div_latch0_c23 extends uvm_reg;

  rand uvm_reg_field div_val23;

  constraint c_div_val23 { div_val23.value == 1; }
  virtual function void build();
    div_val23 = uvm_reg_field::type_id::create("div_val23");
    div_val23.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg23.set_inst_name($sformatf("%s.wcov23", get_full_name()));
    rd_cg23.set_inst_name($sformatf("%s.rcov23", get_full_name()));
  endfunction

  covergroup wr_cg23;
    option.per_instance=1;
    div_val23 : coverpoint div_val23.value[7:0];
  endgroup
  covergroup rd_cg23;
    option.per_instance=1;
    div_val23 : coverpoint div_val23.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg23.sample();
    if(is_read) rd_cg23.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c23, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c23, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c23)
  function new(input string name="unnamed23-ua_div_latch0_c23");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg23=new;
    rd_cg23=new;
  endfunction : new
endclass : ua_div_latch0_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 287


class ua_div_latch1_c23 extends uvm_reg;

  rand uvm_reg_field div_val23;

  constraint c_div_val23 { div_val23.value == 0; }
  virtual function void build();
    div_val23 = uvm_reg_field::type_id::create("div_val23");
    div_val23.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg23.set_inst_name($sformatf("%s.wcov23", get_full_name()));
    rd_cg23.set_inst_name($sformatf("%s.rcov23", get_full_name()));
  endfunction

  covergroup wr_cg23;
    option.per_instance=1;
    div_val23 : coverpoint div_val23.value[7:0];
  endgroup
  covergroup rd_cg23;
    option.per_instance=1;
    div_val23 : coverpoint div_val23.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg23.sample();
    if(is_read) rd_cg23.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c23, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c23, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c23)
  function new(input string name="unnamed23-ua_div_latch1_c23");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg23=new;
    rd_cg23=new;
  endfunction : new
endclass : ua_div_latch1_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 82


class ua_int_id_c23 extends uvm_reg;

  uvm_reg_field priority_bit23;
  uvm_reg_field bit123;
  uvm_reg_field bit223;
  uvm_reg_field bit323;

  virtual function void build();
    priority_bit23 = uvm_reg_field::type_id::create("priority_bit23");
    priority_bit23.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit123 = uvm_reg_field::type_id::create("bit123");
    bit123.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit223 = uvm_reg_field::type_id::create("bit223");
    bit223.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit323 = uvm_reg_field::type_id::create("bit323");
    bit323.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg23.set_inst_name($sformatf("%s.rcov23", get_full_name()));
  endfunction

  covergroup rd_cg23;
    option.per_instance=1;
    priority_bit23 : coverpoint priority_bit23.value[0:0];
    bit123 : coverpoint bit123.value[0:0];
    bit223 : coverpoint bit223.value[0:0];
    bit323 : coverpoint bit323.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg23.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c23, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c23, uvm_reg)
  `uvm_object_utils(ua_int_id_c23)
  function new(input string name="unnamed23-ua_int_id_c23");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg23=new;
  endfunction : new
endclass : ua_int_id_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 139


class ua_fifo_ctrl_c23 extends uvm_reg;

  rand uvm_reg_field rx_clear23;
  rand uvm_reg_field tx_clear23;
  rand uvm_reg_field rx_fifo_int_trig_level23;

  virtual function void build();
    rx_clear23 = uvm_reg_field::type_id::create("rx_clear23");
    rx_clear23.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear23 = uvm_reg_field::type_id::create("tx_clear23");
    tx_clear23.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level23 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level23");
    rx_fifo_int_trig_level23.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg23.set_inst_name($sformatf("%s.wcov23", get_full_name()));
  endfunction

  covergroup wr_cg23;
    option.per_instance=1;
    rx_clear23 : coverpoint rx_clear23.value[0:0];
    tx_clear23 : coverpoint tx_clear23.value[0:0];
    rx_fifo_int_trig_level23 : coverpoint rx_fifo_int_trig_level23.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg23.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c23, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c23, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c23)
  function new(input string name="unnamed23-ua_fifo_ctrl_c23");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg23=new;
  endfunction : new
endclass : ua_fifo_ctrl_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 188


class ua_lcr_c23 extends uvm_reg;

  rand uvm_reg_field char_lngth23;
  rand uvm_reg_field num_stop_bits23;
  rand uvm_reg_field p_en23;
  rand uvm_reg_field parity_even23;
  rand uvm_reg_field parity_sticky23;
  rand uvm_reg_field break_ctrl23;
  rand uvm_reg_field div_latch_access23;

  constraint c_char_lngth23 { char_lngth23.value != 2'b00; }
  constraint c_break_ctrl23 { break_ctrl23.value == 1'b0; }
  virtual function void build();
    char_lngth23 = uvm_reg_field::type_id::create("char_lngth23");
    char_lngth23.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits23 = uvm_reg_field::type_id::create("num_stop_bits23");
    num_stop_bits23.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en23 = uvm_reg_field::type_id::create("p_en23");
    p_en23.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even23 = uvm_reg_field::type_id::create("parity_even23");
    parity_even23.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky23 = uvm_reg_field::type_id::create("parity_sticky23");
    parity_sticky23.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl23 = uvm_reg_field::type_id::create("break_ctrl23");
    break_ctrl23.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access23 = uvm_reg_field::type_id::create("div_latch_access23");
    div_latch_access23.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg23.set_inst_name($sformatf("%s.wcov23", get_full_name()));
    rd_cg23.set_inst_name($sformatf("%s.rcov23", get_full_name()));
  endfunction

  covergroup wr_cg23;
    option.per_instance=1;
    char_lngth23 : coverpoint char_lngth23.value[1:0];
    num_stop_bits23 : coverpoint num_stop_bits23.value[0:0];
    p_en23 : coverpoint p_en23.value[0:0];
    parity_even23 : coverpoint parity_even23.value[0:0];
    parity_sticky23 : coverpoint parity_sticky23.value[0:0];
    break_ctrl23 : coverpoint break_ctrl23.value[0:0];
    div_latch_access23 : coverpoint div_latch_access23.value[0:0];
  endgroup
  covergroup rd_cg23;
    option.per_instance=1;
    char_lngth23 : coverpoint char_lngth23.value[1:0];
    num_stop_bits23 : coverpoint num_stop_bits23.value[0:0];
    p_en23 : coverpoint p_en23.value[0:0];
    parity_even23 : coverpoint parity_even23.value[0:0];
    parity_sticky23 : coverpoint parity_sticky23.value[0:0];
    break_ctrl23 : coverpoint break_ctrl23.value[0:0];
    div_latch_access23 : coverpoint div_latch_access23.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg23.sample();
    if(is_read) rd_cg23.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c23, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c23, uvm_reg)
  `uvm_object_utils(ua_lcr_c23)
  function new(input string name="unnamed23-ua_lcr_c23");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg23=new;
    rd_cg23=new;
  endfunction : new
endclass : ua_lcr_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 25


class ua_ier_c23 extends uvm_reg;

  rand uvm_reg_field rx_data23;
  rand uvm_reg_field tx_data23;
  rand uvm_reg_field rx_line_sts23;
  rand uvm_reg_field mdm_sts23;

  virtual function void build();
    rx_data23 = uvm_reg_field::type_id::create("rx_data23");
    rx_data23.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data23 = uvm_reg_field::type_id::create("tx_data23");
    tx_data23.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts23 = uvm_reg_field::type_id::create("rx_line_sts23");
    rx_line_sts23.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts23 = uvm_reg_field::type_id::create("mdm_sts23");
    mdm_sts23.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg23.set_inst_name($sformatf("%s.wcov23", get_full_name()));
    rd_cg23.set_inst_name($sformatf("%s.rcov23", get_full_name()));
  endfunction

  covergroup wr_cg23;
    option.per_instance=1;
    rx_data23 : coverpoint rx_data23.value[0:0];
    tx_data23 : coverpoint tx_data23.value[0:0];
    rx_line_sts23 : coverpoint rx_line_sts23.value[0:0];
    mdm_sts23 : coverpoint mdm_sts23.value[0:0];
  endgroup
  covergroup rd_cg23;
    option.per_instance=1;
    rx_data23 : coverpoint rx_data23.value[0:0];
    tx_data23 : coverpoint tx_data23.value[0:0];
    rx_line_sts23 : coverpoint rx_line_sts23.value[0:0];
    mdm_sts23 : coverpoint mdm_sts23.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg23.sample();
    if(is_read) rd_cg23.sample();
  endfunction

  `uvm_register_cb(ua_ier_c23, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c23, uvm_reg)
  `uvm_object_utils(ua_ier_c23)
  function new(input string name="unnamed23-ua_ier_c23");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg23=new;
    rd_cg23=new;
  endfunction : new
endclass : ua_ier_c23

class uart_ctrl_rf_c23 extends uvm_reg_block;

  rand ua_div_latch0_c23 ua_div_latch023;
  rand ua_div_latch1_c23 ua_div_latch123;
  rand ua_int_id_c23 ua_int_id23;
  rand ua_fifo_ctrl_c23 ua_fifo_ctrl23;
  rand ua_lcr_c23 ua_lcr23;
  rand ua_ier_c23 ua_ier23;

  virtual function void build();

    // Now23 create all registers

    ua_div_latch023 = ua_div_latch0_c23::type_id::create("ua_div_latch023", , get_full_name());
    ua_div_latch123 = ua_div_latch1_c23::type_id::create("ua_div_latch123", , get_full_name());
    ua_int_id23 = ua_int_id_c23::type_id::create("ua_int_id23", , get_full_name());
    ua_fifo_ctrl23 = ua_fifo_ctrl_c23::type_id::create("ua_fifo_ctrl23", , get_full_name());
    ua_lcr23 = ua_lcr_c23::type_id::create("ua_lcr23", , get_full_name());
    ua_ier23 = ua_ier_c23::type_id::create("ua_ier23", , get_full_name());

    // Now23 build the registers. Set parent and hdl_paths

    ua_div_latch023.configure(this, null, "dl23[7:0]");
    ua_div_latch023.build();
    ua_div_latch123.configure(this, null, "dl23[15;8]");
    ua_div_latch123.build();
    ua_int_id23.configure(this, null, "iir23");
    ua_int_id23.build();
    ua_fifo_ctrl23.configure(this, null, "fcr23");
    ua_fifo_ctrl23.build();
    ua_lcr23.configure(this, null, "lcr23");
    ua_lcr23.build();
    ua_ier23.configure(this, null, "ier23");
    ua_ier23.build();
    // Now23 define address mappings23
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch023, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch123, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id23, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl23, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr23, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier23, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c23)
  function new(input string name="unnamed23-uart_ctrl_rf23");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c23

//////////////////////////////////////////////////////////////////////////////
// Address_map23 definition23
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c23 extends uvm_reg_block;

  rand uart_ctrl_rf_c23 uart_ctrl_rf23;

  function void build();
    // Now23 define address mappings23
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf23 = uart_ctrl_rf_c23::type_id::create("uart_ctrl_rf23", , get_full_name());
    uart_ctrl_rf23.configure(this, "regs");
    uart_ctrl_rf23.build();
    uart_ctrl_rf23.lock_model();
    default_map.add_submap(uart_ctrl_rf23.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top23.uart_dut23");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c23)
  function new(input string name="unnamed23-uart_ctrl_reg_model_c23");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c23

`endif // UART_CTRL_REGS_SV23
