/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_vir_seq_lib23.sv
Title23       : Virtual Sequence
Project23     :
Created23     :
Description23 : This23 file implements23 the virtual sequence for the APB23-UART23 env23.
Notes23       : The concurrent_u2a_a2u_rand_trans23 sequence first configures23
            : the UART23 RTL23. Once23 the configuration sequence is completed
            : random read/write sequences from both the UVCs23 are enabled
            : in parallel23. At23 the end a Rx23 FIFO read sequence is executed23.
            : The intrpt_seq23 needs23 to be modified to take23 interrupt23 into account23.
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV23
`define APB_UART_VIRTUAL_SEQ_LIB_SV23

class u2a_incr_payload23 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr23;
  rand int unsigned num_a2u0_wr23;
  rand int unsigned num_u12a_wr23;
  rand int unsigned num_a2u1_wr23;

  function new(string name="u2a_incr_payload23",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)    

  constraint num_u02a_wr_ct23 {(num_u02a_wr23 > 2) && (num_u02a_wr23 <= 4);}
  constraint num_a2u0_wr_ct23 {(num_a2u0_wr23 == 1);}
  constraint num_u12a_wr_ct23 {(num_u12a_wr23 > 2) && (num_u12a_wr23 <= 4);}
  constraint num_a2u1_wr_ct23 {(num_a2u1_wr23 == 1);}

  // APB23 and UART23 UVC23 sequences
  uart_ctrl_config_reg_seq23 uart_cfg_dut_seq23;
  uart_incr_payload_seq23 uart_seq23;
  intrpt_seq23 rd_rx_fifo23;
  ahb_to_uart_wr23 raw_seq23;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq23", $psprintf("Number23 of APB23->UART023 Transaction23 = %d", num_a2u0_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Number23 of APB23->UART123 Transaction23 = %d", num_a2u1_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Number23 of UART023->APB23 Transaction23 = %d", num_u02a_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Number23 of UART123->APB23 Transaction23 = %d", num_u12a_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Total23 Number23 of AHB23, UART23 Transaction23 = %d", num_u02a_wr23 + num_a2u0_wr23 + num_u02a_wr23 + num_a2u0_wr23), UVM_LOW)

    // configure UART023 DUT
    uart_cfg_dut_seq23 = uart_ctrl_config_reg_seq23::type_id::create("uart_cfg_dut_seq23");
    uart_cfg_dut_seq23.reg_model23 = p_sequencer.reg_model_ptr23.uart0_rm23;
    uart_cfg_dut_seq23.start(null);


    // configure UART123 DUT
    uart_cfg_dut_seq23 = uart_ctrl_config_reg_seq23::type_id::create("uart_cfg_dut_seq23");
    uart_cfg_dut_seq23.reg_model23 = p_sequencer.reg_model_ptr23.uart1_rm23;
    uart_cfg_dut_seq23.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == num_a2u0_wr23; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == num_a2u1_wr23; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq23, p_sequencer.uart0_seqr23, {cnt == num_u02a_wr23;})
      `uvm_do_on_with(uart_seq23, p_sequencer.uart1_seqr23, {cnt == num_u12a_wr23;})
    join
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u02a_wr23; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u12a_wr23; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload23

// rand shutdown23 and power23-on
class on_off_seq23 extends uvm_sequence;
  `uvm_object_utils(on_off_seq23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)

  function new(string name = "on_off_seq23");
     super.new(name);
  endfunction

  shutdown_dut23 shut_dut23;
  poweron_dut23 power_dut23;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut23, p_sequencer.ahb_seqr23)
       #4000;
      `uvm_do_on(power_dut23, p_sequencer.ahb_seqr23)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq23


