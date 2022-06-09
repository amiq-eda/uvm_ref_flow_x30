/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_vir_seq_lib2.sv
Title2       : Virtual Sequence
Project2     :
Created2     :
Description2 : This2 file implements2 the virtual sequence for the APB2-UART2 env2.
Notes2       : The concurrent_u2a_a2u_rand_trans2 sequence first configures2
            : the UART2 RTL2. Once2 the configuration sequence is completed
            : random read/write sequences from both the UVCs2 are enabled
            : in parallel2. At2 the end a Rx2 FIFO read sequence is executed2.
            : The intrpt_seq2 needs2 to be modified to take2 interrupt2 into account2.
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV2
`define APB_UART_VIRTUAL_SEQ_LIB_SV2

class u2a_incr_payload2 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr2;
  rand int unsigned num_a2u0_wr2;
  rand int unsigned num_u12a_wr2;
  rand int unsigned num_a2u1_wr2;

  function new(string name="u2a_incr_payload2",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)    

  constraint num_u02a_wr_ct2 {(num_u02a_wr2 > 2) && (num_u02a_wr2 <= 4);}
  constraint num_a2u0_wr_ct2 {(num_a2u0_wr2 == 1);}
  constraint num_u12a_wr_ct2 {(num_u12a_wr2 > 2) && (num_u12a_wr2 <= 4);}
  constraint num_a2u1_wr_ct2 {(num_a2u1_wr2 == 1);}

  // APB2 and UART2 UVC2 sequences
  uart_ctrl_config_reg_seq2 uart_cfg_dut_seq2;
  uart_incr_payload_seq2 uart_seq2;
  intrpt_seq2 rd_rx_fifo2;
  ahb_to_uart_wr2 raw_seq2;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq2", $psprintf("Number2 of APB2->UART02 Transaction2 = %d", num_a2u0_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Number2 of APB2->UART12 Transaction2 = %d", num_a2u1_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Number2 of UART02->APB2 Transaction2 = %d", num_u02a_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Number2 of UART12->APB2 Transaction2 = %d", num_u12a_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Total2 Number2 of AHB2, UART2 Transaction2 = %d", num_u02a_wr2 + num_a2u0_wr2 + num_u02a_wr2 + num_a2u0_wr2), UVM_LOW)

    // configure UART02 DUT
    uart_cfg_dut_seq2 = uart_ctrl_config_reg_seq2::type_id::create("uart_cfg_dut_seq2");
    uart_cfg_dut_seq2.reg_model2 = p_sequencer.reg_model_ptr2.uart0_rm2;
    uart_cfg_dut_seq2.start(null);


    // configure UART12 DUT
    uart_cfg_dut_seq2 = uart_ctrl_config_reg_seq2::type_id::create("uart_cfg_dut_seq2");
    uart_cfg_dut_seq2.reg_model2 = p_sequencer.reg_model_ptr2.uart1_rm2;
    uart_cfg_dut_seq2.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == num_a2u0_wr2; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == num_a2u1_wr2; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq2, p_sequencer.uart0_seqr2, {cnt == num_u02a_wr2;})
      `uvm_do_on_with(uart_seq2, p_sequencer.uart1_seqr2, {cnt == num_u12a_wr2;})
    join
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u02a_wr2; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u12a_wr2; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload2

// rand shutdown2 and power2-on
class on_off_seq2 extends uvm_sequence;
  `uvm_object_utils(on_off_seq2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)

  function new(string name = "on_off_seq2");
     super.new(name);
  endfunction

  shutdown_dut2 shut_dut2;
  poweron_dut2 power_dut2;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut2, p_sequencer.ahb_seqr2)
       #4000;
      `uvm_do_on(power_dut2, p_sequencer.ahb_seqr2)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq2


