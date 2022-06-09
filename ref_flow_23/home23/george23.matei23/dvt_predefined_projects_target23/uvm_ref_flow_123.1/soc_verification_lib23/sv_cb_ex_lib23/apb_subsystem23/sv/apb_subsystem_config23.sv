/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_config23.svh
Title23       : APB23 Subsystem23 configuration
Project23     :
Created23     :
Description23 : This23 file contains23 multiple configuration classes23:
                apb_config23
                   master_config23
                   slave_configs23[N]
                uart_config23
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV23
`define APB_SUBSYSTEM_CTRL_CONFIG_SV23

// APB23 Subsystem23 Configuration23 Class23
class apb_subsystem_config23 extends uvm_object;

  uart_ctrl_config23 uart_cfg023;
  uart_ctrl_config23 uart_cfg123;
  spi_pkg23::spi_config23 spi_cfg23;  //Sharon23 - ok to use as is, as a shortcut23 - document23 this
  gpio_pkg23::gpio_config23 gpio_cfg23;

  `uvm_object_utils_begin(apb_subsystem_config23)
      `uvm_field_object(uart_cfg023, UVM_DEFAULT)
      `uvm_field_object(uart_cfg123, UVM_DEFAULT)
      `uvm_field_object(spi_cfg23, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg23, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config23");
    super.new(name);
    uart_cfg023 = uart_ctrl_config23::type_id::create("uart_cfg023");
    uart_cfg123 = uart_ctrl_config23::type_id::create("uart_cfg123");
    spi_cfg23   = spi_pkg23::spi_config23::type_id::create("spi_cfg23"); 
    gpio_cfg23  = gpio_pkg23::gpio_config23::type_id::create("gpio_cfg23"); 
  endfunction : new

endclass : apb_subsystem_config23

//================================================================
class default_apb_subsystem_config23 extends apb_subsystem_config23;

  `uvm_object_utils(default_apb_subsystem_config23)

  function new(string name = "default_apb_subsystem_config23");
    super.new(name);
    uart_cfg023 = uart_ctrl_config23::type_id::create("uart_cfg023");
    uart_cfg123 = uart_ctrl_config23::type_id::create("uart_cfg123");
    spi_cfg23   = spi_pkg23::spi_config23::type_id::create("spi_cfg23"); 
    gpio_cfg23  = gpio_pkg23::gpio_config23::type_id::create("gpio_cfg23"); 
    uart_cfg023.apb_cfg23.add_master23("master23", UVM_PASSIVE);
    uart_cfg023.apb_cfg23.add_slave23("spi023",  `AM_SPI0_BASE_ADDRESS23,  `AM_SPI0_END_ADDRESS23,  0, UVM_PASSIVE);
    uart_cfg023.apb_cfg23.add_slave23("uart023", `AM_UART0_BASE_ADDRESS23, `AM_UART0_END_ADDRESS23, 0, UVM_PASSIVE);
    uart_cfg023.apb_cfg23.add_slave23("gpio023", `AM_GPIO0_BASE_ADDRESS23, `AM_GPIO0_END_ADDRESS23, 0, UVM_PASSIVE);
    uart_cfg023.apb_cfg23.add_slave23("uart123", `AM_UART1_BASE_ADDRESS23, `AM_UART1_END_ADDRESS23, 1, UVM_PASSIVE);
    uart_cfg123.apb_cfg23.add_master23("master23", UVM_PASSIVE);
    uart_cfg123.apb_cfg23.add_slave23("spi023",  `AM_SPI0_BASE_ADDRESS23,  `AM_SPI0_END_ADDRESS23,  0, UVM_PASSIVE);
    uart_cfg123.apb_cfg23.add_slave23("uart023", `AM_UART0_BASE_ADDRESS23, `AM_UART0_END_ADDRESS23, 0, UVM_PASSIVE);
    uart_cfg123.apb_cfg23.add_slave23("gpio023", `AM_GPIO0_BASE_ADDRESS23, `AM_GPIO0_END_ADDRESS23, 0, UVM_PASSIVE);
    uart_cfg123.apb_cfg23.add_slave23("uart123", `AM_UART1_BASE_ADDRESS23, `AM_UART1_END_ADDRESS23, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config23

`endif // UART_CTRL_CONFIG_SV23

