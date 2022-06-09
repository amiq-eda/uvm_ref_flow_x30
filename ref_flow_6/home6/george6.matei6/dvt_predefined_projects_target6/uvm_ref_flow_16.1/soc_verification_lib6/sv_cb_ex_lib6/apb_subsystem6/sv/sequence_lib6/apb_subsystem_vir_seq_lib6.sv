/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_vir_seq_lib6.sv
Title6       : Virtual Sequence
Project6     :
Created6     :
Description6 : This6 file implements6 the virtual sequence for the APB6-UART6 env6.
Notes6       : The concurrent_u2a_a2u_rand_trans6 sequence first configures6
            : the UART6 RTL6. Once6 the configuration sequence is completed
            : random read/write sequences from both the UVCs6 are enabled
            : in parallel6. At6 the end a Rx6 FIFO read sequence is executed6.
            : The intrpt_seq6 needs6 to be modified to take6 interrupt6 into account6.
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV6
`define APB_UART_VIRTUAL_SEQ_LIB_SV6

class u2a_incr_payload6 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr6;
  rand int unsigned num_a2u0_wr6;
  rand int unsigned num_u12a_wr6;
  rand int unsigned num_a2u1_wr6;

  function new(string name="u2a_incr_payload6",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)    

  constraint num_u02a_wr_ct6 {(num_u02a_wr6 > 2) && (num_u02a_wr6 <= 4);}
  constraint num_a2u0_wr_ct6 {(num_a2u0_wr6 == 1);}
  constraint num_u12a_wr_ct6 {(num_u12a_wr6 > 2) && (num_u12a_wr6 <= 4);}
  constraint num_a2u1_wr_ct6 {(num_a2u1_wr6 == 1);}

  // APB6 and UART6 UVC6 sequences
  uart_ctrl_config_reg_seq6 uart_cfg_dut_seq6;
  uart_incr_payload_seq6 uart_seq6;
  intrpt_seq6 rd_rx_fifo6;
  ahb_to_uart_wr6 raw_seq6;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq6", $psprintf("Number6 of APB6->UART06 Transaction6 = %d", num_a2u0_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Number6 of APB6->UART16 Transaction6 = %d", num_a2u1_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Number6 of UART06->APB6 Transaction6 = %d", num_u02a_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Number6 of UART16->APB6 Transaction6 = %d", num_u12a_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Total6 Number6 of AHB6, UART6 Transaction6 = %d", num_u02a_wr6 + num_a2u0_wr6 + num_u02a_wr6 + num_a2u0_wr6), UVM_LOW)

    // configure UART06 DUT
    uart_cfg_dut_seq6 = uart_ctrl_config_reg_seq6::type_id::create("uart_cfg_dut_seq6");
    uart_cfg_dut_seq6.reg_model6 = p_sequencer.reg_model_ptr6.uart0_rm6;
    uart_cfg_dut_seq6.start(null);


    // configure UART16 DUT
    uart_cfg_dut_seq6 = uart_ctrl_config_reg_seq6::type_id::create("uart_cfg_dut_seq6");
    uart_cfg_dut_seq6.reg_model6 = p_sequencer.reg_model_ptr6.uart1_rm6;
    uart_cfg_dut_seq6.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == num_a2u0_wr6; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == num_a2u1_wr6; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq6, p_sequencer.uart0_seqr6, {cnt == num_u02a_wr6;})
      `uvm_do_on_with(uart_seq6, p_sequencer.uart1_seqr6, {cnt == num_u12a_wr6;})
    join
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u02a_wr6; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u12a_wr6; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload6

// rand shutdown6 and power6-on
class on_off_seq6 extends uvm_sequence;
  `uvm_object_utils(on_off_seq6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)

  function new(string name = "on_off_seq6");
     super.new(name);
  endfunction

  shutdown_dut6 shut_dut6;
  poweron_dut6 power_dut6;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut6, p_sequencer.ahb_seqr6)
       #4000;
      `uvm_do_on(power_dut6, p_sequencer.ahb_seqr6)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq6


