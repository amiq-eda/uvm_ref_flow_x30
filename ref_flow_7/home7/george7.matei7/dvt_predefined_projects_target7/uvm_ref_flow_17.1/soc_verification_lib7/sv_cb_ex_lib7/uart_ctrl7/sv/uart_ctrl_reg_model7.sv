// This7 file is generated7 using Cadence7 iregGen7 version7 1.05

`ifndef UART_CTRL_REGS_SV7
`define UART_CTRL_REGS_SV7

// Input7 File7: uart_ctrl_regs7.xml7

// Number7 of AddrMaps7 = 1
// Number7 of RegFiles7 = 1
// Number7 of Registers7 = 6
// Number7 of Memories7 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 262


class ua_div_latch0_c7 extends uvm_reg;

  rand uvm_reg_field div_val7;

  constraint c_div_val7 { div_val7.value == 1; }
  virtual function void build();
    div_val7 = uvm_reg_field::type_id::create("div_val7");
    div_val7.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg7.set_inst_name($sformatf("%s.wcov7", get_full_name()));
    rd_cg7.set_inst_name($sformatf("%s.rcov7", get_full_name()));
  endfunction

  covergroup wr_cg7;
    option.per_instance=1;
    div_val7 : coverpoint div_val7.value[7:0];
  endgroup
  covergroup rd_cg7;
    option.per_instance=1;
    div_val7 : coverpoint div_val7.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg7.sample();
    if(is_read) rd_cg7.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c7, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c7, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c7)
  function new(input string name="unnamed7-ua_div_latch0_c7");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg7=new;
    rd_cg7=new;
  endfunction : new
endclass : ua_div_latch0_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 287


class ua_div_latch1_c7 extends uvm_reg;

  rand uvm_reg_field div_val7;

  constraint c_div_val7 { div_val7.value == 0; }
  virtual function void build();
    div_val7 = uvm_reg_field::type_id::create("div_val7");
    div_val7.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg7.set_inst_name($sformatf("%s.wcov7", get_full_name()));
    rd_cg7.set_inst_name($sformatf("%s.rcov7", get_full_name()));
  endfunction

  covergroup wr_cg7;
    option.per_instance=1;
    div_val7 : coverpoint div_val7.value[7:0];
  endgroup
  covergroup rd_cg7;
    option.per_instance=1;
    div_val7 : coverpoint div_val7.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg7.sample();
    if(is_read) rd_cg7.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c7, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c7, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c7)
  function new(input string name="unnamed7-ua_div_latch1_c7");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg7=new;
    rd_cg7=new;
  endfunction : new
endclass : ua_div_latch1_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 82