// shutdown2 and power2-on for uart12
class on_off_uart1_seq2 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)

  function new(string name = "on_off_uart1_seq2");
     super.new(name);
  endfunction

  shutdown_dut2 shut_dut2;
  poweron_dut2 power_dut2;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut2, p_sequencer.ahb_seqr2, {write_data2 == 1;})
        #4000;
      `uvm_do_on(power_dut2, p_sequencer.ahb_seqr2)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq2

// lp2 seq, configuration sequence
class lp_shutdown_config2 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr2;
  rand int unsigned num_a2u0_wr2;
  rand int unsigned num_u12a_wr2;
  rand int unsigned num_a2u1_wr2;

  function new(string name="lp_shutdown_config2",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)    

  constraint num_u02a_wr_ct2 {(num_u02a_wr2 > 2) && (num_u02a_wr2 <= 4);}
  constraint num_a2u0_wr_ct2 {(num_a2u0_wr2 == 1);}
  constraint num_u12a_wr_ct2 {(num_u12a_wr2 > 2) && (num_u12a_wr2 <= 4);}
  constraint num_a2u1_wr_ct2 {(num_a2u1_wr2 == 1);}

  // APB2 and UART2 UVC2 sequences
  uart_ctrl_config_reg_seq2 uart_cfg_dut_seq2;
  uart_incr_payload_seq2 uart_seq2;
  intrpt_seq2 rd_rx_fifo2;
  ahb_to_uart_wr2 raw_seq2;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq2", $psprintf("Number2 of APB2->UART02 Transaction2 = %d", num_a2u0_wr2), UVM_LOW);
    `uvm_info("vseq2", $psprintf("Number2 of APB2->UART12 Transaction2 = %d", num_a2u1_wr2), UVM_LOW);
    `uvm_info("vseq2", $psprintf("Number2 of UART02->APB2 Transaction2 = %d", num_u02a_wr2), UVM_LOW);
    `uvm_info("vseq2", $psprintf("Number2 of UART12->APB2 Transaction2 = %d", num_u12a_wr2), UVM_LOW);
    `uvm_info("vseq2", $psprintf("Total2 Number2 of AHB2, UART2 Transaction2 = %d", num_u02a_wr2 + num_a2u0_wr2 + num_u02a_wr2 + num_a2u0_wr2), UVM_LOW);

    // configure UART02 DUT
    uart_cfg_dut_seq2 = uart_ctrl_config_reg_seq2::type_id::create("uart_cfg_dut_seq2");
    uart_cfg_dut_seq2.reg_model2 = p_sequencer.reg_model_ptr2.uart0_rm2;
    uart_cfg_dut_seq2.start(null);


    // configure UART12 DUT
    uart_cfg_dut_seq2 = uart_ctrl_config_reg_seq2::type_id::create("uart_cfg_dut_seq2");
    uart_cfg_dut_seq2.reg_model2 = p_sequencer.reg_model_ptr2.uart1_rm2;
    uart_cfg_dut_seq2.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == num_a2u0_wr2; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == num_a2u1_wr2; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq2, p_sequencer.uart0_seqr2, {cnt == num_u02a_wr2;})
      `uvm_do_on_with(uart_seq2, p_sequencer.uart1_seqr2, {cnt == num_u12a_wr2;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u02a_wr2; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u12a_wr2; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == num_a2u0_wr2; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq2, p_sequencer.uart0_seqr2, {cnt == num_u02a_wr2;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config2

// rand lp2 shutdown2 seq between uart2 1 and smc2
class lp_shutdown_rand2 extends uvm_sequence;

  rand int unsigned num_u02a_wr2;
  rand int unsigned num_a2u0_wr2;
  rand int unsigned num_u12a_wr2;
  rand int unsigned num_a2u1_wr2;

  function new(string name="lp_shutdown_rand2",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)    

  constraint num_u02a_wr_ct2 {(num_u02a_wr2 > 2) && (num_u02a_wr2 <= 4);}
  constraint num_a2u0_wr_ct2 {(num_a2u0_wr2 == 1);}
  constraint num_u12a_wr_ct2 {(num_u12a_wr2 > 2) && (num_u12a_wr2 <= 4);}
  constraint num_a2u1_wr_ct2 {(num_a2u1_wr2 == 1);}


  on_off_seq2 on_off_seq2;
  uart_incr_payload_seq2 uart_seq2;
  intrpt_seq2 rd_rx_fifo2;
  ahb_to_uart_wr2 raw_seq2;
  lp_shutdown_config2 lp_shutdown_config2;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut2 down seq
    `uvm_do(lp_shutdown_config2);
    #20000;
    `uvm_do(on_off_seq2);

    #10000;
    fork
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == num_a2u1_wr2; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq2, p_sequencer.uart1_seqr2, {cnt == num_u12a_wr2;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u02a_wr2; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u12a_wr2; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand2


// sequence for shutting2 down uart2 1 alone2
class lp_shutdown_uart12 extends uvm_sequence;

  rand int unsigned num_u02a_wr2;
  rand int unsigned num_a2u0_wr2;
  rand int unsigned num_u12a_wr2;
  rand int unsigned num_a2u1_wr2;

  function new(string name="lp_shutdown_uart12",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)    

  constraint num_u02a_wr_ct2 {(num_u02a_wr2 > 2) && (num_u02a_wr2 <= 4);}
  constraint num_a2u0_wr_ct2 {(num_a2u0_wr2 == 1);}
  constraint num_u12a_wr_ct2 {(num_u12a_wr2 > 2) && (num_u12a_wr2 <= 4);}
  constraint num_a2u1_wr_ct2 {(num_a2u1_wr2 == 2);}


  on_off_uart1_seq2 on_off_uart1_seq2;
  uart_incr_payload_seq2 uart_seq2;
  intrpt_seq2 rd_rx_fifo2;
  ahb_to_uart_wr2 raw_seq2;
  lp_shutdown_config2 lp_shutdown_config2;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut2 down seq
    `uvm_do(lp_shutdown_config2);
    #20000;
    `uvm_do(on_off_uart1_seq2);

    #10000;
    fork
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == num_a2u1_wr2; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq2, p_sequencer.uart1_seqr2, {cnt == num_u12a_wr2;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u02a_wr2; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo2, p_sequencer.ahb_seqr2, {num_of_rd2 == num_u12a_wr2; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart12



class apb_spi_incr_payload2 extends uvm_sequence;

  rand int unsigned num_spi2a_wr2;
  rand int unsigned num_a2spi_wr2;

  function new(string name="apb_spi_incr_payload2",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)    

  constraint num_spi2a_wr_ct2 {(num_spi2a_wr2 > 2) && (num_spi2a_wr2 <= 4);}
  constraint num_a2spi_wr_ct2 {(num_a2spi_wr2 == 4);}

  // APB2 and UART2 UVC2 sequences
  spi_cfg_reg_seq2 spi_cfg_dut_seq2;
  spi_incr_payload2 spi_seq2;
  read_spi_rx_reg2 rd_rx_reg2;
  ahb_to_spi_wr2 raw_seq2;
  spi_en_tx_reg_seq2 en_spi_tx_seq2;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq2", $psprintf("Number2 of APB2->SPI2 Transaction2 = %d", num_a2spi_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Number2 of SPI2->APB2 Transaction2 = %d", num_a2spi_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Total2 Number2 of AHB2, SPI2 Transaction2 = %d", 2 * num_a2spi_wr2), UVM_LOW)

    // configure SPI2 DUT
    spi_cfg_dut_seq2 = spi_cfg_reg_seq2::type_id::create("spi_cfg_dut_seq2");
    spi_cfg_dut_seq2.reg_model2 = p_sequencer.reg_model_ptr2.spi_rf2;
    spi_cfg_dut_seq2.start(null);


    for (int i = 0; i < num_a2spi_wr2; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {num_of_wr2 == 1; base_addr == 'h800000;})
            en_spi_tx_seq2 = spi_en_tx_reg_seq2::type_id::create("en_spi_tx_seq2");
            en_spi_tx_seq2.reg_model2 = p_sequencer.reg_model_ptr2.spi_rf2;
            en_spi_tx_seq2.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq2, p_sequencer.spi0_seqr2, {cnt_i2 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg2, p_sequencer.ahb_seqr2, {num_of_rd2 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload2

class apb_gpio_simple_vseq2 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr2;

  function new(string name="apb_gpio_simple_vseq2",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)    

  constraint num_a2gpio_wr_ct2 {(num_a2gpio_wr2 == 4);}

  // APB2 and UART2 UVC2 sequences
  gpio_cfg_reg_seq2 gpio_cfg_dut_seq2;
  gpio_simple_trans_seq2 gpio_seq2;
  read_gpio_rx_reg2 rd_rx_reg2;
  ahb_to_gpio_wr2 raw_seq2;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq2", $psprintf("Number2 of AHB2->GPIO2 Transaction2 = %d", num_a2gpio_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Number2 of GPIO2->APB2 Transaction2 = %d", num_a2gpio_wr2), UVM_LOW)
    `uvm_info("vseq2", $psprintf("Total2 Number2 of AHB2, GPIO2 Transaction2 = %d", 2 * num_a2gpio_wr2), UVM_LOW)

    // configure SPI2 DUT
    gpio_cfg_dut_seq2 = gpio_cfg_reg_seq2::type_id::create("gpio_cfg_dut_seq2");
    gpio_cfg_dut_seq2.reg_model2 = p_sequencer.reg_model_ptr2.gpio_rf2;
    gpio_cfg_dut_seq2.start(null);


    for (int i = 0; i < num_a2gpio_wr2; i++) begin
      `uvm_do_on_with(raw_seq2, p_sequencer.ahb_seqr2, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq2, p_sequencer.gpio0_seqr2)
      `uvm_do_on_with(rd_rx_reg2, p_sequencer.ahb_seqr2, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq2

class apb_subsystem_vseq2 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq2",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq2)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)    

  // APB2 and UART2 UVC2 sequences
  u2a_incr_payload2 apb_to_uart2;
  apb_spi_incr_payload2 apb_to_spi2;
  apb_gpio_simple_vseq2 apb_to_gpio2;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq2", $psprintf("Doing apb_subsystem_vseq2"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart2)
      `uvm_do(apb_to_spi2)
      `uvm_do(apb_to_gpio2)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq2

class apb_ss_cms_seq2 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq2)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer2)

   function new(string name = "apb_ss_cms_seq2");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq2", $psprintf("Starting AHB2 Compliance2 Management2 System2 (CMS2)"), UVM_LOW)
//	   p_sequencer.ahb_seqr2.start_ahb_cms2();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq2
`endif
