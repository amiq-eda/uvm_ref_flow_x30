/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_vir_seq_lib9.sv
Title9       : Virtual Sequence
Project9     :
Created9     :
Description9 : This9 file implements9 the virtual sequence for the APB9-UART9 env9.
Notes9       : The concurrent_u2a_a2u_rand_trans9 sequence first configures9
            : the UART9 RTL9. Once9 the configuration sequence is completed
            : random read/write sequences from both the UVCs9 are enabled
            : in parallel9. At9 the end a Rx9 FIFO read sequence is executed9.
            : The intrpt_seq9 needs9 to be modified to take9 interrupt9 into account9.
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV9
`define APB_UART_VIRTUAL_SEQ_LIB_SV9

class u2a_incr_payload9 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr9;
  rand int unsigned num_a2u0_wr9;
  rand int unsigned num_u12a_wr9;
  rand int unsigned num_a2u1_wr9;

  function new(string name="u2a_incr_payload9",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)    

  constraint num_u02a_wr_ct9 {(num_u02a_wr9 > 2) && (num_u02a_wr9 <= 4);}
  constraint num_a2u0_wr_ct9 {(num_a2u0_wr9 == 1);}
  constraint num_u12a_wr_ct9 {(num_u12a_wr9 > 2) && (num_u12a_wr9 <= 4);}
  constraint num_a2u1_wr_ct9 {(num_a2u1_wr9 == 1);}

  // APB9 and UART9 UVC9 sequences
  uart_ctrl_config_reg_seq9 uart_cfg_dut_seq9;
  uart_incr_payload_seq9 uart_seq9;
  intrpt_seq9 rd_rx_fifo9;
  ahb_to_uart_wr9 raw_seq9;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq9", $psprintf("Number9 of APB9->UART09 Transaction9 = %d", num_a2u0_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Number9 of APB9->UART19 Transaction9 = %d", num_a2u1_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Number9 of UART09->APB9 Transaction9 = %d", num_u02a_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Number9 of UART19->APB9 Transaction9 = %d", num_u12a_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Total9 Number9 of AHB9, UART9 Transaction9 = %d", num_u02a_wr9 + num_a2u0_wr9 + num_u02a_wr9 + num_a2u0_wr9), UVM_LOW)

    // configure UART09 DUT
    uart_cfg_dut_seq9 = uart_ctrl_config_reg_seq9::type_id::create("uart_cfg_dut_seq9");
    uart_cfg_dut_seq9.reg_model9 = p_sequencer.reg_model_ptr9.uart0_rm9;
    uart_cfg_dut_seq9.start(null);


    // configure UART19 DUT
    uart_cfg_dut_seq9 = uart_ctrl_config_reg_seq9::type_id::create("uart_cfg_dut_seq9");
    uart_cfg_dut_seq9.reg_model9 = p_sequencer.reg_model_ptr9.uart1_rm9;
    uart_cfg_dut_seq9.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == num_a2u0_wr9; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == num_a2u1_wr9; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq9, p_sequencer.uart0_seqr9, {cnt == num_u02a_wr9;})
      `uvm_do_on_with(uart_seq9, p_sequencer.uart1_seqr9, {cnt == num_u12a_wr9;})
    join
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u02a_wr9; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u12a_wr9; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload9

// rand shutdown9 and power9-on
class on_off_seq9 extends uvm_sequence;
  `uvm_object_utils(on_off_seq9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)

  function new(string name = "on_off_seq9");
     super.new(name);
  endfunction

  shutdown_dut9 shut_dut9;
  poweron_dut9 power_dut9;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut9, p_sequencer.ahb_seqr9)
       #4000;
      `uvm_do_on(power_dut9, p_sequencer.ahb_seqr9)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq9


