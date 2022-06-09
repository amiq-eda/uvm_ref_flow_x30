/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_vir_seq_lib1.sv
Title1       : Virtual Sequence
Project1     :
Created1     :
Description1 : This1 file implements1 the virtual sequence for the APB1-UART1 env1.
Notes1       : The concurrent_u2a_a2u_rand_trans1 sequence first configures1
            : the UART1 RTL1. Once1 the configuration sequence is completed
            : random read/write sequences from both the UVCs1 are enabled
            : in parallel1. At1 the end a Rx1 FIFO read sequence is executed1.
            : The intrpt_seq1 needs1 to be modified to take1 interrupt1 into account1.
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV1
`define APB_UART_VIRTUAL_SEQ_LIB_SV1

class u2a_incr_payload1 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr1;
  rand int unsigned num_a2u0_wr1;
  rand int unsigned num_u12a_wr1;
  rand int unsigned num_a2u1_wr1;

  function new(string name="u2a_incr_payload1",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)    

  constraint num_u02a_wr_ct1 {(num_u02a_wr1 > 2) && (num_u02a_wr1 <= 4);}
  constraint num_a2u0_wr_ct1 {(num_a2u0_wr1 == 1);}
  constraint num_u12a_wr_ct1 {(num_u12a_wr1 > 2) && (num_u12a_wr1 <= 4);}
  constraint num_a2u1_wr_ct1 {(num_a2u1_wr1 == 1);}

  // APB1 and UART1 UVC1 sequences
  uart_ctrl_config_reg_seq1 uart_cfg_dut_seq1;
  uart_incr_payload_seq1 uart_seq1;
  intrpt_seq1 rd_rx_fifo1;
  ahb_to_uart_wr1 raw_seq1;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq1", $psprintf("Number1 of APB1->UART01 Transaction1 = %d", num_a2u0_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Number1 of APB1->UART11 Transaction1 = %d", num_a2u1_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Number1 of UART01->APB1 Transaction1 = %d", num_u02a_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Number1 of UART11->APB1 Transaction1 = %d", num_u12a_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Total1 Number1 of AHB1, UART1 Transaction1 = %d", num_u02a_wr1 + num_a2u0_wr1 + num_u02a_wr1 + num_a2u0_wr1), UVM_LOW)

    // configure UART01 DUT
    uart_cfg_dut_seq1 = uart_ctrl_config_reg_seq1::type_id::create("uart_cfg_dut_seq1");
    uart_cfg_dut_seq1.reg_model1 = p_sequencer.reg_model_ptr1.uart0_rm1;
    uart_cfg_dut_seq1.start(null);


    // configure UART11 DUT
    uart_cfg_dut_seq1 = uart_ctrl_config_reg_seq1::type_id::create("uart_cfg_dut_seq1");
    uart_cfg_dut_seq1.reg_model1 = p_sequencer.reg_model_ptr1.uart1_rm1;
    uart_cfg_dut_seq1.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == num_a2u0_wr1; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == num_a2u1_wr1; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq1, p_sequencer.uart0_seqr1, {cnt == num_u02a_wr1;})
      `uvm_do_on_with(uart_seq1, p_sequencer.uart1_seqr1, {cnt == num_u12a_wr1;})
    join
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u02a_wr1; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u12a_wr1; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload1

// rand shutdown1 and power1-on
class on_off_seq1 extends uvm_sequence;
  `uvm_object_utils(on_off_seq1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)

  function new(string name = "on_off_seq1");
     super.new(name);
  endfunction

  shutdown_dut1 shut_dut1;
  poweron_dut1 power_dut1;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut1, p_sequencer.ahb_seqr1)
       #4000;
      `uvm_do_on(power_dut1, p_sequencer.ahb_seqr1)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq1


