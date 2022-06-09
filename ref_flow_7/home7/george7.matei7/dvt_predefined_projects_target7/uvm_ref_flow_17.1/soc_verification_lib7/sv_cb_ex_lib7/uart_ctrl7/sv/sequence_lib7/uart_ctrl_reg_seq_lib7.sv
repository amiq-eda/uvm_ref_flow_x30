/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_reg_seq_lib7.sv
Title7       : UVM_REG Sequence Library7
Project7     :
Created7     :
Description7 : Register Sequence Library7 for the UART7 Controller7 DUT
Notes7       :
----------------------------------------------------------------------
Copyright7 2007 (c) Cadence7 Design7 Systems7, Inc7. All Rights7 Reserved7.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq7: Direct7 APB7 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq7 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq7)

   apb_pkg7::write_byte_seq7 write_seq7;
   rand bit [7:0] temp_data7;
   constraint c17 {temp_data7[7] == 1'b1; }

   function new(string name="apb_config_reg_seq7");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART7 Controller7 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line7 Control7 Register: bit 7, Divisor7 Latch7 Access = 1
      `uvm_do_with(write_seq7, { start_addr7 == 3; write_data7 == temp_data7; } )
      // Address 0: Divisor7 Latch7 Byte7 1 = 1
      `uvm_do_with(write_seq7, { start_addr7 == 0; write_data7 == 'h01; } )
      // Address 1: Divisor7 Latch7 Byte7 2 = 0
      `uvm_do_with(write_seq7, { start_addr7 == 1; write_data7 == 'h00; } )
      // Address 3: Line7 Control7 Register: bit 7, Divisor7 Latch7 Access = 0
      temp_data7[7] = 1'b0;
      `uvm_do_with(write_seq7, { start_addr7 == 3; write_data7 == temp_data7; } )
      `uvm_info(get_type_name(),
        "UART7 Controller7 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq7

//--------------------------------------------------------------------
// Base7 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq7 extends uvm_sequence;
  function new(string name="base_reg_seq7");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq7)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer7)

// Use a base sequence to raise/drop7 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running7 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq7

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq7: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq7 extends base_reg_seq7;

   // Pointer7 to the register model
   uart_ctrl_reg_model_c7 reg_model7;
   uvm_object rm_object7;

   `uvm_object_utils(uart_ctrl_config_reg_seq7)

   function new(string name="uart_ctrl_config_reg_seq7");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model7", rm_object7))
      $cast(reg_model7, rm_object7);
      `uvm_info(get_type_name(),
        "UART7 Controller7 Register configuration sequence starting...",
        UVM_LOW)
      // Line7 Control7 Register, set Divisor7 Latch7 Access = 1
      reg_model7.uart_ctrl_rf7.ua_lcr7.write(status, 'h8f);
      // Divisor7 Latch7 Byte7 1 = 1
      reg_model7.uart_ctrl_rf7.ua_div_latch07.write(status, 'h01);
      // Divisor7 Latch7 Byte7 2 = 0
      reg_model7.uart_ctrl_rf7.ua_div_latch17.write(status, 'h00);
      // Line7 Control7 Register, set Divisor7 Latch7 Access = 0
      reg_model7.uart_ctrl_rf7.ua_lcr7.write(status, 'h0f);
      //ToDo7: FIX7: DISABLE7 CHECKS7 AFTER CONFIG7 IS7 DONE
      reg_model7.uart_ctrl_rf7.ua_div_latch07.div_val7.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART7 Controller7 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq7

class uart_ctrl_1stopbit_reg_seq7 extends base_reg_seq7;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq7)

   function new(string name="uart_ctrl_1stopbit_reg_seq7");
      super.new(name);
   endfunction // new
 
   // Pointer7 to the register model
   uart_ctrl_rf_c7 reg_model7;
//   uart_ctrl_reg_model_c7 reg_model7;

   //ua_lcr_c7 ulcr7;
   //ua_div_latch0_c7 div_lsb7;
   //ua_div_latch1_c7 div_msb7;

   virtual task body();
     uvm_status_e status;
     reg_model7 = p_sequencer.reg_model7.uart_ctrl_rf7;
     `uvm_info(get_type_name(),
        "UART7 config register sequence with num_stop_bits7 == STOP17 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with7(ulcr7, "ua_lcr7", {value.num_stop_bits7 == 1'b0;})
      #50;
      //`rgm_write_by_name7(div_msb7, "ua_div_latch17")
      #50;
      //`rgm_write_by_name7(div_lsb7, "ua_div_latch07")
      #50;
      //ulcr7.value.div_latch_access7 = 1'b0;
      //`rgm_write_send7(ulcr7)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq7

class uart_cfg_rxtx_fifo_cov_reg_seq7 extends uart_ctrl_config_reg_seq7;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq7)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq7");
      super.new(name);
   endfunction : new
 
//   ua_ier_c7 uier7;
//   ua_idr_c7 uidr7;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx7/rx7 full/empty7 interrupts7...", UVM_LOW)
//     `rgm_write_by_name_with7(uier7, {uart_rf7, ".ua_ier7"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with7(uidr7, {uart_rf7, ".ua_idr7"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq7
