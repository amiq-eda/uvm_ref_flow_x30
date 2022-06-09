/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_vir_seq_lib13.sv
Title13       : Virtual Sequence
Project13     :
Created13     :
Description13 : This13 file implements13 the virtual sequence for the APB13-UART13 env13.
Notes13       : The concurrent_u2a_a2u_rand_trans13 sequence first configures13
            : the UART13 RTL13. Once13 the configuration sequence is completed
            : random read/write sequences from both the UVCs13 are enabled
            : in parallel13. At13 the end a Rx13 FIFO read sequence is executed13.
            : The intrpt_seq13 needs13 to be modified to take13 interrupt13 into account13.
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV13
`define APB_UART_VIRTUAL_SEQ_LIB_SV13

class u2a_incr_payload13 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr13;
  rand int unsigned num_a2u0_wr13;
  rand int unsigned num_u12a_wr13;
  rand int unsigned num_a2u1_wr13;

  function new(string name="u2a_incr_payload13",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)    

  constraint num_u02a_wr_ct13 {(num_u02a_wr13 > 2) && (num_u02a_wr13 <= 4);}
  constraint num_a2u0_wr_ct13 {(num_a2u0_wr13 == 1);}
  constraint num_u12a_wr_ct13 {(num_u12a_wr13 > 2) && (num_u12a_wr13 <= 4);}
  constraint num_a2u1_wr_ct13 {(num_a2u1_wr13 == 1);}

  // APB13 and UART13 UVC13 sequences
  uart_ctrl_config_reg_seq13 uart_cfg_dut_seq13;
  uart_incr_payload_seq13 uart_seq13;
  intrpt_seq13 rd_rx_fifo13;
  ahb_to_uart_wr13 raw_seq13;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq13", $psprintf("Number13 of APB13->UART013 Transaction13 = %d", num_a2u0_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Number13 of APB13->UART113 Transaction13 = %d", num_a2u1_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Number13 of UART013->APB13 Transaction13 = %d", num_u02a_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Number13 of UART113->APB13 Transaction13 = %d", num_u12a_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Total13 Number13 of AHB13, UART13 Transaction13 = %d", num_u02a_wr13 + num_a2u0_wr13 + num_u02a_wr13 + num_a2u0_wr13), UVM_LOW)

    // configure UART013 DUT
    uart_cfg_dut_seq13 = uart_ctrl_config_reg_seq13::type_id::create("uart_cfg_dut_seq13");
    uart_cfg_dut_seq13.reg_model13 = p_sequencer.reg_model_ptr13.uart0_rm13;
    uart_cfg_dut_seq13.start(null);


    // configure UART113 DUT
    uart_cfg_dut_seq13 = uart_ctrl_config_reg_seq13::type_id::create("uart_cfg_dut_seq13");
    uart_cfg_dut_seq13.reg_model13 = p_sequencer.reg_model_ptr13.uart1_rm13;
    uart_cfg_dut_seq13.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == num_a2u0_wr13; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == num_a2u1_wr13; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq13, p_sequencer.uart0_seqr13, {cnt == num_u02a_wr13;})
      `uvm_do_on_with(uart_seq13, p_sequencer.uart1_seqr13, {cnt == num_u12a_wr13;})
    join
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u02a_wr13; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u12a_wr13; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload13

// rand shutdown13 and power13-on
class on_off_seq13 extends uvm_sequence;
  `uvm_object_utils(on_off_seq13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)

  function new(string name = "on_off_seq13");
     super.new(name);
  endfunction

  shutdown_dut13 shut_dut13;
  poweron_dut13 power_dut13;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut13, p_sequencer.ahb_seqr13)
       #4000;
      `uvm_do_on(power_dut13, p_sequencer.ahb_seqr13)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq13