class ua_int_id_c7 extends uvm_reg;

  uvm_reg_field priority_bit7;
  uvm_reg_field bit17;
  uvm_reg_field bit27;
  uvm_reg_field bit37;

  virtual function void build();
    priority_bit7 = uvm_reg_field::type_id::create("priority_bit7");
    priority_bit7.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit17 = uvm_reg_field::type_id::create("bit17");
    bit17.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit27 = uvm_reg_field::type_id::create("bit27");
    bit27.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit37 = uvm_reg_field::type_id::create("bit37");
    bit37.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg7.set_inst_name($sformatf("%s.rcov7", get_full_name()));
  endfunction

  covergroup rd_cg7;
    option.per_instance=1;
    priority_bit7 : coverpoint priority_bit7.value[0:0];
    bit17 : coverpoint bit17.value[0:0];
    bit27 : coverpoint bit27.value[0:0];
    bit37 : coverpoint bit37.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg7.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c7, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c7, uvm_reg)
  `uvm_object_utils(ua_int_id_c7)
  function new(input string name="unnamed7-ua_int_id_c7");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg7=new;
  endfunction : new
endclass : ua_int_id_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 139


class ua_fifo_ctrl_c7 extends uvm_reg;

  rand uvm_reg_field rx_clear7;
  rand uvm_reg_field tx_clear7;
  rand uvm_reg_field rx_fifo_int_trig_level7;

  virtual function void build();
    rx_clear7 = uvm_reg_field::type_id::create("rx_clear7");
    rx_clear7.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear7 = uvm_reg_field::type_id::create("tx_clear7");
    tx_clear7.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level7 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level7");
    rx_fifo_int_trig_level7.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg7.set_inst_name($sformatf("%s.wcov7", get_full_name()));
  endfunction

  covergroup wr_cg7;
    option.per_instance=1;
    rx_clear7 : coverpoint rx_clear7.value[0:0];
    tx_clear7 : coverpoint tx_clear7.value[0:0];
    rx_fifo_int_trig_level7 : coverpoint rx_fifo_int_trig_level7.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg7.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c7, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c7, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c7)
  function new(input string name="unnamed7-ua_fifo_ctrl_c7");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg7=new;
  endfunction : new
endclass : ua_fifo_ctrl_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 188


class ua_lcr_c7 extends uvm_reg;

  rand uvm_reg_field char_lngth7;
  rand uvm_reg_field num_stop_bits7;
  rand uvm_reg_field p_en7;
  rand uvm_reg_field parity_even7;
  rand uvm_reg_field parity_sticky7;
  rand uvm_reg_field break_ctrl7;
  rand uvm_reg_field div_latch_access7;

  constraint c_char_lngth7 { char_lngth7.value != 2'b00; }
  constraint c_break_ctrl7 { break_ctrl7.value == 1'b0; }
  virtual function void build();
    char_lngth7 = uvm_reg_field::type_id::create("char_lngth7");
    char_lngth7.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits7 = uvm_reg_field::type_id::create("num_stop_bits7");
    num_stop_bits7.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en7 = uvm_reg_field::type_id::create("p_en7");
    p_en7.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even7 = uvm_reg_field::type_id::create("parity_even7");
    parity_even7.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky7 = uvm_reg_field::type_id::create("parity_sticky7");
    parity_sticky7.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl7 = uvm_reg_field::type_id::create("break_ctrl7");
    break_ctrl7.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access7 = uvm_reg_field::type_id::create("div_latch_access7");
    div_latch_access7.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg7.set_inst_name($sformatf("%s.wcov7", get_full_name()));
    rd_cg7.set_inst_name($sformatf("%s.rcov7", get_full_name()));
  endfunction

  covergroup wr_cg7;
    option.per_instance=1;
    char_lngth7 : coverpoint char_lngth7.value[1:0];
    num_stop_bits7 : coverpoint num_stop_bits7.value[0:0];
    p_en7 : coverpoint p_en7.value[0:0];
    parity_even7 : coverpoint parity_even7.value[0:0];
    parity_sticky7 : coverpoint parity_sticky7.value[0:0];
    break_ctrl7 : coverpoint break_ctrl7.value[0:0];
    div_latch_access7 : coverpoint div_latch_access7.value[0:0];
  endgroup
  covergroup rd_cg7;
    option.per_instance=1;
    char_lngth7 : coverpoint char_lngth7.value[1:0];
    num_stop_bits7 : coverpoint num_stop_bits7.value[0:0];
    p_en7 : coverpoint p_en7.value[0:0];
    parity_even7 : coverpoint parity_even7.value[0:0];
    parity_sticky7 : coverpoint parity_sticky7.value[0:0];
    break_ctrl7 : coverpoint break_ctrl7.value[0:0];
    div_latch_access7 : coverpoint div_latch_access7.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg7.sample();
    if(is_read) rd_cg7.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c7, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c7, uvm_reg)
  `uvm_object_utils(ua_lcr_c7)
  function new(input string name="unnamed7-ua_lcr_c7");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg7=new;
    rd_cg7=new;
  endfunction : new
endclass : ua_lcr_c7

//////////////////////////////////////////////////////////////////////////////
// Register definition7
//////////////////////////////////////////////////////////////////////////////
// Line7 Number7: 25


