/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_reg_seq_lib21.sv
Title21       : UVM_REG Sequence Library21
Project21     :
Created21     :
Description21 : Register Sequence Library21 for the UART21 Controller21 DUT
Notes21       :
----------------------------------------------------------------------
Copyright21 2007 (c) Cadence21 Design21 Systems21, Inc21. All Rights21 Reserved21.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq21: Direct21 APB21 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq21 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq21)

   apb_pkg21::write_byte_seq21 write_seq21;
   rand bit [7:0] temp_data21;
   constraint c121 {temp_data21[7] == 1'b1; }

   function new(string name="apb_config_reg_seq21");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART21 Controller21 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line21 Control21 Register: bit 7, Divisor21 Latch21 Access = 1
      `uvm_do_with(write_seq21, { start_addr21 == 3; write_data21 == temp_data21; } )
      // Address 0: Divisor21 Latch21 Byte21 1 = 1
      `uvm_do_with(write_seq21, { start_addr21 == 0; write_data21 == 'h01; } )
      // Address 1: Divisor21 Latch21 Byte21 2 = 0
      `uvm_do_with(write_seq21, { start_addr21 == 1; write_data21 == 'h00; } )
      // Address 3: Line21 Control21 Register: bit 7, Divisor21 Latch21 Access = 0
      temp_data21[7] = 1'b0;
      `uvm_do_with(write_seq21, { start_addr21 == 3; write_data21 == temp_data21; } )
      `uvm_info(get_type_name(),
        "UART21 Controller21 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq21

//--------------------------------------------------------------------
// Base21 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq21 extends uvm_sequence;
  function new(string name="base_reg_seq21");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq21)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer21)

// Use a base sequence to raise/drop21 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running21 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq21

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq21: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq21 extends base_reg_seq21;

   // Pointer21 to the register model
   uart_ctrl_reg_model_c21 reg_model21;
   uvm_object rm_object21;

   `uvm_object_utils(uart_ctrl_config_reg_seq21)

   function new(string name="uart_ctrl_config_reg_seq21");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model21", rm_object21))
      $cast(reg_model21, rm_object21);
      `uvm_info(get_type_name(),
        "UART21 Controller21 Register configuration sequence starting...",
        UVM_LOW)
      // Line21 Control21 Register, set Divisor21 Latch21 Access = 1
      reg_model21.uart_ctrl_rf21.ua_lcr21.write(status, 'h8f);
      // Divisor21 Latch21 Byte21 1 = 1
      reg_model21.uart_ctrl_rf21.ua_div_latch021.write(status, 'h01);
      // Divisor21 Latch21 Byte21 2 = 0
      reg_model21.uart_ctrl_rf21.ua_div_latch121.write(status, 'h00);
      // Line21 Control21 Register, set Divisor21 Latch21 Access = 0
      reg_model21.uart_ctrl_rf21.ua_lcr21.write(status, 'h0f);
      //ToDo21: FIX21: DISABLE21 CHECKS21 AFTER CONFIG21 IS21 DONE
      reg_model21.uart_ctrl_rf21.ua_div_latch021.div_val21.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART21 Controller21 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq21

class uart_ctrl_1stopbit_reg_seq21 extends base_reg_seq21;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq21)

   function new(string name="uart_ctrl_1stopbit_reg_seq21");
      super.new(name);
   endfunction // new
 
   // Pointer21 to the register model
   uart_ctrl_rf_c21 reg_model21;
//   uart_ctrl_reg_model_c21 reg_model21;

   //ua_lcr_c21 ulcr21;
   //ua_div_latch0_c21 div_lsb21;
   //ua_div_latch1_c21 div_msb21;

   virtual task body();
     uvm_status_e status;
     reg_model21 = p_sequencer.reg_model21.uart_ctrl_rf21;
     `uvm_info(get_type_name(),
        "UART21 config register sequence with num_stop_bits21 == STOP121 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with21(ulcr21, "ua_lcr21", {value.num_stop_bits21 == 1'b0;})
      #50;
      //`rgm_write_by_name21(div_msb21, "ua_div_latch121")
      #50;
      //`rgm_write_by_name21(div_lsb21, "ua_div_latch021")
      #50;
      //ulcr21.value.div_latch_access21 = 1'b0;
      //`rgm_write_send21(ulcr21)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq21

class uart_cfg_rxtx_fifo_cov_reg_seq21 extends uart_ctrl_config_reg_seq21;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq21)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq21");
      super.new(name);
   endfunction : new
 
//   ua_ier_c21 uier21;
//   ua_idr_c21 uidr21;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx21/rx21 full/empty21 interrupts21...", UVM_LOW)
//     `rgm_write_by_name_with21(uier21, {uart_rf21, ".ua_ier21"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with21(uidr21, {uart_rf21, ".ua_idr21"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq21
