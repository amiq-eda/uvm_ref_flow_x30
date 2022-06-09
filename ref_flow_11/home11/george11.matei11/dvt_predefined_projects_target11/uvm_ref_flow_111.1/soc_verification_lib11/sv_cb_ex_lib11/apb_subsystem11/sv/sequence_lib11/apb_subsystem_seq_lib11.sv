/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_seq_lib11.sv
Title11       : 
Project11     :
Created11     :
Description11 : This11 file implements11 APB11 Sequences11 specific11 to UART11 
            : CSR11 programming11 and Tx11/Rx11 FIFO write/read
Notes11       : The interrupt11 sequence in this file is not yet complete.
            : The interrupt11 sequence should be triggred11 by the Rx11 fifo 
            : full event from the UART11 RTL11.
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

// writes 0-150 data in UART11 TX11 FIFO
class ahb_to_uart_wr11 extends uvm_sequence #(ahb_transfer11);

    function new(string name="ahb_to_uart_wr11");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    rand bit unsigned[31:0] rand_data11;
    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH11-1:0] start_addr11;
    rand bit [`AHB_DATA_WIDTH11-1:0] write_data11;
    rand int unsigned num_of_wr11;
    constraint num_of_wr_ct11 { (num_of_wr11 <= 150); }

    virtual task body();
      start_addr11 = base_addr + `TX_FIFO_REG11;
      for (int i = 0; i < num_of_wr11; i++) begin
      write_data11 = write_data11 + i;
      `uvm_do_with(req, { req.address == start_addr11; req.data == write_data11; req.direction11 == WRITE; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
      end
    endtask
  
  function void post_randomize();
      write_data11 = rand_data11;
  endfunction
endclass : ahb_to_uart_wr11

// writes 0-150 data in SPI11 TX11 FIFO
class ahb_to_spi_wr11 extends uvm_sequence #(ahb_transfer11);

    function new(string name="ahb_to_spi_wr11");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    rand bit unsigned[31:0] rand_data11;
    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH11-1:0] start_addr11;
    rand bit [`AHB_DATA_WIDTH11-1:0] write_data11;
    rand int unsigned num_of_wr11;
    constraint num_of_wr_ct11 { (num_of_wr11 <= 150); }

    virtual task body();
      start_addr11 = base_addr + `SPI_TX0_REG11;
      for (int i = 0; i < num_of_wr11; i++) begin
      write_data11 = write_data11 + i;
      `uvm_do_with(req, { req.address == start_addr11; req.data == write_data11; req.direction11 == WRITE; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
      end
    endtask
  
  function void post_randomize();
      write_data11 = rand_data11;
  endfunction
endclass : ahb_to_spi_wr11

// writes 1 data in GPIO11 TX11 REG
class ahb_to_gpio_wr11 extends uvm_sequence #(ahb_transfer11);

    function new(string name="ahb_to_gpio_wr11");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    rand bit unsigned[31:0] rand_data11;
    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH11-1:0] start_addr11;
    rand bit [`AHB_DATA_WIDTH11-1:0] write_data11;

    virtual task body();
      start_addr11 = base_addr + `GPIO_OUTPUT_VALUE_REG11;
      `uvm_do_with(req, { req.address == start_addr11; req.data == write_data11; req.direction11 == WRITE; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
    endtask
  
  function void post_randomize();
      write_data11 = rand_data11;
  endfunction
endclass : ahb_to_gpio_wr11

// Low11 Power11 CPF11 test
class shutdown_dut11 extends uvm_sequence #(ahb_transfer11);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    function new(string name="shutdown_dut11");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH11-1:0] start_addr11;

    rand bit [`AHB_DATA_WIDTH11-1:0] write_data11;
    constraint uart_smc_shut11 { (write_data11 >= 1 && write_data11 <= 3); }

    virtual task body();
      start_addr11 = 32'h00860004;
      //write_data11 = 32'h01;

     if (write_data11 == 1)
      `uvm_info("SEQ", ("shutdown_dut11 sequence is shutting11 down UART11 "), UVM_MEDIUM)
     else if (write_data11 == 2) 
      `uvm_info("SEQ", ("shutdown_dut11 sequence is shutting11 down SMC11 "), UVM_MEDIUM)
     else if (write_data11 == 3) 
      `uvm_info("SEQ", ("shutdown_dut11 sequence is shutting11 down UART11 and SMC11 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr11; req.data == write_data11; req.direction11 == WRITE; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
    endtask
  
endclass :  shutdown_dut11

// Low11 Power11 CPF11 test
class poweron_dut11 extends uvm_sequence #(ahb_transfer11);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    function new(string name="poweron_dut11");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH11-1:0] start_addr11;
    bit [`AHB_DATA_WIDTH11-1:0] write_data11;

    virtual task body();
      start_addr11 = 32'h00860004;
      write_data11 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut11 sequence is switching11 on PDurt11"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr11; req.data == write_data11; req.direction11 == WRITE; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
    endtask
  
endclass : poweron_dut11

// Reads11 UART11 RX11 FIFO
class intrpt_seq11 extends uvm_sequence #(ahb_transfer11);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    function new(string name="intrpt_seq11");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH11-1:0] read_addr11;
    rand int unsigned num_of_rd11;
    constraint num_of_rd_ct11 { (num_of_rd11 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH11-1:0] read_data11;

      for (int i = 0; i < num_of_rd11; i++) begin
        read_addr11 = base_addr + `RX_FIFO_REG11;      //rx11 fifo address
        `uvm_do_with(req, { req.address == read_addr11; req.data == read_data11; req.direction11 == READ; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG11 DATA11 is `x%0h", read_data11), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq11

// Reads11 SPI11 RX11 REG
class read_spi_rx_reg11 extends uvm_sequence #(ahb_transfer11);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    function new(string name="read_spi_rx_reg11");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH11-1:0] read_addr11;
    rand int unsigned num_of_rd11;
    constraint num_of_rd_ct11 { (num_of_rd11 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH11-1:0] read_data11;

      for (int i = 0; i < num_of_rd11; i++) begin
        read_addr11 = base_addr + `SPI_RX0_REG11;
        `uvm_do_with(req, { req.address == read_addr11; req.data == read_data11; req.direction11 == READ; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
        `uvm_info("SEQ", $psprintf("Read DATA11 is `x%0h", read_data11), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg11

// Reads11 GPIO11 INPUT_VALUE11 REG
class read_gpio_rx_reg11 extends uvm_sequence #(ahb_transfer11);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg11)
    `uvm_declare_p_sequencer(ahb_pkg11::ahb_master_sequencer11)    

    function new(string name="read_gpio_rx_reg11");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH11-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH11-1:0] read_addr11;

    virtual task body();
      bit [`AHB_DATA_WIDTH11-1:0] read_data11;

      read_addr11 = base_addr + `GPIO_INPUT_VALUE_REG11;
      `uvm_do_with(req, { req.address == read_addr11; req.data == read_data11; req.direction11 == READ; req.burst == ahb_pkg11::SINGLE11; req.hsize11 == ahb_pkg11::WORD11;} )
      `uvm_info("SEQ", $psprintf("Read DATA11 is `x%0h", read_data11), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg11

