/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_vir_seq_lib17.sv
Title17       : Virtual Sequence
Project17     :
Created17     :
Description17 : This17 file implements17 the virtual sequence for the APB17-UART17 env17.
Notes17       : The concurrent_u2a_a2u_rand_trans17 sequence first configures17
            : the UART17 RTL17. Once17 the configuration sequence is completed
            : random read/write sequences from both the UVCs17 are enabled
            : in parallel17. At17 the end a Rx17 FIFO read sequence is executed17.
            : The intrpt_seq17 needs17 to be modified to take17 interrupt17 into account17.
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV17
`define APB_UART_VIRTUAL_SEQ_LIB_SV17

class u2a_incr_payload17 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr17;
  rand int unsigned num_a2u0_wr17;
  rand int unsigned num_u12a_wr17;
  rand int unsigned num_a2u1_wr17;

  function new(string name="u2a_incr_payload17",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)    

  constraint num_u02a_wr_ct17 {(num_u02a_wr17 > 2) && (num_u02a_wr17 <= 4);}
  constraint num_a2u0_wr_ct17 {(num_a2u0_wr17 == 1);}
  constraint num_u12a_wr_ct17 {(num_u12a_wr17 > 2) && (num_u12a_wr17 <= 4);}
  constraint num_a2u1_wr_ct17 {(num_a2u1_wr17 == 1);}

  // APB17 and UART17 UVC17 sequences
  uart_ctrl_config_reg_seq17 uart_cfg_dut_seq17;
  uart_incr_payload_seq17 uart_seq17;
  intrpt_seq17 rd_rx_fifo17;
  ahb_to_uart_wr17 raw_seq17;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq17", $psprintf("Number17 of APB17->UART017 Transaction17 = %d", num_a2u0_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Number17 of APB17->UART117 Transaction17 = %d", num_a2u1_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Number17 of UART017->APB17 Transaction17 = %d", num_u02a_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Number17 of UART117->APB17 Transaction17 = %d", num_u12a_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Total17 Number17 of AHB17, UART17 Transaction17 = %d", num_u02a_wr17 + num_a2u0_wr17 + num_u02a_wr17 + num_a2u0_wr17), UVM_LOW)

    // configure UART017 DUT
    uart_cfg_dut_seq17 = uart_ctrl_config_reg_seq17::type_id::create("uart_cfg_dut_seq17");
    uart_cfg_dut_seq17.reg_model17 = p_sequencer.reg_model_ptr17.uart0_rm17;
    uart_cfg_dut_seq17.start(null);


    // configure UART117 DUT
    uart_cfg_dut_seq17 = uart_ctrl_config_reg_seq17::type_id::create("uart_cfg_dut_seq17");
    uart_cfg_dut_seq17.reg_model17 = p_sequencer.reg_model_ptr17.uart1_rm17;
    uart_cfg_dut_seq17.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == num_a2u0_wr17; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == num_a2u1_wr17; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq17, p_sequencer.uart0_seqr17, {cnt == num_u02a_wr17;})
      `uvm_do_on_with(uart_seq17, p_sequencer.uart1_seqr17, {cnt == num_u12a_wr17;})
    join
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u02a_wr17; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u12a_wr17; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload17

// rand shutdown17 and power17-on
class on_off_seq17 extends uvm_sequence;
  `uvm_object_utils(on_off_seq17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)

  function new(string name = "on_off_seq17");
     super.new(name);
  endfunction

  shutdown_dut17 shut_dut17;
  poweron_dut17 power_dut17;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut17, p_sequencer.ahb_seqr17)
       #4000;
      `uvm_do_on(power_dut17, p_sequencer.ahb_seqr17)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq17


