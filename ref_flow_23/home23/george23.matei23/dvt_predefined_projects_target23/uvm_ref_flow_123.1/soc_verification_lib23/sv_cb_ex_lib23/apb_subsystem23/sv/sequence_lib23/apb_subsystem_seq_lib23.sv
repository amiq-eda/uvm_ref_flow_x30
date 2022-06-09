/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_seq_lib23.sv
Title23       : 
Project23     :
Created23     :
Description23 : This23 file implements23 APB23 Sequences23 specific23 to UART23 
            : CSR23 programming23 and Tx23/Rx23 FIFO write/read
Notes23       : The interrupt23 sequence in this file is not yet complete.
            : The interrupt23 sequence should be triggred23 by the Rx23 fifo 
            : full event from the UART23 RTL23.
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

// writes 0-150 data in UART23 TX23 FIFO
class ahb_to_uart_wr23 extends uvm_sequence #(ahb_transfer23);

    function new(string name="ahb_to_uart_wr23");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    rand bit unsigned[31:0] rand_data23;
    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH23-1:0] start_addr23;
    rand bit [`AHB_DATA_WIDTH23-1:0] write_data23;
    rand int unsigned num_of_wr23;
    constraint num_of_wr_ct23 { (num_of_wr23 <= 150); }

    virtual task body();
      start_addr23 = base_addr + `TX_FIFO_REG23;
      for (int i = 0; i < num_of_wr23; i++) begin
      write_data23 = write_data23 + i;
      `uvm_do_with(req, { req.address == start_addr23; req.data == write_data23; req.direction23 == WRITE; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
      end
    endtask
  
  function void post_randomize();
      write_data23 = rand_data23;
  endfunction
endclass : ahb_to_uart_wr23

// writes 0-150 data in SPI23 TX23 FIFO
class ahb_to_spi_wr23 extends uvm_sequence #(ahb_transfer23);

    function new(string name="ahb_to_spi_wr23");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    rand bit unsigned[31:0] rand_data23;
    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH23-1:0] start_addr23;
    rand bit [`AHB_DATA_WIDTH23-1:0] write_data23;
    rand int unsigned num_of_wr23;
    constraint num_of_wr_ct23 { (num_of_wr23 <= 150); }

    virtual task body();
      start_addr23 = base_addr + `SPI_TX0_REG23;
      for (int i = 0; i < num_of_wr23; i++) begin
      write_data23 = write_data23 + i;
      `uvm_do_with(req, { req.address == start_addr23; req.data == write_data23; req.direction23 == WRITE; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
      end
    endtask
  
  function void post_randomize();
      write_data23 = rand_data23;
  endfunction
endclass : ahb_to_spi_wr23

// writes 1 data in GPIO23 TX23 REG
class ahb_to_gpio_wr23 extends uvm_sequence #(ahb_transfer23);

    function new(string name="ahb_to_gpio_wr23");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    rand bit unsigned[31:0] rand_data23;
    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH23-1:0] start_addr23;
    rand bit [`AHB_DATA_WIDTH23-1:0] write_data23;

    virtual task body();
      start_addr23 = base_addr + `GPIO_OUTPUT_VALUE_REG23;
      `uvm_do_with(req, { req.address == start_addr23; req.data == write_data23; req.direction23 == WRITE; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
    endtask
  
  function void post_randomize();
      write_data23 = rand_data23;
  endfunction
endclass : ahb_to_gpio_wr23

// Low23 Power23 CPF23 test
class shutdown_dut23 extends uvm_sequence #(ahb_transfer23);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    function new(string name="shutdown_dut23");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH23-1:0] start_addr23;

    rand bit [`AHB_DATA_WIDTH23-1:0] write_data23;
    constraint uart_smc_shut23 { (write_data23 >= 1 && write_data23 <= 3); }

    virtual task body();
      start_addr23 = 32'h00860004;
      //write_data23 = 32'h01;

     if (write_data23 == 1)
      `uvm_info("SEQ", ("shutdown_dut23 sequence is shutting23 down UART23 "), UVM_MEDIUM)
     else if (write_data23 == 2) 
      `uvm_info("SEQ", ("shutdown_dut23 sequence is shutting23 down SMC23 "), UVM_MEDIUM)
     else if (write_data23 == 3) 
      `uvm_info("SEQ", ("shutdown_dut23 sequence is shutting23 down UART23 and SMC23 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr23; req.data == write_data23; req.direction23 == WRITE; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
    endtask
  
endclass :  shutdown_dut23

// Low23 Power23 CPF23 test
class poweron_dut23 extends uvm_sequence #(ahb_transfer23);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    function new(string name="poweron_dut23");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH23-1:0] start_addr23;
    bit [`AHB_DATA_WIDTH23-1:0] write_data23;

    virtual task body();
      start_addr23 = 32'h00860004;
      write_data23 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut23 sequence is switching23 on PDurt23"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr23; req.data == write_data23; req.direction23 == WRITE; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
    endtask
  
endclass : poweron_dut23

// Reads23 UART23 RX23 FIFO
class intrpt_seq23 extends uvm_sequence #(ahb_transfer23);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    function new(string name="intrpt_seq23");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH23-1:0] read_addr23;
    rand int unsigned num_of_rd23;
    constraint num_of_rd_ct23 { (num_of_rd23 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH23-1:0] read_data23;

      for (int i = 0; i < num_of_rd23; i++) begin
        read_addr23 = base_addr + `RX_FIFO_REG23;      //rx23 fifo address
        `uvm_do_with(req, { req.address == read_addr23; req.data == read_data23; req.direction23 == READ; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG23 DATA23 is `x%0h", read_data23), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq23

// Reads23 SPI23 RX23 REG
class read_spi_rx_reg23 extends uvm_sequence #(ahb_transfer23);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    function new(string name="read_spi_rx_reg23");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH23-1:0] read_addr23;
    rand int unsigned num_of_rd23;
    constraint num_of_rd_ct23 { (num_of_rd23 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH23-1:0] read_data23;

      for (int i = 0; i < num_of_rd23; i++) begin
        read_addr23 = base_addr + `SPI_RX0_REG23;
        `uvm_do_with(req, { req.address == read_addr23; req.data == read_data23; req.direction23 == READ; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
        `uvm_info("SEQ", $psprintf("Read DATA23 is `x%0h", read_data23), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg23

// Reads23 GPIO23 INPUT_VALUE23 REG
class read_gpio_rx_reg23 extends uvm_sequence #(ahb_transfer23);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg23)
    `uvm_declare_p_sequencer(ahb_pkg23::ahb_master_sequencer23)    

    function new(string name="read_gpio_rx_reg23");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH23-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH23-1:0] read_addr23;

    virtual task body();
      bit [`AHB_DATA_WIDTH23-1:0] read_data23;

      read_addr23 = base_addr + `GPIO_INPUT_VALUE_REG23;
      `uvm_do_with(req, { req.address == read_addr23; req.data == read_data23; req.direction23 == READ; req.burst == ahb_pkg23::SINGLE23; req.hsize23 == ahb_pkg23::WORD23;} )
      `uvm_info("SEQ", $psprintf("Read DATA23 is `x%0h", read_data23), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg23

