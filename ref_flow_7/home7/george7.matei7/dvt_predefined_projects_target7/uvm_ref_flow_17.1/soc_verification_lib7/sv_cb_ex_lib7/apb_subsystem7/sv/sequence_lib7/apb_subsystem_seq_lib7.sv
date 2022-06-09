/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_seq_lib7.sv
Title7       : 
Project7     :
Created7     :
Description7 : This7 file implements7 APB7 Sequences7 specific7 to UART7 
            : CSR7 programming7 and Tx7/Rx7 FIFO write/read
Notes7       : The interrupt7 sequence in this file is not yet complete.
            : The interrupt7 sequence should be triggred7 by the Rx7 fifo 
            : full event from the UART7 RTL7.
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

// writes 0-150 data in UART7 TX7 FIFO
class ahb_to_uart_wr7 extends uvm_sequence #(ahb_transfer7);

    function new(string name="ahb_to_uart_wr7");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    rand bit unsigned[31:0] rand_data7;
    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH7-1:0] start_addr7;
    rand bit [`AHB_DATA_WIDTH7-1:0] write_data7;
    rand int unsigned num_of_wr7;
    constraint num_of_wr_ct7 { (num_of_wr7 <= 150); }

    virtual task body();
      start_addr7 = base_addr + `TX_FIFO_REG7;
      for (int i = 0; i < num_of_wr7; i++) begin
      write_data7 = write_data7 + i;
      `uvm_do_with(req, { req.address == start_addr7; req.data == write_data7; req.direction7 == WRITE; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
      end
    endtask
  
  function void post_randomize();
      write_data7 = rand_data7;
  endfunction
endclass : ahb_to_uart_wr7

// writes 0-150 data in SPI7 TX7 FIFO
class ahb_to_spi_wr7 extends uvm_sequence #(ahb_transfer7);

    function new(string name="ahb_to_spi_wr7");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    rand bit unsigned[31:0] rand_data7;
    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH7-1:0] start_addr7;
    rand bit [`AHB_DATA_WIDTH7-1:0] write_data7;
    rand int unsigned num_of_wr7;
    constraint num_of_wr_ct7 { (num_of_wr7 <= 150); }

    virtual task body();
      start_addr7 = base_addr + `SPI_TX0_REG7;
      for (int i = 0; i < num_of_wr7; i++) begin
      write_data7 = write_data7 + i;
      `uvm_do_with(req, { req.address == start_addr7; req.data == write_data7; req.direction7 == WRITE; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
      end
    endtask
  
  function void post_randomize();
      write_data7 = rand_data7;
  endfunction
endclass : ahb_to_spi_wr7

// writes 1 data in GPIO7 TX7 REG
class ahb_to_gpio_wr7 extends uvm_sequence #(ahb_transfer7);

    function new(string name="ahb_to_gpio_wr7");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    rand bit unsigned[31:0] rand_data7;
    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH7-1:0] start_addr7;
    rand bit [`AHB_DATA_WIDTH7-1:0] write_data7;

    virtual task body();
      start_addr7 = base_addr + `GPIO_OUTPUT_VALUE_REG7;
      `uvm_do_with(req, { req.address == start_addr7; req.data == write_data7; req.direction7 == WRITE; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
    endtask
  
  function void post_randomize();
      write_data7 = rand_data7;
  endfunction
endclass : ahb_to_gpio_wr7

// Low7 Power7 CPF7 test
class shutdown_dut7 extends uvm_sequence #(ahb_transfer7);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    function new(string name="shutdown_dut7");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH7-1:0] start_addr7;

    rand bit [`AHB_DATA_WIDTH7-1:0] write_data7;
    constraint uart_smc_shut7 { (write_data7 >= 1 && write_data7 <= 3); }

    virtual task body();
      start_addr7 = 32'h00860004;
      //write_data7 = 32'h01;

     if (write_data7 == 1)
      `uvm_info("SEQ", ("shutdown_dut7 sequence is shutting7 down UART7 "), UVM_MEDIUM)
     else if (write_data7 == 2) 
      `uvm_info("SEQ", ("shutdown_dut7 sequence is shutting7 down SMC7 "), UVM_MEDIUM)
     else if (write_data7 == 3) 
      `uvm_info("SEQ", ("shutdown_dut7 sequence is shutting7 down UART7 and SMC7 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr7; req.data == write_data7; req.direction7 == WRITE; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
    endtask
  
endclass :  shutdown_dut7

// Low7 Power7 CPF7 test
class poweron_dut7 extends uvm_sequence #(ahb_transfer7);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    function new(string name="poweron_dut7");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH7-1:0] start_addr7;
    bit [`AHB_DATA_WIDTH7-1:0] write_data7;

    virtual task body();
      start_addr7 = 32'h00860004;
      write_data7 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut7 sequence is switching7 on PDurt7"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr7; req.data == write_data7; req.direction7 == WRITE; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
    endtask
  
endclass : poweron_dut7

// Reads7 UART7 RX7 FIFO
class intrpt_seq7 extends uvm_sequence #(ahb_transfer7);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    function new(string name="intrpt_seq7");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH7-1:0] read_addr7;
    rand int unsigned num_of_rd7;
    constraint num_of_rd_ct7 { (num_of_rd7 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH7-1:0] read_data7;

      for (int i = 0; i < num_of_rd7; i++) begin
        read_addr7 = base_addr + `RX_FIFO_REG7;      //rx7 fifo address
        `uvm_do_with(req, { req.address == read_addr7; req.data == read_data7; req.direction7 == READ; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG7 DATA7 is `x%0h", read_data7), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq7

// Reads7 SPI7 RX7 REG
class read_spi_rx_reg7 extends uvm_sequence #(ahb_transfer7);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    function new(string name="read_spi_rx_reg7");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH7-1:0] read_addr7;
    rand int unsigned num_of_rd7;
    constraint num_of_rd_ct7 { (num_of_rd7 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH7-1:0] read_data7;

      for (int i = 0; i < num_of_rd7; i++) begin
        read_addr7 = base_addr + `SPI_RX0_REG7;
        `uvm_do_with(req, { req.address == read_addr7; req.data == read_data7; req.direction7 == READ; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
        `uvm_info("SEQ", $psprintf("Read DATA7 is `x%0h", read_data7), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg7

// Reads7 GPIO7 INPUT_VALUE7 REG
class read_gpio_rx_reg7 extends uvm_sequence #(ahb_transfer7);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg7)
    `uvm_declare_p_sequencer(ahb_pkg7::ahb_master_sequencer7)    

    function new(string name="read_gpio_rx_reg7");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH7-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH7-1:0] read_addr7;

    virtual task body();
      bit [`AHB_DATA_WIDTH7-1:0] read_data7;

      read_addr7 = base_addr + `GPIO_INPUT_VALUE_REG7;
      `uvm_do_with(req, { req.address == read_addr7; req.data == read_data7; req.direction7 == READ; req.burst == ahb_pkg7::SINGLE7; req.hsize7 == ahb_pkg7::WORD7;} )
      `uvm_info("SEQ", $psprintf("Read DATA7 is `x%0h", read_data7), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg7

