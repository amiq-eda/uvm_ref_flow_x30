/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_seq_lib25.sv
Title25       : 
Project25     :
Created25     :
Description25 : This25 file implements25 APB25 Sequences25 specific25 to UART25 
            : CSR25 programming25 and Tx25/Rx25 FIFO write/read
Notes25       : The interrupt25 sequence in this file is not yet complete.
            : The interrupt25 sequence should be triggred25 by the Rx25 fifo 
            : full event from the UART25 RTL25.
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

// writes 0-150 data in UART25 TX25 FIFO
class ahb_to_uart_wr25 extends uvm_sequence #(ahb_transfer25);

    function new(string name="ahb_to_uart_wr25");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    rand bit unsigned[31:0] rand_data25;
    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH25-1:0] start_addr25;
    rand bit [`AHB_DATA_WIDTH25-1:0] write_data25;
    rand int unsigned num_of_wr25;
    constraint num_of_wr_ct25 { (num_of_wr25 <= 150); }

    virtual task body();
      start_addr25 = base_addr + `TX_FIFO_REG25;
      for (int i = 0; i < num_of_wr25; i++) begin
      write_data25 = write_data25 + i;
      `uvm_do_with(req, { req.address == start_addr25; req.data == write_data25; req.direction25 == WRITE; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
      end
    endtask
  
  function void post_randomize();
      write_data25 = rand_data25;
  endfunction
endclass : ahb_to_uart_wr25

// writes 0-150 data in SPI25 TX25 FIFO
class ahb_to_spi_wr25 extends uvm_sequence #(ahb_transfer25);

    function new(string name="ahb_to_spi_wr25");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    rand bit unsigned[31:0] rand_data25;
    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH25-1:0] start_addr25;
    rand bit [`AHB_DATA_WIDTH25-1:0] write_data25;
    rand int unsigned num_of_wr25;
    constraint num_of_wr_ct25 { (num_of_wr25 <= 150); }

    virtual task body();
      start_addr25 = base_addr + `SPI_TX0_REG25;
      for (int i = 0; i < num_of_wr25; i++) begin
      write_data25 = write_data25 + i;
      `uvm_do_with(req, { req.address == start_addr25; req.data == write_data25; req.direction25 == WRITE; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
      end
    endtask
  
  function void post_randomize();
      write_data25 = rand_data25;
  endfunction
endclass : ahb_to_spi_wr25

// writes 1 data in GPIO25 TX25 REG
class ahb_to_gpio_wr25 extends uvm_sequence #(ahb_transfer25);

    function new(string name="ahb_to_gpio_wr25");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    rand bit unsigned[31:0] rand_data25;
    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH25-1:0] start_addr25;
    rand bit [`AHB_DATA_WIDTH25-1:0] write_data25;

    virtual task body();
      start_addr25 = base_addr + `GPIO_OUTPUT_VALUE_REG25;
      `uvm_do_with(req, { req.address == start_addr25; req.data == write_data25; req.direction25 == WRITE; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
    endtask
  
  function void post_randomize();
      write_data25 = rand_data25;
  endfunction
endclass : ahb_to_gpio_wr25

// Low25 Power25 CPF25 test
class shutdown_dut25 extends uvm_sequence #(ahb_transfer25);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    function new(string name="shutdown_dut25");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH25-1:0] start_addr25;

    rand bit [`AHB_DATA_WIDTH25-1:0] write_data25;
    constraint uart_smc_shut25 { (write_data25 >= 1 && write_data25 <= 3); }

    virtual task body();
      start_addr25 = 32'h00860004;
      //write_data25 = 32'h01;

     if (write_data25 == 1)
      `uvm_info("SEQ", ("shutdown_dut25 sequence is shutting25 down UART25 "), UVM_MEDIUM)
     else if (write_data25 == 2) 
      `uvm_info("SEQ", ("shutdown_dut25 sequence is shutting25 down SMC25 "), UVM_MEDIUM)
     else if (write_data25 == 3) 
      `uvm_info("SEQ", ("shutdown_dut25 sequence is shutting25 down UART25 and SMC25 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr25; req.data == write_data25; req.direction25 == WRITE; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
    endtask
  
endclass :  shutdown_dut25

// Low25 Power25 CPF25 test
class poweron_dut25 extends uvm_sequence #(ahb_transfer25);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    function new(string name="poweron_dut25");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH25-1:0] start_addr25;
    bit [`AHB_DATA_WIDTH25-1:0] write_data25;

    virtual task body();
      start_addr25 = 32'h00860004;
      write_data25 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut25 sequence is switching25 on PDurt25"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr25; req.data == write_data25; req.direction25 == WRITE; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
    endtask
  
endclass : poweron_dut25

// Reads25 UART25 RX25 FIFO
class intrpt_seq25 extends uvm_sequence #(ahb_transfer25);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    function new(string name="intrpt_seq25");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH25-1:0] read_addr25;
    rand int unsigned num_of_rd25;
    constraint num_of_rd_ct25 { (num_of_rd25 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH25-1:0] read_data25;

      for (int i = 0; i < num_of_rd25; i++) begin
        read_addr25 = base_addr + `RX_FIFO_REG25;      //rx25 fifo address
        `uvm_do_with(req, { req.address == read_addr25; req.data == read_data25; req.direction25 == READ; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG25 DATA25 is `x%0h", read_data25), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq25

// Reads25 SPI25 RX25 REG
class read_spi_rx_reg25 extends uvm_sequence #(ahb_transfer25);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    function new(string name="read_spi_rx_reg25");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH25-1:0] read_addr25;
    rand int unsigned num_of_rd25;
    constraint num_of_rd_ct25 { (num_of_rd25 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH25-1:0] read_data25;

      for (int i = 0; i < num_of_rd25; i++) begin
        read_addr25 = base_addr + `SPI_RX0_REG25;
        `uvm_do_with(req, { req.address == read_addr25; req.data == read_data25; req.direction25 == READ; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
        `uvm_info("SEQ", $psprintf("Read DATA25 is `x%0h", read_data25), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg25

// Reads25 GPIO25 INPUT_VALUE25 REG
class read_gpio_rx_reg25 extends uvm_sequence #(ahb_transfer25);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg25)
    `uvm_declare_p_sequencer(ahb_pkg25::ahb_master_sequencer25)    

    function new(string name="read_gpio_rx_reg25");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH25-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH25-1:0] read_addr25;

    virtual task body();
      bit [`AHB_DATA_WIDTH25-1:0] read_data25;

      read_addr25 = base_addr + `GPIO_INPUT_VALUE_REG25;
      `uvm_do_with(req, { req.address == read_addr25; req.data == read_data25; req.direction25 == READ; req.burst == ahb_pkg25::SINGLE25; req.hsize25 == ahb_pkg25::WORD25;} )
      `uvm_info("SEQ", $psprintf("Read DATA25 is `x%0h", read_data25), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg25