class ua_ier_c7 extends uvm_reg;

  rand uvm_reg_field rx_data7;
  rand uvm_reg_field tx_data7;
  rand uvm_reg_field rx_line_sts7;
  rand uvm_reg_field mdm_sts7;

  virtual function void build();
    rx_data7 = uvm_reg_field::type_id::create("rx_data7");
    rx_data7.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data7 = uvm_reg_field::type_id::create("tx_data7");
    tx_data7.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts7 = uvm_reg_field::type_id::create("rx_line_sts7");
    rx_line_sts7.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts7 = uvm_reg_field::type_id::create("mdm_sts7");
    mdm_sts7.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg7.set_inst_name($sformatf("%s.wcov7", get_full_name()));
    rd_cg7.set_inst_name($sformatf("%s.rcov7", get_full_name()));
  endfunction

  covergroup wr_cg7;
    option.per_instance=1;
    rx_data7 : coverpoint rx_data7.value[0:0];
    tx_data7 : coverpoint tx_data7.value[0:0];
    rx_line_sts7 : coverpoint rx_line_sts7.value[0:0];
    mdm_sts7 : coverpoint mdm_sts7.value[0:0];
  endgroup
  covergroup rd_cg7;
    option.per_instance=1;
    rx_data7 : coverpoint rx_data7.value[0:0];
    tx_data7 : coverpoint tx_data7.value[0:0];
    rx_line_sts7 : coverpoint rx_line_sts7.value[0:0];
    mdm_sts7 : coverpoint mdm_sts7.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg7.sample();
    if(is_read) rd_cg7.sample();
  endfunction

  `uvm_register_cb(ua_ier_c7, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c7, uvm_reg)
  `uvm_object_utils(ua_ier_c7)
  function new(input string name="unnamed7-ua_ier_c7");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg7=new;
    rd_cg7=new;
  endfunction : new
endclass : ua_ier_c7

class uart_ctrl_rf_c7 extends uvm_reg_block;

  rand ua_div_latch0_c7 ua_div_latch07;
  rand ua_div_latch1_c7 ua_div_latch17;
  rand ua_int_id_c7 ua_int_id7;
  rand ua_fifo_ctrl_c7 ua_fifo_ctrl7;
  rand ua_lcr_c7 ua_lcr7;
  rand ua_ier_c7 ua_ier7;

  virtual function void build();

    // Now7 create all registers

    ua_div_latch07 = ua_div_latch0_c7::type_id::create("ua_div_latch07", , get_full_name());
    ua_div_latch17 = ua_div_latch1_c7::type_id::create("ua_div_latch17", , get_full_name());
    ua_int_id7 = ua_int_id_c7::type_id::create("ua_int_id7", , get_full_name());
    ua_fifo_ctrl7 = ua_fifo_ctrl_c7::type_id::create("ua_fifo_ctrl7", , get_full_name());
    ua_lcr7 = ua_lcr_c7::type_id::create("ua_lcr7", , get_full_name());
    ua_ier7 = ua_ier_c7::type_id::create("ua_ier7", , get_full_name());

    // Now7 build the registers. Set parent and hdl_paths

    ua_div_latch07.configure(this, null, "dl7[7:0]");
    ua_div_latch07.build();
    ua_div_latch17.configure(this, null, "dl7[15;8]");
    ua_div_latch17.build();
    ua_int_id7.configure(this, null, "iir7");
    ua_int_id7.build();
    ua_fifo_ctrl7.configure(this, null, "fcr7");
    ua_fifo_ctrl7.build();
    ua_lcr7.configure(this, null, "lcr7");
    ua_lcr7.build();
    ua_ier7.configure(this, null, "ier7");
    ua_ier7.build();
    // Now7 define address mappings7
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch07, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch17, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id7, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl7, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr7, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier7, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c7)
  function new(input string name="unnamed7-uart_ctrl_rf7");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c7

//////////////////////////////////////////////////////////////////////////////
// Address_map7 definition7
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c7 extends uvm_reg_block;

  rand uart_ctrl_rf_c7 uart_ctrl_rf7;

  function void build();
    // Now7 define address mappings7
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf7 = uart_ctrl_rf_c7::type_id::create("uart_ctrl_rf7", , get_full_name());
    uart_ctrl_rf7.configure(this, "regs");
    uart_ctrl_rf7.build();
    uart_ctrl_rf7.lock_model();
    default_map.add_submap(uart_ctrl_rf7.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top7.uart_dut7");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c7)
  function new(input string name="unnamed7-uart_ctrl_reg_model_c7");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c7

`endif // UART_CTRL_REGS_SV7
