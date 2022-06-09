/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_seq_lib13.sv
Title13       : 
Project13     :
Created13     :
Description13 : This13 file implements13 APB13 Sequences13 specific13 to UART13 
            : CSR13 programming13 and Tx13/Rx13 FIFO write/read
Notes13       : The interrupt13 sequence in this file is not yet complete.
            : The interrupt13 sequence should be triggred13 by the Rx13 fifo 
            : full event from the UART13 RTL13.
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

// writes 0-150 data in UART13 TX13 FIFO
class ahb_to_uart_wr13 extends uvm_sequence #(ahb_transfer13);

    function new(string name="ahb_to_uart_wr13");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    rand bit unsigned[31:0] rand_data13;
    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH13-1:0] start_addr13;
    rand bit [`AHB_DATA_WIDTH13-1:0] write_data13;
    rand int unsigned num_of_wr13;
    constraint num_of_wr_ct13 { (num_of_wr13 <= 150); }

    virtual task body();
      start_addr13 = base_addr + `TX_FIFO_REG13;
      for (int i = 0; i < num_of_wr13; i++) begin
      write_data13 = write_data13 + i;
      `uvm_do_with(req, { req.address == start_addr13; req.data == write_data13; req.direction13 == WRITE; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
      end
    endtask
  
  function void post_randomize();
      write_data13 = rand_data13;
  endfunction
endclass : ahb_to_uart_wr13

// writes 0-150 data in SPI13 TX13 FIFO
class ahb_to_spi_wr13 extends uvm_sequence #(ahb_transfer13);

    function new(string name="ahb_to_spi_wr13");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    rand bit unsigned[31:0] rand_data13;
    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH13-1:0] start_addr13;
    rand bit [`AHB_DATA_WIDTH13-1:0] write_data13;
    rand int unsigned num_of_wr13;
    constraint num_of_wr_ct13 { (num_of_wr13 <= 150); }

    virtual task body();
      start_addr13 = base_addr + `SPI_TX0_REG13;
      for (int i = 0; i < num_of_wr13; i++) begin
      write_data13 = write_data13 + i;
      `uvm_do_with(req, { req.address == start_addr13; req.data == write_data13; req.direction13 == WRITE; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
      end
    endtask
  
  function void post_randomize();
      write_data13 = rand_data13;
  endfunction
endclass : ahb_to_spi_wr13

// writes 1 data in GPIO13 TX13 REG
class ahb_to_gpio_wr13 extends uvm_sequence #(ahb_transfer13);

    function new(string name="ahb_to_gpio_wr13");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    rand bit unsigned[31:0] rand_data13;
    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH13-1:0] start_addr13;
    rand bit [`AHB_DATA_WIDTH13-1:0] write_data13;

    virtual task body();
      start_addr13 = base_addr + `GPIO_OUTPUT_VALUE_REG13;
      `uvm_do_with(req, { req.address == start_addr13; req.data == write_data13; req.direction13 == WRITE; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
    endtask
  
  function void post_randomize();
      write_data13 = rand_data13;
  endfunction
endclass : ahb_to_gpio_wr13

// Low13 Power13 CPF13 test
class shutdown_dut13 extends uvm_sequence #(ahb_transfer13);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    function new(string name="shutdown_dut13");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH13-1:0] start_addr13;

    rand bit [`AHB_DATA_WIDTH13-1:0] write_data13;
    constraint uart_smc_shut13 { (write_data13 >= 1 && write_data13 <= 3); }

    virtual task body();
      start_addr13 = 32'h00860004;
      //write_data13 = 32'h01;

     if (write_data13 == 1)
      `uvm_info("SEQ", ("shutdown_dut13 sequence is shutting13 down UART13 "), UVM_MEDIUM)
     else if (write_data13 == 2) 
      `uvm_info("SEQ", ("shutdown_dut13 sequence is shutting13 down SMC13 "), UVM_MEDIUM)
     else if (write_data13 == 3) 
      `uvm_info("SEQ", ("shutdown_dut13 sequence is shutting13 down UART13 and SMC13 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr13; req.data == write_data13; req.direction13 == WRITE; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
    endtask
  
endclass :  shutdown_dut13

// Low13 Power13 CPF13 test
class poweron_dut13 extends uvm_sequence #(ahb_transfer13);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    function new(string name="poweron_dut13");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH13-1:0] start_addr13;
    bit [`AHB_DATA_WIDTH13-1:0] write_data13;

    virtual task body();
      start_addr13 = 32'h00860004;
      write_data13 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut13 sequence is switching13 on PDurt13"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr13; req.data == write_data13; req.direction13 == WRITE; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
    endtask
  
endclass : poweron_dut13

// Reads13 UART13 RX13 FIFO
class intrpt_seq13 extends uvm_sequence #(ahb_transfer13);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    function new(string name="intrpt_seq13");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH13-1:0] read_addr13;
    rand int unsigned num_of_rd13;
    constraint num_of_rd_ct13 { (num_of_rd13 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH13-1:0] read_data13;

      for (int i = 0; i < num_of_rd13; i++) begin
        read_addr13 = base_addr + `RX_FIFO_REG13;      //rx13 fifo address
        `uvm_do_with(req, { req.address == read_addr13; req.data == read_data13; req.direction13 == READ; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG13 DATA13 is `x%0h", read_data13), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq13

// Reads13 SPI13 RX13 REG
class read_spi_rx_reg13 extends uvm_sequence #(ahb_transfer13);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    function new(string name="read_spi_rx_reg13");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH13-1:0] read_addr13;
    rand int unsigned num_of_rd13;
    constraint num_of_rd_ct13 { (num_of_rd13 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH13-1:0] read_data13;

      for (int i = 0; i < num_of_rd13; i++) begin
        read_addr13 = base_addr + `SPI_RX0_REG13;
        `uvm_do_with(req, { req.address == read_addr13; req.data == read_data13; req.direction13 == READ; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
        `uvm_info("SEQ", $psprintf("Read DATA13 is `x%0h", read_data13), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg13

// Reads13 GPIO13 INPUT_VALUE13 REG
class read_gpio_rx_reg13 extends uvm_sequence #(ahb_transfer13);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg13)
    `uvm_declare_p_sequencer(ahb_pkg13::ahb_master_sequencer13)    

    function new(string name="read_gpio_rx_reg13");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH13-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH13-1:0] read_addr13;

    virtual task body();
      bit [`AHB_DATA_WIDTH13-1:0] read_data13;

      read_addr13 = base_addr + `GPIO_INPUT_VALUE_REG13;
      `uvm_do_with(req, { req.address == read_addr13; req.data == read_data13; req.direction13 == READ; req.burst == ahb_pkg13::SINGLE13; req.hsize13 == ahb_pkg13::WORD13;} )
      `uvm_info("SEQ", $psprintf("Read DATA13 is `x%0h", read_data13), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg13

