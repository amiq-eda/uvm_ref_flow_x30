/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_vir_seq_lib28.sv
Title28       : Virtual Sequence
Project28     :
Created28     :
Description28 : This28 file implements28 the virtual sequence for the APB28-UART28 env28.
Notes28       : The concurrent_u2a_a2u_rand_trans28 sequence first configures28
            : the UART28 RTL28. Once28 the configuration sequence is completed
            : random read/write sequences from both the UVCs28 are enabled
            : in parallel28. At28 the end a Rx28 FIFO read sequence is executed28.
            : The intrpt_seq28 needs28 to be modified to take28 interrupt28 into account28.
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV28
`define APB_UART_VIRTUAL_SEQ_LIB_SV28

class u2a_incr_payload28 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr28;
  rand int unsigned num_a2u0_wr28;
  rand int unsigned num_u12a_wr28;
  rand int unsigned num_a2u1_wr28;

  function new(string name="u2a_incr_payload28",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)    

  constraint num_u02a_wr_ct28 {(num_u02a_wr28 > 2) && (num_u02a_wr28 <= 4);}
  constraint num_a2u0_wr_ct28 {(num_a2u0_wr28 == 1);}
  constraint num_u12a_wr_ct28 {(num_u12a_wr28 > 2) && (num_u12a_wr28 <= 4);}
  constraint num_a2u1_wr_ct28 {(num_a2u1_wr28 == 1);}

  // APB28 and UART28 UVC28 sequences
  uart_ctrl_config_reg_seq28 uart_cfg_dut_seq28;
  uart_incr_payload_seq28 uart_seq28;
  intrpt_seq28 rd_rx_fifo28;
  ahb_to_uart_wr28 raw_seq28;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq28", $psprintf("Number28 of APB28->UART028 Transaction28 = %d", num_a2u0_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Number28 of APB28->UART128 Transaction28 = %d", num_a2u1_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Number28 of UART028->APB28 Transaction28 = %d", num_u02a_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Number28 of UART128->APB28 Transaction28 = %d", num_u12a_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Total28 Number28 of AHB28, UART28 Transaction28 = %d", num_u02a_wr28 + num_a2u0_wr28 + num_u02a_wr28 + num_a2u0_wr28), UVM_LOW)

    // configure UART028 DUT
    uart_cfg_dut_seq28 = uart_ctrl_config_reg_seq28::type_id::create("uart_cfg_dut_seq28");
    uart_cfg_dut_seq28.reg_model28 = p_sequencer.reg_model_ptr28.uart0_rm28;
    uart_cfg_dut_seq28.start(null);


    // configure UART128 DUT
    uart_cfg_dut_seq28 = uart_ctrl_config_reg_seq28::type_id::create("uart_cfg_dut_seq28");
    uart_cfg_dut_seq28.reg_model28 = p_sequencer.reg_model_ptr28.uart1_rm28;
    uart_cfg_dut_seq28.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == num_a2u0_wr28; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == num_a2u1_wr28; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq28, p_sequencer.uart0_seqr28, {cnt == num_u02a_wr28;})
      `uvm_do_on_with(uart_seq28, p_sequencer.uart1_seqr28, {cnt == num_u12a_wr28;})
    join
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u02a_wr28; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u12a_wr28; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload28

// rand shutdown28 and power28-on
class on_off_seq28 extends uvm_sequence;
  `uvm_object_utils(on_off_seq28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)

  function new(string name = "on_off_seq28");
     super.new(name);
  endfunction

  shutdown_dut28 shut_dut28;
  poweron_dut28 power_dut28;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut28, p_sequencer.ahb_seqr28)
       #4000;
      `uvm_do_on(power_dut28, p_sequencer.ahb_seqr28)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq28