// shutdown23 and power23-on for uart123
class on_off_uart1_seq23 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)

  function new(string name = "on_off_uart1_seq23");
     super.new(name);
  endfunction

  shutdown_dut23 shut_dut23;
  poweron_dut23 power_dut23;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut23, p_sequencer.ahb_seqr23, {write_data23 == 1;})
        #4000;
      `uvm_do_on(power_dut23, p_sequencer.ahb_seqr23)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq23

// lp23 seq, configuration sequence
class lp_shutdown_config23 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr23;
  rand int unsigned num_a2u0_wr23;
  rand int unsigned num_u12a_wr23;
  rand int unsigned num_a2u1_wr23;

  function new(string name="lp_shutdown_config23",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)    

  constraint num_u02a_wr_ct23 {(num_u02a_wr23 > 2) && (num_u02a_wr23 <= 4);}
  constraint num_a2u0_wr_ct23 {(num_a2u0_wr23 == 1);}
  constraint num_u12a_wr_ct23 {(num_u12a_wr23 > 2) && (num_u12a_wr23 <= 4);}
  constraint num_a2u1_wr_ct23 {(num_a2u1_wr23 == 1);}

  // APB23 and UART23 UVC23 sequences
  uart_ctrl_config_reg_seq23 uart_cfg_dut_seq23;
  uart_incr_payload_seq23 uart_seq23;
  intrpt_seq23 rd_rx_fifo23;
  ahb_to_uart_wr23 raw_seq23;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq23", $psprintf("Number23 of APB23->UART023 Transaction23 = %d", num_a2u0_wr23), UVM_LOW);
    `uvm_info("vseq23", $psprintf("Number23 of APB23->UART123 Transaction23 = %d", num_a2u1_wr23), UVM_LOW);
    `uvm_info("vseq23", $psprintf("Number23 of UART023->APB23 Transaction23 = %d", num_u02a_wr23), UVM_LOW);
    `uvm_info("vseq23", $psprintf("Number23 of UART123->APB23 Transaction23 = %d", num_u12a_wr23), UVM_LOW);
    `uvm_info("vseq23", $psprintf("Total23 Number23 of AHB23, UART23 Transaction23 = %d", num_u02a_wr23 + num_a2u0_wr23 + num_u02a_wr23 + num_a2u0_wr23), UVM_LOW);

    // configure UART023 DUT
    uart_cfg_dut_seq23 = uart_ctrl_config_reg_seq23::type_id::create("uart_cfg_dut_seq23");
    uart_cfg_dut_seq23.reg_model23 = p_sequencer.reg_model_ptr23.uart0_rm23;
    uart_cfg_dut_seq23.start(null);


    // configure UART123 DUT
    uart_cfg_dut_seq23 = uart_ctrl_config_reg_seq23::type_id::create("uart_cfg_dut_seq23");
    uart_cfg_dut_seq23.reg_model23 = p_sequencer.reg_model_ptr23.uart1_rm23;
    uart_cfg_dut_seq23.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == num_a2u0_wr23; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == num_a2u1_wr23; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq23, p_sequencer.uart0_seqr23, {cnt == num_u02a_wr23;})
      `uvm_do_on_with(uart_seq23, p_sequencer.uart1_seqr23, {cnt == num_u12a_wr23;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u02a_wr23; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u12a_wr23; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == num_a2u0_wr23; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq23, p_sequencer.uart0_seqr23, {cnt == num_u02a_wr23;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config23

// rand lp23 shutdown23 seq between uart23 1 and smc23
class lp_shutdown_rand23 extends uvm_sequence;

  rand int unsigned num_u02a_wr23;
  rand int unsigned num_a2u0_wr23;
  rand int unsigned num_u12a_wr23;
  rand int unsigned num_a2u1_wr23;

  function new(string name="lp_shutdown_rand23",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)    

  constraint num_u02a_wr_ct23 {(num_u02a_wr23 > 2) && (num_u02a_wr23 <= 4);}
  constraint num_a2u0_wr_ct23 {(num_a2u0_wr23 == 1);}
  constraint num_u12a_wr_ct23 {(num_u12a_wr23 > 2) && (num_u12a_wr23 <= 4);}
  constraint num_a2u1_wr_ct23 {(num_a2u1_wr23 == 1);}


  on_off_seq23 on_off_seq23;
  uart_incr_payload_seq23 uart_seq23;
  intrpt_seq23 rd_rx_fifo23;
  ahb_to_uart_wr23 raw_seq23;
  lp_shutdown_config23 lp_shutdown_config23;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut23 down seq
    `uvm_do(lp_shutdown_config23);
    #20000;
    `uvm_do(on_off_seq23);

    #10000;
    fork
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == num_a2u1_wr23; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq23, p_sequencer.uart1_seqr23, {cnt == num_u12a_wr23;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u02a_wr23; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u12a_wr23; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand23


// sequence for shutting23 down uart23 1 alone23
class lp_shutdown_uart123 extends uvm_sequence;

  rand int unsigned num_u02a_wr23;
  rand int unsigned num_a2u0_wr23;
  rand int unsigned num_u12a_wr23;
  rand int unsigned num_a2u1_wr23;

  function new(string name="lp_shutdown_uart123",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart123)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)    

  constraint num_u02a_wr_ct23 {(num_u02a_wr23 > 2) && (num_u02a_wr23 <= 4);}
  constraint num_a2u0_wr_ct23 {(num_a2u0_wr23 == 1);}
  constraint num_u12a_wr_ct23 {(num_u12a_wr23 > 2) && (num_u12a_wr23 <= 4);}
  constraint num_a2u1_wr_ct23 {(num_a2u1_wr23 == 2);}


  on_off_uart1_seq23 on_off_uart1_seq23;
  uart_incr_payload_seq23 uart_seq23;
  intrpt_seq23 rd_rx_fifo23;
  ahb_to_uart_wr23 raw_seq23;
  lp_shutdown_config23 lp_shutdown_config23;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut23 down seq
    `uvm_do(lp_shutdown_config23);
    #20000;
    `uvm_do(on_off_uart1_seq23);

    #10000;
    fork
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == num_a2u1_wr23; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq23, p_sequencer.uart1_seqr23, {cnt == num_u12a_wr23;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u02a_wr23; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo23, p_sequencer.ahb_seqr23, {num_of_rd23 == num_u12a_wr23; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart123



class apb_spi_incr_payload23 extends uvm_sequence;

  rand int unsigned num_spi2a_wr23;
  rand int unsigned num_a2spi_wr23;

  function new(string name="apb_spi_incr_payload23",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)    

  constraint num_spi2a_wr_ct23 {(num_spi2a_wr23 > 2) && (num_spi2a_wr23 <= 4);}
  constraint num_a2spi_wr_ct23 {(num_a2spi_wr23 == 4);}

  // APB23 and UART23 UVC23 sequences
  spi_cfg_reg_seq23 spi_cfg_dut_seq23;
  spi_incr_payload23 spi_seq23;
  read_spi_rx_reg23 rd_rx_reg23;
  ahb_to_spi_wr23 raw_seq23;
  spi_en_tx_reg_seq23 en_spi_tx_seq23;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq23", $psprintf("Number23 of APB23->SPI23 Transaction23 = %d", num_a2spi_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Number23 of SPI23->APB23 Transaction23 = %d", num_a2spi_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Total23 Number23 of AHB23, SPI23 Transaction23 = %d", 2 * num_a2spi_wr23), UVM_LOW)

    // configure SPI23 DUT
    spi_cfg_dut_seq23 = spi_cfg_reg_seq23::type_id::create("spi_cfg_dut_seq23");
    spi_cfg_dut_seq23.reg_model23 = p_sequencer.reg_model_ptr23.spi_rf23;
    spi_cfg_dut_seq23.start(null);


    for (int i = 0; i < num_a2spi_wr23; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {num_of_wr23 == 1; base_addr == 'h800000;})
            en_spi_tx_seq23 = spi_en_tx_reg_seq23::type_id::create("en_spi_tx_seq23");
            en_spi_tx_seq23.reg_model23 = p_sequencer.reg_model_ptr23.spi_rf23;
            en_spi_tx_seq23.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq23, p_sequencer.spi0_seqr23, {cnt_i23 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg23, p_sequencer.ahb_seqr23, {num_of_rd23 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload23

class apb_gpio_simple_vseq23 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr23;

  function new(string name="apb_gpio_simple_vseq23",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)    

  constraint num_a2gpio_wr_ct23 {(num_a2gpio_wr23 == 4);}

  // APB23 and UART23 UVC23 sequences
  gpio_cfg_reg_seq23 gpio_cfg_dut_seq23;
  gpio_simple_trans_seq23 gpio_seq23;
  read_gpio_rx_reg23 rd_rx_reg23;
  ahb_to_gpio_wr23 raw_seq23;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq23", $psprintf("Number23 of AHB23->GPIO23 Transaction23 = %d", num_a2gpio_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Number23 of GPIO23->APB23 Transaction23 = %d", num_a2gpio_wr23), UVM_LOW)
    `uvm_info("vseq23", $psprintf("Total23 Number23 of AHB23, GPIO23 Transaction23 = %d", 2 * num_a2gpio_wr23), UVM_LOW)

    // configure SPI23 DUT
    gpio_cfg_dut_seq23 = gpio_cfg_reg_seq23::type_id::create("gpio_cfg_dut_seq23");
    gpio_cfg_dut_seq23.reg_model23 = p_sequencer.reg_model_ptr23.gpio_rf23;
    gpio_cfg_dut_seq23.start(null);


    for (int i = 0; i < num_a2gpio_wr23; i++) begin
      `uvm_do_on_with(raw_seq23, p_sequencer.ahb_seqr23, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq23, p_sequencer.gpio0_seqr23)
      `uvm_do_on_with(rd_rx_reg23, p_sequencer.ahb_seqr23, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq23

class apb_subsystem_vseq23 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq23",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq23)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)    

  // APB23 and UART23 UVC23 sequences
  u2a_incr_payload23 apb_to_uart23;
  apb_spi_incr_payload23 apb_to_spi23;
  apb_gpio_simple_vseq23 apb_to_gpio23;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq23", $psprintf("Doing apb_subsystem_vseq23"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart23)
      `uvm_do(apb_to_spi23)
      `uvm_do(apb_to_gpio23)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq23

class apb_ss_cms_seq23 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq23)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer23)

   function new(string name = "apb_ss_cms_seq23");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq23", $psprintf("Starting AHB23 Compliance23 Management23 System23 (CMS23)"), UVM_LOW)
//	   p_sequencer.ahb_seqr23.start_ahb_cms23();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq23
`endif
