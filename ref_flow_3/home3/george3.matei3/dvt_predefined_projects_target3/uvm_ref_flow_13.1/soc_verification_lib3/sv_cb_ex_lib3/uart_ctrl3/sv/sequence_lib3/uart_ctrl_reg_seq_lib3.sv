/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_reg_seq_lib3.sv
Title3       : UVM_REG Sequence Library3
Project3     :
Created3     :
Description3 : Register Sequence Library3 for the UART3 Controller3 DUT
Notes3       :
----------------------------------------------------------------------
Copyright3 2007 (c) Cadence3 Design3 Systems3, Inc3. All Rights3 Reserved3.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq3: Direct3 APB3 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq3 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq3)

   apb_pkg3::write_byte_seq3 write_seq3;
   rand bit [7:0] temp_data3;
   constraint c13 {temp_data3[7] == 1'b1; }

   function new(string name="apb_config_reg_seq3");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART3 Controller3 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line3 Control3 Register: bit 7, Divisor3 Latch3 Access = 1
      `uvm_do_with(write_seq3, { start_addr3 == 3; write_data3 == temp_data3; } )
      // Address 0: Divisor3 Latch3 Byte3 1 = 1
      `uvm_do_with(write_seq3, { start_addr3 == 0; write_data3 == 'h01; } )
      // Address 1: Divisor3 Latch3 Byte3 2 = 0
      `uvm_do_with(write_seq3, { start_addr3 == 1; write_data3 == 'h00; } )
      // Address 3: Line3 Control3 Register: bit 7, Divisor3 Latch3 Access = 0
      temp_data3[7] = 1'b0;
      `uvm_do_with(write_seq3, { start_addr3 == 3; write_data3 == temp_data3; } )
      `uvm_info(get_type_name(),
        "UART3 Controller3 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq3

//--------------------------------------------------------------------
// Base3 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq3 extends uvm_sequence;
  function new(string name="base_reg_seq3");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq3)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer3)

// Use a base sequence to raise/drop3 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running3 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq3

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq3: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq3 extends base_reg_seq3;

   // Pointer3 to the register model
   uart_ctrl_reg_model_c3 reg_model3;
   uvm_object rm_object3;

   `uvm_object_utils(uart_ctrl_config_reg_seq3)

   function new(string name="uart_ctrl_config_reg_seq3");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model3", rm_object3))
      $cast(reg_model3, rm_object3);
      `uvm_info(get_type_name(),
        "UART3 Controller3 Register configuration sequence starting...",
        UVM_LOW)
      // Line3 Control3 Register, set Divisor3 Latch3 Access = 1
      reg_model3.uart_ctrl_rf3.ua_lcr3.write(status, 'h8f);
      // Divisor3 Latch3 Byte3 1 = 1
      reg_model3.uart_ctrl_rf3.ua_div_latch03.write(status, 'h01);
      // Divisor3 Latch3 Byte3 2 = 0
      reg_model3.uart_ctrl_rf3.ua_div_latch13.write(status, 'h00);
      // Line3 Control3 Register, set Divisor3 Latch3 Access = 0
      reg_model3.uart_ctrl_rf3.ua_lcr3.write(status, 'h0f);
      //ToDo3: FIX3: DISABLE3 CHECKS3 AFTER CONFIG3 IS3 DONE
      reg_model3.uart_ctrl_rf3.ua_div_latch03.div_val3.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART3 Controller3 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq3

class uart_ctrl_1stopbit_reg_seq3 extends base_reg_seq3;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq3)

   function new(string name="uart_ctrl_1stopbit_reg_seq3");
      super.new(name);
   endfunction // new
 
   // Pointer3 to the register model
   uart_ctrl_rf_c3 reg_model3;
//   uart_ctrl_reg_model_c3 reg_model3;

   //ua_lcr_c3 ulcr3;
   //ua_div_latch0_c3 div_lsb3;
   //ua_div_latch1_c3 div_msb3;

   virtual task body();
     uvm_status_e status;
     reg_model3 = p_sequencer.reg_model3.uart_ctrl_rf3;
     `uvm_info(get_type_name(),
        "UART3 config register sequence with num_stop_bits3 == STOP13 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with3(ulcr3, "ua_lcr3", {value.num_stop_bits3 == 1'b0;})
      #50;
      //`rgm_write_by_name3(div_msb3, "ua_div_latch13")
      #50;
      //`rgm_write_by_name3(div_lsb3, "ua_div_latch03")
      #50;
      //ulcr3.value.div_latch_access3 = 1'b0;
      //`rgm_write_send3(ulcr3)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq3

class uart_cfg_rxtx_fifo_cov_reg_seq3 extends uart_ctrl_config_reg_seq3;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq3)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq3");
      super.new(name);
   endfunction : new
 
//   ua_ier_c3 uier3;
//   ua_idr_c3 uidr3;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx3/rx3 full/empty3 interrupts3...", UVM_LOW)
//     `rgm_write_by_name_with3(uier3, {uart_rf3, ".ua_ier3"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with3(uidr3, {uart_rf3, ".ua_idr3"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq3
