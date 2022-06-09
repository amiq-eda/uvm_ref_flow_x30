/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_vir_seq_lib16.sv
Title16       : Virtual Sequence
Project16     :
Created16     :
Description16 : This16 file implements16 the virtual sequence for the APB16-UART16 env16.
Notes16       : The concurrent_u2a_a2u_rand_trans16 sequence first configures16
            : the UART16 RTL16. Once16 the configuration sequence is completed
            : random read/write sequences from both the UVCs16 are enabled
            : in parallel16. At16 the end a Rx16 FIFO read sequence is executed16.
            : The intrpt_seq16 needs16 to be modified to take16 interrupt16 into account16.
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV16
`define APB_UART_VIRTUAL_SEQ_LIB_SV16

class u2a_incr_payload16 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr16;
  rand int unsigned num_a2u0_wr16;
  rand int unsigned num_u12a_wr16;
  rand int unsigned num_a2u1_wr16;

  function new(string name="u2a_incr_payload16",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)    

  constraint num_u02a_wr_ct16 {(num_u02a_wr16 > 2) && (num_u02a_wr16 <= 4);}
  constraint num_a2u0_wr_ct16 {(num_a2u0_wr16 == 1);}
  constraint num_u12a_wr_ct16 {(num_u12a_wr16 > 2) && (num_u12a_wr16 <= 4);}
  constraint num_a2u1_wr_ct16 {(num_a2u1_wr16 == 1);}

  // APB16 and UART16 UVC16 sequences
  uart_ctrl_config_reg_seq16 uart_cfg_dut_seq16;
  uart_incr_payload_seq16 uart_seq16;
  intrpt_seq16 rd_rx_fifo16;
  ahb_to_uart_wr16 raw_seq16;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq16", $psprintf("Number16 of APB16->UART016 Transaction16 = %d", num_a2u0_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Number16 of APB16->UART116 Transaction16 = %d", num_a2u1_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Number16 of UART016->APB16 Transaction16 = %d", num_u02a_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Number16 of UART116->APB16 Transaction16 = %d", num_u12a_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Total16 Number16 of AHB16, UART16 Transaction16 = %d", num_u02a_wr16 + num_a2u0_wr16 + num_u02a_wr16 + num_a2u0_wr16), UVM_LOW)

    // configure UART016 DUT
    uart_cfg_dut_seq16 = uart_ctrl_config_reg_seq16::type_id::create("uart_cfg_dut_seq16");
    uart_cfg_dut_seq16.reg_model16 = p_sequencer.reg_model_ptr16.uart0_rm16;
    uart_cfg_dut_seq16.start(null);


    // configure UART116 DUT
    uart_cfg_dut_seq16 = uart_ctrl_config_reg_seq16::type_id::create("uart_cfg_dut_seq16");
    uart_cfg_dut_seq16.reg_model16 = p_sequencer.reg_model_ptr16.uart1_rm16;
    uart_cfg_dut_seq16.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == num_a2u0_wr16; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == num_a2u1_wr16; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq16, p_sequencer.uart0_seqr16, {cnt == num_u02a_wr16;})
      `uvm_do_on_with(uart_seq16, p_sequencer.uart1_seqr16, {cnt == num_u12a_wr16;})
    join
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u02a_wr16; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u12a_wr16; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload16

// rand shutdown16 and power16-on
class on_off_seq16 extends uvm_sequence;
  `uvm_object_utils(on_off_seq16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)

  function new(string name = "on_off_seq16");
     super.new(name);
  endfunction

  shutdown_dut16 shut_dut16;
  poweron_dut16 power_dut16;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut16, p_sequencer.ahb_seqr16)
       #4000;
      `uvm_do_on(power_dut16, p_sequencer.ahb_seqr16)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq16


