/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_config30.svh
Title30       : APB30 Subsystem30 configuration
Project30     :
Created30     :
Description30 : This30 file contains30 multiple configuration classes30:
                apb_config30
                   master_config30
                   slave_configs30[N]
                uart_config30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV30
`define APB_SUBSYSTEM_CTRL_CONFIG_SV30

// APB30 Subsystem30 Configuration30 Class30
class apb_subsystem_config30 extends uvm_object;

  uart_ctrl_config30 uart_cfg030;
  uart_ctrl_config30 uart_cfg130;
  spi_pkg30::spi_config30 spi_cfg30;  //Sharon30 - ok to use as is, as a shortcut30 - document30 this
  gpio_pkg30::gpio_config30 gpio_cfg30;

  `uvm_object_utils_begin(apb_subsystem_config30)
      `uvm_field_object(uart_cfg030, UVM_DEFAULT)
      `uvm_field_object(uart_cfg130, UVM_DEFAULT)
      `uvm_field_object(spi_cfg30, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg30, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config30");
    super.new(name);
    uart_cfg030 = uart_ctrl_config30::type_id::create("uart_cfg030");
    uart_cfg130 = uart_ctrl_config30::type_id::create("uart_cfg130");
    spi_cfg30   = spi_pkg30::spi_config30::type_id::create("spi_cfg30"); 
    gpio_cfg30  = gpio_pkg30::gpio_config30::type_id::create("gpio_cfg30"); 
  endfunction : new

endclass : apb_subsystem_config30

//================================================================
class default_apb_subsystem_config30 extends apb_subsystem_config30;

  `uvm_object_utils(default_apb_subsystem_config30)

  function new(string name = "default_apb_subsystem_config30");
    super.new(name);
    uart_cfg030 = uart_ctrl_config30::type_id::create("uart_cfg030");
    uart_cfg130 = uart_ctrl_config30::type_id::create("uart_cfg130");
    spi_cfg30   = spi_pkg30::spi_config30::type_id::create("spi_cfg30"); 
    gpio_cfg30  = gpio_pkg30::gpio_config30::type_id::create("gpio_cfg30"); 
    uart_cfg030.apb_cfg30.add_master30("master30", UVM_PASSIVE);
    uart_cfg030.apb_cfg30.add_slave30("spi030",  `AM_SPI0_BASE_ADDRESS30,  `AM_SPI0_END_ADDRESS30,  0, UVM_PASSIVE);
    uart_cfg030.apb_cfg30.add_slave30("uart030", `AM_UART0_BASE_ADDRESS30, `AM_UART0_END_ADDRESS30, 0, UVM_PASSIVE);
    uart_cfg030.apb_cfg30.add_slave30("gpio030", `AM_GPIO0_BASE_ADDRESS30, `AM_GPIO0_END_ADDRESS30, 0, UVM_PASSIVE);
    uart_cfg030.apb_cfg30.add_slave30("uart130", `AM_UART1_BASE_ADDRESS30, `AM_UART1_END_ADDRESS30, 1, UVM_PASSIVE);
    uart_cfg130.apb_cfg30.add_master30("master30", UVM_PASSIVE);
    uart_cfg130.apb_cfg30.add_slave30("spi030",  `AM_SPI0_BASE_ADDRESS30,  `AM_SPI0_END_ADDRESS30,  0, UVM_PASSIVE);
    uart_cfg130.apb_cfg30.add_slave30("uart030", `AM_UART0_BASE_ADDRESS30, `AM_UART0_END_ADDRESS30, 0, UVM_PASSIVE);
    uart_cfg130.apb_cfg30.add_slave30("gpio030", `AM_GPIO0_BASE_ADDRESS30, `AM_GPIO0_END_ADDRESS30, 0, UVM_PASSIVE);
    uart_cfg130.apb_cfg30.add_slave30("uart130", `AM_UART1_BASE_ADDRESS30, `AM_UART1_END_ADDRESS30, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config30

`endif // UART_CTRL_CONFIG_SV30

