/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_reg_seq_lib1.sv
Title1       : UVM_REG Sequence Library1
Project1     :
Created1     :
Description1 : Register Sequence Library1 for the UART1 Controller1 DUT
Notes1       :
----------------------------------------------------------------------
Copyright1 2007 (c) Cadence1 Design1 Systems1, Inc1. All Rights1 Reserved1.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq1: Direct1 APB1 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq1 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq1)

   apb_pkg1::write_byte_seq1 write_seq1;
   rand bit [7:0] temp_data1;
   constraint c11 {temp_data1[7] == 1'b1; }

   function new(string name="apb_config_reg_seq1");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART1 Controller1 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line1 Control1 Register: bit 7, Divisor1 Latch1 Access = 1
      `uvm_do_with(write_seq1, { start_addr1 == 3; write_data1 == temp_data1; } )
      // Address 0: Divisor1 Latch1 Byte1 1 = 1
      `uvm_do_with(write_seq1, { start_addr1 == 0; write_data1 == 'h01; } )
      // Address 1: Divisor1 Latch1 Byte1 2 = 0
      `uvm_do_with(write_seq1, { start_addr1 == 1; write_data1 == 'h00; } )
      // Address 3: Line1 Control1 Register: bit 7, Divisor1 Latch1 Access = 0
      temp_data1[7] = 1'b0;
      `uvm_do_with(write_seq1, { start_addr1 == 3; write_data1 == temp_data1; } )
      `uvm_info(get_type_name(),
        "UART1 Controller1 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq1

//--------------------------------------------------------------------
// Base1 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq1 extends uvm_sequence;
  function new(string name="base_reg_seq1");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq1)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer1)

// Use a base sequence to raise/drop1 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running1 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq1

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq1: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq1 extends base_reg_seq1;

   // Pointer1 to the register model
   uart_ctrl_reg_model_c1 reg_model1;
   uvm_object rm_object1;

   `uvm_object_utils(uart_ctrl_config_reg_seq1)

   function new(string name="uart_ctrl_config_reg_seq1");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model1", rm_object1))
      $cast(reg_model1, rm_object1);
      `uvm_info(get_type_name(),
        "UART1 Controller1 Register configuration sequence starting...",
        UVM_LOW)
      // Line1 Control1 Register, set Divisor1 Latch1 Access = 1
      reg_model1.uart_ctrl_rf1.ua_lcr1.write(status, 'h8f);
      // Divisor1 Latch1 Byte1 1 = 1
      reg_model1.uart_ctrl_rf1.ua_div_latch01.write(status, 'h01);
      // Divisor1 Latch1 Byte1 2 = 0
      reg_model1.uart_ctrl_rf1.ua_div_latch11.write(status, 'h00);
      // Line1 Control1 Register, set Divisor1 Latch1 Access = 0
      reg_model1.uart_ctrl_rf1.ua_lcr1.write(status, 'h0f);
      //ToDo1: FIX1: DISABLE1 CHECKS1 AFTER CONFIG1 IS1 DONE
      reg_model1.uart_ctrl_rf1.ua_div_latch01.div_val1.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART1 Controller1 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq1

class uart_ctrl_1stopbit_reg_seq1 extends base_reg_seq1;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq1)

   function new(string name="uart_ctrl_1stopbit_reg_seq1");
      super.new(name);
   endfunction // new
 
   // Pointer1 to the register model
   uart_ctrl_rf_c1 reg_model1;
//   uart_ctrl_reg_model_c1 reg_model1;

   //ua_lcr_c1 ulcr1;
   //ua_div_latch0_c1 div_lsb1;
   //ua_div_latch1_c1 div_msb1;

   virtual task body();
     uvm_status_e status;
     reg_model1 = p_sequencer.reg_model1.uart_ctrl_rf1;
     `uvm_info(get_type_name(),
        "UART1 config register sequence with num_stop_bits1 == STOP11 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with1(ulcr1, "ua_lcr1", {value.num_stop_bits1 == 1'b0;})
      #50;
      //`rgm_write_by_name1(div_msb1, "ua_div_latch11")
      #50;
      //`rgm_write_by_name1(div_lsb1, "ua_div_latch01")
      #50;
      //ulcr1.value.div_latch_access1 = 1'b0;
      //`rgm_write_send1(ulcr1)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq1

class uart_cfg_rxtx_fifo_cov_reg_seq1 extends uart_ctrl_config_reg_seq1;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq1)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq1");
      super.new(name);
   endfunction : new
 
//   ua_ier_c1 uier1;
//   ua_idr_c1 uidr1;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx1/rx1 full/empty1 interrupts1...", UVM_LOW)
//     `rgm_write_by_name_with1(uier1, {uart_rf1, ".ua_ier1"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with1(uidr1, {uart_rf1, ".ua_idr1"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq1
