/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_reg_seq_lib13.sv
Title13       : UVM_REG Sequence Library13
Project13     :
Created13     :
Description13 : Register Sequence Library13 for the UART13 Controller13 DUT
Notes13       :
----------------------------------------------------------------------
Copyright13 2007 (c) Cadence13 Design13 Systems13, Inc13. All Rights13 Reserved13.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq13: Direct13 APB13 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq13 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq13)

   apb_pkg13::write_byte_seq13 write_seq13;
   rand bit [7:0] temp_data13;
   constraint c113 {temp_data13[7] == 1'b1; }

   function new(string name="apb_config_reg_seq13");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART13 Controller13 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line13 Control13 Register: bit 7, Divisor13 Latch13 Access = 1
      `uvm_do_with(write_seq13, { start_addr13 == 3; write_data13 == temp_data13; } )
      // Address 0: Divisor13 Latch13 Byte13 1 = 1
      `uvm_do_with(write_seq13, { start_addr13 == 0; write_data13 == 'h01; } )
      // Address 1: Divisor13 Latch13 Byte13 2 = 0
      `uvm_do_with(write_seq13, { start_addr13 == 1; write_data13 == 'h00; } )
      // Address 3: Line13 Control13 Register: bit 7, Divisor13 Latch13 Access = 0
      temp_data13[7] = 1'b0;
      `uvm_do_with(write_seq13, { start_addr13 == 3; write_data13 == temp_data13; } )
      `uvm_info(get_type_name(),
        "UART13 Controller13 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq13

//--------------------------------------------------------------------
// Base13 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq13 extends uvm_sequence;
  function new(string name="base_reg_seq13");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq13)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer13)

// Use a base sequence to raise/drop13 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running13 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq13

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq13: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq13 extends base_reg_seq13;

   // Pointer13 to the register model
   uart_ctrl_reg_model_c13 reg_model13;
   uvm_object rm_object13;

   `uvm_object_utils(uart_ctrl_config_reg_seq13)

   function new(string name="uart_ctrl_config_reg_seq13");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model13", rm_object13))
      $cast(reg_model13, rm_object13);
      `uvm_info(get_type_name(),
        "UART13 Controller13 Register configuration sequence starting...",
        UVM_LOW)
      // Line13 Control13 Register, set Divisor13 Latch13 Access = 1
      reg_model13.uart_ctrl_rf13.ua_lcr13.write(status, 'h8f);
      // Divisor13 Latch13 Byte13 1 = 1
      reg_model13.uart_ctrl_rf13.ua_div_latch013.write(status, 'h01);
      // Divisor13 Latch13 Byte13 2 = 0
      reg_model13.uart_ctrl_rf13.ua_div_latch113.write(status, 'h00);
      // Line13 Control13 Register, set Divisor13 Latch13 Access = 0
      reg_model13.uart_ctrl_rf13.ua_lcr13.write(status, 'h0f);
      //ToDo13: FIX13: DISABLE13 CHECKS13 AFTER CONFIG13 IS13 DONE
      reg_model13.uart_ctrl_rf13.ua_div_latch013.div_val13.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART13 Controller13 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq13

class uart_ctrl_1stopbit_reg_seq13 extends base_reg_seq13;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq13)

   function new(string name="uart_ctrl_1stopbit_reg_seq13");
      super.new(name);
   endfunction // new
 
   // Pointer13 to the register model
   uart_ctrl_rf_c13 reg_model13;
//   uart_ctrl_reg_model_c13 reg_model13;

   //ua_lcr_c13 ulcr13;
   //ua_div_latch0_c13 div_lsb13;
   //ua_div_latch1_c13 div_msb13;

   virtual task body();
     uvm_status_e status;
     reg_model13 = p_sequencer.reg_model13.uart_ctrl_rf13;
     `uvm_info(get_type_name(),
        "UART13 config register sequence with num_stop_bits13 == STOP113 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with13(ulcr13, "ua_lcr13", {value.num_stop_bits13 == 1'b0;})
      #50;
      //`rgm_write_by_name13(div_msb13, "ua_div_latch113")
      #50;
      //`rgm_write_by_name13(div_lsb13, "ua_div_latch013")
      #50;
      //ulcr13.value.div_latch_access13 = 1'b0;
      //`rgm_write_send13(ulcr13)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq13

class uart_cfg_rxtx_fifo_cov_reg_seq13 extends uart_ctrl_config_reg_seq13;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq13)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq13");
      super.new(name);
   endfunction : new
 
//   ua_ier_c13 uier13;
//   ua_idr_c13 uidr13;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx13/rx13 full/empty13 interrupts13...", UVM_LOW)
//     `rgm_write_by_name_with13(uier13, {uart_rf13, ".ua_ier13"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with13(uidr13, {uart_rf13, ".ua_idr13"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq13
