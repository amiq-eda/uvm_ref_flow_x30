/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_reg_seq_lib29.sv
Title29       : UVM_REG Sequence Library29
Project29     :
Created29     :
Description29 : Register Sequence Library29 for the UART29 Controller29 DUT
Notes29       :
----------------------------------------------------------------------
Copyright29 2007 (c) Cadence29 Design29 Systems29, Inc29. All Rights29 Reserved29.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq29: Direct29 APB29 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq29 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq29)

   apb_pkg29::write_byte_seq29 write_seq29;
   rand bit [7:0] temp_data29;
   constraint c129 {temp_data29[7] == 1'b1; }

   function new(string name="apb_config_reg_seq29");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART29 Controller29 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line29 Control29 Register: bit 7, Divisor29 Latch29 Access = 1
      `uvm_do_with(write_seq29, { start_addr29 == 3; write_data29 == temp_data29; } )
      // Address 0: Divisor29 Latch29 Byte29 1 = 1
      `uvm_do_with(write_seq29, { start_addr29 == 0; write_data29 == 'h01; } )
      // Address 1: Divisor29 Latch29 Byte29 2 = 0
      `uvm_do_with(write_seq29, { start_addr29 == 1; write_data29 == 'h00; } )
      // Address 3: Line29 Control29 Register: bit 7, Divisor29 Latch29 Access = 0
      temp_data29[7] = 1'b0;
      `uvm_do_with(write_seq29, { start_addr29 == 3; write_data29 == temp_data29; } )
      `uvm_info(get_type_name(),
        "UART29 Controller29 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq29

//--------------------------------------------------------------------
// Base29 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq29 extends uvm_sequence;
  function new(string name="base_reg_seq29");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq29)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer29)

// Use a base sequence to raise/drop29 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running29 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq29

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq29: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq29 extends base_reg_seq29;

   // Pointer29 to the register model
   uart_ctrl_reg_model_c29 reg_model29;
   uvm_object rm_object29;

   `uvm_object_utils(uart_ctrl_config_reg_seq29)

   function new(string name="uart_ctrl_config_reg_seq29");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model29", rm_object29))
      $cast(reg_model29, rm_object29);
      `uvm_info(get_type_name(),
        "UART29 Controller29 Register configuration sequence starting...",
        UVM_LOW)
      // Line29 Control29 Register, set Divisor29 Latch29 Access = 1
      reg_model29.uart_ctrl_rf29.ua_lcr29.write(status, 'h8f);
      // Divisor29 Latch29 Byte29 1 = 1
      reg_model29.uart_ctrl_rf29.ua_div_latch029.write(status, 'h01);
      // Divisor29 Latch29 Byte29 2 = 0
      reg_model29.uart_ctrl_rf29.ua_div_latch129.write(status, 'h00);
      // Line29 Control29 Register, set Divisor29 Latch29 Access = 0
      reg_model29.uart_ctrl_rf29.ua_lcr29.write(status, 'h0f);
      //ToDo29: FIX29: DISABLE29 CHECKS29 AFTER CONFIG29 IS29 DONE
      reg_model29.uart_ctrl_rf29.ua_div_latch029.div_val29.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART29 Controller29 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq29

class uart_ctrl_1stopbit_reg_seq29 extends base_reg_seq29;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq29)

   function new(string name="uart_ctrl_1stopbit_reg_seq29");
      super.new(name);
   endfunction // new
 
   // Pointer29 to the register model
   uart_ctrl_rf_c29 reg_model29;
//   uart_ctrl_reg_model_c29 reg_model29;

   //ua_lcr_c29 ulcr29;
   //ua_div_latch0_c29 div_lsb29;
   //ua_div_latch1_c29 div_msb29;

   virtual task body();
     uvm_status_e status;
     reg_model29 = p_sequencer.reg_model29.uart_ctrl_rf29;
     `uvm_info(get_type_name(),
        "UART29 config register sequence with num_stop_bits29 == STOP129 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with29(ulcr29, "ua_lcr29", {value.num_stop_bits29 == 1'b0;})
      #50;
      //`rgm_write_by_name29(div_msb29, "ua_div_latch129")
      #50;
      //`rgm_write_by_name29(div_lsb29, "ua_div_latch029")
      #50;
      //ulcr29.value.div_latch_access29 = 1'b0;
      //`rgm_write_send29(ulcr29)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq29

class uart_cfg_rxtx_fifo_cov_reg_seq29 extends uart_ctrl_config_reg_seq29;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq29)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq29");
      super.new(name);
   endfunction : new
 
//   ua_ier_c29 uier29;
//   ua_idr_c29 uidr29;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx29/rx29 full/empty29 interrupts29...", UVM_LOW)
//     `rgm_write_by_name_with29(uier29, {uart_rf29, ".ua_ier29"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with29(uidr29, {uart_rf29, ".ua_idr29"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq29
