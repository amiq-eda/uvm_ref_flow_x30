// This24 file is generated24 using Cadence24 iregGen24 version24 1.05

`ifndef UART_CTRL_REGS_SV24
`define UART_CTRL_REGS_SV24

// Input24 File24: uart_ctrl_regs24.xml24

// Number24 of AddrMaps24 = 1
// Number24 of RegFiles24 = 1
// Number24 of Registers24 = 6
// Number24 of Memories24 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 262


class ua_div_latch0_c24 extends uvm_reg;

  rand uvm_reg_field div_val24;

  constraint c_div_val24 { div_val24.value == 1; }
  virtual function void build();
    div_val24 = uvm_reg_field::type_id::create("div_val24");
    div_val24.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg24.set_inst_name($sformatf("%s.wcov24", get_full_name()));
    rd_cg24.set_inst_name($sformatf("%s.rcov24", get_full_name()));
  endfunction

  covergroup wr_cg24;
    option.per_instance=1;
    div_val24 : coverpoint div_val24.value[7:0];
  endgroup
  covergroup rd_cg24;
    option.per_instance=1;
    div_val24 : coverpoint div_val24.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg24.sample();
    if(is_read) rd_cg24.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c24, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c24, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c24)
  function new(input string name="unnamed24-ua_div_latch0_c24");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg24=new;
    rd_cg24=new;
  endfunction : new
endclass : ua_div_latch0_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 287


class ua_div_latch1_c24 extends uvm_reg;

  rand uvm_reg_field div_val24;

  constraint c_div_val24 { div_val24.value == 0; }
  virtual function void build();
    div_val24 = uvm_reg_field::type_id::create("div_val24");
    div_val24.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg24.set_inst_name($sformatf("%s.wcov24", get_full_name()));
    rd_cg24.set_inst_name($sformatf("%s.rcov24", get_full_name()));
  endfunction

  covergroup wr_cg24;
    option.per_instance=1;
    div_val24 : coverpoint div_val24.value[7:0];
  endgroup
  covergroup rd_cg24;
    option.per_instance=1;
    div_val24 : coverpoint div_val24.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg24.sample();
    if(is_read) rd_cg24.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c24, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c24, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c24)
  function new(input string name="unnamed24-ua_div_latch1_c24");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg24=new;
    rd_cg24=new;
  endfunction : new
endclass : ua_div_latch1_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 82


