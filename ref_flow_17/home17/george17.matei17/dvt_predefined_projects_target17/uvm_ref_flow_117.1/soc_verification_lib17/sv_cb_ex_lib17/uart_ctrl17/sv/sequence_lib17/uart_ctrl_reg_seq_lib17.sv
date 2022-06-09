/*-------------------------------------------------------------------------
File17 name   : uart_ctrl_reg_seq_lib17.sv
Title17       : UVM_REG Sequence Library17
Project17     :
Created17     :
Description17 : Register Sequence Library17 for the UART17 Controller17 DUT
Notes17       :
----------------------------------------------------------------------
Copyright17 2007 (c) Cadence17 Design17 Systems17, Inc17. All Rights17 Reserved17.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq17: Direct17 APB17 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq17 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq17)

   apb_pkg17::write_byte_seq17 write_seq17;
   rand bit [7:0] temp_data17;
   constraint c117 {temp_data17[7] == 1'b1; }

   function new(string name="apb_config_reg_seq17");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART17 Controller17 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line17 Control17 Register: bit 7, Divisor17 Latch17 Access = 1
      `uvm_do_with(write_seq17, { start_addr17 == 3; write_data17 == temp_data17; } )
      // Address 0: Divisor17 Latch17 Byte17 1 = 1
      `uvm_do_with(write_seq17, { start_addr17 == 0; write_data17 == 'h01; } )
      // Address 1: Divisor17 Latch17 Byte17 2 = 0
      `uvm_do_with(write_seq17, { start_addr17 == 1; write_data17 == 'h00; } )
      // Address 3: Line17 Control17 Register: bit 7, Divisor17 Latch17 Access = 0
      temp_data17[7] = 1'b0;
      `uvm_do_with(write_seq17, { start_addr17 == 3; write_data17 == temp_data17; } )
      `uvm_info(get_type_name(),
        "UART17 Controller17 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq17

//--------------------------------------------------------------------
// Base17 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq17 extends uvm_sequence;
  function new(string name="base_reg_seq17");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq17)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer17)

// Use a base sequence to raise/drop17 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running17 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq17

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq17: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq17 extends base_reg_seq17;

   // Pointer17 to the register model
   uart_ctrl_reg_model_c17 reg_model17;
   uvm_object rm_object17;

   `uvm_object_utils(uart_ctrl_config_reg_seq17)

   function new(string name="uart_ctrl_config_reg_seq17");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model17", rm_object17))
      $cast(reg_model17, rm_object17);
      `uvm_info(get_type_name(),
        "UART17 Controller17 Register configuration sequence starting...",
        UVM_LOW)
      // Line17 Control17 Register, set Divisor17 Latch17 Access = 1
      reg_model17.uart_ctrl_rf17.ua_lcr17.write(status, 'h8f);
      // Divisor17 Latch17 Byte17 1 = 1
      reg_model17.uart_ctrl_rf17.ua_div_latch017.write(status, 'h01);
      // Divisor17 Latch17 Byte17 2 = 0
      reg_model17.uart_ctrl_rf17.ua_div_latch117.write(status, 'h00);
      // Line17 Control17 Register, set Divisor17 Latch17 Access = 0
      reg_model17.uart_ctrl_rf17.ua_lcr17.write(status, 'h0f);
      //ToDo17: FIX17: DISABLE17 CHECKS17 AFTER CONFIG17 IS17 DONE
      reg_model17.uart_ctrl_rf17.ua_div_latch017.div_val17.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART17 Controller17 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq17

class uart_ctrl_1stopbit_reg_seq17 extends base_reg_seq17;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq17)

   function new(string name="uart_ctrl_1stopbit_reg_seq17");
      super.new(name);
   endfunction // new
 
   // Pointer17 to the register model
   uart_ctrl_rf_c17 reg_model17;
//   uart_ctrl_reg_model_c17 reg_model17;

   //ua_lcr_c17 ulcr17;
   //ua_div_latch0_c17 div_lsb17;
   //ua_div_latch1_c17 div_msb17;

   virtual task body();
     uvm_status_e status;
     reg_model17 = p_sequencer.reg_model17.uart_ctrl_rf17;
     `uvm_info(get_type_name(),
        "UART17 config register sequence with num_stop_bits17 == STOP117 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with17(ulcr17, "ua_lcr17", {value.num_stop_bits17 == 1'b0;})
      #50;
      //`rgm_write_by_name17(div_msb17, "ua_div_latch117")
      #50;
      //`rgm_write_by_name17(div_lsb17, "ua_div_latch017")
      #50;
      //ulcr17.value.div_latch_access17 = 1'b0;
      //`rgm_write_send17(ulcr17)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq17

class uart_cfg_rxtx_fifo_cov_reg_seq17 extends uart_ctrl_config_reg_seq17;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq17)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq17");
      super.new(name);
   endfunction : new
 
//   ua_ier_c17 uier17;
//   ua_idr_c17 uidr17;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx17/rx17 full/empty17 interrupts17...", UVM_LOW)
//     `rgm_write_by_name_with17(uier17, {uart_rf17, ".ua_ier17"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with17(uidr17, {uart_rf17, ".ua_idr17"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq17
