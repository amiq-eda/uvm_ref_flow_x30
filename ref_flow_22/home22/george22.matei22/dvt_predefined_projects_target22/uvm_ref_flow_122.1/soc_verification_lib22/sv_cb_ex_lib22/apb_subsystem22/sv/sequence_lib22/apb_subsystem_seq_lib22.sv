/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_seq_lib22.sv
Title22       : 
Project22     :
Created22     :
Description22 : This22 file implements22 APB22 Sequences22 specific22 to UART22 
            : CSR22 programming22 and Tx22/Rx22 FIFO write/read
Notes22       : The interrupt22 sequence in this file is not yet complete.
            : The interrupt22 sequence should be triggred22 by the Rx22 fifo 
            : full event from the UART22 RTL22.
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

// writes 0-150 data in UART22 TX22 FIFO
class ahb_to_uart_wr22 extends uvm_sequence #(ahb_transfer22);

    function new(string name="ahb_to_uart_wr22");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    rand bit unsigned[31:0] rand_data22;
    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH22-1:0] start_addr22;
    rand bit [`AHB_DATA_WIDTH22-1:0] write_data22;
    rand int unsigned num_of_wr22;
    constraint num_of_wr_ct22 { (num_of_wr22 <= 150); }

    virtual task body();
      start_addr22 = base_addr + `TX_FIFO_REG22;
      for (int i = 0; i < num_of_wr22; i++) begin
      write_data22 = write_data22 + i;
      `uvm_do_with(req, { req.address == start_addr22; req.data == write_data22; req.direction22 == WRITE; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
      end
    endtask
  
  function void post_randomize();
      write_data22 = rand_data22;
  endfunction
endclass : ahb_to_uart_wr22

// writes 0-150 data in SPI22 TX22 FIFO
class ahb_to_spi_wr22 extends uvm_sequence #(ahb_transfer22);

    function new(string name="ahb_to_spi_wr22");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    rand bit unsigned[31:0] rand_data22;
    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH22-1:0] start_addr22;
    rand bit [`AHB_DATA_WIDTH22-1:0] write_data22;
    rand int unsigned num_of_wr22;
    constraint num_of_wr_ct22 { (num_of_wr22 <= 150); }

    virtual task body();
      start_addr22 = base_addr + `SPI_TX0_REG22;
      for (int i = 0; i < num_of_wr22; i++) begin
      write_data22 = write_data22 + i;
      `uvm_do_with(req, { req.address == start_addr22; req.data == write_data22; req.direction22 == WRITE; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
      end
    endtask
  
  function void post_randomize();
      write_data22 = rand_data22;
  endfunction
endclass : ahb_to_spi_wr22

// writes 1 data in GPIO22 TX22 REG
class ahb_to_gpio_wr22 extends uvm_sequence #(ahb_transfer22);

    function new(string name="ahb_to_gpio_wr22");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    rand bit unsigned[31:0] rand_data22;
    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH22-1:0] start_addr22;
    rand bit [`AHB_DATA_WIDTH22-1:0] write_data22;

    virtual task body();
      start_addr22 = base_addr + `GPIO_OUTPUT_VALUE_REG22;
      `uvm_do_with(req, { req.address == start_addr22; req.data == write_data22; req.direction22 == WRITE; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
    endtask
  
  function void post_randomize();
      write_data22 = rand_data22;
  endfunction
endclass : ahb_to_gpio_wr22

// Low22 Power22 CPF22 test
class shutdown_dut22 extends uvm_sequence #(ahb_transfer22);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    function new(string name="shutdown_dut22");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH22-1:0] start_addr22;

    rand bit [`AHB_DATA_WIDTH22-1:0] write_data22;
    constraint uart_smc_shut22 { (write_data22 >= 1 && write_data22 <= 3); }

    virtual task body();
      start_addr22 = 32'h00860004;
      //write_data22 = 32'h01;

     if (write_data22 == 1)
      `uvm_info("SEQ", ("shutdown_dut22 sequence is shutting22 down UART22 "), UVM_MEDIUM)
     else if (write_data22 == 2) 
      `uvm_info("SEQ", ("shutdown_dut22 sequence is shutting22 down SMC22 "), UVM_MEDIUM)
     else if (write_data22 == 3) 
      `uvm_info("SEQ", ("shutdown_dut22 sequence is shutting22 down UART22 and SMC22 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr22; req.data == write_data22; req.direction22 == WRITE; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
    endtask
  
endclass :  shutdown_dut22

// Low22 Power22 CPF22 test
class poweron_dut22 extends uvm_sequence #(ahb_transfer22);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    function new(string name="poweron_dut22");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH22-1:0] start_addr22;
    bit [`AHB_DATA_WIDTH22-1:0] write_data22;

    virtual task body();
      start_addr22 = 32'h00860004;
      write_data22 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut22 sequence is switching22 on PDurt22"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr22; req.data == write_data22; req.direction22 == WRITE; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
    endtask
  
endclass : poweron_dut22

// Reads22 UART22 RX22 FIFO
class intrpt_seq22 extends uvm_sequence #(ahb_transfer22);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    function new(string name="intrpt_seq22");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH22-1:0] read_addr22;
    rand int unsigned num_of_rd22;
    constraint num_of_rd_ct22 { (num_of_rd22 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH22-1:0] read_data22;

      for (int i = 0; i < num_of_rd22; i++) begin
        read_addr22 = base_addr + `RX_FIFO_REG22;      //rx22 fifo address
        `uvm_do_with(req, { req.address == read_addr22; req.data == read_data22; req.direction22 == READ; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG22 DATA22 is `x%0h", read_data22), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq22

// Reads22 SPI22 RX22 REG
class read_spi_rx_reg22 extends uvm_sequence #(ahb_transfer22);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    function new(string name="read_spi_rx_reg22");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH22-1:0] read_addr22;
    rand int unsigned num_of_rd22;
    constraint num_of_rd_ct22 { (num_of_rd22 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH22-1:0] read_data22;

      for (int i = 0; i < num_of_rd22; i++) begin
        read_addr22 = base_addr + `SPI_RX0_REG22;
        `uvm_do_with(req, { req.address == read_addr22; req.data == read_data22; req.direction22 == READ; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
        `uvm_info("SEQ", $psprintf("Read DATA22 is `x%0h", read_data22), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg22

// Reads22 GPIO22 INPUT_VALUE22 REG
class read_gpio_rx_reg22 extends uvm_sequence #(ahb_transfer22);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg22)
    `uvm_declare_p_sequencer(ahb_pkg22::ahb_master_sequencer22)    

    function new(string name="read_gpio_rx_reg22");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH22-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH22-1:0] read_addr22;

    virtual task body();
      bit [`AHB_DATA_WIDTH22-1:0] read_data22;

      read_addr22 = base_addr + `GPIO_INPUT_VALUE_REG22;
      `uvm_do_with(req, { req.address == read_addr22; req.data == read_data22; req.direction22 == READ; req.burst == ahb_pkg22::SINGLE22; req.hsize22 == ahb_pkg22::WORD22;} )
      `uvm_info("SEQ", $psprintf("Read DATA22 is `x%0h", read_data22), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg22

