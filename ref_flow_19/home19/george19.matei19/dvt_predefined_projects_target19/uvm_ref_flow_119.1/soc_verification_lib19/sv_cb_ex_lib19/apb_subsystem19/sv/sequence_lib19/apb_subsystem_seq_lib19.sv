/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_seq_lib19.sv
Title19       : 
Project19     :
Created19     :
Description19 : This19 file implements19 APB19 Sequences19 specific19 to UART19 
            : CSR19 programming19 and Tx19/Rx19 FIFO write/read
Notes19       : The interrupt19 sequence in this file is not yet complete.
            : The interrupt19 sequence should be triggred19 by the Rx19 fifo 
            : full event from the UART19 RTL19.
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

// writes 0-150 data in UART19 TX19 FIFO
class ahb_to_uart_wr19 extends uvm_sequence #(ahb_transfer19);

    function new(string name="ahb_to_uart_wr19");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    rand bit unsigned[31:0] rand_data19;
    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH19-1:0] start_addr19;
    rand bit [`AHB_DATA_WIDTH19-1:0] write_data19;
    rand int unsigned num_of_wr19;
    constraint num_of_wr_ct19 { (num_of_wr19 <= 150); }

    virtual task body();
      start_addr19 = base_addr + `TX_FIFO_REG19;
      for (int i = 0; i < num_of_wr19; i++) begin
      write_data19 = write_data19 + i;
      `uvm_do_with(req, { req.address == start_addr19; req.data == write_data19; req.direction19 == WRITE; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
      end
    endtask
  
  function void post_randomize();
      write_data19 = rand_data19;
  endfunction
endclass : ahb_to_uart_wr19

// writes 0-150 data in SPI19 TX19 FIFO
class ahb_to_spi_wr19 extends uvm_sequence #(ahb_transfer19);

    function new(string name="ahb_to_spi_wr19");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    rand bit unsigned[31:0] rand_data19;
    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH19-1:0] start_addr19;
    rand bit [`AHB_DATA_WIDTH19-1:0] write_data19;
    rand int unsigned num_of_wr19;
    constraint num_of_wr_ct19 { (num_of_wr19 <= 150); }

    virtual task body();
      start_addr19 = base_addr + `SPI_TX0_REG19;
      for (int i = 0; i < num_of_wr19; i++) begin
      write_data19 = write_data19 + i;
      `uvm_do_with(req, { req.address == start_addr19; req.data == write_data19; req.direction19 == WRITE; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
      end
    endtask
  
  function void post_randomize();
      write_data19 = rand_data19;
  endfunction
endclass : ahb_to_spi_wr19

// writes 1 data in GPIO19 TX19 REG
class ahb_to_gpio_wr19 extends uvm_sequence #(ahb_transfer19);

    function new(string name="ahb_to_gpio_wr19");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    rand bit unsigned[31:0] rand_data19;
    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH19-1:0] start_addr19;
    rand bit [`AHB_DATA_WIDTH19-1:0] write_data19;

    virtual task body();
      start_addr19 = base_addr + `GPIO_OUTPUT_VALUE_REG19;
      `uvm_do_with(req, { req.address == start_addr19; req.data == write_data19; req.direction19 == WRITE; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
    endtask
  
  function void post_randomize();
      write_data19 = rand_data19;
  endfunction
endclass : ahb_to_gpio_wr19

// Low19 Power19 CPF19 test
class shutdown_dut19 extends uvm_sequence #(ahb_transfer19);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    function new(string name="shutdown_dut19");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH19-1:0] start_addr19;

    rand bit [`AHB_DATA_WIDTH19-1:0] write_data19;
    constraint uart_smc_shut19 { (write_data19 >= 1 && write_data19 <= 3); }

    virtual task body();
      start_addr19 = 32'h00860004;
      //write_data19 = 32'h01;

     if (write_data19 == 1)
      `uvm_info("SEQ", ("shutdown_dut19 sequence is shutting19 down UART19 "), UVM_MEDIUM)
     else if (write_data19 == 2) 
      `uvm_info("SEQ", ("shutdown_dut19 sequence is shutting19 down SMC19 "), UVM_MEDIUM)
     else if (write_data19 == 3) 
      `uvm_info("SEQ", ("shutdown_dut19 sequence is shutting19 down UART19 and SMC19 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr19; req.data == write_data19; req.direction19 == WRITE; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
    endtask
  
endclass :  shutdown_dut19

// Low19 Power19 CPF19 test
class poweron_dut19 extends uvm_sequence #(ahb_transfer19);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    function new(string name="poweron_dut19");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH19-1:0] start_addr19;
    bit [`AHB_DATA_WIDTH19-1:0] write_data19;

    virtual task body();
      start_addr19 = 32'h00860004;
      write_data19 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut19 sequence is switching19 on PDurt19"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr19; req.data == write_data19; req.direction19 == WRITE; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
    endtask
  
endclass : poweron_dut19

// Reads19 UART19 RX19 FIFO
class intrpt_seq19 extends uvm_sequence #(ahb_transfer19);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    function new(string name="intrpt_seq19");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH19-1:0] read_addr19;
    rand int unsigned num_of_rd19;
    constraint num_of_rd_ct19 { (num_of_rd19 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH19-1:0] read_data19;

      for (int i = 0; i < num_of_rd19; i++) begin
        read_addr19 = base_addr + `RX_FIFO_REG19;      //rx19 fifo address
        `uvm_do_with(req, { req.address == read_addr19; req.data == read_data19; req.direction19 == READ; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG19 DATA19 is `x%0h", read_data19), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq19

// Reads19 SPI19 RX19 REG
class read_spi_rx_reg19 extends uvm_sequence #(ahb_transfer19);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    function new(string name="read_spi_rx_reg19");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH19-1:0] read_addr19;
    rand int unsigned num_of_rd19;
    constraint num_of_rd_ct19 { (num_of_rd19 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH19-1:0] read_data19;

      for (int i = 0; i < num_of_rd19; i++) begin
        read_addr19 = base_addr + `SPI_RX0_REG19;
        `uvm_do_with(req, { req.address == read_addr19; req.data == read_data19; req.direction19 == READ; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
        `uvm_info("SEQ", $psprintf("Read DATA19 is `x%0h", read_data19), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg19

// Reads19 GPIO19 INPUT_VALUE19 REG
class read_gpio_rx_reg19 extends uvm_sequence #(ahb_transfer19);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg19)
    `uvm_declare_p_sequencer(ahb_pkg19::ahb_master_sequencer19)    

    function new(string name="read_gpio_rx_reg19");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH19-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH19-1:0] read_addr19;

    virtual task body();
      bit [`AHB_DATA_WIDTH19-1:0] read_data19;

      read_addr19 = base_addr + `GPIO_INPUT_VALUE_REG19;
      `uvm_do_with(req, { req.address == read_addr19; req.data == read_data19; req.direction19 == READ; req.burst == ahb_pkg19::SINGLE19; req.hsize19 == ahb_pkg19::WORD19;} )
      `uvm_info("SEQ", $psprintf("Read DATA19 is `x%0h", read_data19), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg19

