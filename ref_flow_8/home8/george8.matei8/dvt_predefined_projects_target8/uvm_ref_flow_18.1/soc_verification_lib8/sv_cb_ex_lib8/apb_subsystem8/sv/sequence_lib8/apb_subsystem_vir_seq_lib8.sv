/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_vir_seq_lib8.sv
Title8       : Virtual Sequence
Project8     :
Created8     :
Description8 : This8 file implements8 the virtual sequence for the APB8-UART8 env8.
Notes8       : The concurrent_u2a_a2u_rand_trans8 sequence first configures8
            : the UART8 RTL8. Once8 the configuration sequence is completed
            : random read/write sequences from both the UVCs8 are enabled
            : in parallel8. At8 the end a Rx8 FIFO read sequence is executed8.
            : The intrpt_seq8 needs8 to be modified to take8 interrupt8 into account8.
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV8
`define APB_UART_VIRTUAL_SEQ_LIB_SV8

class u2a_incr_payload8 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr8;
  rand int unsigned num_a2u0_wr8;
  rand int unsigned num_u12a_wr8;
  rand int unsigned num_a2u1_wr8;

  function new(string name="u2a_incr_payload8",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)    

  constraint num_u02a_wr_ct8 {(num_u02a_wr8 > 2) && (num_u02a_wr8 <= 4);}
  constraint num_a2u0_wr_ct8 {(num_a2u0_wr8 == 1);}
  constraint num_u12a_wr_ct8 {(num_u12a_wr8 > 2) && (num_u12a_wr8 <= 4);}
  constraint num_a2u1_wr_ct8 {(num_a2u1_wr8 == 1);}

  // APB8 and UART8 UVC8 sequences
  uart_ctrl_config_reg_seq8 uart_cfg_dut_seq8;
  uart_incr_payload_seq8 uart_seq8;
  intrpt_seq8 rd_rx_fifo8;
  ahb_to_uart_wr8 raw_seq8;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq8", $psprintf("Number8 of APB8->UART08 Transaction8 = %d", num_a2u0_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Number8 of APB8->UART18 Transaction8 = %d", num_a2u1_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Number8 of UART08->APB8 Transaction8 = %d", num_u02a_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Number8 of UART18->APB8 Transaction8 = %d", num_u12a_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Total8 Number8 of AHB8, UART8 Transaction8 = %d", num_u02a_wr8 + num_a2u0_wr8 + num_u02a_wr8 + num_a2u0_wr8), UVM_LOW)

    // configure UART08 DUT
    uart_cfg_dut_seq8 = uart_ctrl_config_reg_seq8::type_id::create("uart_cfg_dut_seq8");
    uart_cfg_dut_seq8.reg_model8 = p_sequencer.reg_model_ptr8.uart0_rm8;
    uart_cfg_dut_seq8.start(null);


    // configure UART18 DUT
    uart_cfg_dut_seq8 = uart_ctrl_config_reg_seq8::type_id::create("uart_cfg_dut_seq8");
    uart_cfg_dut_seq8.reg_model8 = p_sequencer.reg_model_ptr8.uart1_rm8;
    uart_cfg_dut_seq8.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == num_a2u0_wr8; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == num_a2u1_wr8; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq8, p_sequencer.uart0_seqr8, {cnt == num_u02a_wr8;})
      `uvm_do_on_with(uart_seq8, p_sequencer.uart1_seqr8, {cnt == num_u12a_wr8;})
    join
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u02a_wr8; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u12a_wr8; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload8

// rand shutdown8 and power8-on
class on_off_seq8 extends uvm_sequence;
  `uvm_object_utils(on_off_seq8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)

  function new(string name = "on_off_seq8");
     super.new(name);
  endfunction

  shutdown_dut8 shut_dut8;
  poweron_dut8 power_dut8;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut8, p_sequencer.ahb_seqr8)
       #4000;
      `uvm_do_on(power_dut8, p_sequencer.ahb_seqr8)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq8


