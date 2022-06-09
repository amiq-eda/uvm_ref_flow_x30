/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_config3.svh
Title3       : APB3 Subsystem3 configuration
Project3     :
Created3     :
Description3 : This3 file contains3 multiple configuration classes3:
                apb_config3
                   master_config3
                   slave_configs3[N]
                uart_config3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV3
`define APB_SUBSYSTEM_CTRL_CONFIG_SV3

// APB3 Subsystem3 Configuration3 Class3
class apb_subsystem_config3 extends uvm_object;

  uart_ctrl_config3 uart_cfg03;
  uart_ctrl_config3 uart_cfg13;
  spi_pkg3::spi_config3 spi_cfg3;  //Sharon3 - ok to use as is, as a shortcut3 - document3 this
  gpio_pkg3::gpio_config3 gpio_cfg3;

  `uvm_object_utils_begin(apb_subsystem_config3)
      `uvm_field_object(uart_cfg03, UVM_DEFAULT)
      `uvm_field_object(uart_cfg13, UVM_DEFAULT)
      `uvm_field_object(spi_cfg3, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg3, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config3");
    super.new(name);
    uart_cfg03 = uart_ctrl_config3::type_id::create("uart_cfg03");
    uart_cfg13 = uart_ctrl_config3::type_id::create("uart_cfg13");
    spi_cfg3   = spi_pkg3::spi_config3::type_id::create("spi_cfg3"); 
    gpio_cfg3  = gpio_pkg3::gpio_config3::type_id::create("gpio_cfg3"); 
  endfunction : new

endclass : apb_subsystem_config3

//================================================================
class default_apb_subsystem_config3 extends apb_subsystem_config3;

  `uvm_object_utils(default_apb_subsystem_config3)

  function new(string name = "default_apb_subsystem_config3");
    super.new(name);
    uart_cfg03 = uart_ctrl_config3::type_id::create("uart_cfg03");
    uart_cfg13 = uart_ctrl_config3::type_id::create("uart_cfg13");
    spi_cfg3   = spi_pkg3::spi_config3::type_id::create("spi_cfg3"); 
    gpio_cfg3  = gpio_pkg3::gpio_config3::type_id::create("gpio_cfg3"); 
    uart_cfg03.apb_cfg3.add_master3("master3", UVM_PASSIVE);
    uart_cfg03.apb_cfg3.add_slave3("spi03",  `AM_SPI0_BASE_ADDRESS3,  `AM_SPI0_END_ADDRESS3,  0, UVM_PASSIVE);
    uart_cfg03.apb_cfg3.add_slave3("uart03", `AM_UART0_BASE_ADDRESS3, `AM_UART0_END_ADDRESS3, 0, UVM_PASSIVE);
    uart_cfg03.apb_cfg3.add_slave3("gpio03", `AM_GPIO0_BASE_ADDRESS3, `AM_GPIO0_END_ADDRESS3, 0, UVM_PASSIVE);
    uart_cfg03.apb_cfg3.add_slave3("uart13", `AM_UART1_BASE_ADDRESS3, `AM_UART1_END_ADDRESS3, 1, UVM_PASSIVE);
    uart_cfg13.apb_cfg3.add_master3("master3", UVM_PASSIVE);
    uart_cfg13.apb_cfg3.add_slave3("spi03",  `AM_SPI0_BASE_ADDRESS3,  `AM_SPI0_END_ADDRESS3,  0, UVM_PASSIVE);
    uart_cfg13.apb_cfg3.add_slave3("uart03", `AM_UART0_BASE_ADDRESS3, `AM_UART0_END_ADDRESS3, 0, UVM_PASSIVE);
    uart_cfg13.apb_cfg3.add_slave3("gpio03", `AM_GPIO0_BASE_ADDRESS3, `AM_GPIO0_END_ADDRESS3, 0, UVM_PASSIVE);
    uart_cfg13.apb_cfg3.add_slave3("uart13", `AM_UART1_BASE_ADDRESS3, `AM_UART1_END_ADDRESS3, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config3

`endif // UART_CTRL_CONFIG_SV3

