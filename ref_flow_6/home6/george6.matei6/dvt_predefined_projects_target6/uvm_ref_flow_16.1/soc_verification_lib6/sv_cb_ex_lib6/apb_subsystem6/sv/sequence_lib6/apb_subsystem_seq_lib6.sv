/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_seq_lib6.sv
Title6       : 
Project6     :
Created6     :
Description6 : This6 file implements6 APB6 Sequences6 specific6 to UART6 
            : CSR6 programming6 and Tx6/Rx6 FIFO write/read
Notes6       : The interrupt6 sequence in this file is not yet complete.
            : The interrupt6 sequence should be triggred6 by the Rx6 fifo 
            : full event from the UART6 RTL6.
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

// writes 0-150 data in UART6 TX6 FIFO
class ahb_to_uart_wr6 extends uvm_sequence #(ahb_transfer6);

    function new(string name="ahb_to_uart_wr6");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    rand bit unsigned[31:0] rand_data6;
    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH6-1:0] start_addr6;
    rand bit [`AHB_DATA_WIDTH6-1:0] write_data6;
    rand int unsigned num_of_wr6;
    constraint num_of_wr_ct6 { (num_of_wr6 <= 150); }

    virtual task body();
      start_addr6 = base_addr + `TX_FIFO_REG6;
      for (int i = 0; i < num_of_wr6; i++) begin
      write_data6 = write_data6 + i;
      `uvm_do_with(req, { req.address == start_addr6; req.data == write_data6; req.direction6 == WRITE; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
      end
    endtask
  
  function void post_randomize();
      write_data6 = rand_data6;
  endfunction
endclass : ahb_to_uart_wr6

// writes 0-150 data in SPI6 TX6 FIFO
class ahb_to_spi_wr6 extends uvm_sequence #(ahb_transfer6);

    function new(string name="ahb_to_spi_wr6");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    rand bit unsigned[31:0] rand_data6;
    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH6-1:0] start_addr6;
    rand bit [`AHB_DATA_WIDTH6-1:0] write_data6;
    rand int unsigned num_of_wr6;
    constraint num_of_wr_ct6 { (num_of_wr6 <= 150); }

    virtual task body();
      start_addr6 = base_addr + `SPI_TX0_REG6;
      for (int i = 0; i < num_of_wr6; i++) begin
      write_data6 = write_data6 + i;
      `uvm_do_with(req, { req.address == start_addr6; req.data == write_data6; req.direction6 == WRITE; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
      end
    endtask
  
  function void post_randomize();
      write_data6 = rand_data6;
  endfunction
endclass : ahb_to_spi_wr6

// writes 1 data in GPIO6 TX6 REG
class ahb_to_gpio_wr6 extends uvm_sequence #(ahb_transfer6);

    function new(string name="ahb_to_gpio_wr6");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    rand bit unsigned[31:0] rand_data6;
    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH6-1:0] start_addr6;
    rand bit [`AHB_DATA_WIDTH6-1:0] write_data6;

    virtual task body();
      start_addr6 = base_addr + `GPIO_OUTPUT_VALUE_REG6;
      `uvm_do_with(req, { req.address == start_addr6; req.data == write_data6; req.direction6 == WRITE; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
    endtask
  
  function void post_randomize();
      write_data6 = rand_data6;
  endfunction
endclass : ahb_to_gpio_wr6

// Low6 Power6 CPF6 test
class shutdown_dut6 extends uvm_sequence #(ahb_transfer6);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    function new(string name="shutdown_dut6");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH6-1:0] start_addr6;

    rand bit [`AHB_DATA_WIDTH6-1:0] write_data6;
    constraint uart_smc_shut6 { (write_data6 >= 1 && write_data6 <= 3); }

    virtual task body();
      start_addr6 = 32'h00860004;
      //write_data6 = 32'h01;

     if (write_data6 == 1)
      `uvm_info("SEQ", ("shutdown_dut6 sequence is shutting6 down UART6 "), UVM_MEDIUM)
     else if (write_data6 == 2) 
      `uvm_info("SEQ", ("shutdown_dut6 sequence is shutting6 down SMC6 "), UVM_MEDIUM)
     else if (write_data6 == 3) 
      `uvm_info("SEQ", ("shutdown_dut6 sequence is shutting6 down UART6 and SMC6 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr6; req.data == write_data6; req.direction6 == WRITE; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
    endtask
  
endclass :  shutdown_dut6

// Low6 Power6 CPF6 test
class poweron_dut6 extends uvm_sequence #(ahb_transfer6);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    function new(string name="poweron_dut6");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH6-1:0] start_addr6;
    bit [`AHB_DATA_WIDTH6-1:0] write_data6;

    virtual task body();
      start_addr6 = 32'h00860004;
      write_data6 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut6 sequence is switching6 on PDurt6"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr6; req.data == write_data6; req.direction6 == WRITE; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
    endtask
  
endclass : poweron_dut6

// Reads6 UART6 RX6 FIFO
class intrpt_seq6 extends uvm_sequence #(ahb_transfer6);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    function new(string name="intrpt_seq6");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH6-1:0] read_addr6;
    rand int unsigned num_of_rd6;
    constraint num_of_rd_ct6 { (num_of_rd6 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH6-1:0] read_data6;

      for (int i = 0; i < num_of_rd6; i++) begin
        read_addr6 = base_addr + `RX_FIFO_REG6;      //rx6 fifo address
        `uvm_do_with(req, { req.address == read_addr6; req.data == read_data6; req.direction6 == READ; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG6 DATA6 is `x%0h", read_data6), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq6

// Reads6 SPI6 RX6 REG
class read_spi_rx_reg6 extends uvm_sequence #(ahb_transfer6);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    function new(string name="read_spi_rx_reg6");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH6-1:0] read_addr6;
    rand int unsigned num_of_rd6;
    constraint num_of_rd_ct6 { (num_of_rd6 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH6-1:0] read_data6;

      for (int i = 0; i < num_of_rd6; i++) begin
        read_addr6 = base_addr + `SPI_RX0_REG6;
        `uvm_do_with(req, { req.address == read_addr6; req.data == read_data6; req.direction6 == READ; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
        `uvm_info("SEQ", $psprintf("Read DATA6 is `x%0h", read_data6), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg6

// Reads6 GPIO6 INPUT_VALUE6 REG
class read_gpio_rx_reg6 extends uvm_sequence #(ahb_transfer6);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg6)
    `uvm_declare_p_sequencer(ahb_pkg6::ahb_master_sequencer6)    

    function new(string name="read_gpio_rx_reg6");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH6-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH6-1:0] read_addr6;

    virtual task body();
      bit [`AHB_DATA_WIDTH6-1:0] read_data6;

      read_addr6 = base_addr + `GPIO_INPUT_VALUE_REG6;
      `uvm_do_with(req, { req.address == read_addr6; req.data == read_data6; req.direction6 == READ; req.burst == ahb_pkg6::SINGLE6; req.hsize6 == ahb_pkg6::WORD6;} )
      `uvm_info("SEQ", $psprintf("Read DATA6 is `x%0h", read_data6), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg6