// shutdown17 and power17-on for uart117
class on_off_uart1_seq17 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)

  function new(string name = "on_off_uart1_seq17");
     super.new(name);
  endfunction

  shutdown_dut17 shut_dut17;
  poweron_dut17 power_dut17;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut17, p_sequencer.ahb_seqr17, {write_data17 == 1;})
        #4000;
      `uvm_do_on(power_dut17, p_sequencer.ahb_seqr17)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq17

// lp17 seq, configuration sequence
class lp_shutdown_config17 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr17;
  rand int unsigned num_a2u0_wr17;
  rand int unsigned num_u12a_wr17;
  rand int unsigned num_a2u1_wr17;

  function new(string name="lp_shutdown_config17",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)    

  constraint num_u02a_wr_ct17 {(num_u02a_wr17 > 2) && (num_u02a_wr17 <= 4);}
  constraint num_a2u0_wr_ct17 {(num_a2u0_wr17 == 1);}
  constraint num_u12a_wr_ct17 {(num_u12a_wr17 > 2) && (num_u12a_wr17 <= 4);}
  constraint num_a2u1_wr_ct17 {(num_a2u1_wr17 == 1);}

  // APB17 and UART17 UVC17 sequences
  uart_ctrl_config_reg_seq17 uart_cfg_dut_seq17;
  uart_incr_payload_seq17 uart_seq17;
  intrpt_seq17 rd_rx_fifo17;
  ahb_to_uart_wr17 raw_seq17;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq17", $psprintf("Number17 of APB17->UART017 Transaction17 = %d", num_a2u0_wr17), UVM_LOW);
    `uvm_info("vseq17", $psprintf("Number17 of APB17->UART117 Transaction17 = %d", num_a2u1_wr17), UVM_LOW);
    `uvm_info("vseq17", $psprintf("Number17 of UART017->APB17 Transaction17 = %d", num_u02a_wr17), UVM_LOW);
    `uvm_info("vseq17", $psprintf("Number17 of UART117->APB17 Transaction17 = %d", num_u12a_wr17), UVM_LOW);
    `uvm_info("vseq17", $psprintf("Total17 Number17 of AHB17, UART17 Transaction17 = %d", num_u02a_wr17 + num_a2u0_wr17 + num_u02a_wr17 + num_a2u0_wr17), UVM_LOW);

    // configure UART017 DUT
    uart_cfg_dut_seq17 = uart_ctrl_config_reg_seq17::type_id::create("uart_cfg_dut_seq17");
    uart_cfg_dut_seq17.reg_model17 = p_sequencer.reg_model_ptr17.uart0_rm17;
    uart_cfg_dut_seq17.start(null);


    // configure UART117 DUT
    uart_cfg_dut_seq17 = uart_ctrl_config_reg_seq17::type_id::create("uart_cfg_dut_seq17");
    uart_cfg_dut_seq17.reg_model17 = p_sequencer.reg_model_ptr17.uart1_rm17;
    uart_cfg_dut_seq17.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == num_a2u0_wr17; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == num_a2u1_wr17; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq17, p_sequencer.uart0_seqr17, {cnt == num_u02a_wr17;})
      `uvm_do_on_with(uart_seq17, p_sequencer.uart1_seqr17, {cnt == num_u12a_wr17;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u02a_wr17; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u12a_wr17; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == num_a2u0_wr17; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq17, p_sequencer.uart0_seqr17, {cnt == num_u02a_wr17;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config17

// rand lp17 shutdown17 seq between uart17 1 and smc17
class lp_shutdown_rand17 extends uvm_sequence;

  rand int unsigned num_u02a_wr17;
  rand int unsigned num_a2u0_wr17;
  rand int unsigned num_u12a_wr17;
  rand int unsigned num_a2u1_wr17;

  function new(string name="lp_shutdown_rand17",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)    

  constraint num_u02a_wr_ct17 {(num_u02a_wr17 > 2) && (num_u02a_wr17 <= 4);}
  constraint num_a2u0_wr_ct17 {(num_a2u0_wr17 == 1);}
  constraint num_u12a_wr_ct17 {(num_u12a_wr17 > 2) && (num_u12a_wr17 <= 4);}
  constraint num_a2u1_wr_ct17 {(num_a2u1_wr17 == 1);}


  on_off_seq17 on_off_seq17;
  uart_incr_payload_seq17 uart_seq17;
  intrpt_seq17 rd_rx_fifo17;
  ahb_to_uart_wr17 raw_seq17;
  lp_shutdown_config17 lp_shutdown_config17;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut17 down seq
    `uvm_do(lp_shutdown_config17);
    #20000;
    `uvm_do(on_off_seq17);

    #10000;
    fork
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == num_a2u1_wr17; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq17, p_sequencer.uart1_seqr17, {cnt == num_u12a_wr17;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u02a_wr17; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u12a_wr17; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand17


// sequence for shutting17 down uart17 1 alone17
class lp_shutdown_uart117 extends uvm_sequence;

  rand int unsigned num_u02a_wr17;
  rand int unsigned num_a2u0_wr17;
  rand int unsigned num_u12a_wr17;
  rand int unsigned num_a2u1_wr17;

  function new(string name="lp_shutdown_uart117",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart117)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)    

  constraint num_u02a_wr_ct17 {(num_u02a_wr17 > 2) && (num_u02a_wr17 <= 4);}
  constraint num_a2u0_wr_ct17 {(num_a2u0_wr17 == 1);}
  constraint num_u12a_wr_ct17 {(num_u12a_wr17 > 2) && (num_u12a_wr17 <= 4);}
  constraint num_a2u1_wr_ct17 {(num_a2u1_wr17 == 2);}


  on_off_uart1_seq17 on_off_uart1_seq17;
  uart_incr_payload_seq17 uart_seq17;
  intrpt_seq17 rd_rx_fifo17;
  ahb_to_uart_wr17 raw_seq17;
  lp_shutdown_config17 lp_shutdown_config17;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut17 down seq
    `uvm_do(lp_shutdown_config17);
    #20000;
    `uvm_do(on_off_uart1_seq17);

    #10000;
    fork
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == num_a2u1_wr17; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq17, p_sequencer.uart1_seqr17, {cnt == num_u12a_wr17;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u02a_wr17; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo17, p_sequencer.ahb_seqr17, {num_of_rd17 == num_u12a_wr17; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart117



class apb_spi_incr_payload17 extends uvm_sequence;

  rand int unsigned num_spi2a_wr17;
  rand int unsigned num_a2spi_wr17;

  function new(string name="apb_spi_incr_payload17",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)    

  constraint num_spi2a_wr_ct17 {(num_spi2a_wr17 > 2) && (num_spi2a_wr17 <= 4);}
  constraint num_a2spi_wr_ct17 {(num_a2spi_wr17 == 4);}

  // APB17 and UART17 UVC17 sequences
  spi_cfg_reg_seq17 spi_cfg_dut_seq17;
  spi_incr_payload17 spi_seq17;
  read_spi_rx_reg17 rd_rx_reg17;
  ahb_to_spi_wr17 raw_seq17;
  spi_en_tx_reg_seq17 en_spi_tx_seq17;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq17", $psprintf("Number17 of APB17->SPI17 Transaction17 = %d", num_a2spi_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Number17 of SPI17->APB17 Transaction17 = %d", num_a2spi_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Total17 Number17 of AHB17, SPI17 Transaction17 = %d", 2 * num_a2spi_wr17), UVM_LOW)

    // configure SPI17 DUT
    spi_cfg_dut_seq17 = spi_cfg_reg_seq17::type_id::create("spi_cfg_dut_seq17");
    spi_cfg_dut_seq17.reg_model17 = p_sequencer.reg_model_ptr17.spi_rf17;
    spi_cfg_dut_seq17.start(null);


    for (int i = 0; i < num_a2spi_wr17; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {num_of_wr17 == 1; base_addr == 'h800000;})
            en_spi_tx_seq17 = spi_en_tx_reg_seq17::type_id::create("en_spi_tx_seq17");
            en_spi_tx_seq17.reg_model17 = p_sequencer.reg_model_ptr17.spi_rf17;
            en_spi_tx_seq17.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq17, p_sequencer.spi0_seqr17, {cnt_i17 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg17, p_sequencer.ahb_seqr17, {num_of_rd17 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload17

class apb_gpio_simple_vseq17 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr17;

  function new(string name="apb_gpio_simple_vseq17",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)    

  constraint num_a2gpio_wr_ct17 {(num_a2gpio_wr17 == 4);}

  // APB17 and UART17 UVC17 sequences
  gpio_cfg_reg_seq17 gpio_cfg_dut_seq17;
  gpio_simple_trans_seq17 gpio_seq17;
  read_gpio_rx_reg17 rd_rx_reg17;
  ahb_to_gpio_wr17 raw_seq17;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq17", $psprintf("Number17 of AHB17->GPIO17 Transaction17 = %d", num_a2gpio_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Number17 of GPIO17->APB17 Transaction17 = %d", num_a2gpio_wr17), UVM_LOW)
    `uvm_info("vseq17", $psprintf("Total17 Number17 of AHB17, GPIO17 Transaction17 = %d", 2 * num_a2gpio_wr17), UVM_LOW)

    // configure SPI17 DUT
    gpio_cfg_dut_seq17 = gpio_cfg_reg_seq17::type_id::create("gpio_cfg_dut_seq17");
    gpio_cfg_dut_seq17.reg_model17 = p_sequencer.reg_model_ptr17.gpio_rf17;
    gpio_cfg_dut_seq17.start(null);


    for (int i = 0; i < num_a2gpio_wr17; i++) begin
      `uvm_do_on_with(raw_seq17, p_sequencer.ahb_seqr17, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq17, p_sequencer.gpio0_seqr17)
      `uvm_do_on_with(rd_rx_reg17, p_sequencer.ahb_seqr17, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq17

class apb_subsystem_vseq17 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq17",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)    

  // APB17 and UART17 UVC17 sequences
  u2a_incr_payload17 apb_to_uart17;
  apb_spi_incr_payload17 apb_to_spi17;
  apb_gpio_simple_vseq17 apb_to_gpio17;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq17", $psprintf("Doing apb_subsystem_vseq17"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart17)
      `uvm_do(apb_to_spi17)
      `uvm_do(apb_to_gpio17)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq17

class apb_ss_cms_seq17 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq17)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer17)

   function new(string name = "apb_ss_cms_seq17");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq17", $psprintf("Starting AHB17 Compliance17 Management17 System17 (CMS17)"), UVM_LOW)
//	   p_sequencer.ahb_seqr17.start_ahb_cms17();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq17
`endif
