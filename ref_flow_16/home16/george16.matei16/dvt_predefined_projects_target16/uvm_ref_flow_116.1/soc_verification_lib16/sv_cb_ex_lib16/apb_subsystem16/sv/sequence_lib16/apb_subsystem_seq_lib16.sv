/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_seq_lib16.sv
Title16       : 
Project16     :
Created16     :
Description16 : This16 file implements16 APB16 Sequences16 specific16 to UART16 
            : CSR16 programming16 and Tx16/Rx16 FIFO write/read
Notes16       : The interrupt16 sequence in this file is not yet complete.
            : The interrupt16 sequence should be triggred16 by the Rx16 fifo 
            : full event from the UART16 RTL16.
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

// writes 0-150 data in UART16 TX16 FIFO
class ahb_to_uart_wr16 extends uvm_sequence #(ahb_transfer16);

    function new(string name="ahb_to_uart_wr16");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    rand bit unsigned[31:0] rand_data16;
    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH16-1:0] start_addr16;
    rand bit [`AHB_DATA_WIDTH16-1:0] write_data16;
    rand int unsigned num_of_wr16;
    constraint num_of_wr_ct16 { (num_of_wr16 <= 150); }

    virtual task body();
      start_addr16 = base_addr + `TX_FIFO_REG16;
      for (int i = 0; i < num_of_wr16; i++) begin
      write_data16 = write_data16 + i;
      `uvm_do_with(req, { req.address == start_addr16; req.data == write_data16; req.direction16 == WRITE; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
      end
    endtask
  
  function void post_randomize();
      write_data16 = rand_data16;
  endfunction
endclass : ahb_to_uart_wr16

// writes 0-150 data in SPI16 TX16 FIFO
class ahb_to_spi_wr16 extends uvm_sequence #(ahb_transfer16);

    function new(string name="ahb_to_spi_wr16");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    rand bit unsigned[31:0] rand_data16;
    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH16-1:0] start_addr16;
    rand bit [`AHB_DATA_WIDTH16-1:0] write_data16;
    rand int unsigned num_of_wr16;
    constraint num_of_wr_ct16 { (num_of_wr16 <= 150); }

    virtual task body();
      start_addr16 = base_addr + `SPI_TX0_REG16;
      for (int i = 0; i < num_of_wr16; i++) begin
      write_data16 = write_data16 + i;
      `uvm_do_with(req, { req.address == start_addr16; req.data == write_data16; req.direction16 == WRITE; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
      end
    endtask
  
  function void post_randomize();
      write_data16 = rand_data16;
  endfunction
endclass : ahb_to_spi_wr16

// writes 1 data in GPIO16 TX16 REG
class ahb_to_gpio_wr16 extends uvm_sequence #(ahb_transfer16);

    function new(string name="ahb_to_gpio_wr16");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    rand bit unsigned[31:0] rand_data16;
    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH16-1:0] start_addr16;
    rand bit [`AHB_DATA_WIDTH16-1:0] write_data16;

    virtual task body();
      start_addr16 = base_addr + `GPIO_OUTPUT_VALUE_REG16;
      `uvm_do_with(req, { req.address == start_addr16; req.data == write_data16; req.direction16 == WRITE; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
    endtask
  
  function void post_randomize();
      write_data16 = rand_data16;
  endfunction
endclass : ahb_to_gpio_wr16

// Low16 Power16 CPF16 test
class shutdown_dut16 extends uvm_sequence #(ahb_transfer16);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    function new(string name="shutdown_dut16");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH16-1:0] start_addr16;

    rand bit [`AHB_DATA_WIDTH16-1:0] write_data16;
    constraint uart_smc_shut16 { (write_data16 >= 1 && write_data16 <= 3); }

    virtual task body();
      start_addr16 = 32'h00860004;
      //write_data16 = 32'h01;

     if (write_data16 == 1)
      `uvm_info("SEQ", ("shutdown_dut16 sequence is shutting16 down UART16 "), UVM_MEDIUM)
     else if (write_data16 == 2) 
      `uvm_info("SEQ", ("shutdown_dut16 sequence is shutting16 down SMC16 "), UVM_MEDIUM)
     else if (write_data16 == 3) 
      `uvm_info("SEQ", ("shutdown_dut16 sequence is shutting16 down UART16 and SMC16 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr16; req.data == write_data16; req.direction16 == WRITE; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
    endtask
  
endclass :  shutdown_dut16

// Low16 Power16 CPF16 test
class poweron_dut16 extends uvm_sequence #(ahb_transfer16);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    function new(string name="poweron_dut16");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH16-1:0] start_addr16;
    bit [`AHB_DATA_WIDTH16-1:0] write_data16;

    virtual task body();
      start_addr16 = 32'h00860004;
      write_data16 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut16 sequence is switching16 on PDurt16"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr16; req.data == write_data16; req.direction16 == WRITE; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
    endtask
  
endclass : poweron_dut16

// Reads16 UART16 RX16 FIFO
class intrpt_seq16 extends uvm_sequence #(ahb_transfer16);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    function new(string name="intrpt_seq16");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH16-1:0] read_addr16;
    rand int unsigned num_of_rd16;
    constraint num_of_rd_ct16 { (num_of_rd16 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH16-1:0] read_data16;

      for (int i = 0; i < num_of_rd16; i++) begin
        read_addr16 = base_addr + `RX_FIFO_REG16;      //rx16 fifo address
        `uvm_do_with(req, { req.address == read_addr16; req.data == read_data16; req.direction16 == READ; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG16 DATA16 is `x%0h", read_data16), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq16

// Reads16 SPI16 RX16 REG
class read_spi_rx_reg16 extends uvm_sequence #(ahb_transfer16);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    function new(string name="read_spi_rx_reg16");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH16-1:0] read_addr16;
    rand int unsigned num_of_rd16;
    constraint num_of_rd_ct16 { (num_of_rd16 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH16-1:0] read_data16;

      for (int i = 0; i < num_of_rd16; i++) begin
        read_addr16 = base_addr + `SPI_RX0_REG16;
        `uvm_do_with(req, { req.address == read_addr16; req.data == read_data16; req.direction16 == READ; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
        `uvm_info("SEQ", $psprintf("Read DATA16 is `x%0h", read_data16), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg16

// Reads16 GPIO16 INPUT_VALUE16 REG
class read_gpio_rx_reg16 extends uvm_sequence #(ahb_transfer16);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg16)
    `uvm_declare_p_sequencer(ahb_pkg16::ahb_master_sequencer16)    

    function new(string name="read_gpio_rx_reg16");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH16-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH16-1:0] read_addr16;

    virtual task body();
      bit [`AHB_DATA_WIDTH16-1:0] read_data16;

      read_addr16 = base_addr + `GPIO_INPUT_VALUE_REG16;
      `uvm_do_with(req, { req.address == read_addr16; req.data == read_data16; req.direction16 == READ; req.burst == ahb_pkg16::SINGLE16; req.hsize16 == ahb_pkg16::WORD16;} )
      `uvm_info("SEQ", $psprintf("Read DATA16 is `x%0h", read_data16), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg16

