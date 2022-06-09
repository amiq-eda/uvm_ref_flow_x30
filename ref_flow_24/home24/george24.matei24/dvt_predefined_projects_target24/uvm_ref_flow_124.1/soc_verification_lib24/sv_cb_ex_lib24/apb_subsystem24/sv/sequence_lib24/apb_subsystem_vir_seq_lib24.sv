/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_vir_seq_lib24.sv
Title24       : Virtual Sequence
Project24     :
Created24     :
Description24 : This24 file implements24 the virtual sequence for the APB24-UART24 env24.
Notes24       : The concurrent_u2a_a2u_rand_trans24 sequence first configures24
            : the UART24 RTL24. Once24 the configuration sequence is completed
            : random read/write sequences from both the UVCs24 are enabled
            : in parallel24. At24 the end a Rx24 FIFO read sequence is executed24.
            : The intrpt_seq24 needs24 to be modified to take24 interrupt24 into account24.
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV24
`define APB_UART_VIRTUAL_SEQ_LIB_SV24

class u2a_incr_payload24 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr24;
  rand int unsigned num_a2u0_wr24;
  rand int unsigned num_u12a_wr24;
  rand int unsigned num_a2u1_wr24;

  function new(string name="u2a_incr_payload24",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)    

  constraint num_u02a_wr_ct24 {(num_u02a_wr24 > 2) && (num_u02a_wr24 <= 4);}
  constraint num_a2u0_wr_ct24 {(num_a2u0_wr24 == 1);}
  constraint num_u12a_wr_ct24 {(num_u12a_wr24 > 2) && (num_u12a_wr24 <= 4);}
  constraint num_a2u1_wr_ct24 {(num_a2u1_wr24 == 1);}

  // APB24 and UART24 UVC24 sequences
  uart_ctrl_config_reg_seq24 uart_cfg_dut_seq24;
  uart_incr_payload_seq24 uart_seq24;
  intrpt_seq24 rd_rx_fifo24;
  ahb_to_uart_wr24 raw_seq24;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq24", $psprintf("Number24 of APB24->UART024 Transaction24 = %d", num_a2u0_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Number24 of APB24->UART124 Transaction24 = %d", num_a2u1_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Number24 of UART024->APB24 Transaction24 = %d", num_u02a_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Number24 of UART124->APB24 Transaction24 = %d", num_u12a_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Total24 Number24 of AHB24, UART24 Transaction24 = %d", num_u02a_wr24 + num_a2u0_wr24 + num_u02a_wr24 + num_a2u0_wr24), UVM_LOW)

    // configure UART024 DUT
    uart_cfg_dut_seq24 = uart_ctrl_config_reg_seq24::type_id::create("uart_cfg_dut_seq24");
    uart_cfg_dut_seq24.reg_model24 = p_sequencer.reg_model_ptr24.uart0_rm24;
    uart_cfg_dut_seq24.start(null);


    // configure UART124 DUT
    uart_cfg_dut_seq24 = uart_ctrl_config_reg_seq24::type_id::create("uart_cfg_dut_seq24");
    uart_cfg_dut_seq24.reg_model24 = p_sequencer.reg_model_ptr24.uart1_rm24;
    uart_cfg_dut_seq24.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == num_a2u0_wr24; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == num_a2u1_wr24; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq24, p_sequencer.uart0_seqr24, {cnt == num_u02a_wr24;})
      `uvm_do_on_with(uart_seq24, p_sequencer.uart1_seqr24, {cnt == num_u12a_wr24;})
    join
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u02a_wr24; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u12a_wr24; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload24

// rand shutdown24 and power24-on
class on_off_seq24 extends uvm_sequence;
  `uvm_object_utils(on_off_seq24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)

  function new(string name = "on_off_seq24");
     super.new(name);
  endfunction

  shutdown_dut24 shut_dut24;
  poweron_dut24 power_dut24;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut24, p_sequencer.ahb_seqr24)
       #4000;
      `uvm_do_on(power_dut24, p_sequencer.ahb_seqr24)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq24


