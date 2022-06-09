/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_reg_seq_lib10.sv
Title10       : UVM_REG Sequence Library10
Project10     :
Created10     :
Description10 : Register Sequence Library10 for the UART10 Controller10 DUT
Notes10       :
----------------------------------------------------------------------
Copyright10 2007 (c) Cadence10 Design10 Systems10, Inc10. All Rights10 Reserved10.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq10: Direct10 APB10 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq10 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq10)

   apb_pkg10::write_byte_seq10 write_seq10;
   rand bit [7:0] temp_data10;
   constraint c110 {temp_data10[7] == 1'b1; }

   function new(string name="apb_config_reg_seq10");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART10 Controller10 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line10 Control10 Register: bit 7, Divisor10 Latch10 Access = 1
      `uvm_do_with(write_seq10, { start_addr10 == 3; write_data10 == temp_data10; } )
      // Address 0: Divisor10 Latch10 Byte10 1 = 1
      `uvm_do_with(write_seq10, { start_addr10 == 0; write_data10 == 'h01; } )
      // Address 1: Divisor10 Latch10 Byte10 2 = 0
      `uvm_do_with(write_seq10, { start_addr10 == 1; write_data10 == 'h00; } )
      // Address 3: Line10 Control10 Register: bit 7, Divisor10 Latch10 Access = 0
      temp_data10[7] = 1'b0;
      `uvm_do_with(write_seq10, { start_addr10 == 3; write_data10 == temp_data10; } )
      `uvm_info(get_type_name(),
        "UART10 Controller10 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq10

//--------------------------------------------------------------------
// Base10 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq10 extends uvm_sequence;
  function new(string name="base_reg_seq10");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq10)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer10)

// Use a base sequence to raise/drop10 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running10 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq10

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq10: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq10 extends base_reg_seq10;

   // Pointer10 to the register model
   uart_ctrl_reg_model_c10 reg_model10;
   uvm_object rm_object10;

   `uvm_object_utils(uart_ctrl_config_reg_seq10)

   function new(string name="uart_ctrl_config_reg_seq10");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model10", rm_object10))
      $cast(reg_model10, rm_object10);
      `uvm_info(get_type_name(),
        "UART10 Controller10 Register configuration sequence starting...",
        UVM_LOW)
      // Line10 Control10 Register, set Divisor10 Latch10 Access = 1
      reg_model10.uart_ctrl_rf10.ua_lcr10.write(status, 'h8f);
      // Divisor10 Latch10 Byte10 1 = 1
      reg_model10.uart_ctrl_rf10.ua_div_latch010.write(status, 'h01);
      // Divisor10 Latch10 Byte10 2 = 0
      reg_model10.uart_ctrl_rf10.ua_div_latch110.write(status, 'h00);
      // Line10 Control10 Register, set Divisor10 Latch10 Access = 0
      reg_model10.uart_ctrl_rf10.ua_lcr10.write(status, 'h0f);
      //ToDo10: FIX10: DISABLE10 CHECKS10 AFTER CONFIG10 IS10 DONE
      reg_model10.uart_ctrl_rf10.ua_div_latch010.div_val10.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART10 Controller10 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq10

class uart_ctrl_1stopbit_reg_seq10 extends base_reg_seq10;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq10)

   function new(string name="uart_ctrl_1stopbit_reg_seq10");
      super.new(name);
   endfunction // new
 
   // Pointer10 to the register model
   uart_ctrl_rf_c10 reg_model10;
//   uart_ctrl_reg_model_c10 reg_model10;

   //ua_lcr_c10 ulcr10;
   //ua_div_latch0_c10 div_lsb10;
   //ua_div_latch1_c10 div_msb10;

   virtual task body();
     uvm_status_e status;
     reg_model10 = p_sequencer.reg_model10.uart_ctrl_rf10;
     `uvm_info(get_type_name(),
        "UART10 config register sequence with num_stop_bits10 == STOP110 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with10(ulcr10, "ua_lcr10", {value.num_stop_bits10 == 1'b0;})
      #50;
      //`rgm_write_by_name10(div_msb10, "ua_div_latch110")
      #50;
      //`rgm_write_by_name10(div_lsb10, "ua_div_latch010")
      #50;
      //ulcr10.value.div_latch_access10 = 1'b0;
      //`rgm_write_send10(ulcr10)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq10

class uart_cfg_rxtx_fifo_cov_reg_seq10 extends uart_ctrl_config_reg_seq10;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq10)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq10");
      super.new(name);
   endfunction : new
 
//   ua_ier_c10 uier10;
//   ua_idr_c10 uidr10;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx10/rx10 full/empty10 interrupts10...", UVM_LOW)
//     `rgm_write_by_name_with10(uier10, {uart_rf10, ".ua_ier10"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with10(uidr10, {uart_rf10, ".ua_idr10"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq10
