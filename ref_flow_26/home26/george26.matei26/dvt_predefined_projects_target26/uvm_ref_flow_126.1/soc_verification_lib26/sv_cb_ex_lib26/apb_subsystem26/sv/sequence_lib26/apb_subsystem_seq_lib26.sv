/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_seq_lib26.sv
Title26       : 
Project26     :
Created26     :
Description26 : This26 file implements26 APB26 Sequences26 specific26 to UART26 
            : CSR26 programming26 and Tx26/Rx26 FIFO write/read
Notes26       : The interrupt26 sequence in this file is not yet complete.
            : The interrupt26 sequence should be triggred26 by the Rx26 fifo 
            : full event from the UART26 RTL26.
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

// writes 0-150 data in UART26 TX26 FIFO
class ahb_to_uart_wr26 extends uvm_sequence #(ahb_transfer26);

    function new(string name="ahb_to_uart_wr26");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    rand bit unsigned[31:0] rand_data26;
    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH26-1:0] start_addr26;
    rand bit [`AHB_DATA_WIDTH26-1:0] write_data26;
    rand int unsigned num_of_wr26;
    constraint num_of_wr_ct26 { (num_of_wr26 <= 150); }

    virtual task body();
      start_addr26 = base_addr + `TX_FIFO_REG26;
      for (int i = 0; i < num_of_wr26; i++) begin
      write_data26 = write_data26 + i;
      `uvm_do_with(req, { req.address == start_addr26; req.data == write_data26; req.direction26 == WRITE; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
      end
    endtask
  
  function void post_randomize();
      write_data26 = rand_data26;
  endfunction
endclass : ahb_to_uart_wr26

// writes 0-150 data in SPI26 TX26 FIFO
class ahb_to_spi_wr26 extends uvm_sequence #(ahb_transfer26);

    function new(string name="ahb_to_spi_wr26");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    rand bit unsigned[31:0] rand_data26;
    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH26-1:0] start_addr26;
    rand bit [`AHB_DATA_WIDTH26-1:0] write_data26;
    rand int unsigned num_of_wr26;
    constraint num_of_wr_ct26 { (num_of_wr26 <= 150); }

    virtual task body();
      start_addr26 = base_addr + `SPI_TX0_REG26;
      for (int i = 0; i < num_of_wr26; i++) begin
      write_data26 = write_data26 + i;
      `uvm_do_with(req, { req.address == start_addr26; req.data == write_data26; req.direction26 == WRITE; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
      end
    endtask
  
  function void post_randomize();
      write_data26 = rand_data26;
  endfunction
endclass : ahb_to_spi_wr26

// writes 1 data in GPIO26 TX26 REG
class ahb_to_gpio_wr26 extends uvm_sequence #(ahb_transfer26);

    function new(string name="ahb_to_gpio_wr26");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    rand bit unsigned[31:0] rand_data26;
    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH26-1:0] start_addr26;
    rand bit [`AHB_DATA_WIDTH26-1:0] write_data26;

    virtual task body();
      start_addr26 = base_addr + `GPIO_OUTPUT_VALUE_REG26;
      `uvm_do_with(req, { req.address == start_addr26; req.data == write_data26; req.direction26 == WRITE; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
    endtask
  
  function void post_randomize();
      write_data26 = rand_data26;
  endfunction
endclass : ahb_to_gpio_wr26

// Low26 Power26 CPF26 test
class shutdown_dut26 extends uvm_sequence #(ahb_transfer26);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    function new(string name="shutdown_dut26");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH26-1:0] start_addr26;

    rand bit [`AHB_DATA_WIDTH26-1:0] write_data26;
    constraint uart_smc_shut26 { (write_data26 >= 1 && write_data26 <= 3); }

    virtual task body();
      start_addr26 = 32'h00860004;
      //write_data26 = 32'h01;

     if (write_data26 == 1)
      `uvm_info("SEQ", ("shutdown_dut26 sequence is shutting26 down UART26 "), UVM_MEDIUM)
     else if (write_data26 == 2) 
      `uvm_info("SEQ", ("shutdown_dut26 sequence is shutting26 down SMC26 "), UVM_MEDIUM)
     else if (write_data26 == 3) 
      `uvm_info("SEQ", ("shutdown_dut26 sequence is shutting26 down UART26 and SMC26 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr26; req.data == write_data26; req.direction26 == WRITE; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
    endtask
  
endclass :  shutdown_dut26

// Low26 Power26 CPF26 test
class poweron_dut26 extends uvm_sequence #(ahb_transfer26);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    function new(string name="poweron_dut26");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH26-1:0] start_addr26;
    bit [`AHB_DATA_WIDTH26-1:0] write_data26;

    virtual task body();
      start_addr26 = 32'h00860004;
      write_data26 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut26 sequence is switching26 on PDurt26"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr26; req.data == write_data26; req.direction26 == WRITE; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
    endtask
  
endclass : poweron_dut26

// Reads26 UART26 RX26 FIFO
class intrpt_seq26 extends uvm_sequence #(ahb_transfer26);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    function new(string name="intrpt_seq26");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH26-1:0] read_addr26;
    rand int unsigned num_of_rd26;
    constraint num_of_rd_ct26 { (num_of_rd26 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH26-1:0] read_data26;

      for (int i = 0; i < num_of_rd26; i++) begin
        read_addr26 = base_addr + `RX_FIFO_REG26;      //rx26 fifo address
        `uvm_do_with(req, { req.address == read_addr26; req.data == read_data26; req.direction26 == READ; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG26 DATA26 is `x%0h", read_data26), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq26

// Reads26 SPI26 RX26 REG
class read_spi_rx_reg26 extends uvm_sequence #(ahb_transfer26);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    function new(string name="read_spi_rx_reg26");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH26-1:0] read_addr26;
    rand int unsigned num_of_rd26;
    constraint num_of_rd_ct26 { (num_of_rd26 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH26-1:0] read_data26;

      for (int i = 0; i < num_of_rd26; i++) begin
        read_addr26 = base_addr + `SPI_RX0_REG26;
        `uvm_do_with(req, { req.address == read_addr26; req.data == read_data26; req.direction26 == READ; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
        `uvm_info("SEQ", $psprintf("Read DATA26 is `x%0h", read_data26), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg26

// Reads26 GPIO26 INPUT_VALUE26 REG
class read_gpio_rx_reg26 extends uvm_sequence #(ahb_transfer26);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg26)
    `uvm_declare_p_sequencer(ahb_pkg26::ahb_master_sequencer26)    

    function new(string name="read_gpio_rx_reg26");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH26-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH26-1:0] read_addr26;

    virtual task body();
      bit [`AHB_DATA_WIDTH26-1:0] read_data26;

      read_addr26 = base_addr + `GPIO_INPUT_VALUE_REG26;
      `uvm_do_with(req, { req.address == read_addr26; req.data == read_data26; req.direction26 == READ; req.burst == ahb_pkg26::SINGLE26; req.hsize26 == ahb_pkg26::WORD26;} )
      `uvm_info("SEQ", $psprintf("Read DATA26 is `x%0h", read_data26), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg26

