/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_reg_seq_lib4.sv
Title4       : UVM_REG Sequence Library4
Project4     :
Created4     :
Description4 : Register Sequence Library4 for the UART4 Controller4 DUT
Notes4       :
----------------------------------------------------------------------
Copyright4 2007 (c) Cadence4 Design4 Systems4, Inc4. All Rights4 Reserved4.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq4: Direct4 APB4 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq4 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq4)

   apb_pkg4::write_byte_seq4 write_seq4;
   rand bit [7:0] temp_data4;
   constraint c14 {temp_data4[7] == 1'b1; }

   function new(string name="apb_config_reg_seq4");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART4 Controller4 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line4 Control4 Register: bit 7, Divisor4 Latch4 Access = 1
      `uvm_do_with(write_seq4, { start_addr4 == 3; write_data4 == temp_data4; } )
      // Address 0: Divisor4 Latch4 Byte4 1 = 1
      `uvm_do_with(write_seq4, { start_addr4 == 0; write_data4 == 'h01; } )
      // Address 1: Divisor4 Latch4 Byte4 2 = 0
      `uvm_do_with(write_seq4, { start_addr4 == 1; write_data4 == 'h00; } )
      // Address 3: Line4 Control4 Register: bit 7, Divisor4 Latch4 Access = 0
      temp_data4[7] = 1'b0;
      `uvm_do_with(write_seq4, { start_addr4 == 3; write_data4 == temp_data4; } )
      `uvm_info(get_type_name(),
        "UART4 Controller4 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq4

//--------------------------------------------------------------------
// Base4 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq4 extends uvm_sequence;
  function new(string name="base_reg_seq4");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq4)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer4)

// Use a base sequence to raise/drop4 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running4 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq4

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq4: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq4 extends base_reg_seq4;

   // Pointer4 to the register model
   uart_ctrl_reg_model_c4 reg_model4;
   uvm_object rm_object4;

   `uvm_object_utils(uart_ctrl_config_reg_seq4)

   function new(string name="uart_ctrl_config_reg_seq4");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model4", rm_object4))
      $cast(reg_model4, rm_object4);
      `uvm_info(get_type_name(),
        "UART4 Controller4 Register configuration sequence starting...",
        UVM_LOW)
      // Line4 Control4 Register, set Divisor4 Latch4 Access = 1
      reg_model4.uart_ctrl_rf4.ua_lcr4.write(status, 'h8f);
      // Divisor4 Latch4 Byte4 1 = 1
      reg_model4.uart_ctrl_rf4.ua_div_latch04.write(status, 'h01);
      // Divisor4 Latch4 Byte4 2 = 0
      reg_model4.uart_ctrl_rf4.ua_div_latch14.write(status, 'h00);
      // Line4 Control4 Register, set Divisor4 Latch4 Access = 0
      reg_model4.uart_ctrl_rf4.ua_lcr4.write(status, 'h0f);
      //ToDo4: FIX4: DISABLE4 CHECKS4 AFTER CONFIG4 IS4 DONE
      reg_model4.uart_ctrl_rf4.ua_div_latch04.div_val4.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART4 Controller4 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq4

class uart_ctrl_1stopbit_reg_seq4 extends base_reg_seq4;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq4)

   function new(string name="uart_ctrl_1stopbit_reg_seq4");
      super.new(name);
   endfunction // new
 
   // Pointer4 to the register model
   uart_ctrl_rf_c4 reg_model4;
//   uart_ctrl_reg_model_c4 reg_model4;

   //ua_lcr_c4 ulcr4;
   //ua_div_latch0_c4 div_lsb4;
   //ua_div_latch1_c4 div_msb4;

   virtual task body();
     uvm_status_e status;
     reg_model4 = p_sequencer.reg_model4.uart_ctrl_rf4;
     `uvm_info(get_type_name(),
        "UART4 config register sequence with num_stop_bits4 == STOP14 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with4(ulcr4, "ua_lcr4", {value.num_stop_bits4 == 1'b0;})
      #50;
      //`rgm_write_by_name4(div_msb4, "ua_div_latch14")
      #50;
      //`rgm_write_by_name4(div_lsb4, "ua_div_latch04")
      #50;
      //ulcr4.value.div_latch_access4 = 1'b0;
      //`rgm_write_send4(ulcr4)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq4

class uart_cfg_rxtx_fifo_cov_reg_seq4 extends uart_ctrl_config_reg_seq4;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq4)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq4");
      super.new(name);
   endfunction : new
 
//   ua_ier_c4 uier4;
//   ua_idr_c4 uidr4;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx4/rx4 full/empty4 interrupts4...", UVM_LOW)
//     `rgm_write_by_name_with4(uier4, {uart_rf4, ".ua_ier4"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with4(uidr4, {uart_rf4, ".ua_idr4"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq4