// shutdown6 and power6-on for uart16
class on_off_uart1_seq6 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)

  function new(string name = "on_off_uart1_seq6");
     super.new(name);
  endfunction

  shutdown_dut6 shut_dut6;
  poweron_dut6 power_dut6;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut6, p_sequencer.ahb_seqr6, {write_data6 == 1;})
        #4000;
      `uvm_do_on(power_dut6, p_sequencer.ahb_seqr6)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq6

// lp6 seq, configuration sequence
class lp_shutdown_config6 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr6;
  rand int unsigned num_a2u0_wr6;
  rand int unsigned num_u12a_wr6;
  rand int unsigned num_a2u1_wr6;

  function new(string name="lp_shutdown_config6",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)    

  constraint num_u02a_wr_ct6 {(num_u02a_wr6 > 2) && (num_u02a_wr6 <= 4);}
  constraint num_a2u0_wr_ct6 {(num_a2u0_wr6 == 1);}
  constraint num_u12a_wr_ct6 {(num_u12a_wr6 > 2) && (num_u12a_wr6 <= 4);}
  constraint num_a2u1_wr_ct6 {(num_a2u1_wr6 == 1);}

  // APB6 and UART6 UVC6 sequences
  uart_ctrl_config_reg_seq6 uart_cfg_dut_seq6;
  uart_incr_payload_seq6 uart_seq6;
  intrpt_seq6 rd_rx_fifo6;
  ahb_to_uart_wr6 raw_seq6;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq6", $psprintf("Number6 of APB6->UART06 Transaction6 = %d", num_a2u0_wr6), UVM_LOW);
    `uvm_info("vseq6", $psprintf("Number6 of APB6->UART16 Transaction6 = %d", num_a2u1_wr6), UVM_LOW);
    `uvm_info("vseq6", $psprintf("Number6 of UART06->APB6 Transaction6 = %d", num_u02a_wr6), UVM_LOW);
    `uvm_info("vseq6", $psprintf("Number6 of UART16->APB6 Transaction6 = %d", num_u12a_wr6), UVM_LOW);
    `uvm_info("vseq6", $psprintf("Total6 Number6 of AHB6, UART6 Transaction6 = %d", num_u02a_wr6 + num_a2u0_wr6 + num_u02a_wr6 + num_a2u0_wr6), UVM_LOW);

    // configure UART06 DUT
    uart_cfg_dut_seq6 = uart_ctrl_config_reg_seq6::type_id::create("uart_cfg_dut_seq6");
    uart_cfg_dut_seq6.reg_model6 = p_sequencer.reg_model_ptr6.uart0_rm6;
    uart_cfg_dut_seq6.start(null);


    // configure UART16 DUT
    uart_cfg_dut_seq6 = uart_ctrl_config_reg_seq6::type_id::create("uart_cfg_dut_seq6");
    uart_cfg_dut_seq6.reg_model6 = p_sequencer.reg_model_ptr6.uart1_rm6;
    uart_cfg_dut_seq6.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == num_a2u0_wr6; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == num_a2u1_wr6; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq6, p_sequencer.uart0_seqr6, {cnt == num_u02a_wr6;})
      `uvm_do_on_with(uart_seq6, p_sequencer.uart1_seqr6, {cnt == num_u12a_wr6;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u02a_wr6; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u12a_wr6; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == num_a2u0_wr6; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq6, p_sequencer.uart0_seqr6, {cnt == num_u02a_wr6;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config6

// rand lp6 shutdown6 seq between uart6 1 and smc6
class lp_shutdown_rand6 extends uvm_sequence;

  rand int unsigned num_u02a_wr6;
  rand int unsigned num_a2u0_wr6;
  rand int unsigned num_u12a_wr6;
  rand int unsigned num_a2u1_wr6;

  function new(string name="lp_shutdown_rand6",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)    

  constraint num_u02a_wr_ct6 {(num_u02a_wr6 > 2) && (num_u02a_wr6 <= 4);}
  constraint num_a2u0_wr_ct6 {(num_a2u0_wr6 == 1);}
  constraint num_u12a_wr_ct6 {(num_u12a_wr6 > 2) && (num_u12a_wr6 <= 4);}
  constraint num_a2u1_wr_ct6 {(num_a2u1_wr6 == 1);}


  on_off_seq6 on_off_seq6;
  uart_incr_payload_seq6 uart_seq6;
  intrpt_seq6 rd_rx_fifo6;
  ahb_to_uart_wr6 raw_seq6;
  lp_shutdown_config6 lp_shutdown_config6;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut6 down seq
    `uvm_do(lp_shutdown_config6);
    #20000;
    `uvm_do(on_off_seq6);

    #10000;
    fork
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == num_a2u1_wr6; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq6, p_sequencer.uart1_seqr6, {cnt == num_u12a_wr6;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u02a_wr6; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u12a_wr6; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand6


// sequence for shutting6 down uart6 1 alone6
class lp_shutdown_uart16 extends uvm_sequence;

  rand int unsigned num_u02a_wr6;
  rand int unsigned num_a2u0_wr6;
  rand int unsigned num_u12a_wr6;
  rand int unsigned num_a2u1_wr6;

  function new(string name="lp_shutdown_uart16",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart16)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)    

  constraint num_u02a_wr_ct6 {(num_u02a_wr6 > 2) && (num_u02a_wr6 <= 4);}
  constraint num_a2u0_wr_ct6 {(num_a2u0_wr6 == 1);}
  constraint num_u12a_wr_ct6 {(num_u12a_wr6 > 2) && (num_u12a_wr6 <= 4);}
  constraint num_a2u1_wr_ct6 {(num_a2u1_wr6 == 2);}


  on_off_uart1_seq6 on_off_uart1_seq6;
  uart_incr_payload_seq6 uart_seq6;
  intrpt_seq6 rd_rx_fifo6;
  ahb_to_uart_wr6 raw_seq6;
  lp_shutdown_config6 lp_shutdown_config6;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut6 down seq
    `uvm_do(lp_shutdown_config6);
    #20000;
    `uvm_do(on_off_uart1_seq6);

    #10000;
    fork
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == num_a2u1_wr6; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq6, p_sequencer.uart1_seqr6, {cnt == num_u12a_wr6;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u02a_wr6; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo6, p_sequencer.ahb_seqr6, {num_of_rd6 == num_u12a_wr6; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart16



class apb_spi_incr_payload6 extends uvm_sequence;

  rand int unsigned num_spi2a_wr6;
  rand int unsigned num_a2spi_wr6;

  function new(string name="apb_spi_incr_payload6",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)    

  constraint num_spi2a_wr_ct6 {(num_spi2a_wr6 > 2) && (num_spi2a_wr6 <= 4);}
  constraint num_a2spi_wr_ct6 {(num_a2spi_wr6 == 4);}

  // APB6 and UART6 UVC6 sequences
  spi_cfg_reg_seq6 spi_cfg_dut_seq6;
  spi_incr_payload6 spi_seq6;
  read_spi_rx_reg6 rd_rx_reg6;
  ahb_to_spi_wr6 raw_seq6;
  spi_en_tx_reg_seq6 en_spi_tx_seq6;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq6", $psprintf("Number6 of APB6->SPI6 Transaction6 = %d", num_a2spi_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Number6 of SPI6->APB6 Transaction6 = %d", num_a2spi_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Total6 Number6 of AHB6, SPI6 Transaction6 = %d", 2 * num_a2spi_wr6), UVM_LOW)

    // configure SPI6 DUT
    spi_cfg_dut_seq6 = spi_cfg_reg_seq6::type_id::create("spi_cfg_dut_seq6");
    spi_cfg_dut_seq6.reg_model6 = p_sequencer.reg_model_ptr6.spi_rf6;
    spi_cfg_dut_seq6.start(null);


    for (int i = 0; i < num_a2spi_wr6; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {num_of_wr6 == 1; base_addr == 'h800000;})
            en_spi_tx_seq6 = spi_en_tx_reg_seq6::type_id::create("en_spi_tx_seq6");
            en_spi_tx_seq6.reg_model6 = p_sequencer.reg_model_ptr6.spi_rf6;
            en_spi_tx_seq6.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq6, p_sequencer.spi0_seqr6, {cnt_i6 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg6, p_sequencer.ahb_seqr6, {num_of_rd6 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload6

class apb_gpio_simple_vseq6 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr6;

  function new(string name="apb_gpio_simple_vseq6",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)    

  constraint num_a2gpio_wr_ct6 {(num_a2gpio_wr6 == 4);}

  // APB6 and UART6 UVC6 sequences
  gpio_cfg_reg_seq6 gpio_cfg_dut_seq6;
  gpio_simple_trans_seq6 gpio_seq6;
  read_gpio_rx_reg6 rd_rx_reg6;
  ahb_to_gpio_wr6 raw_seq6;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq6", $psprintf("Number6 of AHB6->GPIO6 Transaction6 = %d", num_a2gpio_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Number6 of GPIO6->APB6 Transaction6 = %d", num_a2gpio_wr6), UVM_LOW)
    `uvm_info("vseq6", $psprintf("Total6 Number6 of AHB6, GPIO6 Transaction6 = %d", 2 * num_a2gpio_wr6), UVM_LOW)

    // configure SPI6 DUT
    gpio_cfg_dut_seq6 = gpio_cfg_reg_seq6::type_id::create("gpio_cfg_dut_seq6");
    gpio_cfg_dut_seq6.reg_model6 = p_sequencer.reg_model_ptr6.gpio_rf6;
    gpio_cfg_dut_seq6.start(null);


    for (int i = 0; i < num_a2gpio_wr6; i++) begin
      `uvm_do_on_with(raw_seq6, p_sequencer.ahb_seqr6, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq6, p_sequencer.gpio0_seqr6)
      `uvm_do_on_with(rd_rx_reg6, p_sequencer.ahb_seqr6, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq6

class apb_subsystem_vseq6 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq6",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq6)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)    

  // APB6 and UART6 UVC6 sequences
  u2a_incr_payload6 apb_to_uart6;
  apb_spi_incr_payload6 apb_to_spi6;
  apb_gpio_simple_vseq6 apb_to_gpio6;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq6", $psprintf("Doing apb_subsystem_vseq6"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart6)
      `uvm_do(apb_to_spi6)
      `uvm_do(apb_to_gpio6)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq6

class apb_ss_cms_seq6 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq6)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer6)

   function new(string name = "apb_ss_cms_seq6");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq6", $psprintf("Starting AHB6 Compliance6 Management6 System6 (CMS6)"), UVM_LOW)
//	   p_sequencer.ahb_seqr6.start_ahb_cms6();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq6
`endif
