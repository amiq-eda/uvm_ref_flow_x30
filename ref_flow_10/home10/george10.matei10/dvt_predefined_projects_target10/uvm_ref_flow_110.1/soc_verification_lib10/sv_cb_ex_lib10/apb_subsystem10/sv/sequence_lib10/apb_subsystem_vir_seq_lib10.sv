/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_vir_seq_lib10.sv
Title10       : Virtual Sequence
Project10     :
Created10     :
Description10 : This10 file implements10 the virtual sequence for the APB10-UART10 env10.
Notes10       : The concurrent_u2a_a2u_rand_trans10 sequence first configures10
            : the UART10 RTL10. Once10 the configuration sequence is completed
            : random read/write sequences from both the UVCs10 are enabled
            : in parallel10. At10 the end a Rx10 FIFO read sequence is executed10.
            : The intrpt_seq10 needs10 to be modified to take10 interrupt10 into account10.
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV10
`define APB_UART_VIRTUAL_SEQ_LIB_SV10

class u2a_incr_payload10 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr10;
  rand int unsigned num_a2u0_wr10;
  rand int unsigned num_u12a_wr10;
  rand int unsigned num_a2u1_wr10;

  function new(string name="u2a_incr_payload10",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)    

  constraint num_u02a_wr_ct10 {(num_u02a_wr10 > 2) && (num_u02a_wr10 <= 4);}
  constraint num_a2u0_wr_ct10 {(num_a2u0_wr10 == 1);}
  constraint num_u12a_wr_ct10 {(num_u12a_wr10 > 2) && (num_u12a_wr10 <= 4);}
  constraint num_a2u1_wr_ct10 {(num_a2u1_wr10 == 1);}

  // APB10 and UART10 UVC10 sequences
  uart_ctrl_config_reg_seq10 uart_cfg_dut_seq10;
  uart_incr_payload_seq10 uart_seq10;
  intrpt_seq10 rd_rx_fifo10;
  ahb_to_uart_wr10 raw_seq10;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq10", $psprintf("Number10 of APB10->UART010 Transaction10 = %d", num_a2u0_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Number10 of APB10->UART110 Transaction10 = %d", num_a2u1_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Number10 of UART010->APB10 Transaction10 = %d", num_u02a_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Number10 of UART110->APB10 Transaction10 = %d", num_u12a_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Total10 Number10 of AHB10, UART10 Transaction10 = %d", num_u02a_wr10 + num_a2u0_wr10 + num_u02a_wr10 + num_a2u0_wr10), UVM_LOW)

    // configure UART010 DUT
    uart_cfg_dut_seq10 = uart_ctrl_config_reg_seq10::type_id::create("uart_cfg_dut_seq10");
    uart_cfg_dut_seq10.reg_model10 = p_sequencer.reg_model_ptr10.uart0_rm10;
    uart_cfg_dut_seq10.start(null);


    // configure UART110 DUT
    uart_cfg_dut_seq10 = uart_ctrl_config_reg_seq10::type_id::create("uart_cfg_dut_seq10");
    uart_cfg_dut_seq10.reg_model10 = p_sequencer.reg_model_ptr10.uart1_rm10;
    uart_cfg_dut_seq10.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == num_a2u0_wr10; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == num_a2u1_wr10; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq10, p_sequencer.uart0_seqr10, {cnt == num_u02a_wr10;})
      `uvm_do_on_with(uart_seq10, p_sequencer.uart1_seqr10, {cnt == num_u12a_wr10;})
    join
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u02a_wr10; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u12a_wr10; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload10

// rand shutdown10 and power10-on
class on_off_seq10 extends uvm_sequence;
  `uvm_object_utils(on_off_seq10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)

  function new(string name = "on_off_seq10");
     super.new(name);
  endfunction

  shutdown_dut10 shut_dut10;
  poweron_dut10 power_dut10;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut10, p_sequencer.ahb_seqr10)
       #4000;
      `uvm_do_on(power_dut10, p_sequencer.ahb_seqr10)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq10


