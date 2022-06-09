/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_reg_seq_lib8.sv
Title8       : UVM_REG Sequence Library8
Project8     :
Created8     :
Description8 : Register Sequence Library8 for the UART8 Controller8 DUT
Notes8       :
----------------------------------------------------------------------
Copyright8 2007 (c) Cadence8 Design8 Systems8, Inc8. All Rights8 Reserved8.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq8: Direct8 APB8 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq8 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq8)

   apb_pkg8::write_byte_seq8 write_seq8;
   rand bit [7:0] temp_data8;
   constraint c18 {temp_data8[7] == 1'b1; }

   function new(string name="apb_config_reg_seq8");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART8 Controller8 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line8 Control8 Register: bit 7, Divisor8 Latch8 Access = 1
      `uvm_do_with(write_seq8, { start_addr8 == 3; write_data8 == temp_data8; } )
      // Address 0: Divisor8 Latch8 Byte8 1 = 1
      `uvm_do_with(write_seq8, { start_addr8 == 0; write_data8 == 'h01; } )
      // Address 1: Divisor8 Latch8 Byte8 2 = 0
      `uvm_do_with(write_seq8, { start_addr8 == 1; write_data8 == 'h00; } )
      // Address 3: Line8 Control8 Register: bit 7, Divisor8 Latch8 Access = 0
      temp_data8[7] = 1'b0;
      `uvm_do_with(write_seq8, { start_addr8 == 3; write_data8 == temp_data8; } )
      `uvm_info(get_type_name(),
        "UART8 Controller8 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq8

//--------------------------------------------------------------------
// Base8 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq8 extends uvm_sequence;
  function new(string name="base_reg_seq8");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq8)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer8)

// Use a base sequence to raise/drop8 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running8 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq8

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq8: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq8 extends base_reg_seq8;

   // Pointer8 to the register model
   uart_ctrl_reg_model_c8 reg_model8;
   uvm_object rm_object8;

   `uvm_object_utils(uart_ctrl_config_reg_seq8)

   function new(string name="uart_ctrl_config_reg_seq8");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model8", rm_object8))
      $cast(reg_model8, rm_object8);
      `uvm_info(get_type_name(),
        "UART8 Controller8 Register configuration sequence starting...",
        UVM_LOW)
      // Line8 Control8 Register, set Divisor8 Latch8 Access = 1
      reg_model8.uart_ctrl_rf8.ua_lcr8.write(status, 'h8f);
      // Divisor8 Latch8 Byte8 1 = 1
      reg_model8.uart_ctrl_rf8.ua_div_latch08.write(status, 'h01);
      // Divisor8 Latch8 Byte8 2 = 0
      reg_model8.uart_ctrl_rf8.ua_div_latch18.write(status, 'h00);
      // Line8 Control8 Register, set Divisor8 Latch8 Access = 0
      reg_model8.uart_ctrl_rf8.ua_lcr8.write(status, 'h0f);
      //ToDo8: FIX8: DISABLE8 CHECKS8 AFTER CONFIG8 IS8 DONE
      reg_model8.uart_ctrl_rf8.ua_div_latch08.div_val8.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART8 Controller8 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq8

class uart_ctrl_1stopbit_reg_seq8 extends base_reg_seq8;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq8)

   function new(string name="uart_ctrl_1stopbit_reg_seq8");
      super.new(name);
   endfunction // new
 
   // Pointer8 to the register model
   uart_ctrl_rf_c8 reg_model8;
//   uart_ctrl_reg_model_c8 reg_model8;

   //ua_lcr_c8 ulcr8;
   //ua_div_latch0_c8 div_lsb8;
   //ua_div_latch1_c8 div_msb8;

   virtual task body();
     uvm_status_e status;
     reg_model8 = p_sequencer.reg_model8.uart_ctrl_rf8;
     `uvm_info(get_type_name(),
        "UART8 config register sequence with num_stop_bits8 == STOP18 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with8(ulcr8, "ua_lcr8", {value.num_stop_bits8 == 1'b0;})
      #50;
      //`rgm_write_by_name8(div_msb8, "ua_div_latch18")
      #50;
      //`rgm_write_by_name8(div_lsb8, "ua_div_latch08")
      #50;
      //ulcr8.value.div_latch_access8 = 1'b0;
      //`rgm_write_send8(ulcr8)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq8

class uart_cfg_rxtx_fifo_cov_reg_seq8 extends uart_ctrl_config_reg_seq8;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq8)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq8");
      super.new(name);
   endfunction : new
 
//   ua_ier_c8 uier8;
//   ua_idr_c8 uidr8;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx8/rx8 full/empty8 interrupts8...", UVM_LOW)
//     `rgm_write_by_name_with8(uier8, {uart_rf8, ".ua_ier8"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with8(uidr8, {uart_rf8, ".ua_idr8"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq8
