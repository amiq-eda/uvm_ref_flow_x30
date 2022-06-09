/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_seq_lib10.sv
Title10       : 
Project10     :
Created10     :
Description10 : This10 file implements10 APB10 Sequences10 specific10 to UART10 
            : CSR10 programming10 and Tx10/Rx10 FIFO write/read
Notes10       : The interrupt10 sequence in this file is not yet complete.
            : The interrupt10 sequence should be triggred10 by the Rx10 fifo 
            : full event from the UART10 RTL10.
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

// writes 0-150 data in UART10 TX10 FIFO
class ahb_to_uart_wr10 extends uvm_sequence #(ahb_transfer10);

    function new(string name="ahb_to_uart_wr10");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    rand bit unsigned[31:0] rand_data10;
    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH10-1:0] start_addr10;
    rand bit [`AHB_DATA_WIDTH10-1:0] write_data10;
    rand int unsigned num_of_wr10;
    constraint num_of_wr_ct10 { (num_of_wr10 <= 150); }

    virtual task body();
      start_addr10 = base_addr + `TX_FIFO_REG10;
      for (int i = 0; i < num_of_wr10; i++) begin
      write_data10 = write_data10 + i;
      `uvm_do_with(req, { req.address == start_addr10; req.data == write_data10; req.direction10 == WRITE; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
      end
    endtask
  
  function void post_randomize();
      write_data10 = rand_data10;
  endfunction
endclass : ahb_to_uart_wr10

// writes 0-150 data in SPI10 TX10 FIFO
class ahb_to_spi_wr10 extends uvm_sequence #(ahb_transfer10);

    function new(string name="ahb_to_spi_wr10");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    rand bit unsigned[31:0] rand_data10;
    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH10-1:0] start_addr10;
    rand bit [`AHB_DATA_WIDTH10-1:0] write_data10;
    rand int unsigned num_of_wr10;
    constraint num_of_wr_ct10 { (num_of_wr10 <= 150); }

    virtual task body();
      start_addr10 = base_addr + `SPI_TX0_REG10;
      for (int i = 0; i < num_of_wr10; i++) begin
      write_data10 = write_data10 + i;
      `uvm_do_with(req, { req.address == start_addr10; req.data == write_data10; req.direction10 == WRITE; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
      end
    endtask
  
  function void post_randomize();
      write_data10 = rand_data10;
  endfunction
endclass : ahb_to_spi_wr10

// writes 1 data in GPIO10 TX10 REG
class ahb_to_gpio_wr10 extends uvm_sequence #(ahb_transfer10);

    function new(string name="ahb_to_gpio_wr10");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    rand bit unsigned[31:0] rand_data10;
    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH10-1:0] start_addr10;
    rand bit [`AHB_DATA_WIDTH10-1:0] write_data10;

    virtual task body();
      start_addr10 = base_addr + `GPIO_OUTPUT_VALUE_REG10;
      `uvm_do_with(req, { req.address == start_addr10; req.data == write_data10; req.direction10 == WRITE; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
    endtask
  
  function void post_randomize();
      write_data10 = rand_data10;
  endfunction
endclass : ahb_to_gpio_wr10

// Low10 Power10 CPF10 test
class shutdown_dut10 extends uvm_sequence #(ahb_transfer10);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    function new(string name="shutdown_dut10");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH10-1:0] start_addr10;

    rand bit [`AHB_DATA_WIDTH10-1:0] write_data10;
    constraint uart_smc_shut10 { (write_data10 >= 1 && write_data10 <= 3); }

    virtual task body();
      start_addr10 = 32'h00860004;
      //write_data10 = 32'h01;

     if (write_data10 == 1)
      `uvm_info("SEQ", ("shutdown_dut10 sequence is shutting10 down UART10 "), UVM_MEDIUM)
     else if (write_data10 == 2) 
      `uvm_info("SEQ", ("shutdown_dut10 sequence is shutting10 down SMC10 "), UVM_MEDIUM)
     else if (write_data10 == 3) 
      `uvm_info("SEQ", ("shutdown_dut10 sequence is shutting10 down UART10 and SMC10 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr10; req.data == write_data10; req.direction10 == WRITE; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
    endtask
  
endclass :  shutdown_dut10

// Low10 Power10 CPF10 test
class poweron_dut10 extends uvm_sequence #(ahb_transfer10);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    function new(string name="poweron_dut10");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH10-1:0] start_addr10;
    bit [`AHB_DATA_WIDTH10-1:0] write_data10;

    virtual task body();
      start_addr10 = 32'h00860004;
      write_data10 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut10 sequence is switching10 on PDurt10"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr10; req.data == write_data10; req.direction10 == WRITE; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
    endtask
  
endclass : poweron_dut10

// Reads10 UART10 RX10 FIFO
class intrpt_seq10 extends uvm_sequence #(ahb_transfer10);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    function new(string name="intrpt_seq10");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH10-1:0] read_addr10;
    rand int unsigned num_of_rd10;
    constraint num_of_rd_ct10 { (num_of_rd10 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH10-1:0] read_data10;

      for (int i = 0; i < num_of_rd10; i++) begin
        read_addr10 = base_addr + `RX_FIFO_REG10;      //rx10 fifo address
        `uvm_do_with(req, { req.address == read_addr10; req.data == read_data10; req.direction10 == READ; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG10 DATA10 is `x%0h", read_data10), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq10

// Reads10 SPI10 RX10 REG
class read_spi_rx_reg10 extends uvm_sequence #(ahb_transfer10);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    function new(string name="read_spi_rx_reg10");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH10-1:0] read_addr10;
    rand int unsigned num_of_rd10;
    constraint num_of_rd_ct10 { (num_of_rd10 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH10-1:0] read_data10;

      for (int i = 0; i < num_of_rd10; i++) begin
        read_addr10 = base_addr + `SPI_RX0_REG10;
        `uvm_do_with(req, { req.address == read_addr10; req.data == read_data10; req.direction10 == READ; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
        `uvm_info("SEQ", $psprintf("Read DATA10 is `x%0h", read_data10), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg10

// Reads10 GPIO10 INPUT_VALUE10 REG
class read_gpio_rx_reg10 extends uvm_sequence #(ahb_transfer10);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg10)
    `uvm_declare_p_sequencer(ahb_pkg10::ahb_master_sequencer10)    

    function new(string name="read_gpio_rx_reg10");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH10-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH10-1:0] read_addr10;

    virtual task body();
      bit [`AHB_DATA_WIDTH10-1:0] read_data10;

      read_addr10 = base_addr + `GPIO_INPUT_VALUE_REG10;
      `uvm_do_with(req, { req.address == read_addr10; req.data == read_data10; req.direction10 == READ; req.burst == ahb_pkg10::SINGLE10; req.hsize10 == ahb_pkg10::WORD10;} )
      `uvm_info("SEQ", $psprintf("Read DATA10 is `x%0h", read_data10), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg10