class ua_int_id_c24 extends uvm_reg;

  uvm_reg_field priority_bit24;
  uvm_reg_field bit124;
  uvm_reg_field bit224;
  uvm_reg_field bit324;

  virtual function void build();
    priority_bit24 = uvm_reg_field::type_id::create("priority_bit24");
    priority_bit24.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit124 = uvm_reg_field::type_id::create("bit124");
    bit124.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit224 = uvm_reg_field::type_id::create("bit224");
    bit224.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit324 = uvm_reg_field::type_id::create("bit324");
    bit324.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg24.set_inst_name($sformatf("%s.rcov24", get_full_name()));
  endfunction

  covergroup rd_cg24;
    option.per_instance=1;
    priority_bit24 : coverpoint priority_bit24.value[0:0];
    bit124 : coverpoint bit124.value[0:0];
    bit224 : coverpoint bit224.value[0:0];
    bit324 : coverpoint bit324.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg24.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c24, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c24, uvm_reg)
  `uvm_object_utils(ua_int_id_c24)
  function new(input string name="unnamed24-ua_int_id_c24");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg24=new;
  endfunction : new
endclass : ua_int_id_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 139


class ua_fifo_ctrl_c24 extends uvm_reg;

  rand uvm_reg_field rx_clear24;
  rand uvm_reg_field tx_clear24;
  rand uvm_reg_field rx_fifo_int_trig_level24;

  virtual function void build();
    rx_clear24 = uvm_reg_field::type_id::create("rx_clear24");
    rx_clear24.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear24 = uvm_reg_field::type_id::create("tx_clear24");
    tx_clear24.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level24 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level24");
    rx_fifo_int_trig_level24.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg24.set_inst_name($sformatf("%s.wcov24", get_full_name()));
  endfunction

  covergroup wr_cg24;
    option.per_instance=1;
    rx_clear24 : coverpoint rx_clear24.value[0:0];
    tx_clear24 : coverpoint tx_clear24.value[0:0];
    rx_fifo_int_trig_level24 : coverpoint rx_fifo_int_trig_level24.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg24.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c24, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c24, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c24)
  function new(input string name="unnamed24-ua_fifo_ctrl_c24");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg24=new;
  endfunction : new
endclass : ua_fifo_ctrl_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 188


class ua_lcr_c24 extends uvm_reg;

  rand uvm_reg_field char_lngth24;
  rand uvm_reg_field num_stop_bits24;
  rand uvm_reg_field p_en24;
  rand uvm_reg_field parity_even24;
  rand uvm_reg_field parity_sticky24;
  rand uvm_reg_field break_ctrl24;
  rand uvm_reg_field div_latch_access24;

  constraint c_char_lngth24 { char_lngth24.value != 2'b00; }
  constraint c_break_ctrl24 { break_ctrl24.value == 1'b0; }
  virtual function void build();
    char_lngth24 = uvm_reg_field::type_id::create("char_lngth24");
    char_lngth24.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits24 = uvm_reg_field::type_id::create("num_stop_bits24");
    num_stop_bits24.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en24 = uvm_reg_field::type_id::create("p_en24");
    p_en24.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even24 = uvm_reg_field::type_id::create("parity_even24");
    parity_even24.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky24 = uvm_reg_field::type_id::create("parity_sticky24");
    parity_sticky24.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl24 = uvm_reg_field::type_id::create("break_ctrl24");
    break_ctrl24.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access24 = uvm_reg_field::type_id::create("div_latch_access24");
    div_latch_access24.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg24.set_inst_name($sformatf("%s.wcov24", get_full_name()));
    rd_cg24.set_inst_name($sformatf("%s.rcov24", get_full_name()));
  endfunction

  covergroup wr_cg24;
    option.per_instance=1;
    char_lngth24 : coverpoint char_lngth24.value[1:0];
    num_stop_bits24 : coverpoint num_stop_bits24.value[0:0];
    p_en24 : coverpoint p_en24.value[0:0];
    parity_even24 : coverpoint parity_even24.value[0:0];
    parity_sticky24 : coverpoint parity_sticky24.value[0:0];
    break_ctrl24 : coverpoint break_ctrl24.value[0:0];
    div_latch_access24 : coverpoint div_latch_access24.value[0:0];
  endgroup
  covergroup rd_cg24;
    option.per_instance=1;
    char_lngth24 : coverpoint char_lngth24.value[1:0];
    num_stop_bits24 : coverpoint num_stop_bits24.value[0:0];
    p_en24 : coverpoint p_en24.value[0:0];
    parity_even24 : coverpoint parity_even24.value[0:0];
    parity_sticky24 : coverpoint parity_sticky24.value[0:0];
    break_ctrl24 : coverpoint break_ctrl24.value[0:0];
    div_latch_access24 : coverpoint div_latch_access24.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg24.sample();
    if(is_read) rd_cg24.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c24, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c24, uvm_reg)
  `uvm_object_utils(ua_lcr_c24)
  function new(input string name="unnamed24-ua_lcr_c24");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg24=new;
    rd_cg24=new;
  endfunction : new
endclass : ua_lcr_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 25


