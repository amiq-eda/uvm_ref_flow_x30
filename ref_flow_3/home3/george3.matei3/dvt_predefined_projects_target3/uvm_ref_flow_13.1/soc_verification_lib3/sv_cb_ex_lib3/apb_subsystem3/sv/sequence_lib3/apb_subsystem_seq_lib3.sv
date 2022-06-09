/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_seq_lib3.sv
Title3       : 
Project3     :
Created3     :
Description3 : This3 file implements3 APB3 Sequences3 specific3 to UART3 
            : CSR3 programming3 and Tx3/Rx3 FIFO write/read
Notes3       : The interrupt3 sequence in this file is not yet complete.
            : The interrupt3 sequence should be triggred3 by the Rx3 fifo 
            : full event from the UART3 RTL3.
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

// writes 0-150 data in UART3 TX3 FIFO
class ahb_to_uart_wr3 extends uvm_sequence #(ahb_transfer3);

    function new(string name="ahb_to_uart_wr3");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    rand bit unsigned[31:0] rand_data3;
    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH3-1:0] start_addr3;
    rand bit [`AHB_DATA_WIDTH3-1:0] write_data3;
    rand int unsigned num_of_wr3;
    constraint num_of_wr_ct3 { (num_of_wr3 <= 150); }

    virtual task body();
      start_addr3 = base_addr + `TX_FIFO_REG3;
      for (int i = 0; i < num_of_wr3; i++) begin
      write_data3 = write_data3 + i;
      `uvm_do_with(req, { req.address == start_addr3; req.data == write_data3; req.direction3 == WRITE; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
      end
    endtask
  
  function void post_randomize();
      write_data3 = rand_data3;
  endfunction
endclass : ahb_to_uart_wr3

// writes 0-150 data in SPI3 TX3 FIFO
class ahb_to_spi_wr3 extends uvm_sequence #(ahb_transfer3);

    function new(string name="ahb_to_spi_wr3");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    rand bit unsigned[31:0] rand_data3;
    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH3-1:0] start_addr3;
    rand bit [`AHB_DATA_WIDTH3-1:0] write_data3;
    rand int unsigned num_of_wr3;
    constraint num_of_wr_ct3 { (num_of_wr3 <= 150); }

    virtual task body();
      start_addr3 = base_addr + `SPI_TX0_REG3;
      for (int i = 0; i < num_of_wr3; i++) begin
      write_data3 = write_data3 + i;
      `uvm_do_with(req, { req.address == start_addr3; req.data == write_data3; req.direction3 == WRITE; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
      end
    endtask
  
  function void post_randomize();
      write_data3 = rand_data3;
  endfunction
endclass : ahb_to_spi_wr3

// writes 1 data in GPIO3 TX3 REG
class ahb_to_gpio_wr3 extends uvm_sequence #(ahb_transfer3);

    function new(string name="ahb_to_gpio_wr3");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    rand bit unsigned[31:0] rand_data3;
    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH3-1:0] start_addr3;
    rand bit [`AHB_DATA_WIDTH3-1:0] write_data3;

    virtual task body();
      start_addr3 = base_addr + `GPIO_OUTPUT_VALUE_REG3;
      `uvm_do_with(req, { req.address == start_addr3; req.data == write_data3; req.direction3 == WRITE; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
    endtask
  
  function void post_randomize();
      write_data3 = rand_data3;
  endfunction
endclass : ahb_to_gpio_wr3

// Low3 Power3 CPF3 test
class shutdown_dut3 extends uvm_sequence #(ahb_transfer3);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    function new(string name="shutdown_dut3");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH3-1:0] start_addr3;

    rand bit [`AHB_DATA_WIDTH3-1:0] write_data3;
    constraint uart_smc_shut3 { (write_data3 >= 1 && write_data3 <= 3); }

    virtual task body();
      start_addr3 = 32'h00860004;
      //write_data3 = 32'h01;

     if (write_data3 == 1)
      `uvm_info("SEQ", ("shutdown_dut3 sequence is shutting3 down UART3 "), UVM_MEDIUM)
     else if (write_data3 == 2) 
      `uvm_info("SEQ", ("shutdown_dut3 sequence is shutting3 down SMC3 "), UVM_MEDIUM)
     else if (write_data3 == 3) 
      `uvm_info("SEQ", ("shutdown_dut3 sequence is shutting3 down UART3 and SMC3 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr3; req.data == write_data3; req.direction3 == WRITE; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
    endtask
  
endclass :  shutdown_dut3

// Low3 Power3 CPF3 test
class poweron_dut3 extends uvm_sequence #(ahb_transfer3);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    function new(string name="poweron_dut3");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH3-1:0] start_addr3;
    bit [`AHB_DATA_WIDTH3-1:0] write_data3;

    virtual task body();
      start_addr3 = 32'h00860004;
      write_data3 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut3 sequence is switching3 on PDurt3"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr3; req.data == write_data3; req.direction3 == WRITE; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
    endtask
  
endclass : poweron_dut3

// Reads3 UART3 RX3 FIFO
class intrpt_seq3 extends uvm_sequence #(ahb_transfer3);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    function new(string name="intrpt_seq3");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH3-1:0] read_addr3;
    rand int unsigned num_of_rd3;
    constraint num_of_rd_ct3 { (num_of_rd3 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH3-1:0] read_data3;

      for (int i = 0; i < num_of_rd3; i++) begin
        read_addr3 = base_addr + `RX_FIFO_REG3;      //rx3 fifo address
        `uvm_do_with(req, { req.address == read_addr3; req.data == read_data3; req.direction3 == READ; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG3 DATA3 is `x%0h", read_data3), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq3

// Reads3 SPI3 RX3 REG
class read_spi_rx_reg3 extends uvm_sequence #(ahb_transfer3);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    function new(string name="read_spi_rx_reg3");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH3-1:0] read_addr3;
    rand int unsigned num_of_rd3;
    constraint num_of_rd_ct3 { (num_of_rd3 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH3-1:0] read_data3;

      for (int i = 0; i < num_of_rd3; i++) begin
        read_addr3 = base_addr + `SPI_RX0_REG3;
        `uvm_do_with(req, { req.address == read_addr3; req.data == read_data3; req.direction3 == READ; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
        `uvm_info("SEQ", $psprintf("Read DATA3 is `x%0h", read_data3), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg3

// Reads3 GPIO3 INPUT_VALUE3 REG
class read_gpio_rx_reg3 extends uvm_sequence #(ahb_transfer3);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg3)
    `uvm_declare_p_sequencer(ahb_pkg3::ahb_master_sequencer3)    

    function new(string name="read_gpio_rx_reg3");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH3-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH3-1:0] read_addr3;

    virtual task body();
      bit [`AHB_DATA_WIDTH3-1:0] read_data3;

      read_addr3 = base_addr + `GPIO_INPUT_VALUE_REG3;
      `uvm_do_with(req, { req.address == read_addr3; req.data == read_data3; req.direction3 == READ; req.burst == ahb_pkg3::SINGLE3; req.hsize3 == ahb_pkg3::WORD3;} )
      `uvm_info("SEQ", $psprintf("Read DATA3 is `x%0h", read_data3), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg3