// shutdown9 and power9-on for uart19
class on_off_uart1_seq9 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)

  function new(string name = "on_off_uart1_seq9");
     super.new(name);
  endfunction

  shutdown_dut9 shut_dut9;
  poweron_dut9 power_dut9;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut9, p_sequencer.ahb_seqr9, {write_data9 == 1;})
        #4000;
      `uvm_do_on(power_dut9, p_sequencer.ahb_seqr9)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq9

// lp9 seq, configuration sequence
class lp_shutdown_config9 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr9;
  rand int unsigned num_a2u0_wr9;
  rand int unsigned num_u12a_wr9;
  rand int unsigned num_a2u1_wr9;

  function new(string name="lp_shutdown_config9",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)    

  constraint num_u02a_wr_ct9 {(num_u02a_wr9 > 2) && (num_u02a_wr9 <= 4);}
  constraint num_a2u0_wr_ct9 {(num_a2u0_wr9 == 1);}
  constraint num_u12a_wr_ct9 {(num_u12a_wr9 > 2) && (num_u12a_wr9 <= 4);}
  constraint num_a2u1_wr_ct9 {(num_a2u1_wr9 == 1);}

  // APB9 and UART9 UVC9 sequences
  uart_ctrl_config_reg_seq9 uart_cfg_dut_seq9;
  uart_incr_payload_seq9 uart_seq9;
  intrpt_seq9 rd_rx_fifo9;
  ahb_to_uart_wr9 raw_seq9;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq9", $psprintf("Number9 of APB9->UART09 Transaction9 = %d", num_a2u0_wr9), UVM_LOW);
    `uvm_info("vseq9", $psprintf("Number9 of APB9->UART19 Transaction9 = %d", num_a2u1_wr9), UVM_LOW);
    `uvm_info("vseq9", $psprintf("Number9 of UART09->APB9 Transaction9 = %d", num_u02a_wr9), UVM_LOW);
    `uvm_info("vseq9", $psprintf("Number9 of UART19->APB9 Transaction9 = %d", num_u12a_wr9), UVM_LOW);
    `uvm_info("vseq9", $psprintf("Total9 Number9 of AHB9, UART9 Transaction9 = %d", num_u02a_wr9 + num_a2u0_wr9 + num_u02a_wr9 + num_a2u0_wr9), UVM_LOW);

    // configure UART09 DUT
    uart_cfg_dut_seq9 = uart_ctrl_config_reg_seq9::type_id::create("uart_cfg_dut_seq9");
    uart_cfg_dut_seq9.reg_model9 = p_sequencer.reg_model_ptr9.uart0_rm9;
    uart_cfg_dut_seq9.start(null);


    // configure UART19 DUT
    uart_cfg_dut_seq9 = uart_ctrl_config_reg_seq9::type_id::create("uart_cfg_dut_seq9");
    uart_cfg_dut_seq9.reg_model9 = p_sequencer.reg_model_ptr9.uart1_rm9;
    uart_cfg_dut_seq9.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == num_a2u0_wr9; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == num_a2u1_wr9; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq9, p_sequencer.uart0_seqr9, {cnt == num_u02a_wr9;})
      `uvm_do_on_with(uart_seq9, p_sequencer.uart1_seqr9, {cnt == num_u12a_wr9;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u02a_wr9; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u12a_wr9; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == num_a2u0_wr9; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq9, p_sequencer.uart0_seqr9, {cnt == num_u02a_wr9;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config9

// rand lp9 shutdown9 seq between uart9 1 and smc9
class lp_shutdown_rand9 extends uvm_sequence;

  rand int unsigned num_u02a_wr9;
  rand int unsigned num_a2u0_wr9;
  rand int unsigned num_u12a_wr9;
  rand int unsigned num_a2u1_wr9;

  function new(string name="lp_shutdown_rand9",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)    

  constraint num_u02a_wr_ct9 {(num_u02a_wr9 > 2) && (num_u02a_wr9 <= 4);}
  constraint num_a2u0_wr_ct9 {(num_a2u0_wr9 == 1);}
  constraint num_u12a_wr_ct9 {(num_u12a_wr9 > 2) && (num_u12a_wr9 <= 4);}
  constraint num_a2u1_wr_ct9 {(num_a2u1_wr9 == 1);}


  on_off_seq9 on_off_seq9;
  uart_incr_payload_seq9 uart_seq9;
  intrpt_seq9 rd_rx_fifo9;
  ahb_to_uart_wr9 raw_seq9;
  lp_shutdown_config9 lp_shutdown_config9;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut9 down seq
    `uvm_do(lp_shutdown_config9);
    #20000;
    `uvm_do(on_off_seq9);

    #10000;
    fork
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == num_a2u1_wr9; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq9, p_sequencer.uart1_seqr9, {cnt == num_u12a_wr9;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u02a_wr9; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u12a_wr9; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand9


// sequence for shutting9 down uart9 1 alone9
class lp_shutdown_uart19 extends uvm_sequence;

  rand int unsigned num_u02a_wr9;
  rand int unsigned num_a2u0_wr9;
  rand int unsigned num_u12a_wr9;
  rand int unsigned num_a2u1_wr9;

  function new(string name="lp_shutdown_uart19",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)    

  constraint num_u02a_wr_ct9 {(num_u02a_wr9 > 2) && (num_u02a_wr9 <= 4);}
  constraint num_a2u0_wr_ct9 {(num_a2u0_wr9 == 1);}
  constraint num_u12a_wr_ct9 {(num_u12a_wr9 > 2) && (num_u12a_wr9 <= 4);}
  constraint num_a2u1_wr_ct9 {(num_a2u1_wr9 == 2);}


  on_off_uart1_seq9 on_off_uart1_seq9;
  uart_incr_payload_seq9 uart_seq9;
  intrpt_seq9 rd_rx_fifo9;
  ahb_to_uart_wr9 raw_seq9;
  lp_shutdown_config9 lp_shutdown_config9;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut9 down seq
    `uvm_do(lp_shutdown_config9);
    #20000;
    `uvm_do(on_off_uart1_seq9);

    #10000;
    fork
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == num_a2u1_wr9; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq9, p_sequencer.uart1_seqr9, {cnt == num_u12a_wr9;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u02a_wr9; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo9, p_sequencer.ahb_seqr9, {num_of_rd9 == num_u12a_wr9; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart19



class apb_spi_incr_payload9 extends uvm_sequence;

  rand int unsigned num_spi2a_wr9;
  rand int unsigned num_a2spi_wr9;

  function new(string name="apb_spi_incr_payload9",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)    

  constraint num_spi2a_wr_ct9 {(num_spi2a_wr9 > 2) && (num_spi2a_wr9 <= 4);}
  constraint num_a2spi_wr_ct9 {(num_a2spi_wr9 == 4);}

  // APB9 and UART9 UVC9 sequences
  spi_cfg_reg_seq9 spi_cfg_dut_seq9;
  spi_incr_payload9 spi_seq9;
  read_spi_rx_reg9 rd_rx_reg9;
  ahb_to_spi_wr9 raw_seq9;
  spi_en_tx_reg_seq9 en_spi_tx_seq9;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq9", $psprintf("Number9 of APB9->SPI9 Transaction9 = %d", num_a2spi_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Number9 of SPI9->APB9 Transaction9 = %d", num_a2spi_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Total9 Number9 of AHB9, SPI9 Transaction9 = %d", 2 * num_a2spi_wr9), UVM_LOW)

    // configure SPI9 DUT
    spi_cfg_dut_seq9 = spi_cfg_reg_seq9::type_id::create("spi_cfg_dut_seq9");
    spi_cfg_dut_seq9.reg_model9 = p_sequencer.reg_model_ptr9.spi_rf9;
    spi_cfg_dut_seq9.start(null);


    for (int i = 0; i < num_a2spi_wr9; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {num_of_wr9 == 1; base_addr == 'h800000;})
            en_spi_tx_seq9 = spi_en_tx_reg_seq9::type_id::create("en_spi_tx_seq9");
            en_spi_tx_seq9.reg_model9 = p_sequencer.reg_model_ptr9.spi_rf9;
            en_spi_tx_seq9.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq9, p_sequencer.spi0_seqr9, {cnt_i9 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg9, p_sequencer.ahb_seqr9, {num_of_rd9 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload9

class apb_gpio_simple_vseq9 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr9;

  function new(string name="apb_gpio_simple_vseq9",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)    

  constraint num_a2gpio_wr_ct9 {(num_a2gpio_wr9 == 4);}

  // APB9 and UART9 UVC9 sequences
  gpio_cfg_reg_seq9 gpio_cfg_dut_seq9;
  gpio_simple_trans_seq9 gpio_seq9;
  read_gpio_rx_reg9 rd_rx_reg9;
  ahb_to_gpio_wr9 raw_seq9;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq9", $psprintf("Number9 of AHB9->GPIO9 Transaction9 = %d", num_a2gpio_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Number9 of GPIO9->APB9 Transaction9 = %d", num_a2gpio_wr9), UVM_LOW)
    `uvm_info("vseq9", $psprintf("Total9 Number9 of AHB9, GPIO9 Transaction9 = %d", 2 * num_a2gpio_wr9), UVM_LOW)

    // configure SPI9 DUT
    gpio_cfg_dut_seq9 = gpio_cfg_reg_seq9::type_id::create("gpio_cfg_dut_seq9");
    gpio_cfg_dut_seq9.reg_model9 = p_sequencer.reg_model_ptr9.gpio_rf9;
    gpio_cfg_dut_seq9.start(null);


    for (int i = 0; i < num_a2gpio_wr9; i++) begin
      `uvm_do_on_with(raw_seq9, p_sequencer.ahb_seqr9, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq9, p_sequencer.gpio0_seqr9)
      `uvm_do_on_with(rd_rx_reg9, p_sequencer.ahb_seqr9, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq9

class apb_subsystem_vseq9 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq9",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq9)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)    

  // APB9 and UART9 UVC9 sequences
  u2a_incr_payload9 apb_to_uart9;
  apb_spi_incr_payload9 apb_to_spi9;
  apb_gpio_simple_vseq9 apb_to_gpio9;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq9", $psprintf("Doing apb_subsystem_vseq9"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart9)
      `uvm_do(apb_to_spi9)
      `uvm_do(apb_to_gpio9)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq9

class apb_ss_cms_seq9 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq9)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer9)

   function new(string name = "apb_ss_cms_seq9");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq9", $psprintf("Starting AHB9 Compliance9 Management9 System9 (CMS9)"), UVM_LOW)
//	   p_sequencer.ahb_seqr9.start_ahb_cms9();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq9
`endif
