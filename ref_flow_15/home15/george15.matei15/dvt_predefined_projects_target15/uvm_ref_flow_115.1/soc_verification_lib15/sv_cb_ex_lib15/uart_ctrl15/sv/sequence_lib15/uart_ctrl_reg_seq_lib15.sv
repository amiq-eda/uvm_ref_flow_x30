/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_reg_seq_lib15.sv
Title15       : UVM_REG Sequence Library15
Project15     :
Created15     :
Description15 : Register Sequence Library15 for the UART15 Controller15 DUT
Notes15       :
----------------------------------------------------------------------
Copyright15 2007 (c) Cadence15 Design15 Systems15, Inc15. All Rights15 Reserved15.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq15: Direct15 APB15 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq15 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq15)

   apb_pkg15::write_byte_seq15 write_seq15;
   rand bit [7:0] temp_data15;
   constraint c115 {temp_data15[7] == 1'b1; }

   function new(string name="apb_config_reg_seq15");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART15 Controller15 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line15 Control15 Register: bit 7, Divisor15 Latch15 Access = 1
      `uvm_do_with(write_seq15, { start_addr15 == 3; write_data15 == temp_data15; } )
      // Address 0: Divisor15 Latch15 Byte15 1 = 1
      `uvm_do_with(write_seq15, { start_addr15 == 0; write_data15 == 'h01; } )
      // Address 1: Divisor15 Latch15 Byte15 2 = 0
      `uvm_do_with(write_seq15, { start_addr15 == 1; write_data15 == 'h00; } )
      // Address 3: Line15 Control15 Register: bit 7, Divisor15 Latch15 Access = 0
      temp_data15[7] = 1'b0;
      `uvm_do_with(write_seq15, { start_addr15 == 3; write_data15 == temp_data15; } )
      `uvm_info(get_type_name(),
        "UART15 Controller15 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq15

//--------------------------------------------------------------------
// Base15 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq15 extends uvm_sequence;
  function new(string name="base_reg_seq15");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq15)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer15)

// Use a base sequence to raise/drop15 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running15 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq15

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq15: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq15 extends base_reg_seq15;

   // Pointer15 to the register model
   uart_ctrl_reg_model_c15 reg_model15;
   uvm_object rm_object15;

   `uvm_object_utils(uart_ctrl_config_reg_seq15)

   function new(string name="uart_ctrl_config_reg_seq15");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model15", rm_object15))
      $cast(reg_model15, rm_object15);
      `uvm_info(get_type_name(),
        "UART15 Controller15 Register configuration sequence starting...",
        UVM_LOW)
      // Line15 Control15 Register, set Divisor15 Latch15 Access = 1
      reg_model15.uart_ctrl_rf15.ua_lcr15.write(status, 'h8f);
      // Divisor15 Latch15 Byte15 1 = 1
      reg_model15.uart_ctrl_rf15.ua_div_latch015.write(status, 'h01);
      // Divisor15 Latch15 Byte15 2 = 0
      reg_model15.uart_ctrl_rf15.ua_div_latch115.write(status, 'h00);
      // Line15 Control15 Register, set Divisor15 Latch15 Access = 0
      reg_model15.uart_ctrl_rf15.ua_lcr15.write(status, 'h0f);
      //ToDo15: FIX15: DISABLE15 CHECKS15 AFTER CONFIG15 IS15 DONE
      reg_model15.uart_ctrl_rf15.ua_div_latch015.div_val15.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART15 Controller15 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq15

class uart_ctrl_1stopbit_reg_seq15 extends base_reg_seq15;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq15)

   function new(string name="uart_ctrl_1stopbit_reg_seq15");
      super.new(name);
   endfunction // new
 
   // Pointer15 to the register model
   uart_ctrl_rf_c15 reg_model15;
//   uart_ctrl_reg_model_c15 reg_model15;

   //ua_lcr_c15 ulcr15;
   //ua_div_latch0_c15 div_lsb15;
   //ua_div_latch1_c15 div_msb15;

   virtual task body();
     uvm_status_e status;
     reg_model15 = p_sequencer.reg_model15.uart_ctrl_rf15;
     `uvm_info(get_type_name(),
        "UART15 config register sequence with num_stop_bits15 == STOP115 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with15(ulcr15, "ua_lcr15", {value.num_stop_bits15 == 1'b0;})
      #50;
      //`rgm_write_by_name15(div_msb15, "ua_div_latch115")
      #50;
      //`rgm_write_by_name15(div_lsb15, "ua_div_latch015")
      #50;
      //ulcr15.value.div_latch_access15 = 1'b0;
      //`rgm_write_send15(ulcr15)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq15

class uart_cfg_rxtx_fifo_cov_reg_seq15 extends uart_ctrl_config_reg_seq15;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq15)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq15");
      super.new(name);
   endfunction : new
 
//   ua_ier_c15 uier15;
//   ua_idr_c15 uidr15;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx15/rx15 full/empty15 interrupts15...", UVM_LOW)
//     `rgm_write_by_name_with15(uier15, {uart_rf15, ".ua_ier15"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with15(uidr15, {uart_rf15, ".ua_idr15"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq15
