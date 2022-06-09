/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_vir_seq_lib5.sv
Title5       : Virtual Sequence
Project5     :
Created5     :
Description5 : This5 file implements5 the virtual sequence for the APB5-UART5 env5.
Notes5       : The concurrent_u2a_a2u_rand_trans5 sequence first configures5
            : the UART5 RTL5. Once5 the configuration sequence is completed
            : random read/write sequences from both the UVCs5 are enabled
            : in parallel5. At5 the end a Rx5 FIFO read sequence is executed5.
            : The intrpt_seq5 needs5 to be modified to take5 interrupt5 into account5.
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV5
`define APB_UART_VIRTUAL_SEQ_LIB_SV5

class u2a_incr_payload5 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr5;
  rand int unsigned num_a2u0_wr5;
  rand int unsigned num_u12a_wr5;
  rand int unsigned num_a2u1_wr5;

  function new(string name="u2a_incr_payload5",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)    

  constraint num_u02a_wr_ct5 {(num_u02a_wr5 > 2) && (num_u02a_wr5 <= 4);}
  constraint num_a2u0_wr_ct5 {(num_a2u0_wr5 == 1);}
  constraint num_u12a_wr_ct5 {(num_u12a_wr5 > 2) && (num_u12a_wr5 <= 4);}
  constraint num_a2u1_wr_ct5 {(num_a2u1_wr5 == 1);}

  // APB5 and UART5 UVC5 sequences
  uart_ctrl_config_reg_seq5 uart_cfg_dut_seq5;
  uart_incr_payload_seq5 uart_seq5;
  intrpt_seq5 rd_rx_fifo5;
  ahb_to_uart_wr5 raw_seq5;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq5", $psprintf("Number5 of APB5->UART05 Transaction5 = %d", num_a2u0_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Number5 of APB5->UART15 Transaction5 = %d", num_a2u1_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Number5 of UART05->APB5 Transaction5 = %d", num_u02a_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Number5 of UART15->APB5 Transaction5 = %d", num_u12a_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Total5 Number5 of AHB5, UART5 Transaction5 = %d", num_u02a_wr5 + num_a2u0_wr5 + num_u02a_wr5 + num_a2u0_wr5), UVM_LOW)

    // configure UART05 DUT
    uart_cfg_dut_seq5 = uart_ctrl_config_reg_seq5::type_id::create("uart_cfg_dut_seq5");
    uart_cfg_dut_seq5.reg_model5 = p_sequencer.reg_model_ptr5.uart0_rm5;
    uart_cfg_dut_seq5.start(null);


    // configure UART15 DUT
    uart_cfg_dut_seq5 = uart_ctrl_config_reg_seq5::type_id::create("uart_cfg_dut_seq5");
    uart_cfg_dut_seq5.reg_model5 = p_sequencer.reg_model_ptr5.uart1_rm5;
    uart_cfg_dut_seq5.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == num_a2u0_wr5; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == num_a2u1_wr5; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq5, p_sequencer.uart0_seqr5, {cnt == num_u02a_wr5;})
      `uvm_do_on_with(uart_seq5, p_sequencer.uart1_seqr5, {cnt == num_u12a_wr5;})
    join
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u02a_wr5; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u12a_wr5; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload5

// rand shutdown5 and power5-on
class on_off_seq5 extends uvm_sequence;
  `uvm_object_utils(on_off_seq5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)

  function new(string name = "on_off_seq5");
     super.new(name);
  endfunction

  shutdown_dut5 shut_dut5;
  poweron_dut5 power_dut5;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut5, p_sequencer.ahb_seqr5)
       #4000;
      `uvm_do_on(power_dut5, p_sequencer.ahb_seqr5)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq5


