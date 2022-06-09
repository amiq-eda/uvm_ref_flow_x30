/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_reg_seq_lib9.sv
Title9       : UVM_REG Sequence Library9
Project9     :
Created9     :
Description9 : Register Sequence Library9 for the UART9 Controller9 DUT
Notes9       :
----------------------------------------------------------------------
Copyright9 2007 (c) Cadence9 Design9 Systems9, Inc9. All Rights9 Reserved9.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq9: Direct9 APB9 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq9 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq9)

   apb_pkg9::write_byte_seq9 write_seq9;
   rand bit [7:0] temp_data9;
   constraint c19 {temp_data9[7] == 1'b1; }

   function new(string name="apb_config_reg_seq9");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART9 Controller9 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line9 Control9 Register: bit 7, Divisor9 Latch9 Access = 1
      `uvm_do_with(write_seq9, { start_addr9 == 3; write_data9 == temp_data9; } )
      // Address 0: Divisor9 Latch9 Byte9 1 = 1
      `uvm_do_with(write_seq9, { start_addr9 == 0; write_data9 == 'h01; } )
      // Address 1: Divisor9 Latch9 Byte9 2 = 0
      `uvm_do_with(write_seq9, { start_addr9 == 1; write_data9 == 'h00; } )
      // Address 3: Line9 Control9 Register: bit 7, Divisor9 Latch9 Access = 0
      temp_data9[7] = 1'b0;
      `uvm_do_with(write_seq9, { start_addr9 == 3; write_data9 == temp_data9; } )
      `uvm_info(get_type_name(),
        "UART9 Controller9 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq9

//--------------------------------------------------------------------
// Base9 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq9 extends uvm_sequence;
  function new(string name="base_reg_seq9");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq9)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer9)

// Use a base sequence to raise/drop9 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running9 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq9

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq9: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq9 extends base_reg_seq9;

   // Pointer9 to the register model
   uart_ctrl_reg_model_c9 reg_model9;
   uvm_object rm_object9;

   `uvm_object_utils(uart_ctrl_config_reg_seq9)

   function new(string name="uart_ctrl_config_reg_seq9");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model9", rm_object9))
      $cast(reg_model9, rm_object9);
      `uvm_info(get_type_name(),
        "UART9 Controller9 Register configuration sequence starting...",
        UVM_LOW)
      // Line9 Control9 Register, set Divisor9 Latch9 Access = 1
      reg_model9.uart_ctrl_rf9.ua_lcr9.write(status, 'h8f);
      // Divisor9 Latch9 Byte9 1 = 1
      reg_model9.uart_ctrl_rf9.ua_div_latch09.write(status, 'h01);
      // Divisor9 Latch9 Byte9 2 = 0
      reg_model9.uart_ctrl_rf9.ua_div_latch19.write(status, 'h00);
      // Line9 Control9 Register, set Divisor9 Latch9 Access = 0
      reg_model9.uart_ctrl_rf9.ua_lcr9.write(status, 'h0f);
      //ToDo9: FIX9: DISABLE9 CHECKS9 AFTER CONFIG9 IS9 DONE
      reg_model9.uart_ctrl_rf9.ua_div_latch09.div_val9.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART9 Controller9 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq9

class uart_ctrl_1stopbit_reg_seq9 extends base_reg_seq9;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq9)

   function new(string name="uart_ctrl_1stopbit_reg_seq9");
      super.new(name);
   endfunction // new
 
   // Pointer9 to the register model
   uart_ctrl_rf_c9 reg_model9;
//   uart_ctrl_reg_model_c9 reg_model9;

   //ua_lcr_c9 ulcr9;
   //ua_div_latch0_c9 div_lsb9;
   //ua_div_latch1_c9 div_msb9;

   virtual task body();
     uvm_status_e status;
     reg_model9 = p_sequencer.reg_model9.uart_ctrl_rf9;
     `uvm_info(get_type_name(),
        "UART9 config register sequence with num_stop_bits9 == STOP19 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with9(ulcr9, "ua_lcr9", {value.num_stop_bits9 == 1'b0;})
      #50;
      //`rgm_write_by_name9(div_msb9, "ua_div_latch19")
      #50;
      //`rgm_write_by_name9(div_lsb9, "ua_div_latch09")
      #50;
      //ulcr9.value.div_latch_access9 = 1'b0;
      //`rgm_write_send9(ulcr9)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq9

class uart_cfg_rxtx_fifo_cov_reg_seq9 extends uart_ctrl_config_reg_seq9;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq9)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq9");
      super.new(name);
   endfunction : new
 
//   ua_ier_c9 uier9;
//   ua_idr_c9 uidr9;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx9/rx9 full/empty9 interrupts9...", UVM_LOW)
//     `rgm_write_by_name_with9(uier9, {uart_rf9, ".ua_ier9"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with9(uidr9, {uart_rf9, ".ua_idr9"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq9