// shutdown28 and power28-on for uart128
class on_off_uart1_seq28 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)

  function new(string name = "on_off_uart1_seq28");
     super.new(name);
  endfunction

  shutdown_dut28 shut_dut28;
  poweron_dut28 power_dut28;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut28, p_sequencer.ahb_seqr28, {write_data28 == 1;})
        #4000;
      `uvm_do_on(power_dut28, p_sequencer.ahb_seqr28)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq28

// lp28 seq, configuration sequence
class lp_shutdown_config28 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr28;
  rand int unsigned num_a2u0_wr28;
  rand int unsigned num_u12a_wr28;
  rand int unsigned num_a2u1_wr28;

  function new(string name="lp_shutdown_config28",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)    

  constraint num_u02a_wr_ct28 {(num_u02a_wr28 > 2) && (num_u02a_wr28 <= 4);}
  constraint num_a2u0_wr_ct28 {(num_a2u0_wr28 == 1);}
  constraint num_u12a_wr_ct28 {(num_u12a_wr28 > 2) && (num_u12a_wr28 <= 4);}
  constraint num_a2u1_wr_ct28 {(num_a2u1_wr28 == 1);}

  // APB28 and UART28 UVC28 sequences
  uart_ctrl_config_reg_seq28 uart_cfg_dut_seq28;
  uart_incr_payload_seq28 uart_seq28;
  intrpt_seq28 rd_rx_fifo28;
  ahb_to_uart_wr28 raw_seq28;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq28", $psprintf("Number28 of APB28->UART028 Transaction28 = %d", num_a2u0_wr28), UVM_LOW);
    `uvm_info("vseq28", $psprintf("Number28 of APB28->UART128 Transaction28 = %d", num_a2u1_wr28), UVM_LOW);
    `uvm_info("vseq28", $psprintf("Number28 of UART028->APB28 Transaction28 = %d", num_u02a_wr28), UVM_LOW);
    `uvm_info("vseq28", $psprintf("Number28 of UART128->APB28 Transaction28 = %d", num_u12a_wr28), UVM_LOW);
    `uvm_info("vseq28", $psprintf("Total28 Number28 of AHB28, UART28 Transaction28 = %d", num_u02a_wr28 + num_a2u0_wr28 + num_u02a_wr28 + num_a2u0_wr28), UVM_LOW);

    // configure UART028 DUT
    uart_cfg_dut_seq28 = uart_ctrl_config_reg_seq28::type_id::create("uart_cfg_dut_seq28");
    uart_cfg_dut_seq28.reg_model28 = p_sequencer.reg_model_ptr28.uart0_rm28;
    uart_cfg_dut_seq28.start(null);


    // configure UART128 DUT
    uart_cfg_dut_seq28 = uart_ctrl_config_reg_seq28::type_id::create("uart_cfg_dut_seq28");
    uart_cfg_dut_seq28.reg_model28 = p_sequencer.reg_model_ptr28.uart1_rm28;
    uart_cfg_dut_seq28.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == num_a2u0_wr28; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == num_a2u1_wr28; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq28, p_sequencer.uart0_seqr28, {cnt == num_u02a_wr28;})
      `uvm_do_on_with(uart_seq28, p_sequencer.uart1_seqr28, {cnt == num_u12a_wr28;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u02a_wr28; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u12a_wr28; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == num_a2u0_wr28; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq28, p_sequencer.uart0_seqr28, {cnt == num_u02a_wr28;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config28

// rand lp28 shutdown28 seq between uart28 1 and smc28
class lp_shutdown_rand28 extends uvm_sequence;

  rand int unsigned num_u02a_wr28;
  rand int unsigned num_a2u0_wr28;
  rand int unsigned num_u12a_wr28;
  rand int unsigned num_a2u1_wr28;

  function new(string name="lp_shutdown_rand28",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)    

  constraint num_u02a_wr_ct28 {(num_u02a_wr28 > 2) && (num_u02a_wr28 <= 4);}
  constraint num_a2u0_wr_ct28 {(num_a2u0_wr28 == 1);}
  constraint num_u12a_wr_ct28 {(num_u12a_wr28 > 2) && (num_u12a_wr28 <= 4);}
  constraint num_a2u1_wr_ct28 {(num_a2u1_wr28 == 1);}


  on_off_seq28 on_off_seq28;
  uart_incr_payload_seq28 uart_seq28;
  intrpt_seq28 rd_rx_fifo28;
  ahb_to_uart_wr28 raw_seq28;
  lp_shutdown_config28 lp_shutdown_config28;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut28 down seq
    `uvm_do(lp_shutdown_config28);
    #20000;
    `uvm_do(on_off_seq28);

    #10000;
    fork
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == num_a2u1_wr28; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq28, p_sequencer.uart1_seqr28, {cnt == num_u12a_wr28;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u02a_wr28; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u12a_wr28; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand28


// sequence for shutting28 down uart28 1 alone28
class lp_shutdown_uart128 extends uvm_sequence;

  rand int unsigned num_u02a_wr28;
  rand int unsigned num_a2u0_wr28;
  rand int unsigned num_u12a_wr28;
  rand int unsigned num_a2u1_wr28;

  function new(string name="lp_shutdown_uart128",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart128)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)    

  constraint num_u02a_wr_ct28 {(num_u02a_wr28 > 2) && (num_u02a_wr28 <= 4);}
  constraint num_a2u0_wr_ct28 {(num_a2u0_wr28 == 1);}
  constraint num_u12a_wr_ct28 {(num_u12a_wr28 > 2) && (num_u12a_wr28 <= 4);}
  constraint num_a2u1_wr_ct28 {(num_a2u1_wr28 == 2);}


  on_off_uart1_seq28 on_off_uart1_seq28;
  uart_incr_payload_seq28 uart_seq28;
  intrpt_seq28 rd_rx_fifo28;
  ahb_to_uart_wr28 raw_seq28;
  lp_shutdown_config28 lp_shutdown_config28;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut28 down seq
    `uvm_do(lp_shutdown_config28);
    #20000;
    `uvm_do(on_off_uart1_seq28);

    #10000;
    fork
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == num_a2u1_wr28; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq28, p_sequencer.uart1_seqr28, {cnt == num_u12a_wr28;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u02a_wr28; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo28, p_sequencer.ahb_seqr28, {num_of_rd28 == num_u12a_wr28; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart128



class apb_spi_incr_payload28 extends uvm_sequence;

  rand int unsigned num_spi2a_wr28;
  rand int unsigned num_a2spi_wr28;

  function new(string name="apb_spi_incr_payload28",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)    

  constraint num_spi2a_wr_ct28 {(num_spi2a_wr28 > 2) && (num_spi2a_wr28 <= 4);}
  constraint num_a2spi_wr_ct28 {(num_a2spi_wr28 == 4);}

  // APB28 and UART28 UVC28 sequences
  spi_cfg_reg_seq28 spi_cfg_dut_seq28;
  spi_incr_payload28 spi_seq28;
  read_spi_rx_reg28 rd_rx_reg28;
  ahb_to_spi_wr28 raw_seq28;
  spi_en_tx_reg_seq28 en_spi_tx_seq28;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq28", $psprintf("Number28 of APB28->SPI28 Transaction28 = %d", num_a2spi_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Number28 of SPI28->APB28 Transaction28 = %d", num_a2spi_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Total28 Number28 of AHB28, SPI28 Transaction28 = %d", 2 * num_a2spi_wr28), UVM_LOW)

    // configure SPI28 DUT
    spi_cfg_dut_seq28 = spi_cfg_reg_seq28::type_id::create("spi_cfg_dut_seq28");
    spi_cfg_dut_seq28.reg_model28 = p_sequencer.reg_model_ptr28.spi_rf28;
    spi_cfg_dut_seq28.start(null);


    for (int i = 0; i < num_a2spi_wr28; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {num_of_wr28 == 1; base_addr == 'h800000;})
            en_spi_tx_seq28 = spi_en_tx_reg_seq28::type_id::create("en_spi_tx_seq28");
            en_spi_tx_seq28.reg_model28 = p_sequencer.reg_model_ptr28.spi_rf28;
            en_spi_tx_seq28.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq28, p_sequencer.spi0_seqr28, {cnt_i28 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg28, p_sequencer.ahb_seqr28, {num_of_rd28 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload28

class apb_gpio_simple_vseq28 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr28;

  function new(string name="apb_gpio_simple_vseq28",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)    

  constraint num_a2gpio_wr_ct28 {(num_a2gpio_wr28 == 4);}

  // APB28 and UART28 UVC28 sequences
  gpio_cfg_reg_seq28 gpio_cfg_dut_seq28;
  gpio_simple_trans_seq28 gpio_seq28;
  read_gpio_rx_reg28 rd_rx_reg28;
  ahb_to_gpio_wr28 raw_seq28;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq28", $psprintf("Number28 of AHB28->GPIO28 Transaction28 = %d", num_a2gpio_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Number28 of GPIO28->APB28 Transaction28 = %d", num_a2gpio_wr28), UVM_LOW)
    `uvm_info("vseq28", $psprintf("Total28 Number28 of AHB28, GPIO28 Transaction28 = %d", 2 * num_a2gpio_wr28), UVM_LOW)

    // configure SPI28 DUT
    gpio_cfg_dut_seq28 = gpio_cfg_reg_seq28::type_id::create("gpio_cfg_dut_seq28");
    gpio_cfg_dut_seq28.reg_model28 = p_sequencer.reg_model_ptr28.gpio_rf28;
    gpio_cfg_dut_seq28.start(null);


    for (int i = 0; i < num_a2gpio_wr28; i++) begin
      `uvm_do_on_with(raw_seq28, p_sequencer.ahb_seqr28, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq28, p_sequencer.gpio0_seqr28)
      `uvm_do_on_with(rd_rx_reg28, p_sequencer.ahb_seqr28, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq28

class apb_subsystem_vseq28 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq28",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq28)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)    

  // APB28 and UART28 UVC28 sequences
  u2a_incr_payload28 apb_to_uart28;
  apb_spi_incr_payload28 apb_to_spi28;
  apb_gpio_simple_vseq28 apb_to_gpio28;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq28", $psprintf("Doing apb_subsystem_vseq28"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart28)
      `uvm_do(apb_to_spi28)
      `uvm_do(apb_to_gpio28)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq28

class apb_ss_cms_seq28 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq28)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer28)

   function new(string name = "apb_ss_cms_seq28");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq28", $psprintf("Starting AHB28 Compliance28 Management28 System28 (CMS28)"), UVM_LOW)
//	   p_sequencer.ahb_seqr28.start_ahb_cms28();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq28
`endif
