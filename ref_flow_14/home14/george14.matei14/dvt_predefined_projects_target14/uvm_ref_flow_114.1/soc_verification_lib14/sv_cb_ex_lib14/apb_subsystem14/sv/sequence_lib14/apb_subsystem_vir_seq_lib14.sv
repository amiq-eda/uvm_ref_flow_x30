/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_vir_seq_lib14.sv
Title14       : Virtual Sequence
Project14     :
Created14     :
Description14 : This14 file implements14 the virtual sequence for the APB14-UART14 env14.
Notes14       : The concurrent_u2a_a2u_rand_trans14 sequence first configures14
            : the UART14 RTL14. Once14 the configuration sequence is completed
            : random read/write sequences from both the UVCs14 are enabled
            : in parallel14. At14 the end a Rx14 FIFO read sequence is executed14.
            : The intrpt_seq14 needs14 to be modified to take14 interrupt14 into account14.
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV14
`define APB_UART_VIRTUAL_SEQ_LIB_SV14

class u2a_incr_payload14 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr14;
  rand int unsigned num_a2u0_wr14;
  rand int unsigned num_u12a_wr14;
  rand int unsigned num_a2u1_wr14;

  function new(string name="u2a_incr_payload14",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)    

  constraint num_u02a_wr_ct14 {(num_u02a_wr14 > 2) && (num_u02a_wr14 <= 4);}
  constraint num_a2u0_wr_ct14 {(num_a2u0_wr14 == 1);}
  constraint num_u12a_wr_ct14 {(num_u12a_wr14 > 2) && (num_u12a_wr14 <= 4);}
  constraint num_a2u1_wr_ct14 {(num_a2u1_wr14 == 1);}

  // APB14 and UART14 UVC14 sequences
  uart_ctrl_config_reg_seq14 uart_cfg_dut_seq14;
  uart_incr_payload_seq14 uart_seq14;
  intrpt_seq14 rd_rx_fifo14;
  ahb_to_uart_wr14 raw_seq14;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq14", $psprintf("Number14 of APB14->UART014 Transaction14 = %d", num_a2u0_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Number14 of APB14->UART114 Transaction14 = %d", num_a2u1_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Number14 of UART014->APB14 Transaction14 = %d", num_u02a_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Number14 of UART114->APB14 Transaction14 = %d", num_u12a_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Total14 Number14 of AHB14, UART14 Transaction14 = %d", num_u02a_wr14 + num_a2u0_wr14 + num_u02a_wr14 + num_a2u0_wr14), UVM_LOW)

    // configure UART014 DUT
    uart_cfg_dut_seq14 = uart_ctrl_config_reg_seq14::type_id::create("uart_cfg_dut_seq14");
    uart_cfg_dut_seq14.reg_model14 = p_sequencer.reg_model_ptr14.uart0_rm14;
    uart_cfg_dut_seq14.start(null);


    // configure UART114 DUT
    uart_cfg_dut_seq14 = uart_ctrl_config_reg_seq14::type_id::create("uart_cfg_dut_seq14");
    uart_cfg_dut_seq14.reg_model14 = p_sequencer.reg_model_ptr14.uart1_rm14;
    uart_cfg_dut_seq14.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == num_a2u0_wr14; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == num_a2u1_wr14; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq14, p_sequencer.uart0_seqr14, {cnt == num_u02a_wr14;})
      `uvm_do_on_with(uart_seq14, p_sequencer.uart1_seqr14, {cnt == num_u12a_wr14;})
    join
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u02a_wr14; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u12a_wr14; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload14

// rand shutdown14 and power14-on
class on_off_seq14 extends uvm_sequence;
  `uvm_object_utils(on_off_seq14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)

  function new(string name = "on_off_seq14");
     super.new(name);
  endfunction

  shutdown_dut14 shut_dut14;
  poweron_dut14 power_dut14;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut14, p_sequencer.ahb_seqr14)
       #4000;
      `uvm_do_on(power_dut14, p_sequencer.ahb_seqr14)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq14


