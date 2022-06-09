/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_seq_lib12.sv
Title12       : 
Project12     :
Created12     :
Description12 : This12 file implements12 APB12 Sequences12 specific12 to UART12 
            : CSR12 programming12 and Tx12/Rx12 FIFO write/read
Notes12       : The interrupt12 sequence in this file is not yet complete.
            : The interrupt12 sequence should be triggred12 by the Rx12 fifo 
            : full event from the UART12 RTL12.
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

// writes 0-150 data in UART12 TX12 FIFO
class ahb_to_uart_wr12 extends uvm_sequence #(ahb_transfer12);

    function new(string name="ahb_to_uart_wr12");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    rand bit unsigned[31:0] rand_data12;
    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH12-1:0] start_addr12;
    rand bit [`AHB_DATA_WIDTH12-1:0] write_data12;
    rand int unsigned num_of_wr12;
    constraint num_of_wr_ct12 { (num_of_wr12 <= 150); }

    virtual task body();
      start_addr12 = base_addr + `TX_FIFO_REG12;
      for (int i = 0; i < num_of_wr12; i++) begin
      write_data12 = write_data12 + i;
      `uvm_do_with(req, { req.address == start_addr12; req.data == write_data12; req.direction12 == WRITE; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
      end
    endtask
  
  function void post_randomize();
      write_data12 = rand_data12;
  endfunction
endclass : ahb_to_uart_wr12

// writes 0-150 data in SPI12 TX12 FIFO
class ahb_to_spi_wr12 extends uvm_sequence #(ahb_transfer12);

    function new(string name="ahb_to_spi_wr12");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    rand bit unsigned[31:0] rand_data12;
    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH12-1:0] start_addr12;
    rand bit [`AHB_DATA_WIDTH12-1:0] write_data12;
    rand int unsigned num_of_wr12;
    constraint num_of_wr_ct12 { (num_of_wr12 <= 150); }

    virtual task body();
      start_addr12 = base_addr + `SPI_TX0_REG12;
      for (int i = 0; i < num_of_wr12; i++) begin
      write_data12 = write_data12 + i;
      `uvm_do_with(req, { req.address == start_addr12; req.data == write_data12; req.direction12 == WRITE; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
      end
    endtask
  
  function void post_randomize();
      write_data12 = rand_data12;
  endfunction
endclass : ahb_to_spi_wr12

// writes 1 data in GPIO12 TX12 REG
class ahb_to_gpio_wr12 extends uvm_sequence #(ahb_transfer12);

    function new(string name="ahb_to_gpio_wr12");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    rand bit unsigned[31:0] rand_data12;
    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH12-1:0] start_addr12;
    rand bit [`AHB_DATA_WIDTH12-1:0] write_data12;

    virtual task body();
      start_addr12 = base_addr + `GPIO_OUTPUT_VALUE_REG12;
      `uvm_do_with(req, { req.address == start_addr12; req.data == write_data12; req.direction12 == WRITE; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
    endtask
  
  function void post_randomize();
      write_data12 = rand_data12;
  endfunction
endclass : ahb_to_gpio_wr12

// Low12 Power12 CPF12 test
class shutdown_dut12 extends uvm_sequence #(ahb_transfer12);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    function new(string name="shutdown_dut12");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH12-1:0] start_addr12;

    rand bit [`AHB_DATA_WIDTH12-1:0] write_data12;
    constraint uart_smc_shut12 { (write_data12 >= 1 && write_data12 <= 3); }

    virtual task body();
      start_addr12 = 32'h00860004;
      //write_data12 = 32'h01;

     if (write_data12 == 1)
      `uvm_info("SEQ", ("shutdown_dut12 sequence is shutting12 down UART12 "), UVM_MEDIUM)
     else if (write_data12 == 2) 
      `uvm_info("SEQ", ("shutdown_dut12 sequence is shutting12 down SMC12 "), UVM_MEDIUM)
     else if (write_data12 == 3) 
      `uvm_info("SEQ", ("shutdown_dut12 sequence is shutting12 down UART12 and SMC12 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr12; req.data == write_data12; req.direction12 == WRITE; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
    endtask
  
endclass :  shutdown_dut12

// Low12 Power12 CPF12 test
class poweron_dut12 extends uvm_sequence #(ahb_transfer12);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    function new(string name="poweron_dut12");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH12-1:0] start_addr12;
    bit [`AHB_DATA_WIDTH12-1:0] write_data12;

    virtual task body();
      start_addr12 = 32'h00860004;
      write_data12 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut12 sequence is switching12 on PDurt12"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr12; req.data == write_data12; req.direction12 == WRITE; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
    endtask
  
endclass : poweron_dut12

// Reads12 UART12 RX12 FIFO
class intrpt_seq12 extends uvm_sequence #(ahb_transfer12);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    function new(string name="intrpt_seq12");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH12-1:0] read_addr12;
    rand int unsigned num_of_rd12;
    constraint num_of_rd_ct12 { (num_of_rd12 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH12-1:0] read_data12;

      for (int i = 0; i < num_of_rd12; i++) begin
        read_addr12 = base_addr + `RX_FIFO_REG12;      //rx12 fifo address
        `uvm_do_with(req, { req.address == read_addr12; req.data == read_data12; req.direction12 == READ; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG12 DATA12 is `x%0h", read_data12), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq12

// Reads12 SPI12 RX12 REG
class read_spi_rx_reg12 extends uvm_sequence #(ahb_transfer12);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    function new(string name="read_spi_rx_reg12");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH12-1:0] read_addr12;
    rand int unsigned num_of_rd12;
    constraint num_of_rd_ct12 { (num_of_rd12 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH12-1:0] read_data12;

      for (int i = 0; i < num_of_rd12; i++) begin
        read_addr12 = base_addr + `SPI_RX0_REG12;
        `uvm_do_with(req, { req.address == read_addr12; req.data == read_data12; req.direction12 == READ; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
        `uvm_info("SEQ", $psprintf("Read DATA12 is `x%0h", read_data12), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg12

// Reads12 GPIO12 INPUT_VALUE12 REG
class read_gpio_rx_reg12 extends uvm_sequence #(ahb_transfer12);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg12)
    `uvm_declare_p_sequencer(ahb_pkg12::ahb_master_sequencer12)    

    function new(string name="read_gpio_rx_reg12");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH12-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH12-1:0] read_addr12;

    virtual task body();
      bit [`AHB_DATA_WIDTH12-1:0] read_data12;

      read_addr12 = base_addr + `GPIO_INPUT_VALUE_REG12;
      `uvm_do_with(req, { req.address == read_addr12; req.data == read_data12; req.direction12 == READ; req.burst == ahb_pkg12::SINGLE12; req.hsize12 == ahb_pkg12::WORD12;} )
      `uvm_info("SEQ", $psprintf("Read DATA12 is `x%0h", read_data12), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg12

