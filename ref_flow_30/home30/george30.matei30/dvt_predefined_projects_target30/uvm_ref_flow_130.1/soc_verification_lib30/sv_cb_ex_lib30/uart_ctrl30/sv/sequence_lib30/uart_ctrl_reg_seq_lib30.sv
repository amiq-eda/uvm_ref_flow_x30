/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_reg_seq_lib30.sv
Title30       : UVM_REG Sequence Library30
Project30     :
Created30     :
Description30 : Register Sequence Library30 for the UART30 Controller30 DUT
Notes30       :
----------------------------------------------------------------------
Copyright30 2007 (c) Cadence30 Design30 Systems30, Inc30. All Rights30 Reserved30.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq30: Direct30 APB30 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq30 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq30)

   apb_pkg30::write_byte_seq30 write_seq30;
   rand bit [7:0] temp_data30;
   constraint c130 {temp_data30[7] == 1'b1; }

   function new(string name="apb_config_reg_seq30");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART30 Controller30 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line30 Control30 Register: bit 7, Divisor30 Latch30 Access = 1
      `uvm_do_with(write_seq30, { start_addr30 == 3; write_data30 == temp_data30; } )
      // Address 0: Divisor30 Latch30 Byte30 1 = 1
      `uvm_do_with(write_seq30, { start_addr30 == 0; write_data30 == 'h01; } )
      // Address 1: Divisor30 Latch30 Byte30 2 = 0
      `uvm_do_with(write_seq30, { start_addr30 == 1; write_data30 == 'h00; } )
      // Address 3: Line30 Control30 Register: bit 7, Divisor30 Latch30 Access = 0
      temp_data30[7] = 1'b0;
      `uvm_do_with(write_seq30, { start_addr30 == 3; write_data30 == temp_data30; } )
      `uvm_info(get_type_name(),
        "UART30 Controller30 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq30

//--------------------------------------------------------------------
// Base30 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq30 extends uvm_sequence;
  function new(string name="base_reg_seq30");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq30)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer30)

// Use a base sequence to raise/drop30 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running30 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq30

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq30: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq30 extends base_reg_seq30;

   // Pointer30 to the register model
   uart_ctrl_reg_model_c30 reg_model30;
   uvm_object rm_object30;

   `uvm_object_utils(uart_ctrl_config_reg_seq30)

   function new(string name="uart_ctrl_config_reg_seq30");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model30", rm_object30))
      $cast(reg_model30, rm_object30);
      `uvm_info(get_type_name(),
        "UART30 Controller30 Register configuration sequence starting...",
        UVM_LOW)
      // Line30 Control30 Register, set Divisor30 Latch30 Access = 1
      reg_model30.uart_ctrl_rf30.ua_lcr30.write(status, 'h8f);
      // Divisor30 Latch30 Byte30 1 = 1
      reg_model30.uart_ctrl_rf30.ua_div_latch030.write(status, 'h01);
      // Divisor30 Latch30 Byte30 2 = 0
      reg_model30.uart_ctrl_rf30.ua_div_latch130.write(status, 'h00);
      // Line30 Control30 Register, set Divisor30 Latch30 Access = 0
      reg_model30.uart_ctrl_rf30.ua_lcr30.write(status, 'h0f);
      //ToDo30: FIX30: DISABLE30 CHECKS30 AFTER CONFIG30 IS30 DONE
      reg_model30.uart_ctrl_rf30.ua_div_latch030.div_val30.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART30 Controller30 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq30

class uart_ctrl_1stopbit_reg_seq30 extends base_reg_seq30;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq30)

   function new(string name="uart_ctrl_1stopbit_reg_seq30");
      super.new(name);
   endfunction // new
 
   // Pointer30 to the register model
   uart_ctrl_rf_c30 reg_model30;
//   uart_ctrl_reg_model_c30 reg_model30;

   //ua_lcr_c30 ulcr30;
   //ua_div_latch0_c30 div_lsb30;
   //ua_div_latch1_c30 div_msb30;

   virtual task body();
     uvm_status_e status;
     reg_model30 = p_sequencer.reg_model30.uart_ctrl_rf30;
     `uvm_info(get_type_name(),
        "UART30 config register sequence with num_stop_bits30 == STOP130 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with30(ulcr30, "ua_lcr30", {value.num_stop_bits30 == 1'b0;})
      #50;
      //`rgm_write_by_name30(div_msb30, "ua_div_latch130")
      #50;
      //`rgm_write_by_name30(div_lsb30, "ua_div_latch030")
      #50;
      //ulcr30.value.div_latch_access30 = 1'b0;
      //`rgm_write_send30(ulcr30)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq30

class uart_cfg_rxtx_fifo_cov_reg_seq30 extends uart_ctrl_config_reg_seq30;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq30)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq30");
      super.new(name);
   endfunction : new
 
//   ua_ier_c30 uier30;
//   ua_idr_c30 uidr30;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx30/rx30 full/empty30 interrupts30...", UVM_LOW)
//     `rgm_write_by_name_with30(uier30, {uart_rf30, ".ua_ier30"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with30(uidr30, {uart_rf30, ".ua_idr30"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq30
