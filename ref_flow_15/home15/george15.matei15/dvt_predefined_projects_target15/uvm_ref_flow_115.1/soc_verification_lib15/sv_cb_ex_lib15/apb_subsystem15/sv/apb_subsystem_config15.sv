/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_config15.svh
Title15       : APB15 Subsystem15 configuration
Project15     :
Created15     :
Description15 : This15 file contains15 multiple configuration classes15:
                apb_config15
                   master_config15
                   slave_configs15[N]
                uart_config15
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV15
`define APB_SUBSYSTEM_CTRL_CONFIG_SV15

// APB15 Subsystem15 Configuration15 Class15
class apb_subsystem_config15 extends uvm_object;

  uart_ctrl_config15 uart_cfg015;
  uart_ctrl_config15 uart_cfg115;
  spi_pkg15::spi_config15 spi_cfg15;  //Sharon15 - ok to use as is, as a shortcut15 - document15 this
  gpio_pkg15::gpio_config15 gpio_cfg15;

  `uvm_object_utils_begin(apb_subsystem_config15)
      `uvm_field_object(uart_cfg015, UVM_DEFAULT)
      `uvm_field_object(uart_cfg115, UVM_DEFAULT)
      `uvm_field_object(spi_cfg15, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg15, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config15");
    super.new(name);
    uart_cfg015 = uart_ctrl_config15::type_id::create("uart_cfg015");
    uart_cfg115 = uart_ctrl_config15::type_id::create("uart_cfg115");
    spi_cfg15   = spi_pkg15::spi_config15::type_id::create("spi_cfg15"); 
    gpio_cfg15  = gpio_pkg15::gpio_config15::type_id::create("gpio_cfg15"); 
  endfunction : new

endclass : apb_subsystem_config15

//================================================================
class default_apb_subsystem_config15 extends apb_subsystem_config15;

  `uvm_object_utils(default_apb_subsystem_config15)

  function new(string name = "default_apb_subsystem_config15");
    super.new(name);
    uart_cfg015 = uart_ctrl_config15::type_id::create("uart_cfg015");
    uart_cfg115 = uart_ctrl_config15::type_id::create("uart_cfg115");
    spi_cfg15   = spi_pkg15::spi_config15::type_id::create("spi_cfg15"); 
    gpio_cfg15  = gpio_pkg15::gpio_config15::type_id::create("gpio_cfg15"); 
    uart_cfg015.apb_cfg15.add_master15("master15", UVM_PASSIVE);
    uart_cfg015.apb_cfg15.add_slave15("spi015",  `AM_SPI0_BASE_ADDRESS15,  `AM_SPI0_END_ADDRESS15,  0, UVM_PASSIVE);
    uart_cfg015.apb_cfg15.add_slave15("uart015", `AM_UART0_BASE_ADDRESS15, `AM_UART0_END_ADDRESS15, 0, UVM_PASSIVE);
    uart_cfg015.apb_cfg15.add_slave15("gpio015", `AM_GPIO0_BASE_ADDRESS15, `AM_GPIO0_END_ADDRESS15, 0, UVM_PASSIVE);
    uart_cfg015.apb_cfg15.add_slave15("uart115", `AM_UART1_BASE_ADDRESS15, `AM_UART1_END_ADDRESS15, 1, UVM_PASSIVE);
    uart_cfg115.apb_cfg15.add_master15("master15", UVM_PASSIVE);
    uart_cfg115.apb_cfg15.add_slave15("spi015",  `AM_SPI0_BASE_ADDRESS15,  `AM_SPI0_END_ADDRESS15,  0, UVM_PASSIVE);
    uart_cfg115.apb_cfg15.add_slave15("uart015", `AM_UART0_BASE_ADDRESS15, `AM_UART0_END_ADDRESS15, 0, UVM_PASSIVE);
    uart_cfg115.apb_cfg15.add_slave15("gpio015", `AM_GPIO0_BASE_ADDRESS15, `AM_GPIO0_END_ADDRESS15, 0, UVM_PASSIVE);
    uart_cfg115.apb_cfg15.add_slave15("uart115", `AM_UART1_BASE_ADDRESS15, `AM_UART1_END_ADDRESS15, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config15

`endif // UART_CTRL_CONFIG_SV15