// shutdown13 and power13-on for uart113
class on_off_uart1_seq13 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)

  function new(string name = "on_off_uart1_seq13");
     super.new(name);
  endfunction

  shutdown_dut13 shut_dut13;
  poweron_dut13 power_dut13;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut13, p_sequencer.ahb_seqr13, {write_data13 == 1;})
        #4000;
      `uvm_do_on(power_dut13, p_sequencer.ahb_seqr13)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq13

// lp13 seq, configuration sequence
class lp_shutdown_config13 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr13;
  rand int unsigned num_a2u0_wr13;
  rand int unsigned num_u12a_wr13;
  rand int unsigned num_a2u1_wr13;

  function new(string name="lp_shutdown_config13",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)    

  constraint num_u02a_wr_ct13 {(num_u02a_wr13 > 2) && (num_u02a_wr13 <= 4);}
  constraint num_a2u0_wr_ct13 {(num_a2u0_wr13 == 1);}
  constraint num_u12a_wr_ct13 {(num_u12a_wr13 > 2) && (num_u12a_wr13 <= 4);}
  constraint num_a2u1_wr_ct13 {(num_a2u1_wr13 == 1);}

  // APB13 and UART13 UVC13 sequences
  uart_ctrl_config_reg_seq13 uart_cfg_dut_seq13;
  uart_incr_payload_seq13 uart_seq13;
  intrpt_seq13 rd_rx_fifo13;
  ahb_to_uart_wr13 raw_seq13;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq13", $psprintf("Number13 of APB13->UART013 Transaction13 = %d", num_a2u0_wr13), UVM_LOW);
    `uvm_info("vseq13", $psprintf("Number13 of APB13->UART113 Transaction13 = %d", num_a2u1_wr13), UVM_LOW);
    `uvm_info("vseq13", $psprintf("Number13 of UART013->APB13 Transaction13 = %d", num_u02a_wr13), UVM_LOW);
    `uvm_info("vseq13", $psprintf("Number13 of UART113->APB13 Transaction13 = %d", num_u12a_wr13), UVM_LOW);
    `uvm_info("vseq13", $psprintf("Total13 Number13 of AHB13, UART13 Transaction13 = %d", num_u02a_wr13 + num_a2u0_wr13 + num_u02a_wr13 + num_a2u0_wr13), UVM_LOW);

    // configure UART013 DUT
    uart_cfg_dut_seq13 = uart_ctrl_config_reg_seq13::type_id::create("uart_cfg_dut_seq13");
    uart_cfg_dut_seq13.reg_model13 = p_sequencer.reg_model_ptr13.uart0_rm13;
    uart_cfg_dut_seq13.start(null);


    // configure UART113 DUT
    uart_cfg_dut_seq13 = uart_ctrl_config_reg_seq13::type_id::create("uart_cfg_dut_seq13");
    uart_cfg_dut_seq13.reg_model13 = p_sequencer.reg_model_ptr13.uart1_rm13;
    uart_cfg_dut_seq13.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == num_a2u0_wr13; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == num_a2u1_wr13; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq13, p_sequencer.uart0_seqr13, {cnt == num_u02a_wr13;})
      `uvm_do_on_with(uart_seq13, p_sequencer.uart1_seqr13, {cnt == num_u12a_wr13;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u02a_wr13; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u12a_wr13; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == num_a2u0_wr13; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq13, p_sequencer.uart0_seqr13, {cnt == num_u02a_wr13;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config13

// rand lp13 shutdown13 seq between uart13 1 and smc13
class lp_shutdown_rand13 extends uvm_sequence;

  rand int unsigned num_u02a_wr13;
  rand int unsigned num_a2u0_wr13;
  rand int unsigned num_u12a_wr13;
  rand int unsigned num_a2u1_wr13;

  function new(string name="lp_shutdown_rand13",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)    

  constraint num_u02a_wr_ct13 {(num_u02a_wr13 > 2) && (num_u02a_wr13 <= 4);}
  constraint num_a2u0_wr_ct13 {(num_a2u0_wr13 == 1);}
  constraint num_u12a_wr_ct13 {(num_u12a_wr13 > 2) && (num_u12a_wr13 <= 4);}
  constraint num_a2u1_wr_ct13 {(num_a2u1_wr13 == 1);}


  on_off_seq13 on_off_seq13;
  uart_incr_payload_seq13 uart_seq13;
  intrpt_seq13 rd_rx_fifo13;
  ahb_to_uart_wr13 raw_seq13;
  lp_shutdown_config13 lp_shutdown_config13;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut13 down seq
    `uvm_do(lp_shutdown_config13);
    #20000;
    `uvm_do(on_off_seq13);

    #10000;
    fork
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == num_a2u1_wr13; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq13, p_sequencer.uart1_seqr13, {cnt == num_u12a_wr13;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u02a_wr13; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u12a_wr13; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand13


// sequence for shutting13 down uart13 1 alone13
class lp_shutdown_uart113 extends uvm_sequence;

  rand int unsigned num_u02a_wr13;
  rand int unsigned num_a2u0_wr13;
  rand int unsigned num_u12a_wr13;
  rand int unsigned num_a2u1_wr13;

  function new(string name="lp_shutdown_uart113",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart113)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)    

  constraint num_u02a_wr_ct13 {(num_u02a_wr13 > 2) && (num_u02a_wr13 <= 4);}
  constraint num_a2u0_wr_ct13 {(num_a2u0_wr13 == 1);}
  constraint num_u12a_wr_ct13 {(num_u12a_wr13 > 2) && (num_u12a_wr13 <= 4);}
  constraint num_a2u1_wr_ct13 {(num_a2u1_wr13 == 2);}


  on_off_uart1_seq13 on_off_uart1_seq13;
  uart_incr_payload_seq13 uart_seq13;
  intrpt_seq13 rd_rx_fifo13;
  ahb_to_uart_wr13 raw_seq13;
  lp_shutdown_config13 lp_shutdown_config13;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut13 down seq
    `uvm_do(lp_shutdown_config13);
    #20000;
    `uvm_do(on_off_uart1_seq13);

    #10000;
    fork
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == num_a2u1_wr13; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq13, p_sequencer.uart1_seqr13, {cnt == num_u12a_wr13;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u02a_wr13; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo13, p_sequencer.ahb_seqr13, {num_of_rd13 == num_u12a_wr13; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart113



class apb_spi_incr_payload13 extends uvm_sequence;

  rand int unsigned num_spi2a_wr13;
  rand int unsigned num_a2spi_wr13;

  function new(string name="apb_spi_incr_payload13",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)    

  constraint num_spi2a_wr_ct13 {(num_spi2a_wr13 > 2) && (num_spi2a_wr13 <= 4);}
  constraint num_a2spi_wr_ct13 {(num_a2spi_wr13 == 4);}

  // APB13 and UART13 UVC13 sequences
  spi_cfg_reg_seq13 spi_cfg_dut_seq13;
  spi_incr_payload13 spi_seq13;
  read_spi_rx_reg13 rd_rx_reg13;
  ahb_to_spi_wr13 raw_seq13;
  spi_en_tx_reg_seq13 en_spi_tx_seq13;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq13", $psprintf("Number13 of APB13->SPI13 Transaction13 = %d", num_a2spi_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Number13 of SPI13->APB13 Transaction13 = %d", num_a2spi_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Total13 Number13 of AHB13, SPI13 Transaction13 = %d", 2 * num_a2spi_wr13), UVM_LOW)

    // configure SPI13 DUT
    spi_cfg_dut_seq13 = spi_cfg_reg_seq13::type_id::create("spi_cfg_dut_seq13");
    spi_cfg_dut_seq13.reg_model13 = p_sequencer.reg_model_ptr13.spi_rf13;
    spi_cfg_dut_seq13.start(null);


    for (int i = 0; i < num_a2spi_wr13; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {num_of_wr13 == 1; base_addr == 'h800000;})
            en_spi_tx_seq13 = spi_en_tx_reg_seq13::type_id::create("en_spi_tx_seq13");
            en_spi_tx_seq13.reg_model13 = p_sequencer.reg_model_ptr13.spi_rf13;
            en_spi_tx_seq13.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq13, p_sequencer.spi0_seqr13, {cnt_i13 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg13, p_sequencer.ahb_seqr13, {num_of_rd13 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload13

class apb_gpio_simple_vseq13 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr13;

  function new(string name="apb_gpio_simple_vseq13",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)    

  constraint num_a2gpio_wr_ct13 {(num_a2gpio_wr13 == 4);}

  // APB13 and UART13 UVC13 sequences
  gpio_cfg_reg_seq13 gpio_cfg_dut_seq13;
  gpio_simple_trans_seq13 gpio_seq13;
  read_gpio_rx_reg13 rd_rx_reg13;
  ahb_to_gpio_wr13 raw_seq13;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq13", $psprintf("Number13 of AHB13->GPIO13 Transaction13 = %d", num_a2gpio_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Number13 of GPIO13->APB13 Transaction13 = %d", num_a2gpio_wr13), UVM_LOW)
    `uvm_info("vseq13", $psprintf("Total13 Number13 of AHB13, GPIO13 Transaction13 = %d", 2 * num_a2gpio_wr13), UVM_LOW)

    // configure SPI13 DUT
    gpio_cfg_dut_seq13 = gpio_cfg_reg_seq13::type_id::create("gpio_cfg_dut_seq13");
    gpio_cfg_dut_seq13.reg_model13 = p_sequencer.reg_model_ptr13.gpio_rf13;
    gpio_cfg_dut_seq13.start(null);


    for (int i = 0; i < num_a2gpio_wr13; i++) begin
      `uvm_do_on_with(raw_seq13, p_sequencer.ahb_seqr13, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq13, p_sequencer.gpio0_seqr13)
      `uvm_do_on_with(rd_rx_reg13, p_sequencer.ahb_seqr13, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq13

class apb_subsystem_vseq13 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq13",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)    

  // APB13 and UART13 UVC13 sequences
  u2a_incr_payload13 apb_to_uart13;
  apb_spi_incr_payload13 apb_to_spi13;
  apb_gpio_simple_vseq13 apb_to_gpio13;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq13", $psprintf("Doing apb_subsystem_vseq13"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart13)
      `uvm_do(apb_to_spi13)
      `uvm_do(apb_to_gpio13)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq13

class apb_ss_cms_seq13 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq13)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer13)

   function new(string name = "apb_ss_cms_seq13");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq13", $psprintf("Starting AHB13 Compliance13 Management13 System13 (CMS13)"), UVM_LOW)
//	   p_sequencer.ahb_seqr13.start_ahb_cms13();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq13
`endif
