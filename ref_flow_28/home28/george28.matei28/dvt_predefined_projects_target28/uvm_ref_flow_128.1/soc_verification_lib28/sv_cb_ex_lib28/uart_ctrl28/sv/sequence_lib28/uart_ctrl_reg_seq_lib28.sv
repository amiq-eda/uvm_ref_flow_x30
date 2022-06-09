/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_reg_seq_lib28.sv
Title28       : UVM_REG Sequence Library28
Project28     :
Created28     :
Description28 : Register Sequence Library28 for the UART28 Controller28 DUT
Notes28       :
----------------------------------------------------------------------
Copyright28 2007 (c) Cadence28 Design28 Systems28, Inc28. All Rights28 Reserved28.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq28: Direct28 APB28 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq28 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq28)

   apb_pkg28::write_byte_seq28 write_seq28;
   rand bit [7:0] temp_data28;
   constraint c128 {temp_data28[7] == 1'b1; }

   function new(string name="apb_config_reg_seq28");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART28 Controller28 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line28 Control28 Register: bit 7, Divisor28 Latch28 Access = 1
      `uvm_do_with(write_seq28, { start_addr28 == 3; write_data28 == temp_data28; } )
      // Address 0: Divisor28 Latch28 Byte28 1 = 1
      `uvm_do_with(write_seq28, { start_addr28 == 0; write_data28 == 'h01; } )
      // Address 1: Divisor28 Latch28 Byte28 2 = 0
      `uvm_do_with(write_seq28, { start_addr28 == 1; write_data28 == 'h00; } )
      // Address 3: Line28 Control28 Register: bit 7, Divisor28 Latch28 Access = 0
      temp_data28[7] = 1'b0;
      `uvm_do_with(write_seq28, { start_addr28 == 3; write_data28 == temp_data28; } )
      `uvm_info(get_type_name(),
        "UART28 Controller28 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq28

//--------------------------------------------------------------------
// Base28 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq28 extends uvm_sequence;
  function new(string name="base_reg_seq28");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq28)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer28)

// Use a base sequence to raise/drop28 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running28 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq28

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq28: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq28 extends base_reg_seq28;

   // Pointer28 to the register model
   uart_ctrl_reg_model_c28 reg_model28;
   uvm_object rm_object28;

   `uvm_object_utils(uart_ctrl_config_reg_seq28)

   function new(string name="uart_ctrl_config_reg_seq28");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model28", rm_object28))
      $cast(reg_model28, rm_object28);
      `uvm_info(get_type_name(),
        "UART28 Controller28 Register configuration sequence starting...",
        UVM_LOW)
      // Line28 Control28 Register, set Divisor28 Latch28 Access = 1
      reg_model28.uart_ctrl_rf28.ua_lcr28.write(status, 'h8f);
      // Divisor28 Latch28 Byte28 1 = 1
      reg_model28.uart_ctrl_rf28.ua_div_latch028.write(status, 'h01);
      // Divisor28 Latch28 Byte28 2 = 0
      reg_model28.uart_ctrl_rf28.ua_div_latch128.write(status, 'h00);
      // Line28 Control28 Register, set Divisor28 Latch28 Access = 0
      reg_model28.uart_ctrl_rf28.ua_lcr28.write(status, 'h0f);
      //ToDo28: FIX28: DISABLE28 CHECKS28 AFTER CONFIG28 IS28 DONE
      reg_model28.uart_ctrl_rf28.ua_div_latch028.div_val28.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART28 Controller28 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq28

class uart_ctrl_1stopbit_reg_seq28 extends base_reg_seq28;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq28)

   function new(string name="uart_ctrl_1stopbit_reg_seq28");
      super.new(name);
   endfunction // new
 
   // Pointer28 to the register model
   uart_ctrl_rf_c28 reg_model28;
//   uart_ctrl_reg_model_c28 reg_model28;

   //ua_lcr_c28 ulcr28;
   //ua_div_latch0_c28 div_lsb28;
   //ua_div_latch1_c28 div_msb28;

   virtual task body();
     uvm_status_e status;
     reg_model28 = p_sequencer.reg_model28.uart_ctrl_rf28;
     `uvm_info(get_type_name(),
        "UART28 config register sequence with num_stop_bits28 == STOP128 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with28(ulcr28, "ua_lcr28", {value.num_stop_bits28 == 1'b0;})
      #50;
      //`rgm_write_by_name28(div_msb28, "ua_div_latch128")
      #50;
      //`rgm_write_by_name28(div_lsb28, "ua_div_latch028")
      #50;
      //ulcr28.value.div_latch_access28 = 1'b0;
      //`rgm_write_send28(ulcr28)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq28

class uart_cfg_rxtx_fifo_cov_reg_seq28 extends uart_ctrl_config_reg_seq28;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq28)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq28");
      super.new(name);
   endfunction : new
 
//   ua_ier_c28 uier28;
//   ua_idr_c28 uidr28;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx28/rx28 full/empty28 interrupts28...", UVM_LOW)
//     `rgm_write_by_name_with28(uier28, {uart_rf28, ".ua_ier28"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with28(uidr28, {uart_rf28, ".ua_idr28"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq28
