/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_seq_lib27.sv
Title27       : 
Project27     :
Created27     :
Description27 : This27 file implements27 APB27 Sequences27 specific27 to UART27 
            : CSR27 programming27 and Tx27/Rx27 FIFO write/read
Notes27       : The interrupt27 sequence in this file is not yet complete.
            : The interrupt27 sequence should be triggred27 by the Rx27 fifo 
            : full event from the UART27 RTL27.
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

// writes 0-150 data in UART27 TX27 FIFO
class ahb_to_uart_wr27 extends uvm_sequence #(ahb_transfer27);

    function new(string name="ahb_to_uart_wr27");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    rand bit unsigned[31:0] rand_data27;
    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH27-1:0] start_addr27;
    rand bit [`AHB_DATA_WIDTH27-1:0] write_data27;
    rand int unsigned num_of_wr27;
    constraint num_of_wr_ct27 { (num_of_wr27 <= 150); }

    virtual task body();
      start_addr27 = base_addr + `TX_FIFO_REG27;
      for (int i = 0; i < num_of_wr27; i++) begin
      write_data27 = write_data27 + i;
      `uvm_do_with(req, { req.address == start_addr27; req.data == write_data27; req.direction27 == WRITE; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
      end
    endtask
  
  function void post_randomize();
      write_data27 = rand_data27;
  endfunction
endclass : ahb_to_uart_wr27

// writes 0-150 data in SPI27 TX27 FIFO
class ahb_to_spi_wr27 extends uvm_sequence #(ahb_transfer27);

    function new(string name="ahb_to_spi_wr27");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    rand bit unsigned[31:0] rand_data27;
    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH27-1:0] start_addr27;
    rand bit [`AHB_DATA_WIDTH27-1:0] write_data27;
    rand int unsigned num_of_wr27;
    constraint num_of_wr_ct27 { (num_of_wr27 <= 150); }

    virtual task body();
      start_addr27 = base_addr + `SPI_TX0_REG27;
      for (int i = 0; i < num_of_wr27; i++) begin
      write_data27 = write_data27 + i;
      `uvm_do_with(req, { req.address == start_addr27; req.data == write_data27; req.direction27 == WRITE; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
      end
    endtask
  
  function void post_randomize();
      write_data27 = rand_data27;
  endfunction
endclass : ahb_to_spi_wr27

// writes 1 data in GPIO27 TX27 REG
class ahb_to_gpio_wr27 extends uvm_sequence #(ahb_transfer27);

    function new(string name="ahb_to_gpio_wr27");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    rand bit unsigned[31:0] rand_data27;
    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH27-1:0] start_addr27;
    rand bit [`AHB_DATA_WIDTH27-1:0] write_data27;

    virtual task body();
      start_addr27 = base_addr + `GPIO_OUTPUT_VALUE_REG27;
      `uvm_do_with(req, { req.address == start_addr27; req.data == write_data27; req.direction27 == WRITE; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
    endtask
  
  function void post_randomize();
      write_data27 = rand_data27;
  endfunction
endclass : ahb_to_gpio_wr27

// Low27 Power27 CPF27 test
class shutdown_dut27 extends uvm_sequence #(ahb_transfer27);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    function new(string name="shutdown_dut27");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH27-1:0] start_addr27;

    rand bit [`AHB_DATA_WIDTH27-1:0] write_data27;
    constraint uart_smc_shut27 { (write_data27 >= 1 && write_data27 <= 3); }

    virtual task body();
      start_addr27 = 32'h00860004;
      //write_data27 = 32'h01;

     if (write_data27 == 1)
      `uvm_info("SEQ", ("shutdown_dut27 sequence is shutting27 down UART27 "), UVM_MEDIUM)
     else if (write_data27 == 2) 
      `uvm_info("SEQ", ("shutdown_dut27 sequence is shutting27 down SMC27 "), UVM_MEDIUM)
     else if (write_data27 == 3) 
      `uvm_info("SEQ", ("shutdown_dut27 sequence is shutting27 down UART27 and SMC27 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr27; req.data == write_data27; req.direction27 == WRITE; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
    endtask
  
endclass :  shutdown_dut27

// Low27 Power27 CPF27 test
class poweron_dut27 extends uvm_sequence #(ahb_transfer27);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    function new(string name="poweron_dut27");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH27-1:0] start_addr27;
    bit [`AHB_DATA_WIDTH27-1:0] write_data27;

    virtual task body();
      start_addr27 = 32'h00860004;
      write_data27 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut27 sequence is switching27 on PDurt27"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr27; req.data == write_data27; req.direction27 == WRITE; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
    endtask
  
endclass : poweron_dut27

// Reads27 UART27 RX27 FIFO
class intrpt_seq27 extends uvm_sequence #(ahb_transfer27);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    function new(string name="intrpt_seq27");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH27-1:0] read_addr27;
    rand int unsigned num_of_rd27;
    constraint num_of_rd_ct27 { (num_of_rd27 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH27-1:0] read_data27;

      for (int i = 0; i < num_of_rd27; i++) begin
        read_addr27 = base_addr + `RX_FIFO_REG27;      //rx27 fifo address
        `uvm_do_with(req, { req.address == read_addr27; req.data == read_data27; req.direction27 == READ; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG27 DATA27 is `x%0h", read_data27), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq27

// Reads27 SPI27 RX27 REG
class read_spi_rx_reg27 extends uvm_sequence #(ahb_transfer27);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    function new(string name="read_spi_rx_reg27");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH27-1:0] read_addr27;
    rand int unsigned num_of_rd27;
    constraint num_of_rd_ct27 { (num_of_rd27 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH27-1:0] read_data27;

      for (int i = 0; i < num_of_rd27; i++) begin
        read_addr27 = base_addr + `SPI_RX0_REG27;
        `uvm_do_with(req, { req.address == read_addr27; req.data == read_data27; req.direction27 == READ; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
        `uvm_info("SEQ", $psprintf("Read DATA27 is `x%0h", read_data27), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg27

// Reads27 GPIO27 INPUT_VALUE27 REG
class read_gpio_rx_reg27 extends uvm_sequence #(ahb_transfer27);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg27)
    `uvm_declare_p_sequencer(ahb_pkg27::ahb_master_sequencer27)    

    function new(string name="read_gpio_rx_reg27");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH27-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH27-1:0] read_addr27;

    virtual task body();
      bit [`AHB_DATA_WIDTH27-1:0] read_data27;

      read_addr27 = base_addr + `GPIO_INPUT_VALUE_REG27;
      `uvm_do_with(req, { req.address == read_addr27; req.data == read_data27; req.direction27 == READ; req.burst == ahb_pkg27::SINGLE27; req.hsize27 == ahb_pkg27::WORD27;} )
      `uvm_info("SEQ", $psprintf("Read DATA27 is `x%0h", read_data27), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg27

