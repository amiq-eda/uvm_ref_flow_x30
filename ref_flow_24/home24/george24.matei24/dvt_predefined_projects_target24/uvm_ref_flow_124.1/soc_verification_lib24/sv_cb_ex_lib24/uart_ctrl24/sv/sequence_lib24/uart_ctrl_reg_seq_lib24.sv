/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_reg_seq_lib24.sv
Title24       : UVM_REG Sequence Library24
Project24     :
Created24     :
Description24 : Register Sequence Library24 for the UART24 Controller24 DUT
Notes24       :
----------------------------------------------------------------------
Copyright24 2007 (c) Cadence24 Design24 Systems24, Inc24. All Rights24 Reserved24.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq24: Direct24 APB24 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq24 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq24)

   apb_pkg24::write_byte_seq24 write_seq24;
   rand bit [7:0] temp_data24;
   constraint c124 {temp_data24[7] == 1'b1; }

   function new(string name="apb_config_reg_seq24");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART24 Controller24 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line24 Control24 Register: bit 7, Divisor24 Latch24 Access = 1
      `uvm_do_with(write_seq24, { start_addr24 == 3; write_data24 == temp_data24; } )
      // Address 0: Divisor24 Latch24 Byte24 1 = 1
      `uvm_do_with(write_seq24, { start_addr24 == 0; write_data24 == 'h01; } )
      // Address 1: Divisor24 Latch24 Byte24 2 = 0
      `uvm_do_with(write_seq24, { start_addr24 == 1; write_data24 == 'h00; } )
      // Address 3: Line24 Control24 Register: bit 7, Divisor24 Latch24 Access = 0
      temp_data24[7] = 1'b0;
      `uvm_do_with(write_seq24, { start_addr24 == 3; write_data24 == temp_data24; } )
      `uvm_info(get_type_name(),
        "UART24 Controller24 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq24

//--------------------------------------------------------------------
// Base24 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq24 extends uvm_sequence;
  function new(string name="base_reg_seq24");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq24)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer24)

// Use a base sequence to raise/drop24 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running24 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq24

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq24: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq24 extends base_reg_seq24;

   // Pointer24 to the register model
   uart_ctrl_reg_model_c24 reg_model24;
   uvm_object rm_object24;

   `uvm_object_utils(uart_ctrl_config_reg_seq24)

   function new(string name="uart_ctrl_config_reg_seq24");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model24", rm_object24))
      $cast(reg_model24, rm_object24);
      `uvm_info(get_type_name(),
        "UART24 Controller24 Register configuration sequence starting...",
        UVM_LOW)
      // Line24 Control24 Register, set Divisor24 Latch24 Access = 1
      reg_model24.uart_ctrl_rf24.ua_lcr24.write(status, 'h8f);
      // Divisor24 Latch24 Byte24 1 = 1
      reg_model24.uart_ctrl_rf24.ua_div_latch024.write(status, 'h01);
      // Divisor24 Latch24 Byte24 2 = 0
      reg_model24.uart_ctrl_rf24.ua_div_latch124.write(status, 'h00);
      // Line24 Control24 Register, set Divisor24 Latch24 Access = 0
      reg_model24.uart_ctrl_rf24.ua_lcr24.write(status, 'h0f);
      //ToDo24: FIX24: DISABLE24 CHECKS24 AFTER CONFIG24 IS24 DONE
      reg_model24.uart_ctrl_rf24.ua_div_latch024.div_val24.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART24 Controller24 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq24

class uart_ctrl_1stopbit_reg_seq24 extends base_reg_seq24;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq24)

   function new(string name="uart_ctrl_1stopbit_reg_seq24");
      super.new(name);
   endfunction // new
 
   // Pointer24 to the register model
   uart_ctrl_rf_c24 reg_model24;
//   uart_ctrl_reg_model_c24 reg_model24;

   //ua_lcr_c24 ulcr24;
   //ua_div_latch0_c24 div_lsb24;
   //ua_div_latch1_c24 div_msb24;

   virtual task body();
     uvm_status_e status;
     reg_model24 = p_sequencer.reg_model24.uart_ctrl_rf24;
     `uvm_info(get_type_name(),
        "UART24 config register sequence with num_stop_bits24 == STOP124 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with24(ulcr24, "ua_lcr24", {value.num_stop_bits24 == 1'b0;})
      #50;
      //`rgm_write_by_name24(div_msb24, "ua_div_latch124")
      #50;
      //`rgm_write_by_name24(div_lsb24, "ua_div_latch024")
      #50;
      //ulcr24.value.div_latch_access24 = 1'b0;
      //`rgm_write_send24(ulcr24)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq24

class uart_cfg_rxtx_fifo_cov_reg_seq24 extends uart_ctrl_config_reg_seq24;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq24)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq24");
      super.new(name);
   endfunction : new
 
//   ua_ier_c24 uier24;
//   ua_idr_c24 uidr24;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx24/rx24 full/empty24 interrupts24...", UVM_LOW)
//     `rgm_write_by_name_with24(uier24, {uart_rf24, ".ua_ier24"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with24(uidr24, {uart_rf24, ".ua_idr24"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq24
