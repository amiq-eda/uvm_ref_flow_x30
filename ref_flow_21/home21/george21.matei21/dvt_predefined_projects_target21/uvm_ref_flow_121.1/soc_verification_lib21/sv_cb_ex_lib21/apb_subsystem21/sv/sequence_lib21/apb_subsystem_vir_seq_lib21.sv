/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_vir_seq_lib21.sv
Title21       : Virtual Sequence
Project21     :
Created21     :
Description21 : This21 file implements21 the virtual sequence for the APB21-UART21 env21.
Notes21       : The concurrent_u2a_a2u_rand_trans21 sequence first configures21
            : the UART21 RTL21. Once21 the configuration sequence is completed
            : random read/write sequences from both the UVCs21 are enabled
            : in parallel21. At21 the end a Rx21 FIFO read sequence is executed21.
            : The intrpt_seq21 needs21 to be modified to take21 interrupt21 into account21.
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV21
`define APB_UART_VIRTUAL_SEQ_LIB_SV21

class u2a_incr_payload21 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr21;
  rand int unsigned num_a2u0_wr21;
  rand int unsigned num_u12a_wr21;
  rand int unsigned num_a2u1_wr21;

  function new(string name="u2a_incr_payload21",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)    

  constraint num_u02a_wr_ct21 {(num_u02a_wr21 > 2) && (num_u02a_wr21 <= 4);}
  constraint num_a2u0_wr_ct21 {(num_a2u0_wr21 == 1);}
  constraint num_u12a_wr_ct21 {(num_u12a_wr21 > 2) && (num_u12a_wr21 <= 4);}
  constraint num_a2u1_wr_ct21 {(num_a2u1_wr21 == 1);}

  // APB21 and UART21 UVC21 sequences
  uart_ctrl_config_reg_seq21 uart_cfg_dut_seq21;
  uart_incr_payload_seq21 uart_seq21;
  intrpt_seq21 rd_rx_fifo21;
  ahb_to_uart_wr21 raw_seq21;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq21", $psprintf("Number21 of APB21->UART021 Transaction21 = %d", num_a2u0_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Number21 of APB21->UART121 Transaction21 = %d", num_a2u1_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Number21 of UART021->APB21 Transaction21 = %d", num_u02a_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Number21 of UART121->APB21 Transaction21 = %d", num_u12a_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Total21 Number21 of AHB21, UART21 Transaction21 = %d", num_u02a_wr21 + num_a2u0_wr21 + num_u02a_wr21 + num_a2u0_wr21), UVM_LOW)

    // configure UART021 DUT
    uart_cfg_dut_seq21 = uart_ctrl_config_reg_seq21::type_id::create("uart_cfg_dut_seq21");
    uart_cfg_dut_seq21.reg_model21 = p_sequencer.reg_model_ptr21.uart0_rm21;
    uart_cfg_dut_seq21.start(null);


    // configure UART121 DUT
    uart_cfg_dut_seq21 = uart_ctrl_config_reg_seq21::type_id::create("uart_cfg_dut_seq21");
    uart_cfg_dut_seq21.reg_model21 = p_sequencer.reg_model_ptr21.uart1_rm21;
    uart_cfg_dut_seq21.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == num_a2u0_wr21; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == num_a2u1_wr21; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq21, p_sequencer.uart0_seqr21, {cnt == num_u02a_wr21;})
      `uvm_do_on_with(uart_seq21, p_sequencer.uart1_seqr21, {cnt == num_u12a_wr21;})
    join
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u02a_wr21; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u12a_wr21; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload21

// rand shutdown21 and power21-on
class on_off_seq21 extends uvm_sequence;
  `uvm_object_utils(on_off_seq21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)

  function new(string name = "on_off_seq21");
     super.new(name);
  endfunction

  shutdown_dut21 shut_dut21;
  poweron_dut21 power_dut21;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut21, p_sequencer.ahb_seqr21)
       #4000;
      `uvm_do_on(power_dut21, p_sequencer.ahb_seqr21)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq21