// shutdown24 and power24-on for uart124
class on_off_uart1_seq24 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)

  function new(string name = "on_off_uart1_seq24");
     super.new(name);
  endfunction

  shutdown_dut24 shut_dut24;
  poweron_dut24 power_dut24;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut24, p_sequencer.ahb_seqr24, {write_data24 == 1;})
        #4000;
      `uvm_do_on(power_dut24, p_sequencer.ahb_seqr24)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq24

// lp24 seq, configuration sequence
class lp_shutdown_config24 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr24;
  rand int unsigned num_a2u0_wr24;
  rand int unsigned num_u12a_wr24;
  rand int unsigned num_a2u1_wr24;

  function new(string name="lp_shutdown_config24",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)    

  constraint num_u02a_wr_ct24 {(num_u02a_wr24 > 2) && (num_u02a_wr24 <= 4);}
  constraint num_a2u0_wr_ct24 {(num_a2u0_wr24 == 1);}
  constraint num_u12a_wr_ct24 {(num_u12a_wr24 > 2) && (num_u12a_wr24 <= 4);}
  constraint num_a2u1_wr_ct24 {(num_a2u1_wr24 == 1);}

  // APB24 and UART24 UVC24 sequences
  uart_ctrl_config_reg_seq24 uart_cfg_dut_seq24;
  uart_incr_payload_seq24 uart_seq24;
  intrpt_seq24 rd_rx_fifo24;
  ahb_to_uart_wr24 raw_seq24;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq24", $psprintf("Number24 of APB24->UART024 Transaction24 = %d", num_a2u0_wr24), UVM_LOW);
    `uvm_info("vseq24", $psprintf("Number24 of APB24->UART124 Transaction24 = %d", num_a2u1_wr24), UVM_LOW);
    `uvm_info("vseq24", $psprintf("Number24 of UART024->APB24 Transaction24 = %d", num_u02a_wr24), UVM_LOW);
    `uvm_info("vseq24", $psprintf("Number24 of UART124->APB24 Transaction24 = %d", num_u12a_wr24), UVM_LOW);
    `uvm_info("vseq24", $psprintf("Total24 Number24 of AHB24, UART24 Transaction24 = %d", num_u02a_wr24 + num_a2u0_wr24 + num_u02a_wr24 + num_a2u0_wr24), UVM_LOW);

    // configure UART024 DUT
    uart_cfg_dut_seq24 = uart_ctrl_config_reg_seq24::type_id::create("uart_cfg_dut_seq24");
    uart_cfg_dut_seq24.reg_model24 = p_sequencer.reg_model_ptr24.uart0_rm24;
    uart_cfg_dut_seq24.start(null);


    // configure UART124 DUT
    uart_cfg_dut_seq24 = uart_ctrl_config_reg_seq24::type_id::create("uart_cfg_dut_seq24");
    uart_cfg_dut_seq24.reg_model24 = p_sequencer.reg_model_ptr24.uart1_rm24;
    uart_cfg_dut_seq24.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == num_a2u0_wr24; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == num_a2u1_wr24; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq24, p_sequencer.uart0_seqr24, {cnt == num_u02a_wr24;})
      `uvm_do_on_with(uart_seq24, p_sequencer.uart1_seqr24, {cnt == num_u12a_wr24;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u02a_wr24; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u12a_wr24; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == num_a2u0_wr24; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq24, p_sequencer.uart0_seqr24, {cnt == num_u02a_wr24;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config24

// rand lp24 shutdown24 seq between uart24 1 and smc24
class lp_shutdown_rand24 extends uvm_sequence;

  rand int unsigned num_u02a_wr24;
  rand int unsigned num_a2u0_wr24;
  rand int unsigned num_u12a_wr24;
  rand int unsigned num_a2u1_wr24;

  function new(string name="lp_shutdown_rand24",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)    

  constraint num_u02a_wr_ct24 {(num_u02a_wr24 > 2) && (num_u02a_wr24 <= 4);}
  constraint num_a2u0_wr_ct24 {(num_a2u0_wr24 == 1);}
  constraint num_u12a_wr_ct24 {(num_u12a_wr24 > 2) && (num_u12a_wr24 <= 4);}
  constraint num_a2u1_wr_ct24 {(num_a2u1_wr24 == 1);}


  on_off_seq24 on_off_seq24;
  uart_incr_payload_seq24 uart_seq24;
  intrpt_seq24 rd_rx_fifo24;
  ahb_to_uart_wr24 raw_seq24;
  lp_shutdown_config24 lp_shutdown_config24;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut24 down seq
    `uvm_do(lp_shutdown_config24);
    #20000;
    `uvm_do(on_off_seq24);

    #10000;
    fork
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == num_a2u1_wr24; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq24, p_sequencer.uart1_seqr24, {cnt == num_u12a_wr24;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u02a_wr24; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u12a_wr24; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand24


// sequence for shutting24 down uart24 1 alone24
class lp_shutdown_uart124 extends uvm_sequence;

  rand int unsigned num_u02a_wr24;
  rand int unsigned num_a2u0_wr24;
  rand int unsigned num_u12a_wr24;
  rand int unsigned num_a2u1_wr24;

  function new(string name="lp_shutdown_uart124",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart124)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)    

  constraint num_u02a_wr_ct24 {(num_u02a_wr24 > 2) && (num_u02a_wr24 <= 4);}
  constraint num_a2u0_wr_ct24 {(num_a2u0_wr24 == 1);}
  constraint num_u12a_wr_ct24 {(num_u12a_wr24 > 2) && (num_u12a_wr24 <= 4);}
  constraint num_a2u1_wr_ct24 {(num_a2u1_wr24 == 2);}


  on_off_uart1_seq24 on_off_uart1_seq24;
  uart_incr_payload_seq24 uart_seq24;
  intrpt_seq24 rd_rx_fifo24;
  ahb_to_uart_wr24 raw_seq24;
  lp_shutdown_config24 lp_shutdown_config24;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut24 down seq
    `uvm_do(lp_shutdown_config24);
    #20000;
    `uvm_do(on_off_uart1_seq24);

    #10000;
    fork
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == num_a2u1_wr24; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq24, p_sequencer.uart1_seqr24, {cnt == num_u12a_wr24;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u02a_wr24; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo24, p_sequencer.ahb_seqr24, {num_of_rd24 == num_u12a_wr24; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart124



class apb_spi_incr_payload24 extends uvm_sequence;

  rand int unsigned num_spi2a_wr24;
  rand int unsigned num_a2spi_wr24;

  function new(string name="apb_spi_incr_payload24",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)    

  constraint num_spi2a_wr_ct24 {(num_spi2a_wr24 > 2) && (num_spi2a_wr24 <= 4);}
  constraint num_a2spi_wr_ct24 {(num_a2spi_wr24 == 4);}

  // APB24 and UART24 UVC24 sequences
  spi_cfg_reg_seq24 spi_cfg_dut_seq24;
  spi_incr_payload24 spi_seq24;
  read_spi_rx_reg24 rd_rx_reg24;
  ahb_to_spi_wr24 raw_seq24;
  spi_en_tx_reg_seq24 en_spi_tx_seq24;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq24", $psprintf("Number24 of APB24->SPI24 Transaction24 = %d", num_a2spi_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Number24 of SPI24->APB24 Transaction24 = %d", num_a2spi_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Total24 Number24 of AHB24, SPI24 Transaction24 = %d", 2 * num_a2spi_wr24), UVM_LOW)

    // configure SPI24 DUT
    spi_cfg_dut_seq24 = spi_cfg_reg_seq24::type_id::create("spi_cfg_dut_seq24");
    spi_cfg_dut_seq24.reg_model24 = p_sequencer.reg_model_ptr24.spi_rf24;
    spi_cfg_dut_seq24.start(null);


    for (int i = 0; i < num_a2spi_wr24; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {num_of_wr24 == 1; base_addr == 'h800000;})
            en_spi_tx_seq24 = spi_en_tx_reg_seq24::type_id::create("en_spi_tx_seq24");
            en_spi_tx_seq24.reg_model24 = p_sequencer.reg_model_ptr24.spi_rf24;
            en_spi_tx_seq24.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq24, p_sequencer.spi0_seqr24, {cnt_i24 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg24, p_sequencer.ahb_seqr24, {num_of_rd24 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload24

class apb_gpio_simple_vseq24 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr24;

  function new(string name="apb_gpio_simple_vseq24",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)    

  constraint num_a2gpio_wr_ct24 {(num_a2gpio_wr24 == 4);}

  // APB24 and UART24 UVC24 sequences
  gpio_cfg_reg_seq24 gpio_cfg_dut_seq24;
  gpio_simple_trans_seq24 gpio_seq24;
  read_gpio_rx_reg24 rd_rx_reg24;
  ahb_to_gpio_wr24 raw_seq24;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq24", $psprintf("Number24 of AHB24->GPIO24 Transaction24 = %d", num_a2gpio_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Number24 of GPIO24->APB24 Transaction24 = %d", num_a2gpio_wr24), UVM_LOW)
    `uvm_info("vseq24", $psprintf("Total24 Number24 of AHB24, GPIO24 Transaction24 = %d", 2 * num_a2gpio_wr24), UVM_LOW)

    // configure SPI24 DUT
    gpio_cfg_dut_seq24 = gpio_cfg_reg_seq24::type_id::create("gpio_cfg_dut_seq24");
    gpio_cfg_dut_seq24.reg_model24 = p_sequencer.reg_model_ptr24.gpio_rf24;
    gpio_cfg_dut_seq24.start(null);


    for (int i = 0; i < num_a2gpio_wr24; i++) begin
      `uvm_do_on_with(raw_seq24, p_sequencer.ahb_seqr24, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq24, p_sequencer.gpio0_seqr24)
      `uvm_do_on_with(rd_rx_reg24, p_sequencer.ahb_seqr24, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq24

class apb_subsystem_vseq24 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq24",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq24)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)    

  // APB24 and UART24 UVC24 sequences
  u2a_incr_payload24 apb_to_uart24;
  apb_spi_incr_payload24 apb_to_spi24;
  apb_gpio_simple_vseq24 apb_to_gpio24;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq24", $psprintf("Doing apb_subsystem_vseq24"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart24)
      `uvm_do(apb_to_spi24)
      `uvm_do(apb_to_gpio24)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq24

class apb_ss_cms_seq24 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq24)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer24)

   function new(string name = "apb_ss_cms_seq24");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq24", $psprintf("Starting AHB24 Compliance24 Management24 System24 (CMS24)"), UVM_LOW)
//	   p_sequencer.ahb_seqr24.start_ahb_cms24();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq24
`endif