// shutdown14 and power14-on for uart114
class on_off_uart1_seq14 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)

  function new(string name = "on_off_uart1_seq14");
     super.new(name);
  endfunction

  shutdown_dut14 shut_dut14;
  poweron_dut14 power_dut14;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut14, p_sequencer.ahb_seqr14, {write_data14 == 1;})
        #4000;
      `uvm_do_on(power_dut14, p_sequencer.ahb_seqr14)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq14

// lp14 seq, configuration sequence
class lp_shutdown_config14 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr14;
  rand int unsigned num_a2u0_wr14;
  rand int unsigned num_u12a_wr14;
  rand int unsigned num_a2u1_wr14;

  function new(string name="lp_shutdown_config14",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)    

  constraint num_u02a_wr_ct14 {(num_u02a_wr14 > 2) && (num_u02a_wr14 <= 4);}
  constraint num_a2u0_wr_ct14 {(num_a2u0_wr14 == 1);}
  constraint num_u12a_wr_ct14 {(num_u12a_wr14 > 2) && (num_u12a_wr14 <= 4);}
  constraint num_a2u1_wr_ct14 {(num_a2u1_wr14 == 1);}

  // APB14 and UART14 UVC14 sequences
  uart_ctrl_config_reg_seq14 uart_cfg_dut_seq14;
  uart_incr_payload_seq14 uart_seq14;
  intrpt_seq14 rd_rx_fifo14;
  ahb_to_uart_wr14 raw_seq14;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq14", $psprintf("Number14 of APB14->UART014 Transaction14 = %d", num_a2u0_wr14), UVM_LOW);
    `uvm_info("vseq14", $psprintf("Number14 of APB14->UART114 Transaction14 = %d", num_a2u1_wr14), UVM_LOW);
    `uvm_info("vseq14", $psprintf("Number14 of UART014->APB14 Transaction14 = %d", num_u02a_wr14), UVM_LOW);
    `uvm_info("vseq14", $psprintf("Number14 of UART114->APB14 Transaction14 = %d", num_u12a_wr14), UVM_LOW);
    `uvm_info("vseq14", $psprintf("Total14 Number14 of AHB14, UART14 Transaction14 = %d", num_u02a_wr14 + num_a2u0_wr14 + num_u02a_wr14 + num_a2u0_wr14), UVM_LOW);

    // configure UART014 DUT
    uart_cfg_dut_seq14 = uart_ctrl_config_reg_seq14::type_id::create("uart_cfg_dut_seq14");
    uart_cfg_dut_seq14.reg_model14 = p_sequencer.reg_model_ptr14.uart0_rm14;
    uart_cfg_dut_seq14.start(null);


    // configure UART114 DUT
    uart_cfg_dut_seq14 = uart_ctrl_config_reg_seq14::type_id::create("uart_cfg_dut_seq14");
    uart_cfg_dut_seq14.reg_model14 = p_sequencer.reg_model_ptr14.uart1_rm14;
    uart_cfg_dut_seq14.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == num_a2u0_wr14; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == num_a2u1_wr14; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq14, p_sequencer.uart0_seqr14, {cnt == num_u02a_wr14;})
      `uvm_do_on_with(uart_seq14, p_sequencer.uart1_seqr14, {cnt == num_u12a_wr14;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u02a_wr14; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u12a_wr14; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == num_a2u0_wr14; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq14, p_sequencer.uart0_seqr14, {cnt == num_u02a_wr14;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config14

// rand lp14 shutdown14 seq between uart14 1 and smc14
class lp_shutdown_rand14 extends uvm_sequence;

  rand int unsigned num_u02a_wr14;
  rand int unsigned num_a2u0_wr14;
  rand int unsigned num_u12a_wr14;
  rand int unsigned num_a2u1_wr14;

  function new(string name="lp_shutdown_rand14",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)    

  constraint num_u02a_wr_ct14 {(num_u02a_wr14 > 2) && (num_u02a_wr14 <= 4);}
  constraint num_a2u0_wr_ct14 {(num_a2u0_wr14 == 1);}
  constraint num_u12a_wr_ct14 {(num_u12a_wr14 > 2) && (num_u12a_wr14 <= 4);}
  constraint num_a2u1_wr_ct14 {(num_a2u1_wr14 == 1);}


  on_off_seq14 on_off_seq14;
  uart_incr_payload_seq14 uart_seq14;
  intrpt_seq14 rd_rx_fifo14;
  ahb_to_uart_wr14 raw_seq14;
  lp_shutdown_config14 lp_shutdown_config14;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut14 down seq
    `uvm_do(lp_shutdown_config14);
    #20000;
    `uvm_do(on_off_seq14);

    #10000;
    fork
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == num_a2u1_wr14; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq14, p_sequencer.uart1_seqr14, {cnt == num_u12a_wr14;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u02a_wr14; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u12a_wr14; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand14


// sequence for shutting14 down uart14 1 alone14
class lp_shutdown_uart114 extends uvm_sequence;

  rand int unsigned num_u02a_wr14;
  rand int unsigned num_a2u0_wr14;
  rand int unsigned num_u12a_wr14;
  rand int unsigned num_a2u1_wr14;

  function new(string name="lp_shutdown_uart114",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart114)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)    

  constraint num_u02a_wr_ct14 {(num_u02a_wr14 > 2) && (num_u02a_wr14 <= 4);}
  constraint num_a2u0_wr_ct14 {(num_a2u0_wr14 == 1);}
  constraint num_u12a_wr_ct14 {(num_u12a_wr14 > 2) && (num_u12a_wr14 <= 4);}
  constraint num_a2u1_wr_ct14 {(num_a2u1_wr14 == 2);}


  on_off_uart1_seq14 on_off_uart1_seq14;
  uart_incr_payload_seq14 uart_seq14;
  intrpt_seq14 rd_rx_fifo14;
  ahb_to_uart_wr14 raw_seq14;
  lp_shutdown_config14 lp_shutdown_config14;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut14 down seq
    `uvm_do(lp_shutdown_config14);
    #20000;
    `uvm_do(on_off_uart1_seq14);

    #10000;
    fork
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == num_a2u1_wr14; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq14, p_sequencer.uart1_seqr14, {cnt == num_u12a_wr14;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u02a_wr14; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo14, p_sequencer.ahb_seqr14, {num_of_rd14 == num_u12a_wr14; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart114



class apb_spi_incr_payload14 extends uvm_sequence;

  rand int unsigned num_spi2a_wr14;
  rand int unsigned num_a2spi_wr14;

  function new(string name="apb_spi_incr_payload14",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)    

  constraint num_spi2a_wr_ct14 {(num_spi2a_wr14 > 2) && (num_spi2a_wr14 <= 4);}
  constraint num_a2spi_wr_ct14 {(num_a2spi_wr14 == 4);}

  // APB14 and UART14 UVC14 sequences
  spi_cfg_reg_seq14 spi_cfg_dut_seq14;
  spi_incr_payload14 spi_seq14;
  read_spi_rx_reg14 rd_rx_reg14;
  ahb_to_spi_wr14 raw_seq14;
  spi_en_tx_reg_seq14 en_spi_tx_seq14;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq14", $psprintf("Number14 of APB14->SPI14 Transaction14 = %d", num_a2spi_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Number14 of SPI14->APB14 Transaction14 = %d", num_a2spi_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Total14 Number14 of AHB14, SPI14 Transaction14 = %d", 2 * num_a2spi_wr14), UVM_LOW)

    // configure SPI14 DUT
    spi_cfg_dut_seq14 = spi_cfg_reg_seq14::type_id::create("spi_cfg_dut_seq14");
    spi_cfg_dut_seq14.reg_model14 = p_sequencer.reg_model_ptr14.spi_rf14;
    spi_cfg_dut_seq14.start(null);


    for (int i = 0; i < num_a2spi_wr14; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {num_of_wr14 == 1; base_addr == 'h800000;})
            en_spi_tx_seq14 = spi_en_tx_reg_seq14::type_id::create("en_spi_tx_seq14");
            en_spi_tx_seq14.reg_model14 = p_sequencer.reg_model_ptr14.spi_rf14;
            en_spi_tx_seq14.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq14, p_sequencer.spi0_seqr14, {cnt_i14 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg14, p_sequencer.ahb_seqr14, {num_of_rd14 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload14

class apb_gpio_simple_vseq14 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr14;

  function new(string name="apb_gpio_simple_vseq14",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)    

  constraint num_a2gpio_wr_ct14 {(num_a2gpio_wr14 == 4);}

  // APB14 and UART14 UVC14 sequences
  gpio_cfg_reg_seq14 gpio_cfg_dut_seq14;
  gpio_simple_trans_seq14 gpio_seq14;
  read_gpio_rx_reg14 rd_rx_reg14;
  ahb_to_gpio_wr14 raw_seq14;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq14", $psprintf("Number14 of AHB14->GPIO14 Transaction14 = %d", num_a2gpio_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Number14 of GPIO14->APB14 Transaction14 = %d", num_a2gpio_wr14), UVM_LOW)
    `uvm_info("vseq14", $psprintf("Total14 Number14 of AHB14, GPIO14 Transaction14 = %d", 2 * num_a2gpio_wr14), UVM_LOW)

    // configure SPI14 DUT
    gpio_cfg_dut_seq14 = gpio_cfg_reg_seq14::type_id::create("gpio_cfg_dut_seq14");
    gpio_cfg_dut_seq14.reg_model14 = p_sequencer.reg_model_ptr14.gpio_rf14;
    gpio_cfg_dut_seq14.start(null);


    for (int i = 0; i < num_a2gpio_wr14; i++) begin
      `uvm_do_on_with(raw_seq14, p_sequencer.ahb_seqr14, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq14, p_sequencer.gpio0_seqr14)
      `uvm_do_on_with(rd_rx_reg14, p_sequencer.ahb_seqr14, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq14

class apb_subsystem_vseq14 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq14",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)    

  // APB14 and UART14 UVC14 sequences
  u2a_incr_payload14 apb_to_uart14;
  apb_spi_incr_payload14 apb_to_spi14;
  apb_gpio_simple_vseq14 apb_to_gpio14;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq14", $psprintf("Doing apb_subsystem_vseq14"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart14)
      `uvm_do(apb_to_spi14)
      `uvm_do(apb_to_gpio14)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq14

class apb_ss_cms_seq14 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq14)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer14)

   function new(string name = "apb_ss_cms_seq14");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq14", $psprintf("Starting AHB14 Compliance14 Management14 System14 (CMS14)"), UVM_LOW)
//	   p_sequencer.ahb_seqr14.start_ahb_cms14();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq14
`endif
