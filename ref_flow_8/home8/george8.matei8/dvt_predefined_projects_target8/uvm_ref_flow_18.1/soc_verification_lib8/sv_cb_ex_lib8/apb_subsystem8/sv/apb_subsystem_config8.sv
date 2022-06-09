/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_config8.svh
Title8       : APB8 Subsystem8 configuration
Project8     :
Created8     :
Description8 : This8 file contains8 multiple configuration classes8:
                apb_config8
                   master_config8
                   slave_configs8[N]
                uart_config8
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV8
`define APB_SUBSYSTEM_CTRL_CONFIG_SV8

// APB8 Subsystem8 Configuration8 Class8
class apb_subsystem_config8 extends uvm_object;

  uart_ctrl_config8 uart_cfg08;
  uart_ctrl_config8 uart_cfg18;
  spi_pkg8::spi_config8 spi_cfg8;  //Sharon8 - ok to use as is, as a shortcut8 - document8 this
  gpio_pkg8::gpio_config8 gpio_cfg8;

  `uvm_object_utils_begin(apb_subsystem_config8)
      `uvm_field_object(uart_cfg08, UVM_DEFAULT)
      `uvm_field_object(uart_cfg18, UVM_DEFAULT)
      `uvm_field_object(spi_cfg8, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg8, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config8");
    super.new(name);
    uart_cfg08 = uart_ctrl_config8::type_id::create("uart_cfg08");
    uart_cfg18 = uart_ctrl_config8::type_id::create("uart_cfg18");
    spi_cfg8   = spi_pkg8::spi_config8::type_id::create("spi_cfg8"); 
    gpio_cfg8  = gpio_pkg8::gpio_config8::type_id::create("gpio_cfg8"); 
  endfunction : new

endclass : apb_subsystem_config8

//================================================================
class default_apb_subsystem_config8 extends apb_subsystem_config8;

  `uvm_object_utils(default_apb_subsystem_config8)

  function new(string name = "default_apb_subsystem_config8");
    super.new(name);
    uart_cfg08 = uart_ctrl_config8::type_id::create("uart_cfg08");
    uart_cfg18 = uart_ctrl_config8::type_id::create("uart_cfg18");
    spi_cfg8   = spi_pkg8::spi_config8::type_id::create("spi_cfg8"); 
    gpio_cfg8  = gpio_pkg8::gpio_config8::type_id::create("gpio_cfg8"); 
    uart_cfg08.apb_cfg8.add_master8("master8", UVM_PASSIVE);
    uart_cfg08.apb_cfg8.add_slave8("spi08",  `AM_SPI0_BASE_ADDRESS8,  `AM_SPI0_END_ADDRESS8,  0, UVM_PASSIVE);
    uart_cfg08.apb_cfg8.add_slave8("uart08", `AM_UART0_BASE_ADDRESS8, `AM_UART0_END_ADDRESS8, 0, UVM_PASSIVE);
    uart_cfg08.apb_cfg8.add_slave8("gpio08", `AM_GPIO0_BASE_ADDRESS8, `AM_GPIO0_END_ADDRESS8, 0, UVM_PASSIVE);
    uart_cfg08.apb_cfg8.add_slave8("uart18", `AM_UART1_BASE_ADDRESS8, `AM_UART1_END_ADDRESS8, 1, UVM_PASSIVE);
    uart_cfg18.apb_cfg8.add_master8("master8", UVM_PASSIVE);
    uart_cfg18.apb_cfg8.add_slave8("spi08",  `AM_SPI0_BASE_ADDRESS8,  `AM_SPI0_END_ADDRESS8,  0, UVM_PASSIVE);
    uart_cfg18.apb_cfg8.add_slave8("uart08", `AM_UART0_BASE_ADDRESS8, `AM_UART0_END_ADDRESS8, 0, UVM_PASSIVE);
    uart_cfg18.apb_cfg8.add_slave8("gpio08", `AM_GPIO0_BASE_ADDRESS8, `AM_GPIO0_END_ADDRESS8, 0, UVM_PASSIVE);
    uart_cfg18.apb_cfg8.add_slave8("uart18", `AM_UART1_BASE_ADDRESS8, `AM_UART1_END_ADDRESS8, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config8

`endif // UART_CTRL_CONFIG_SV8

