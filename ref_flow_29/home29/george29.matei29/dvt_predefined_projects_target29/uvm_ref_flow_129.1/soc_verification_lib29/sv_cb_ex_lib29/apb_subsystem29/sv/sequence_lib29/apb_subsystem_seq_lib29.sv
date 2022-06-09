/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_seq_lib29.sv
Title29       : 
Project29     :
Created29     :
Description29 : This29 file implements29 APB29 Sequences29 specific29 to UART29 
            : CSR29 programming29 and Tx29/Rx29 FIFO write/read
Notes29       : The interrupt29 sequence in this file is not yet complete.
            : The interrupt29 sequence should be triggred29 by the Rx29 fifo 
            : full event from the UART29 RTL29.
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

// writes 0-150 data in UART29 TX29 FIFO
class ahb_to_uart_wr29 extends uvm_sequence #(ahb_transfer29);

    function new(string name="ahb_to_uart_wr29");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    rand bit unsigned[31:0] rand_data29;
    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH29-1:0] start_addr29;
    rand bit [`AHB_DATA_WIDTH29-1:0] write_data29;
    rand int unsigned num_of_wr29;
    constraint num_of_wr_ct29 { (num_of_wr29 <= 150); }

    virtual task body();
      start_addr29 = base_addr + `TX_FIFO_REG29;
      for (int i = 0; i < num_of_wr29; i++) begin
      write_data29 = write_data29 + i;
      `uvm_do_with(req, { req.address == start_addr29; req.data == write_data29; req.direction29 == WRITE; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
      end
    endtask
  
  function void post_randomize();
      write_data29 = rand_data29;
  endfunction
endclass : ahb_to_uart_wr29

// writes 0-150 data in SPI29 TX29 FIFO
class ahb_to_spi_wr29 extends uvm_sequence #(ahb_transfer29);

    function new(string name="ahb_to_spi_wr29");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    rand bit unsigned[31:0] rand_data29;
    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH29-1:0] start_addr29;
    rand bit [`AHB_DATA_WIDTH29-1:0] write_data29;
    rand int unsigned num_of_wr29;
    constraint num_of_wr_ct29 { (num_of_wr29 <= 150); }

    virtual task body();
      start_addr29 = base_addr + `SPI_TX0_REG29;
      for (int i = 0; i < num_of_wr29; i++) begin
      write_data29 = write_data29 + i;
      `uvm_do_with(req, { req.address == start_addr29; req.data == write_data29; req.direction29 == WRITE; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
      end
    endtask
  
  function void post_randomize();
      write_data29 = rand_data29;
  endfunction
endclass : ahb_to_spi_wr29

// writes 1 data in GPIO29 TX29 REG
class ahb_to_gpio_wr29 extends uvm_sequence #(ahb_transfer29);

    function new(string name="ahb_to_gpio_wr29");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    rand bit unsigned[31:0] rand_data29;
    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH29-1:0] start_addr29;
    rand bit [`AHB_DATA_WIDTH29-1:0] write_data29;

    virtual task body();
      start_addr29 = base_addr + `GPIO_OUTPUT_VALUE_REG29;
      `uvm_do_with(req, { req.address == start_addr29; req.data == write_data29; req.direction29 == WRITE; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
    endtask
  
  function void post_randomize();
      write_data29 = rand_data29;
  endfunction
endclass : ahb_to_gpio_wr29

// Low29 Power29 CPF29 test
class shutdown_dut29 extends uvm_sequence #(ahb_transfer29);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    function new(string name="shutdown_dut29");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH29-1:0] start_addr29;

    rand bit [`AHB_DATA_WIDTH29-1:0] write_data29;
    constraint uart_smc_shut29 { (write_data29 >= 1 && write_data29 <= 3); }

    virtual task body();
      start_addr29 = 32'h00860004;
      //write_data29 = 32'h01;

     if (write_data29 == 1)
      `uvm_info("SEQ", ("shutdown_dut29 sequence is shutting29 down UART29 "), UVM_MEDIUM)
     else if (write_data29 == 2) 
      `uvm_info("SEQ", ("shutdown_dut29 sequence is shutting29 down SMC29 "), UVM_MEDIUM)
     else if (write_data29 == 3) 
      `uvm_info("SEQ", ("shutdown_dut29 sequence is shutting29 down UART29 and SMC29 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr29; req.data == write_data29; req.direction29 == WRITE; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
    endtask
  
endclass :  shutdown_dut29

// Low29 Power29 CPF29 test
class poweron_dut29 extends uvm_sequence #(ahb_transfer29);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    function new(string name="poweron_dut29");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH29-1:0] start_addr29;
    bit [`AHB_DATA_WIDTH29-1:0] write_data29;

    virtual task body();
      start_addr29 = 32'h00860004;
      write_data29 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut29 sequence is switching29 on PDurt29"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr29; req.data == write_data29; req.direction29 == WRITE; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
    endtask
  
endclass : poweron_dut29

// Reads29 UART29 RX29 FIFO
class intrpt_seq29 extends uvm_sequence #(ahb_transfer29);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    function new(string name="intrpt_seq29");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH29-1:0] read_addr29;
    rand int unsigned num_of_rd29;
    constraint num_of_rd_ct29 { (num_of_rd29 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH29-1:0] read_data29;

      for (int i = 0; i < num_of_rd29; i++) begin
        read_addr29 = base_addr + `RX_FIFO_REG29;      //rx29 fifo address
        `uvm_do_with(req, { req.address == read_addr29; req.data == read_data29; req.direction29 == READ; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG29 DATA29 is `x%0h", read_data29), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq29

// Reads29 SPI29 RX29 REG
class read_spi_rx_reg29 extends uvm_sequence #(ahb_transfer29);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    function new(string name="read_spi_rx_reg29");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH29-1:0] read_addr29;
    rand int unsigned num_of_rd29;
    constraint num_of_rd_ct29 { (num_of_rd29 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH29-1:0] read_data29;

      for (int i = 0; i < num_of_rd29; i++) begin
        read_addr29 = base_addr + `SPI_RX0_REG29;
        `uvm_do_with(req, { req.address == read_addr29; req.data == read_data29; req.direction29 == READ; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
        `uvm_info("SEQ", $psprintf("Read DATA29 is `x%0h", read_data29), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg29

// Reads29 GPIO29 INPUT_VALUE29 REG
class read_gpio_rx_reg29 extends uvm_sequence #(ahb_transfer29);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg29)
    `uvm_declare_p_sequencer(ahb_pkg29::ahb_master_sequencer29)    

    function new(string name="read_gpio_rx_reg29");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH29-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH29-1:0] read_addr29;

    virtual task body();
      bit [`AHB_DATA_WIDTH29-1:0] read_data29;

      read_addr29 = base_addr + `GPIO_INPUT_VALUE_REG29;
      `uvm_do_with(req, { req.address == read_addr29; req.data == read_data29; req.direction29 == READ; req.burst == ahb_pkg29::SINGLE29; req.hsize29 == ahb_pkg29::WORD29;} )
      `uvm_info("SEQ", $psprintf("Read DATA29 is `x%0h", read_data29), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg29