// shutdown16 and power16-on for uart116
class on_off_uart1_seq16 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)

  function new(string name = "on_off_uart1_seq16");
     super.new(name);
  endfunction

  shutdown_dut16 shut_dut16;
  poweron_dut16 power_dut16;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut16, p_sequencer.ahb_seqr16, {write_data16 == 1;})
        #4000;
      `uvm_do_on(power_dut16, p_sequencer.ahb_seqr16)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq16

// lp16 seq, configuration sequence
class lp_shutdown_config16 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr16;
  rand int unsigned num_a2u0_wr16;
  rand int unsigned num_u12a_wr16;
  rand int unsigned num_a2u1_wr16;

  function new(string name="lp_shutdown_config16",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)    

  constraint num_u02a_wr_ct16 {(num_u02a_wr16 > 2) && (num_u02a_wr16 <= 4);}
  constraint num_a2u0_wr_ct16 {(num_a2u0_wr16 == 1);}
  constraint num_u12a_wr_ct16 {(num_u12a_wr16 > 2) && (num_u12a_wr16 <= 4);}
  constraint num_a2u1_wr_ct16 {(num_a2u1_wr16 == 1);}

  // APB16 and UART16 UVC16 sequences
  uart_ctrl_config_reg_seq16 uart_cfg_dut_seq16;
  uart_incr_payload_seq16 uart_seq16;
  intrpt_seq16 rd_rx_fifo16;
  ahb_to_uart_wr16 raw_seq16;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq16", $psprintf("Number16 of APB16->UART016 Transaction16 = %d", num_a2u0_wr16), UVM_LOW);
    `uvm_info("vseq16", $psprintf("Number16 of APB16->UART116 Transaction16 = %d", num_a2u1_wr16), UVM_LOW);
    `uvm_info("vseq16", $psprintf("Number16 of UART016->APB16 Transaction16 = %d", num_u02a_wr16), UVM_LOW);
    `uvm_info("vseq16", $psprintf("Number16 of UART116->APB16 Transaction16 = %d", num_u12a_wr16), UVM_LOW);
    `uvm_info("vseq16", $psprintf("Total16 Number16 of AHB16, UART16 Transaction16 = %d", num_u02a_wr16 + num_a2u0_wr16 + num_u02a_wr16 + num_a2u0_wr16), UVM_LOW);

    // configure UART016 DUT
    uart_cfg_dut_seq16 = uart_ctrl_config_reg_seq16::type_id::create("uart_cfg_dut_seq16");
    uart_cfg_dut_seq16.reg_model16 = p_sequencer.reg_model_ptr16.uart0_rm16;
    uart_cfg_dut_seq16.start(null);


    // configure UART116 DUT
    uart_cfg_dut_seq16 = uart_ctrl_config_reg_seq16::type_id::create("uart_cfg_dut_seq16");
    uart_cfg_dut_seq16.reg_model16 = p_sequencer.reg_model_ptr16.uart1_rm16;
    uart_cfg_dut_seq16.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == num_a2u0_wr16; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == num_a2u1_wr16; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq16, p_sequencer.uart0_seqr16, {cnt == num_u02a_wr16;})
      `uvm_do_on_with(uart_seq16, p_sequencer.uart1_seqr16, {cnt == num_u12a_wr16;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u02a_wr16; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u12a_wr16; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == num_a2u0_wr16; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq16, p_sequencer.uart0_seqr16, {cnt == num_u02a_wr16;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config16

// rand lp16 shutdown16 seq between uart16 1 and smc16
class lp_shutdown_rand16 extends uvm_sequence;

  rand int unsigned num_u02a_wr16;
  rand int unsigned num_a2u0_wr16;
  rand int unsigned num_u12a_wr16;
  rand int unsigned num_a2u1_wr16;

  function new(string name="lp_shutdown_rand16",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)    

  constraint num_u02a_wr_ct16 {(num_u02a_wr16 > 2) && (num_u02a_wr16 <= 4);}
  constraint num_a2u0_wr_ct16 {(num_a2u0_wr16 == 1);}
  constraint num_u12a_wr_ct16 {(num_u12a_wr16 > 2) && (num_u12a_wr16 <= 4);}
  constraint num_a2u1_wr_ct16 {(num_a2u1_wr16 == 1);}


  on_off_seq16 on_off_seq16;
  uart_incr_payload_seq16 uart_seq16;
  intrpt_seq16 rd_rx_fifo16;
  ahb_to_uart_wr16 raw_seq16;
  lp_shutdown_config16 lp_shutdown_config16;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut16 down seq
    `uvm_do(lp_shutdown_config16);
    #20000;
    `uvm_do(on_off_seq16);

    #10000;
    fork
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == num_a2u1_wr16; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq16, p_sequencer.uart1_seqr16, {cnt == num_u12a_wr16;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u02a_wr16; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u12a_wr16; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand16


// sequence for shutting16 down uart16 1 alone16
class lp_shutdown_uart116 extends uvm_sequence;

  rand int unsigned num_u02a_wr16;
  rand int unsigned num_a2u0_wr16;
  rand int unsigned num_u12a_wr16;
  rand int unsigned num_a2u1_wr16;

  function new(string name="lp_shutdown_uart116",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart116)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)    

  constraint num_u02a_wr_ct16 {(num_u02a_wr16 > 2) && (num_u02a_wr16 <= 4);}
  constraint num_a2u0_wr_ct16 {(num_a2u0_wr16 == 1);}
  constraint num_u12a_wr_ct16 {(num_u12a_wr16 > 2) && (num_u12a_wr16 <= 4);}
  constraint num_a2u1_wr_ct16 {(num_a2u1_wr16 == 2);}


  on_off_uart1_seq16 on_off_uart1_seq16;
  uart_incr_payload_seq16 uart_seq16;
  intrpt_seq16 rd_rx_fifo16;
  ahb_to_uart_wr16 raw_seq16;
  lp_shutdown_config16 lp_shutdown_config16;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut16 down seq
    `uvm_do(lp_shutdown_config16);
    #20000;
    `uvm_do(on_off_uart1_seq16);

    #10000;
    fork
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == num_a2u1_wr16; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq16, p_sequencer.uart1_seqr16, {cnt == num_u12a_wr16;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u02a_wr16; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo16, p_sequencer.ahb_seqr16, {num_of_rd16 == num_u12a_wr16; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart116



class apb_spi_incr_payload16 extends uvm_sequence;

  rand int unsigned num_spi2a_wr16;
  rand int unsigned num_a2spi_wr16;

  function new(string name="apb_spi_incr_payload16",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)    

  constraint num_spi2a_wr_ct16 {(num_spi2a_wr16 > 2) && (num_spi2a_wr16 <= 4);}
  constraint num_a2spi_wr_ct16 {(num_a2spi_wr16 == 4);}

  // APB16 and UART16 UVC16 sequences
  spi_cfg_reg_seq16 spi_cfg_dut_seq16;
  spi_incr_payload16 spi_seq16;
  read_spi_rx_reg16 rd_rx_reg16;
  ahb_to_spi_wr16 raw_seq16;
  spi_en_tx_reg_seq16 en_spi_tx_seq16;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq16", $psprintf("Number16 of APB16->SPI16 Transaction16 = %d", num_a2spi_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Number16 of SPI16->APB16 Transaction16 = %d", num_a2spi_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Total16 Number16 of AHB16, SPI16 Transaction16 = %d", 2 * num_a2spi_wr16), UVM_LOW)

    // configure SPI16 DUT
    spi_cfg_dut_seq16 = spi_cfg_reg_seq16::type_id::create("spi_cfg_dut_seq16");
    spi_cfg_dut_seq16.reg_model16 = p_sequencer.reg_model_ptr16.spi_rf16;
    spi_cfg_dut_seq16.start(null);


    for (int i = 0; i < num_a2spi_wr16; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {num_of_wr16 == 1; base_addr == 'h800000;})
            en_spi_tx_seq16 = spi_en_tx_reg_seq16::type_id::create("en_spi_tx_seq16");
            en_spi_tx_seq16.reg_model16 = p_sequencer.reg_model_ptr16.spi_rf16;
            en_spi_tx_seq16.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq16, p_sequencer.spi0_seqr16, {cnt_i16 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg16, p_sequencer.ahb_seqr16, {num_of_rd16 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload16

class apb_gpio_simple_vseq16 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr16;

  function new(string name="apb_gpio_simple_vseq16",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)    

  constraint num_a2gpio_wr_ct16 {(num_a2gpio_wr16 == 4);}

  // APB16 and UART16 UVC16 sequences
  gpio_cfg_reg_seq16 gpio_cfg_dut_seq16;
  gpio_simple_trans_seq16 gpio_seq16;
  read_gpio_rx_reg16 rd_rx_reg16;
  ahb_to_gpio_wr16 raw_seq16;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq16", $psprintf("Number16 of AHB16->GPIO16 Transaction16 = %d", num_a2gpio_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Number16 of GPIO16->APB16 Transaction16 = %d", num_a2gpio_wr16), UVM_LOW)
    `uvm_info("vseq16", $psprintf("Total16 Number16 of AHB16, GPIO16 Transaction16 = %d", 2 * num_a2gpio_wr16), UVM_LOW)

    // configure SPI16 DUT
    gpio_cfg_dut_seq16 = gpio_cfg_reg_seq16::type_id::create("gpio_cfg_dut_seq16");
    gpio_cfg_dut_seq16.reg_model16 = p_sequencer.reg_model_ptr16.gpio_rf16;
    gpio_cfg_dut_seq16.start(null);


    for (int i = 0; i < num_a2gpio_wr16; i++) begin
      `uvm_do_on_with(raw_seq16, p_sequencer.ahb_seqr16, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq16, p_sequencer.gpio0_seqr16)
      `uvm_do_on_with(rd_rx_reg16, p_sequencer.ahb_seqr16, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq16

class apb_subsystem_vseq16 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq16",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)    

  // APB16 and UART16 UVC16 sequences
  u2a_incr_payload16 apb_to_uart16;
  apb_spi_incr_payload16 apb_to_spi16;
  apb_gpio_simple_vseq16 apb_to_gpio16;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq16", $psprintf("Doing apb_subsystem_vseq16"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart16)
      `uvm_do(apb_to_spi16)
      `uvm_do(apb_to_gpio16)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq16

class apb_ss_cms_seq16 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq16)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer16)

   function new(string name = "apb_ss_cms_seq16");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq16", $psprintf("Starting AHB16 Compliance16 Management16 System16 (CMS16)"), UVM_LOW)
//	   p_sequencer.ahb_seqr16.start_ahb_cms16();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq16
`endif