// shutdown10 and power10-on for uart110
class on_off_uart1_seq10 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)

  function new(string name = "on_off_uart1_seq10");
     super.new(name);
  endfunction

  shutdown_dut10 shut_dut10;
  poweron_dut10 power_dut10;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut10, p_sequencer.ahb_seqr10, {write_data10 == 1;})
        #4000;
      `uvm_do_on(power_dut10, p_sequencer.ahb_seqr10)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq10

// lp10 seq, configuration sequence
class lp_shutdown_config10 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr10;
  rand int unsigned num_a2u0_wr10;
  rand int unsigned num_u12a_wr10;
  rand int unsigned num_a2u1_wr10;

  function new(string name="lp_shutdown_config10",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)    

  constraint num_u02a_wr_ct10 {(num_u02a_wr10 > 2) && (num_u02a_wr10 <= 4);}
  constraint num_a2u0_wr_ct10 {(num_a2u0_wr10 == 1);}
  constraint num_u12a_wr_ct10 {(num_u12a_wr10 > 2) && (num_u12a_wr10 <= 4);}
  constraint num_a2u1_wr_ct10 {(num_a2u1_wr10 == 1);}

  // APB10 and UART10 UVC10 sequences
  uart_ctrl_config_reg_seq10 uart_cfg_dut_seq10;
  uart_incr_payload_seq10 uart_seq10;
  intrpt_seq10 rd_rx_fifo10;
  ahb_to_uart_wr10 raw_seq10;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq10", $psprintf("Number10 of APB10->UART010 Transaction10 = %d", num_a2u0_wr10), UVM_LOW);
    `uvm_info("vseq10", $psprintf("Number10 of APB10->UART110 Transaction10 = %d", num_a2u1_wr10), UVM_LOW);
    `uvm_info("vseq10", $psprintf("Number10 of UART010->APB10 Transaction10 = %d", num_u02a_wr10), UVM_LOW);
    `uvm_info("vseq10", $psprintf("Number10 of UART110->APB10 Transaction10 = %d", num_u12a_wr10), UVM_LOW);
    `uvm_info("vseq10", $psprintf("Total10 Number10 of AHB10, UART10 Transaction10 = %d", num_u02a_wr10 + num_a2u0_wr10 + num_u02a_wr10 + num_a2u0_wr10), UVM_LOW);

    // configure UART010 DUT
    uart_cfg_dut_seq10 = uart_ctrl_config_reg_seq10::type_id::create("uart_cfg_dut_seq10");
    uart_cfg_dut_seq10.reg_model10 = p_sequencer.reg_model_ptr10.uart0_rm10;
    uart_cfg_dut_seq10.start(null);


    // configure UART110 DUT
    uart_cfg_dut_seq10 = uart_ctrl_config_reg_seq10::type_id::create("uart_cfg_dut_seq10");
    uart_cfg_dut_seq10.reg_model10 = p_sequencer.reg_model_ptr10.uart1_rm10;
    uart_cfg_dut_seq10.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == num_a2u0_wr10; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == num_a2u1_wr10; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq10, p_sequencer.uart0_seqr10, {cnt == num_u02a_wr10;})
      `uvm_do_on_with(uart_seq10, p_sequencer.uart1_seqr10, {cnt == num_u12a_wr10;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u02a_wr10; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u12a_wr10; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == num_a2u0_wr10; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq10, p_sequencer.uart0_seqr10, {cnt == num_u02a_wr10;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config10

// rand lp10 shutdown10 seq between uart10 1 and smc10
class lp_shutdown_rand10 extends uvm_sequence;

  rand int unsigned num_u02a_wr10;
  rand int unsigned num_a2u0_wr10;
  rand int unsigned num_u12a_wr10;
  rand int unsigned num_a2u1_wr10;

  function new(string name="lp_shutdown_rand10",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)    

  constraint num_u02a_wr_ct10 {(num_u02a_wr10 > 2) && (num_u02a_wr10 <= 4);}
  constraint num_a2u0_wr_ct10 {(num_a2u0_wr10 == 1);}
  constraint num_u12a_wr_ct10 {(num_u12a_wr10 > 2) && (num_u12a_wr10 <= 4);}
  constraint num_a2u1_wr_ct10 {(num_a2u1_wr10 == 1);}


  on_off_seq10 on_off_seq10;
  uart_incr_payload_seq10 uart_seq10;
  intrpt_seq10 rd_rx_fifo10;
  ahb_to_uart_wr10 raw_seq10;
  lp_shutdown_config10 lp_shutdown_config10;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut10 down seq
    `uvm_do(lp_shutdown_config10);
    #20000;
    `uvm_do(on_off_seq10);

    #10000;
    fork
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == num_a2u1_wr10; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq10, p_sequencer.uart1_seqr10, {cnt == num_u12a_wr10;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u02a_wr10; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u12a_wr10; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand10


// sequence for shutting10 down uart10 1 alone10
class lp_shutdown_uart110 extends uvm_sequence;

  rand int unsigned num_u02a_wr10;
  rand int unsigned num_a2u0_wr10;
  rand int unsigned num_u12a_wr10;
  rand int unsigned num_a2u1_wr10;

  function new(string name="lp_shutdown_uart110",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart110)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)    

  constraint num_u02a_wr_ct10 {(num_u02a_wr10 > 2) && (num_u02a_wr10 <= 4);}
  constraint num_a2u0_wr_ct10 {(num_a2u0_wr10 == 1);}
  constraint num_u12a_wr_ct10 {(num_u12a_wr10 > 2) && (num_u12a_wr10 <= 4);}
  constraint num_a2u1_wr_ct10 {(num_a2u1_wr10 == 2);}


  on_off_uart1_seq10 on_off_uart1_seq10;
  uart_incr_payload_seq10 uart_seq10;
  intrpt_seq10 rd_rx_fifo10;
  ahb_to_uart_wr10 raw_seq10;
  lp_shutdown_config10 lp_shutdown_config10;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut10 down seq
    `uvm_do(lp_shutdown_config10);
    #20000;
    `uvm_do(on_off_uart1_seq10);

    #10000;
    fork
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == num_a2u1_wr10; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq10, p_sequencer.uart1_seqr10, {cnt == num_u12a_wr10;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u02a_wr10; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo10, p_sequencer.ahb_seqr10, {num_of_rd10 == num_u12a_wr10; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart110



class apb_spi_incr_payload10 extends uvm_sequence;

  rand int unsigned num_spi2a_wr10;
  rand int unsigned num_a2spi_wr10;

  function new(string name="apb_spi_incr_payload10",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)    

  constraint num_spi2a_wr_ct10 {(num_spi2a_wr10 > 2) && (num_spi2a_wr10 <= 4);}
  constraint num_a2spi_wr_ct10 {(num_a2spi_wr10 == 4);}

  // APB10 and UART10 UVC10 sequences
  spi_cfg_reg_seq10 spi_cfg_dut_seq10;
  spi_incr_payload10 spi_seq10;
  read_spi_rx_reg10 rd_rx_reg10;
  ahb_to_spi_wr10 raw_seq10;
  spi_en_tx_reg_seq10 en_spi_tx_seq10;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq10", $psprintf("Number10 of APB10->SPI10 Transaction10 = %d", num_a2spi_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Number10 of SPI10->APB10 Transaction10 = %d", num_a2spi_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Total10 Number10 of AHB10, SPI10 Transaction10 = %d", 2 * num_a2spi_wr10), UVM_LOW)

    // configure SPI10 DUT
    spi_cfg_dut_seq10 = spi_cfg_reg_seq10::type_id::create("spi_cfg_dut_seq10");
    spi_cfg_dut_seq10.reg_model10 = p_sequencer.reg_model_ptr10.spi_rf10;
    spi_cfg_dut_seq10.start(null);


    for (int i = 0; i < num_a2spi_wr10; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {num_of_wr10 == 1; base_addr == 'h800000;})
            en_spi_tx_seq10 = spi_en_tx_reg_seq10::type_id::create("en_spi_tx_seq10");
            en_spi_tx_seq10.reg_model10 = p_sequencer.reg_model_ptr10.spi_rf10;
            en_spi_tx_seq10.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq10, p_sequencer.spi0_seqr10, {cnt_i10 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg10, p_sequencer.ahb_seqr10, {num_of_rd10 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload10

class apb_gpio_simple_vseq10 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr10;

  function new(string name="apb_gpio_simple_vseq10",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)    

  constraint num_a2gpio_wr_ct10 {(num_a2gpio_wr10 == 4);}

  // APB10 and UART10 UVC10 sequences
  gpio_cfg_reg_seq10 gpio_cfg_dut_seq10;
  gpio_simple_trans_seq10 gpio_seq10;
  read_gpio_rx_reg10 rd_rx_reg10;
  ahb_to_gpio_wr10 raw_seq10;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq10", $psprintf("Number10 of AHB10->GPIO10 Transaction10 = %d", num_a2gpio_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Number10 of GPIO10->APB10 Transaction10 = %d", num_a2gpio_wr10), UVM_LOW)
    `uvm_info("vseq10", $psprintf("Total10 Number10 of AHB10, GPIO10 Transaction10 = %d", 2 * num_a2gpio_wr10), UVM_LOW)

    // configure SPI10 DUT
    gpio_cfg_dut_seq10 = gpio_cfg_reg_seq10::type_id::create("gpio_cfg_dut_seq10");
    gpio_cfg_dut_seq10.reg_model10 = p_sequencer.reg_model_ptr10.gpio_rf10;
    gpio_cfg_dut_seq10.start(null);


    for (int i = 0; i < num_a2gpio_wr10; i++) begin
      `uvm_do_on_with(raw_seq10, p_sequencer.ahb_seqr10, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq10, p_sequencer.gpio0_seqr10)
      `uvm_do_on_with(rd_rx_reg10, p_sequencer.ahb_seqr10, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq10

class apb_subsystem_vseq10 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq10",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq10)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)    

  // APB10 and UART10 UVC10 sequences
  u2a_incr_payload10 apb_to_uart10;
  apb_spi_incr_payload10 apb_to_spi10;
  apb_gpio_simple_vseq10 apb_to_gpio10;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq10", $psprintf("Doing apb_subsystem_vseq10"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart10)
      `uvm_do(apb_to_spi10)
      `uvm_do(apb_to_gpio10)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq10

class apb_ss_cms_seq10 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq10)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer10)

   function new(string name = "apb_ss_cms_seq10");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq10", $psprintf("Starting AHB10 Compliance10 Management10 System10 (CMS10)"), UVM_LOW)
//	   p_sequencer.ahb_seqr10.start_ahb_cms10();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq10
`endif
