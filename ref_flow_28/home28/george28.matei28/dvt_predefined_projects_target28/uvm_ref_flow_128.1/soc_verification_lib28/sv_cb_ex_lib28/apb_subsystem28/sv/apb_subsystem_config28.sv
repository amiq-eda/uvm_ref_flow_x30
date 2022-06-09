/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_config28.svh
Title28       : APB28 Subsystem28 configuration
Project28     :
Created28     :
Description28 : This28 file contains28 multiple configuration classes28:
                apb_config28
                   master_config28
                   slave_configs28[N]
                uart_config28
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV28
`define APB_SUBSYSTEM_CTRL_CONFIG_SV28

// APB28 Subsystem28 Configuration28 Class28
class apb_subsystem_config28 extends uvm_object;

  uart_ctrl_config28 uart_cfg028;
  uart_ctrl_config28 uart_cfg128;
  spi_pkg28::spi_config28 spi_cfg28;  //Sharon28 - ok to use as is, as a shortcut28 - document28 this
  gpio_pkg28::gpio_config28 gpio_cfg28;

  `uvm_object_utils_begin(apb_subsystem_config28)
      `uvm_field_object(uart_cfg028, UVM_DEFAULT)
      `uvm_field_object(uart_cfg128, UVM_DEFAULT)
      `uvm_field_object(spi_cfg28, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg28, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config28");
    super.new(name);
    uart_cfg028 = uart_ctrl_config28::type_id::create("uart_cfg028");
    uart_cfg128 = uart_ctrl_config28::type_id::create("uart_cfg128");
    spi_cfg28   = spi_pkg28::spi_config28::type_id::create("spi_cfg28"); 
    gpio_cfg28  = gpio_pkg28::gpio_config28::type_id::create("gpio_cfg28"); 
  endfunction : new

endclass : apb_subsystem_config28

//================================================================
class default_apb_subsystem_config28 extends apb_subsystem_config28;

  `uvm_object_utils(default_apb_subsystem_config28)

  function new(string name = "default_apb_subsystem_config28");
    super.new(name);
    uart_cfg028 = uart_ctrl_config28::type_id::create("uart_cfg028");
    uart_cfg128 = uart_ctrl_config28::type_id::create("uart_cfg128");
    spi_cfg28   = spi_pkg28::spi_config28::type_id::create("spi_cfg28"); 
    gpio_cfg28  = gpio_pkg28::gpio_config28::type_id::create("gpio_cfg28"); 
    uart_cfg028.apb_cfg28.add_master28("master28", UVM_PASSIVE);
    uart_cfg028.apb_cfg28.add_slave28("spi028",  `AM_SPI0_BASE_ADDRESS28,  `AM_SPI0_END_ADDRESS28,  0, UVM_PASSIVE);
    uart_cfg028.apb_cfg28.add_slave28("uart028", `AM_UART0_BASE_ADDRESS28, `AM_UART0_END_ADDRESS28, 0, UVM_PASSIVE);
    uart_cfg028.apb_cfg28.add_slave28("gpio028", `AM_GPIO0_BASE_ADDRESS28, `AM_GPIO0_END_ADDRESS28, 0, UVM_PASSIVE);
    uart_cfg028.apb_cfg28.add_slave28("uart128", `AM_UART1_BASE_ADDRESS28, `AM_UART1_END_ADDRESS28, 1, UVM_PASSIVE);
    uart_cfg128.apb_cfg28.add_master28("master28", UVM_PASSIVE);
    uart_cfg128.apb_cfg28.add_slave28("spi028",  `AM_SPI0_BASE_ADDRESS28,  `AM_SPI0_END_ADDRESS28,  0, UVM_PASSIVE);
    uart_cfg128.apb_cfg28.add_slave28("uart028", `AM_UART0_BASE_ADDRESS28, `AM_UART0_END_ADDRESS28, 0, UVM_PASSIVE);
    uart_cfg128.apb_cfg28.add_slave28("gpio028", `AM_GPIO0_BASE_ADDRESS28, `AM_GPIO0_END_ADDRESS28, 0, UVM_PASSIVE);
    uart_cfg128.apb_cfg28.add_slave28("uart128", `AM_UART1_BASE_ADDRESS28, `AM_UART1_END_ADDRESS28, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config28

`endif // UART_CTRL_CONFIG_SV28