class ua_ier_c24 extends uvm_reg;

  rand uvm_reg_field rx_data24;
  rand uvm_reg_field tx_data24;
  rand uvm_reg_field rx_line_sts24;
  rand uvm_reg_field mdm_sts24;

  virtual function void build();
    rx_data24 = uvm_reg_field::type_id::create("rx_data24");
    rx_data24.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data24 = uvm_reg_field::type_id::create("tx_data24");
    tx_data24.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts24 = uvm_reg_field::type_id::create("rx_line_sts24");
    rx_line_sts24.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts24 = uvm_reg_field::type_id::create("mdm_sts24");
    mdm_sts24.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg24.set_inst_name($sformatf("%s.wcov24", get_full_name()));
    rd_cg24.set_inst_name($sformatf("%s.rcov24", get_full_name()));
  endfunction

  covergroup wr_cg24;
    option.per_instance=1;
    rx_data24 : coverpoint rx_data24.value[0:0];
    tx_data24 : coverpoint tx_data24.value[0:0];
    rx_line_sts24 : coverpoint rx_line_sts24.value[0:0];
    mdm_sts24 : coverpoint mdm_sts24.value[0:0];
  endgroup
  covergroup rd_cg24;
    option.per_instance=1;
    rx_data24 : coverpoint rx_data24.value[0:0];
    tx_data24 : coverpoint tx_data24.value[0:0];
    rx_line_sts24 : coverpoint rx_line_sts24.value[0:0];
    mdm_sts24 : coverpoint mdm_sts24.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg24.sample();
    if(is_read) rd_cg24.sample();
  endfunction

  `uvm_register_cb(ua_ier_c24, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c24, uvm_reg)
  `uvm_object_utils(ua_ier_c24)
  function new(input string name="unnamed24-ua_ier_c24");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg24=new;
    rd_cg24=new;
  endfunction : new
endclass : ua_ier_c24

class uart_ctrl_rf_c24 extends uvm_reg_block;

  rand ua_div_latch0_c24 ua_div_latch024;
  rand ua_div_latch1_c24 ua_div_latch124;
  rand ua_int_id_c24 ua_int_id24;
  rand ua_fifo_ctrl_c24 ua_fifo_ctrl24;
  rand ua_lcr_c24 ua_lcr24;
  rand ua_ier_c24 ua_ier24;

  virtual function void build();

    // Now24 create all registers

    ua_div_latch024 = ua_div_latch0_c24::type_id::create("ua_div_latch024", , get_full_name());
    ua_div_latch124 = ua_div_latch1_c24::type_id::create("ua_div_latch124", , get_full_name());
    ua_int_id24 = ua_int_id_c24::type_id::create("ua_int_id24", , get_full_name());
    ua_fifo_ctrl24 = ua_fifo_ctrl_c24::type_id::create("ua_fifo_ctrl24", , get_full_name());
    ua_lcr24 = ua_lcr_c24::type_id::create("ua_lcr24", , get_full_name());
    ua_ier24 = ua_ier_c24::type_id::create("ua_ier24", , get_full_name());

    // Now24 build the registers. Set parent and hdl_paths

    ua_div_latch024.configure(this, null, "dl24[7:0]");
    ua_div_latch024.build();
    ua_div_latch124.configure(this, null, "dl24[15;8]");
    ua_div_latch124.build();
    ua_int_id24.configure(this, null, "iir24");
    ua_int_id24.build();
    ua_fifo_ctrl24.configure(this, null, "fcr24");
    ua_fifo_ctrl24.build();
    ua_lcr24.configure(this, null, "lcr24");
    ua_lcr24.build();
    ua_ier24.configure(this, null, "ier24");
    ua_ier24.build();
    // Now24 define address mappings24
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch024, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch124, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id24, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl24, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr24, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier24, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c24)
  function new(input string name="unnamed24-uart_ctrl_rf24");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c24

//////////////////////////////////////////////////////////////////////////////
// Address_map24 definition24
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c24 extends uvm_reg_block;

  rand uart_ctrl_rf_c24 uart_ctrl_rf24;

  function void build();
    // Now24 define address mappings24
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf24 = uart_ctrl_rf_c24::type_id::create("uart_ctrl_rf24", , get_full_name());
    uart_ctrl_rf24.configure(this, "regs");
    uart_ctrl_rf24.build();
    uart_ctrl_rf24.lock_model();
    default_map.add_submap(uart_ctrl_rf24.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top24.uart_dut24");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c24)
  function new(input string name="unnamed24-uart_ctrl_reg_model_c24");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c24

`endif // UART_CTRL_REGS_SV24