// shutdown1 and power1-on for uart11
class on_off_uart1_seq1 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)

  function new(string name = "on_off_uart1_seq1");
     super.new(name);
  endfunction

  shutdown_dut1 shut_dut1;
  poweron_dut1 power_dut1;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut1, p_sequencer.ahb_seqr1, {write_data1 == 1;})
        #4000;
      `uvm_do_on(power_dut1, p_sequencer.ahb_seqr1)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq1

// lp1 seq, configuration sequence
class lp_shutdown_config1 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr1;
  rand int unsigned num_a2u0_wr1;
  rand int unsigned num_u12a_wr1;
  rand int unsigned num_a2u1_wr1;

  function new(string name="lp_shutdown_config1",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)    

  constraint num_u02a_wr_ct1 {(num_u02a_wr1 > 2) && (num_u02a_wr1 <= 4);}
  constraint num_a2u0_wr_ct1 {(num_a2u0_wr1 == 1);}
  constraint num_u12a_wr_ct1 {(num_u12a_wr1 > 2) && (num_u12a_wr1 <= 4);}
  constraint num_a2u1_wr_ct1 {(num_a2u1_wr1 == 1);}

  // APB1 and UART1 UVC1 sequences
  uart_ctrl_config_reg_seq1 uart_cfg_dut_seq1;
  uart_incr_payload_seq1 uart_seq1;
  intrpt_seq1 rd_rx_fifo1;
  ahb_to_uart_wr1 raw_seq1;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq1", $psprintf("Number1 of APB1->UART01 Transaction1 = %d", num_a2u0_wr1), UVM_LOW);
    `uvm_info("vseq1", $psprintf("Number1 of APB1->UART11 Transaction1 = %d", num_a2u1_wr1), UVM_LOW);
    `uvm_info("vseq1", $psprintf("Number1 of UART01->APB1 Transaction1 = %d", num_u02a_wr1), UVM_LOW);
    `uvm_info("vseq1", $psprintf("Number1 of UART11->APB1 Transaction1 = %d", num_u12a_wr1), UVM_LOW);
    `uvm_info("vseq1", $psprintf("Total1 Number1 of AHB1, UART1 Transaction1 = %d", num_u02a_wr1 + num_a2u0_wr1 + num_u02a_wr1 + num_a2u0_wr1), UVM_LOW);

    // configure UART01 DUT
    uart_cfg_dut_seq1 = uart_ctrl_config_reg_seq1::type_id::create("uart_cfg_dut_seq1");
    uart_cfg_dut_seq1.reg_model1 = p_sequencer.reg_model_ptr1.uart0_rm1;
    uart_cfg_dut_seq1.start(null);


    // configure UART11 DUT
    uart_cfg_dut_seq1 = uart_ctrl_config_reg_seq1::type_id::create("uart_cfg_dut_seq1");
    uart_cfg_dut_seq1.reg_model1 = p_sequencer.reg_model_ptr1.uart1_rm1;
    uart_cfg_dut_seq1.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == num_a2u0_wr1; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == num_a2u1_wr1; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq1, p_sequencer.uart0_seqr1, {cnt == num_u02a_wr1;})
      `uvm_do_on_with(uart_seq1, p_sequencer.uart1_seqr1, {cnt == num_u12a_wr1;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u02a_wr1; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u12a_wr1; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == num_a2u0_wr1; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq1, p_sequencer.uart0_seqr1, {cnt == num_u02a_wr1;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config1

// rand lp1 shutdown1 seq between uart1 1 and smc1
class lp_shutdown_rand1 extends uvm_sequence;

  rand int unsigned num_u02a_wr1;
  rand int unsigned num_a2u0_wr1;
  rand int unsigned num_u12a_wr1;
  rand int unsigned num_a2u1_wr1;

  function new(string name="lp_shutdown_rand1",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)    

  constraint num_u02a_wr_ct1 {(num_u02a_wr1 > 2) && (num_u02a_wr1 <= 4);}
  constraint num_a2u0_wr_ct1 {(num_a2u0_wr1 == 1);}
  constraint num_u12a_wr_ct1 {(num_u12a_wr1 > 2) && (num_u12a_wr1 <= 4);}
  constraint num_a2u1_wr_ct1 {(num_a2u1_wr1 == 1);}


  on_off_seq1 on_off_seq1;
  uart_incr_payload_seq1 uart_seq1;
  intrpt_seq1 rd_rx_fifo1;
  ahb_to_uart_wr1 raw_seq1;
  lp_shutdown_config1 lp_shutdown_config1;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut1 down seq
    `uvm_do(lp_shutdown_config1);
    #20000;
    `uvm_do(on_off_seq1);

    #10000;
    fork
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == num_a2u1_wr1; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq1, p_sequencer.uart1_seqr1, {cnt == num_u12a_wr1;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u02a_wr1; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u12a_wr1; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand1


// sequence for shutting1 down uart1 1 alone1
class lp_shutdown_uart11 extends uvm_sequence;

  rand int unsigned num_u02a_wr1;
  rand int unsigned num_a2u0_wr1;
  rand int unsigned num_u12a_wr1;
  rand int unsigned num_a2u1_wr1;

  function new(string name="lp_shutdown_uart11",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)    

  constraint num_u02a_wr_ct1 {(num_u02a_wr1 > 2) && (num_u02a_wr1 <= 4);}
  constraint num_a2u0_wr_ct1 {(num_a2u0_wr1 == 1);}
  constraint num_u12a_wr_ct1 {(num_u12a_wr1 > 2) && (num_u12a_wr1 <= 4);}
  constraint num_a2u1_wr_ct1 {(num_a2u1_wr1 == 2);}


  on_off_uart1_seq1 on_off_uart1_seq1;
  uart_incr_payload_seq1 uart_seq1;
  intrpt_seq1 rd_rx_fifo1;
  ahb_to_uart_wr1 raw_seq1;
  lp_shutdown_config1 lp_shutdown_config1;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut1 down seq
    `uvm_do(lp_shutdown_config1);
    #20000;
    `uvm_do(on_off_uart1_seq1);

    #10000;
    fork
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == num_a2u1_wr1; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq1, p_sequencer.uart1_seqr1, {cnt == num_u12a_wr1;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u02a_wr1; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo1, p_sequencer.ahb_seqr1, {num_of_rd1 == num_u12a_wr1; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart11



class apb_spi_incr_payload1 extends uvm_sequence;

  rand int unsigned num_spi2a_wr1;
  rand int unsigned num_a2spi_wr1;

  function new(string name="apb_spi_incr_payload1",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)    

  constraint num_spi2a_wr_ct1 {(num_spi2a_wr1 > 2) && (num_spi2a_wr1 <= 4);}
  constraint num_a2spi_wr_ct1 {(num_a2spi_wr1 == 4);}

  // APB1 and UART1 UVC1 sequences
  spi_cfg_reg_seq1 spi_cfg_dut_seq1;
  spi_incr_payload1 spi_seq1;
  read_spi_rx_reg1 rd_rx_reg1;
  ahb_to_spi_wr1 raw_seq1;
  spi_en_tx_reg_seq1 en_spi_tx_seq1;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq1", $psprintf("Number1 of APB1->SPI1 Transaction1 = %d", num_a2spi_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Number1 of SPI1->APB1 Transaction1 = %d", num_a2spi_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Total1 Number1 of AHB1, SPI1 Transaction1 = %d", 2 * num_a2spi_wr1), UVM_LOW)

    // configure SPI1 DUT
    spi_cfg_dut_seq1 = spi_cfg_reg_seq1::type_id::create("spi_cfg_dut_seq1");
    spi_cfg_dut_seq1.reg_model1 = p_sequencer.reg_model_ptr1.spi_rf1;
    spi_cfg_dut_seq1.start(null);


    for (int i = 0; i < num_a2spi_wr1; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {num_of_wr1 == 1; base_addr == 'h800000;})
            en_spi_tx_seq1 = spi_en_tx_reg_seq1::type_id::create("en_spi_tx_seq1");
            en_spi_tx_seq1.reg_model1 = p_sequencer.reg_model_ptr1.spi_rf1;
            en_spi_tx_seq1.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq1, p_sequencer.spi0_seqr1, {cnt_i1 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg1, p_sequencer.ahb_seqr1, {num_of_rd1 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload1

class apb_gpio_simple_vseq1 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr1;

  function new(string name="apb_gpio_simple_vseq1",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)    

  constraint num_a2gpio_wr_ct1 {(num_a2gpio_wr1 == 4);}

  // APB1 and UART1 UVC1 sequences
  gpio_cfg_reg_seq1 gpio_cfg_dut_seq1;
  gpio_simple_trans_seq1 gpio_seq1;
  read_gpio_rx_reg1 rd_rx_reg1;
  ahb_to_gpio_wr1 raw_seq1;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq1", $psprintf("Number1 of AHB1->GPIO1 Transaction1 = %d", num_a2gpio_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Number1 of GPIO1->APB1 Transaction1 = %d", num_a2gpio_wr1), UVM_LOW)
    `uvm_info("vseq1", $psprintf("Total1 Number1 of AHB1, GPIO1 Transaction1 = %d", 2 * num_a2gpio_wr1), UVM_LOW)

    // configure SPI1 DUT
    gpio_cfg_dut_seq1 = gpio_cfg_reg_seq1::type_id::create("gpio_cfg_dut_seq1");
    gpio_cfg_dut_seq1.reg_model1 = p_sequencer.reg_model_ptr1.gpio_rf1;
    gpio_cfg_dut_seq1.start(null);


    for (int i = 0; i < num_a2gpio_wr1; i++) begin
      `uvm_do_on_with(raw_seq1, p_sequencer.ahb_seqr1, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq1, p_sequencer.gpio0_seqr1)
      `uvm_do_on_with(rd_rx_reg1, p_sequencer.ahb_seqr1, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq1

class apb_subsystem_vseq1 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq1",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq1)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)    

  // APB1 and UART1 UVC1 sequences
  u2a_incr_payload1 apb_to_uart1;
  apb_spi_incr_payload1 apb_to_spi1;
  apb_gpio_simple_vseq1 apb_to_gpio1;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq1", $psprintf("Doing apb_subsystem_vseq1"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart1)
      `uvm_do(apb_to_spi1)
      `uvm_do(apb_to_gpio1)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq1

class apb_ss_cms_seq1 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq1)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer1)

   function new(string name = "apb_ss_cms_seq1");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq1", $psprintf("Starting AHB1 Compliance1 Management1 System1 (CMS1)"), UVM_LOW)
//	   p_sequencer.ahb_seqr1.start_ahb_cms1();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq1
`endif