// shutdown8 and power8-on for uart18
class on_off_uart1_seq8 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)

  function new(string name = "on_off_uart1_seq8");
     super.new(name);
  endfunction

  shutdown_dut8 shut_dut8;
  poweron_dut8 power_dut8;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut8, p_sequencer.ahb_seqr8, {write_data8 == 1;})
        #4000;
      `uvm_do_on(power_dut8, p_sequencer.ahb_seqr8)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq8

// lp8 seq, configuration sequence
class lp_shutdown_config8 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr8;
  rand int unsigned num_a2u0_wr8;
  rand int unsigned num_u12a_wr8;
  rand int unsigned num_a2u1_wr8;

  function new(string name="lp_shutdown_config8",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)    

  constraint num_u02a_wr_ct8 {(num_u02a_wr8 > 2) && (num_u02a_wr8 <= 4);}
  constraint num_a2u0_wr_ct8 {(num_a2u0_wr8 == 1);}
  constraint num_u12a_wr_ct8 {(num_u12a_wr8 > 2) && (num_u12a_wr8 <= 4);}
  constraint num_a2u1_wr_ct8 {(num_a2u1_wr8 == 1);}

  // APB8 and UART8 UVC8 sequences
  uart_ctrl_config_reg_seq8 uart_cfg_dut_seq8;
  uart_incr_payload_seq8 uart_seq8;
  intrpt_seq8 rd_rx_fifo8;
  ahb_to_uart_wr8 raw_seq8;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq8", $psprintf("Number8 of APB8->UART08 Transaction8 = %d", num_a2u0_wr8), UVM_LOW);
    `uvm_info("vseq8", $psprintf("Number8 of APB8->UART18 Transaction8 = %d", num_a2u1_wr8), UVM_LOW);
    `uvm_info("vseq8", $psprintf("Number8 of UART08->APB8 Transaction8 = %d", num_u02a_wr8), UVM_LOW);
    `uvm_info("vseq8", $psprintf("Number8 of UART18->APB8 Transaction8 = %d", num_u12a_wr8), UVM_LOW);
    `uvm_info("vseq8", $psprintf("Total8 Number8 of AHB8, UART8 Transaction8 = %d", num_u02a_wr8 + num_a2u0_wr8 + num_u02a_wr8 + num_a2u0_wr8), UVM_LOW);

    // configure UART08 DUT
    uart_cfg_dut_seq8 = uart_ctrl_config_reg_seq8::type_id::create("uart_cfg_dut_seq8");
    uart_cfg_dut_seq8.reg_model8 = p_sequencer.reg_model_ptr8.uart0_rm8;
    uart_cfg_dut_seq8.start(null);


    // configure UART18 DUT
    uart_cfg_dut_seq8 = uart_ctrl_config_reg_seq8::type_id::create("uart_cfg_dut_seq8");
    uart_cfg_dut_seq8.reg_model8 = p_sequencer.reg_model_ptr8.uart1_rm8;
    uart_cfg_dut_seq8.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == num_a2u0_wr8; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == num_a2u1_wr8; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq8, p_sequencer.uart0_seqr8, {cnt == num_u02a_wr8;})
      `uvm_do_on_with(uart_seq8, p_sequencer.uart1_seqr8, {cnt == num_u12a_wr8;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u02a_wr8; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u12a_wr8; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == num_a2u0_wr8; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq8, p_sequencer.uart0_seqr8, {cnt == num_u02a_wr8;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config8

// rand lp8 shutdown8 seq between uart8 1 and smc8
class lp_shutdown_rand8 extends uvm_sequence;

  rand int unsigned num_u02a_wr8;
  rand int unsigned num_a2u0_wr8;
  rand int unsigned num_u12a_wr8;
  rand int unsigned num_a2u1_wr8;

  function new(string name="lp_shutdown_rand8",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)    

  constraint num_u02a_wr_ct8 {(num_u02a_wr8 > 2) && (num_u02a_wr8 <= 4);}
  constraint num_a2u0_wr_ct8 {(num_a2u0_wr8 == 1);}
  constraint num_u12a_wr_ct8 {(num_u12a_wr8 > 2) && (num_u12a_wr8 <= 4);}
  constraint num_a2u1_wr_ct8 {(num_a2u1_wr8 == 1);}


  on_off_seq8 on_off_seq8;
  uart_incr_payload_seq8 uart_seq8;
  intrpt_seq8 rd_rx_fifo8;
  ahb_to_uart_wr8 raw_seq8;
  lp_shutdown_config8 lp_shutdown_config8;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut8 down seq
    `uvm_do(lp_shutdown_config8);
    #20000;
    `uvm_do(on_off_seq8);

    #10000;
    fork
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == num_a2u1_wr8; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq8, p_sequencer.uart1_seqr8, {cnt == num_u12a_wr8;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u02a_wr8; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u12a_wr8; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand8


// sequence for shutting8 down uart8 1 alone8
class lp_shutdown_uart18 extends uvm_sequence;

  rand int unsigned num_u02a_wr8;
  rand int unsigned num_a2u0_wr8;
  rand int unsigned num_u12a_wr8;
  rand int unsigned num_a2u1_wr8;

  function new(string name="lp_shutdown_uart18",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)    

  constraint num_u02a_wr_ct8 {(num_u02a_wr8 > 2) && (num_u02a_wr8 <= 4);}
  constraint num_a2u0_wr_ct8 {(num_a2u0_wr8 == 1);}
  constraint num_u12a_wr_ct8 {(num_u12a_wr8 > 2) && (num_u12a_wr8 <= 4);}
  constraint num_a2u1_wr_ct8 {(num_a2u1_wr8 == 2);}


  on_off_uart1_seq8 on_off_uart1_seq8;
  uart_incr_payload_seq8 uart_seq8;
  intrpt_seq8 rd_rx_fifo8;
  ahb_to_uart_wr8 raw_seq8;
  lp_shutdown_config8 lp_shutdown_config8;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut8 down seq
    `uvm_do(lp_shutdown_config8);
    #20000;
    `uvm_do(on_off_uart1_seq8);

    #10000;
    fork
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == num_a2u1_wr8; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq8, p_sequencer.uart1_seqr8, {cnt == num_u12a_wr8;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u02a_wr8; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo8, p_sequencer.ahb_seqr8, {num_of_rd8 == num_u12a_wr8; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart18



class apb_spi_incr_payload8 extends uvm_sequence;

  rand int unsigned num_spi2a_wr8;
  rand int unsigned num_a2spi_wr8;

  function new(string name="apb_spi_incr_payload8",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)    

  constraint num_spi2a_wr_ct8 {(num_spi2a_wr8 > 2) && (num_spi2a_wr8 <= 4);}
  constraint num_a2spi_wr_ct8 {(num_a2spi_wr8 == 4);}

  // APB8 and UART8 UVC8 sequences
  spi_cfg_reg_seq8 spi_cfg_dut_seq8;
  spi_incr_payload8 spi_seq8;
  read_spi_rx_reg8 rd_rx_reg8;
  ahb_to_spi_wr8 raw_seq8;
  spi_en_tx_reg_seq8 en_spi_tx_seq8;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq8", $psprintf("Number8 of APB8->SPI8 Transaction8 = %d", num_a2spi_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Number8 of SPI8->APB8 Transaction8 = %d", num_a2spi_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Total8 Number8 of AHB8, SPI8 Transaction8 = %d", 2 * num_a2spi_wr8), UVM_LOW)

    // configure SPI8 DUT
    spi_cfg_dut_seq8 = spi_cfg_reg_seq8::type_id::create("spi_cfg_dut_seq8");
    spi_cfg_dut_seq8.reg_model8 = p_sequencer.reg_model_ptr8.spi_rf8;
    spi_cfg_dut_seq8.start(null);


    for (int i = 0; i < num_a2spi_wr8; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {num_of_wr8 == 1; base_addr == 'h800000;})
            en_spi_tx_seq8 = spi_en_tx_reg_seq8::type_id::create("en_spi_tx_seq8");
            en_spi_tx_seq8.reg_model8 = p_sequencer.reg_model_ptr8.spi_rf8;
            en_spi_tx_seq8.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq8, p_sequencer.spi0_seqr8, {cnt_i8 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg8, p_sequencer.ahb_seqr8, {num_of_rd8 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload8

class apb_gpio_simple_vseq8 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr8;

  function new(string name="apb_gpio_simple_vseq8",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)    

  constraint num_a2gpio_wr_ct8 {(num_a2gpio_wr8 == 4);}

  // APB8 and UART8 UVC8 sequences
  gpio_cfg_reg_seq8 gpio_cfg_dut_seq8;
  gpio_simple_trans_seq8 gpio_seq8;
  read_gpio_rx_reg8 rd_rx_reg8;
  ahb_to_gpio_wr8 raw_seq8;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq8", $psprintf("Number8 of AHB8->GPIO8 Transaction8 = %d", num_a2gpio_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Number8 of GPIO8->APB8 Transaction8 = %d", num_a2gpio_wr8), UVM_LOW)
    `uvm_info("vseq8", $psprintf("Total8 Number8 of AHB8, GPIO8 Transaction8 = %d", 2 * num_a2gpio_wr8), UVM_LOW)

    // configure SPI8 DUT
    gpio_cfg_dut_seq8 = gpio_cfg_reg_seq8::type_id::create("gpio_cfg_dut_seq8");
    gpio_cfg_dut_seq8.reg_model8 = p_sequencer.reg_model_ptr8.gpio_rf8;
    gpio_cfg_dut_seq8.start(null);


    for (int i = 0; i < num_a2gpio_wr8; i++) begin
      `uvm_do_on_with(raw_seq8, p_sequencer.ahb_seqr8, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq8, p_sequencer.gpio0_seqr8)
      `uvm_do_on_with(rd_rx_reg8, p_sequencer.ahb_seqr8, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq8

class apb_subsystem_vseq8 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq8",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq8)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)    

  // APB8 and UART8 UVC8 sequences
  u2a_incr_payload8 apb_to_uart8;
  apb_spi_incr_payload8 apb_to_spi8;
  apb_gpio_simple_vseq8 apb_to_gpio8;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq8", $psprintf("Doing apb_subsystem_vseq8"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart8)
      `uvm_do(apb_to_spi8)
      `uvm_do(apb_to_gpio8)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq8

class apb_ss_cms_seq8 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq8)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer8)

   function new(string name = "apb_ss_cms_seq8");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq8", $psprintf("Starting AHB8 Compliance8 Management8 System8 (CMS8)"), UVM_LOW)
//	   p_sequencer.ahb_seqr8.start_ahb_cms8();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq8
`endif