// shutdown5 and power5-on for uart15
class on_off_uart1_seq5 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)

  function new(string name = "on_off_uart1_seq5");
     super.new(name);
  endfunction

  shutdown_dut5 shut_dut5;
  poweron_dut5 power_dut5;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut5, p_sequencer.ahb_seqr5, {write_data5 == 1;})
        #4000;
      `uvm_do_on(power_dut5, p_sequencer.ahb_seqr5)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq5

// lp5 seq, configuration sequence
class lp_shutdown_config5 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr5;
  rand int unsigned num_a2u0_wr5;
  rand int unsigned num_u12a_wr5;
  rand int unsigned num_a2u1_wr5;

  function new(string name="lp_shutdown_config5",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)    

  constraint num_u02a_wr_ct5 {(num_u02a_wr5 > 2) && (num_u02a_wr5 <= 4);}
  constraint num_a2u0_wr_ct5 {(num_a2u0_wr5 == 1);}
  constraint num_u12a_wr_ct5 {(num_u12a_wr5 > 2) && (num_u12a_wr5 <= 4);}
  constraint num_a2u1_wr_ct5 {(num_a2u1_wr5 == 1);}

  // APB5 and UART5 UVC5 sequences
  uart_ctrl_config_reg_seq5 uart_cfg_dut_seq5;
  uart_incr_payload_seq5 uart_seq5;
  intrpt_seq5 rd_rx_fifo5;
  ahb_to_uart_wr5 raw_seq5;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq5", $psprintf("Number5 of APB5->UART05 Transaction5 = %d", num_a2u0_wr5), UVM_LOW);
    `uvm_info("vseq5", $psprintf("Number5 of APB5->UART15 Transaction5 = %d", num_a2u1_wr5), UVM_LOW);
    `uvm_info("vseq5", $psprintf("Number5 of UART05->APB5 Transaction5 = %d", num_u02a_wr5), UVM_LOW);
    `uvm_info("vseq5", $psprintf("Number5 of UART15->APB5 Transaction5 = %d", num_u12a_wr5), UVM_LOW);
    `uvm_info("vseq5", $psprintf("Total5 Number5 of AHB5, UART5 Transaction5 = %d", num_u02a_wr5 + num_a2u0_wr5 + num_u02a_wr5 + num_a2u0_wr5), UVM_LOW);

    // configure UART05 DUT
    uart_cfg_dut_seq5 = uart_ctrl_config_reg_seq5::type_id::create("uart_cfg_dut_seq5");
    uart_cfg_dut_seq5.reg_model5 = p_sequencer.reg_model_ptr5.uart0_rm5;
    uart_cfg_dut_seq5.start(null);


    // configure UART15 DUT
    uart_cfg_dut_seq5 = uart_ctrl_config_reg_seq5::type_id::create("uart_cfg_dut_seq5");
    uart_cfg_dut_seq5.reg_model5 = p_sequencer.reg_model_ptr5.uart1_rm5;
    uart_cfg_dut_seq5.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == num_a2u0_wr5; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == num_a2u1_wr5; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq5, p_sequencer.uart0_seqr5, {cnt == num_u02a_wr5;})
      `uvm_do_on_with(uart_seq5, p_sequencer.uart1_seqr5, {cnt == num_u12a_wr5;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u02a_wr5; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u12a_wr5; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == num_a2u0_wr5; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq5, p_sequencer.uart0_seqr5, {cnt == num_u02a_wr5;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config5

// rand lp5 shutdown5 seq between uart5 1 and smc5
class lp_shutdown_rand5 extends uvm_sequence;

  rand int unsigned num_u02a_wr5;
  rand int unsigned num_a2u0_wr5;
  rand int unsigned num_u12a_wr5;
  rand int unsigned num_a2u1_wr5;

  function new(string name="lp_shutdown_rand5",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)    

  constraint num_u02a_wr_ct5 {(num_u02a_wr5 > 2) && (num_u02a_wr5 <= 4);}
  constraint num_a2u0_wr_ct5 {(num_a2u0_wr5 == 1);}
  constraint num_u12a_wr_ct5 {(num_u12a_wr5 > 2) && (num_u12a_wr5 <= 4);}
  constraint num_a2u1_wr_ct5 {(num_a2u1_wr5 == 1);}


  on_off_seq5 on_off_seq5;
  uart_incr_payload_seq5 uart_seq5;
  intrpt_seq5 rd_rx_fifo5;
  ahb_to_uart_wr5 raw_seq5;
  lp_shutdown_config5 lp_shutdown_config5;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut5 down seq
    `uvm_do(lp_shutdown_config5);
    #20000;
    `uvm_do(on_off_seq5);

    #10000;
    fork
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == num_a2u1_wr5; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq5, p_sequencer.uart1_seqr5, {cnt == num_u12a_wr5;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u02a_wr5; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u12a_wr5; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand5


// sequence for shutting5 down uart5 1 alone5
class lp_shutdown_uart15 extends uvm_sequence;

  rand int unsigned num_u02a_wr5;
  rand int unsigned num_a2u0_wr5;
  rand int unsigned num_u12a_wr5;
  rand int unsigned num_a2u1_wr5;

  function new(string name="lp_shutdown_uart15",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)    

  constraint num_u02a_wr_ct5 {(num_u02a_wr5 > 2) && (num_u02a_wr5 <= 4);}
  constraint num_a2u0_wr_ct5 {(num_a2u0_wr5 == 1);}
  constraint num_u12a_wr_ct5 {(num_u12a_wr5 > 2) && (num_u12a_wr5 <= 4);}
  constraint num_a2u1_wr_ct5 {(num_a2u1_wr5 == 2);}


  on_off_uart1_seq5 on_off_uart1_seq5;
  uart_incr_payload_seq5 uart_seq5;
  intrpt_seq5 rd_rx_fifo5;
  ahb_to_uart_wr5 raw_seq5;
  lp_shutdown_config5 lp_shutdown_config5;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut5 down seq
    `uvm_do(lp_shutdown_config5);
    #20000;
    `uvm_do(on_off_uart1_seq5);

    #10000;
    fork
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == num_a2u1_wr5; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq5, p_sequencer.uart1_seqr5, {cnt == num_u12a_wr5;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u02a_wr5; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo5, p_sequencer.ahb_seqr5, {num_of_rd5 == num_u12a_wr5; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart15



class apb_spi_incr_payload5 extends uvm_sequence;

  rand int unsigned num_spi2a_wr5;
  rand int unsigned num_a2spi_wr5;

  function new(string name="apb_spi_incr_payload5",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)    

  constraint num_spi2a_wr_ct5 {(num_spi2a_wr5 > 2) && (num_spi2a_wr5 <= 4);}
  constraint num_a2spi_wr_ct5 {(num_a2spi_wr5 == 4);}

  // APB5 and UART5 UVC5 sequences
  spi_cfg_reg_seq5 spi_cfg_dut_seq5;
  spi_incr_payload5 spi_seq5;
  read_spi_rx_reg5 rd_rx_reg5;
  ahb_to_spi_wr5 raw_seq5;
  spi_en_tx_reg_seq5 en_spi_tx_seq5;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq5", $psprintf("Number5 of APB5->SPI5 Transaction5 = %d", num_a2spi_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Number5 of SPI5->APB5 Transaction5 = %d", num_a2spi_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Total5 Number5 of AHB5, SPI5 Transaction5 = %d", 2 * num_a2spi_wr5), UVM_LOW)

    // configure SPI5 DUT
    spi_cfg_dut_seq5 = spi_cfg_reg_seq5::type_id::create("spi_cfg_dut_seq5");
    spi_cfg_dut_seq5.reg_model5 = p_sequencer.reg_model_ptr5.spi_rf5;
    spi_cfg_dut_seq5.start(null);


    for (int i = 0; i < num_a2spi_wr5; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {num_of_wr5 == 1; base_addr == 'h800000;})
            en_spi_tx_seq5 = spi_en_tx_reg_seq5::type_id::create("en_spi_tx_seq5");
            en_spi_tx_seq5.reg_model5 = p_sequencer.reg_model_ptr5.spi_rf5;
            en_spi_tx_seq5.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq5, p_sequencer.spi0_seqr5, {cnt_i5 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg5, p_sequencer.ahb_seqr5, {num_of_rd5 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload5

class apb_gpio_simple_vseq5 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr5;

  function new(string name="apb_gpio_simple_vseq5",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)    

  constraint num_a2gpio_wr_ct5 {(num_a2gpio_wr5 == 4);}

  // APB5 and UART5 UVC5 sequences
  gpio_cfg_reg_seq5 gpio_cfg_dut_seq5;
  gpio_simple_trans_seq5 gpio_seq5;
  read_gpio_rx_reg5 rd_rx_reg5;
  ahb_to_gpio_wr5 raw_seq5;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq5", $psprintf("Number5 of AHB5->GPIO5 Transaction5 = %d", num_a2gpio_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Number5 of GPIO5->APB5 Transaction5 = %d", num_a2gpio_wr5), UVM_LOW)
    `uvm_info("vseq5", $psprintf("Total5 Number5 of AHB5, GPIO5 Transaction5 = %d", 2 * num_a2gpio_wr5), UVM_LOW)

    // configure SPI5 DUT
    gpio_cfg_dut_seq5 = gpio_cfg_reg_seq5::type_id::create("gpio_cfg_dut_seq5");
    gpio_cfg_dut_seq5.reg_model5 = p_sequencer.reg_model_ptr5.gpio_rf5;
    gpio_cfg_dut_seq5.start(null);


    for (int i = 0; i < num_a2gpio_wr5; i++) begin
      `uvm_do_on_with(raw_seq5, p_sequencer.ahb_seqr5, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq5, p_sequencer.gpio0_seqr5)
      `uvm_do_on_with(rd_rx_reg5, p_sequencer.ahb_seqr5, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq5

class apb_subsystem_vseq5 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq5",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq5)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)    

  // APB5 and UART5 UVC5 sequences
  u2a_incr_payload5 apb_to_uart5;
  apb_spi_incr_payload5 apb_to_spi5;
  apb_gpio_simple_vseq5 apb_to_gpio5;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq5", $psprintf("Doing apb_subsystem_vseq5"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart5)
      `uvm_do(apb_to_spi5)
      `uvm_do(apb_to_gpio5)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq5

class apb_ss_cms_seq5 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq5)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer5)

   function new(string name = "apb_ss_cms_seq5");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq5", $psprintf("Starting AHB5 Compliance5 Management5 System5 (CMS5)"), UVM_LOW)
//	   p_sequencer.ahb_seqr5.start_ahb_cms5();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq5
`endif