// shutdown21 and power21-on for uart121
class on_off_uart1_seq21 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)

  function new(string name = "on_off_uart1_seq21");
     super.new(name);
  endfunction

  shutdown_dut21 shut_dut21;
  poweron_dut21 power_dut21;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut21, p_sequencer.ahb_seqr21, {write_data21 == 1;})
        #4000;
      `uvm_do_on(power_dut21, p_sequencer.ahb_seqr21)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq21

// lp21 seq, configuration sequence
class lp_shutdown_config21 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr21;
  rand int unsigned num_a2u0_wr21;
  rand int unsigned num_u12a_wr21;
  rand int unsigned num_a2u1_wr21;

  function new(string name="lp_shutdown_config21",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)    

  constraint num_u02a_wr_ct21 {(num_u02a_wr21 > 2) && (num_u02a_wr21 <= 4);}
  constraint num_a2u0_wr_ct21 {(num_a2u0_wr21 == 1);}
  constraint num_u12a_wr_ct21 {(num_u12a_wr21 > 2) && (num_u12a_wr21 <= 4);}
  constraint num_a2u1_wr_ct21 {(num_a2u1_wr21 == 1);}

  // APB21 and UART21 UVC21 sequences
  uart_ctrl_config_reg_seq21 uart_cfg_dut_seq21;
  uart_incr_payload_seq21 uart_seq21;
  intrpt_seq21 rd_rx_fifo21;
  ahb_to_uart_wr21 raw_seq21;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq21", $psprintf("Number21 of APB21->UART021 Transaction21 = %d", num_a2u0_wr21), UVM_LOW);
    `uvm_info("vseq21", $psprintf("Number21 of APB21->UART121 Transaction21 = %d", num_a2u1_wr21), UVM_LOW);
    `uvm_info("vseq21", $psprintf("Number21 of UART021->APB21 Transaction21 = %d", num_u02a_wr21), UVM_LOW);
    `uvm_info("vseq21", $psprintf("Number21 of UART121->APB21 Transaction21 = %d", num_u12a_wr21), UVM_LOW);
    `uvm_info("vseq21", $psprintf("Total21 Number21 of AHB21, UART21 Transaction21 = %d", num_u02a_wr21 + num_a2u0_wr21 + num_u02a_wr21 + num_a2u0_wr21), UVM_LOW);

    // configure UART021 DUT
    uart_cfg_dut_seq21 = uart_ctrl_config_reg_seq21::type_id::create("uart_cfg_dut_seq21");
    uart_cfg_dut_seq21.reg_model21 = p_sequencer.reg_model_ptr21.uart0_rm21;
    uart_cfg_dut_seq21.start(null);


    // configure UART121 DUT
    uart_cfg_dut_seq21 = uart_ctrl_config_reg_seq21::type_id::create("uart_cfg_dut_seq21");
    uart_cfg_dut_seq21.reg_model21 = p_sequencer.reg_model_ptr21.uart1_rm21;
    uart_cfg_dut_seq21.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == num_a2u0_wr21; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == num_a2u1_wr21; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq21, p_sequencer.uart0_seqr21, {cnt == num_u02a_wr21;})
      `uvm_do_on_with(uart_seq21, p_sequencer.uart1_seqr21, {cnt == num_u12a_wr21;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u02a_wr21; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u12a_wr21; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == num_a2u0_wr21; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq21, p_sequencer.uart0_seqr21, {cnt == num_u02a_wr21;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config21

// rand lp21 shutdown21 seq between uart21 1 and smc21
class lp_shutdown_rand21 extends uvm_sequence;

  rand int unsigned num_u02a_wr21;
  rand int unsigned num_a2u0_wr21;
  rand int unsigned num_u12a_wr21;
  rand int unsigned num_a2u1_wr21;

  function new(string name="lp_shutdown_rand21",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)    

  constraint num_u02a_wr_ct21 {(num_u02a_wr21 > 2) && (num_u02a_wr21 <= 4);}
  constraint num_a2u0_wr_ct21 {(num_a2u0_wr21 == 1);}
  constraint num_u12a_wr_ct21 {(num_u12a_wr21 > 2) && (num_u12a_wr21 <= 4);}
  constraint num_a2u1_wr_ct21 {(num_a2u1_wr21 == 1);}


  on_off_seq21 on_off_seq21;
  uart_incr_payload_seq21 uart_seq21;
  intrpt_seq21 rd_rx_fifo21;
  ahb_to_uart_wr21 raw_seq21;
  lp_shutdown_config21 lp_shutdown_config21;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut21 down seq
    `uvm_do(lp_shutdown_config21);
    #20000;
    `uvm_do(on_off_seq21);

    #10000;
    fork
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == num_a2u1_wr21; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq21, p_sequencer.uart1_seqr21, {cnt == num_u12a_wr21;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u02a_wr21; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u12a_wr21; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand21


// sequence for shutting21 down uart21 1 alone21
class lp_shutdown_uart121 extends uvm_sequence;

  rand int unsigned num_u02a_wr21;
  rand int unsigned num_a2u0_wr21;
  rand int unsigned num_u12a_wr21;
  rand int unsigned num_a2u1_wr21;

  function new(string name="lp_shutdown_uart121",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart121)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)    

  constraint num_u02a_wr_ct21 {(num_u02a_wr21 > 2) && (num_u02a_wr21 <= 4);}
  constraint num_a2u0_wr_ct21 {(num_a2u0_wr21 == 1);}
  constraint num_u12a_wr_ct21 {(num_u12a_wr21 > 2) && (num_u12a_wr21 <= 4);}
  constraint num_a2u1_wr_ct21 {(num_a2u1_wr21 == 2);}


  on_off_uart1_seq21 on_off_uart1_seq21;
  uart_incr_payload_seq21 uart_seq21;
  intrpt_seq21 rd_rx_fifo21;
  ahb_to_uart_wr21 raw_seq21;
  lp_shutdown_config21 lp_shutdown_config21;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut21 down seq
    `uvm_do(lp_shutdown_config21);
    #20000;
    `uvm_do(on_off_uart1_seq21);

    #10000;
    fork
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == num_a2u1_wr21; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq21, p_sequencer.uart1_seqr21, {cnt == num_u12a_wr21;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u02a_wr21; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo21, p_sequencer.ahb_seqr21, {num_of_rd21 == num_u12a_wr21; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart121



class apb_spi_incr_payload21 extends uvm_sequence;

  rand int unsigned num_spi2a_wr21;
  rand int unsigned num_a2spi_wr21;

  function new(string name="apb_spi_incr_payload21",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)    

  constraint num_spi2a_wr_ct21 {(num_spi2a_wr21 > 2) && (num_spi2a_wr21 <= 4);}
  constraint num_a2spi_wr_ct21 {(num_a2spi_wr21 == 4);}

  // APB21 and UART21 UVC21 sequences
  spi_cfg_reg_seq21 spi_cfg_dut_seq21;
  spi_incr_payload21 spi_seq21;
  read_spi_rx_reg21 rd_rx_reg21;
  ahb_to_spi_wr21 raw_seq21;
  spi_en_tx_reg_seq21 en_spi_tx_seq21;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq21", $psprintf("Number21 of APB21->SPI21 Transaction21 = %d", num_a2spi_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Number21 of SPI21->APB21 Transaction21 = %d", num_a2spi_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Total21 Number21 of AHB21, SPI21 Transaction21 = %d", 2 * num_a2spi_wr21), UVM_LOW)

    // configure SPI21 DUT
    spi_cfg_dut_seq21 = spi_cfg_reg_seq21::type_id::create("spi_cfg_dut_seq21");
    spi_cfg_dut_seq21.reg_model21 = p_sequencer.reg_model_ptr21.spi_rf21;
    spi_cfg_dut_seq21.start(null);


    for (int i = 0; i < num_a2spi_wr21; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {num_of_wr21 == 1; base_addr == 'h800000;})
            en_spi_tx_seq21 = spi_en_tx_reg_seq21::type_id::create("en_spi_tx_seq21");
            en_spi_tx_seq21.reg_model21 = p_sequencer.reg_model_ptr21.spi_rf21;
            en_spi_tx_seq21.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq21, p_sequencer.spi0_seqr21, {cnt_i21 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg21, p_sequencer.ahb_seqr21, {num_of_rd21 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload21

class apb_gpio_simple_vseq21 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr21;

  function new(string name="apb_gpio_simple_vseq21",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)    

  constraint num_a2gpio_wr_ct21 {(num_a2gpio_wr21 == 4);}

  // APB21 and UART21 UVC21 sequences
  gpio_cfg_reg_seq21 gpio_cfg_dut_seq21;
  gpio_simple_trans_seq21 gpio_seq21;
  read_gpio_rx_reg21 rd_rx_reg21;
  ahb_to_gpio_wr21 raw_seq21;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq21", $psprintf("Number21 of AHB21->GPIO21 Transaction21 = %d", num_a2gpio_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Number21 of GPIO21->APB21 Transaction21 = %d", num_a2gpio_wr21), UVM_LOW)
    `uvm_info("vseq21", $psprintf("Total21 Number21 of AHB21, GPIO21 Transaction21 = %d", 2 * num_a2gpio_wr21), UVM_LOW)

    // configure SPI21 DUT
    gpio_cfg_dut_seq21 = gpio_cfg_reg_seq21::type_id::create("gpio_cfg_dut_seq21");
    gpio_cfg_dut_seq21.reg_model21 = p_sequencer.reg_model_ptr21.gpio_rf21;
    gpio_cfg_dut_seq21.start(null);


    for (int i = 0; i < num_a2gpio_wr21; i++) begin
      `uvm_do_on_with(raw_seq21, p_sequencer.ahb_seqr21, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq21, p_sequencer.gpio0_seqr21)
      `uvm_do_on_with(rd_rx_reg21, p_sequencer.ahb_seqr21, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq21

class apb_subsystem_vseq21 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq21",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq21)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)    

  // APB21 and UART21 UVC21 sequences
  u2a_incr_payload21 apb_to_uart21;
  apb_spi_incr_payload21 apb_to_spi21;
  apb_gpio_simple_vseq21 apb_to_gpio21;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq21", $psprintf("Doing apb_subsystem_vseq21"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart21)
      `uvm_do(apb_to_spi21)
      `uvm_do(apb_to_gpio21)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq21

class apb_ss_cms_seq21 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq21)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer21)

   function new(string name = "apb_ss_cms_seq21");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq21", $psprintf("Starting AHB21 Compliance21 Management21 System21 (CMS21)"), UVM_LOW)
//	   p_sequencer.ahb_seqr21.start_ahb_cms21();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq21
`endif
