/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_config27.svh
Title27       : APB27 Subsystem27 configuration
Project27     :
Created27     :
Description27 : This27 file contains27 multiple configuration classes27:
                apb_config27
                   master_config27
                   slave_configs27[N]
                uart_config27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV27
`define APB_SUBSYSTEM_CTRL_CONFIG_SV27

// APB27 Subsystem27 Configuration27 Class27
class apb_subsystem_config27 extends uvm_object;

  uart_ctrl_config27 uart_cfg027;
  uart_ctrl_config27 uart_cfg127;
  spi_pkg27::spi_config27 spi_cfg27;  //Sharon27 - ok to use as is, as a shortcut27 - document27 this
  gpio_pkg27::gpio_config27 gpio_cfg27;

  `uvm_object_utils_begin(apb_subsystem_config27)
      `uvm_field_object(uart_cfg027, UVM_DEFAULT)
      `uvm_field_object(uart_cfg127, UVM_DEFAULT)
      `uvm_field_object(spi_cfg27, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg27, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config27");
    super.new(name);
    uart_cfg027 = uart_ctrl_config27::type_id::create("uart_cfg027");
    uart_cfg127 = uart_ctrl_config27::type_id::create("uart_cfg127");
    spi_cfg27   = spi_pkg27::spi_config27::type_id::create("spi_cfg27"); 
    gpio_cfg27  = gpio_pkg27::gpio_config27::type_id::create("gpio_cfg27"); 
  endfunction : new

endclass : apb_subsystem_config27

//================================================================
class default_apb_subsystem_config27 extends apb_subsystem_config27;

  `uvm_object_utils(default_apb_subsystem_config27)

  function new(string name = "default_apb_subsystem_config27");
    super.new(name);
    uart_cfg027 = uart_ctrl_config27::type_id::create("uart_cfg027");
    uart_cfg127 = uart_ctrl_config27::type_id::create("uart_cfg127");
    spi_cfg27   = spi_pkg27::spi_config27::type_id::create("spi_cfg27"); 
    gpio_cfg27  = gpio_pkg27::gpio_config27::type_id::create("gpio_cfg27"); 
    uart_cfg027.apb_cfg27.add_master27("master27", UVM_PASSIVE);
    uart_cfg027.apb_cfg27.add_slave27("spi027",  `AM_SPI0_BASE_ADDRESS27,  `AM_SPI0_END_ADDRESS27,  0, UVM_PASSIVE);
    uart_cfg027.apb_cfg27.add_slave27("uart027", `AM_UART0_BASE_ADDRESS27, `AM_UART0_END_ADDRESS27, 0, UVM_PASSIVE);
    uart_cfg027.apb_cfg27.add_slave27("gpio027", `AM_GPIO0_BASE_ADDRESS27, `AM_GPIO0_END_ADDRESS27, 0, UVM_PASSIVE);
    uart_cfg027.apb_cfg27.add_slave27("uart127", `AM_UART1_BASE_ADDRESS27, `AM_UART1_END_ADDRESS27, 1, UVM_PASSIVE);
    uart_cfg127.apb_cfg27.add_master27("master27", UVM_PASSIVE);
    uart_cfg127.apb_cfg27.add_slave27("spi027",  `AM_SPI0_BASE_ADDRESS27,  `AM_SPI0_END_ADDRESS27,  0, UVM_PASSIVE);
    uart_cfg127.apb_cfg27.add_slave27("uart027", `AM_UART0_BASE_ADDRESS27, `AM_UART0_END_ADDRESS27, 0, UVM_PASSIVE);
    uart_cfg127.apb_cfg27.add_slave27("gpio027", `AM_GPIO0_BASE_ADDRESS27, `AM_GPIO0_END_ADDRESS27, 0, UVM_PASSIVE);
    uart_cfg127.apb_cfg27.add_slave27("uart127", `AM_UART1_BASE_ADDRESS27, `AM_UART1_END_ADDRESS27, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config27

`endif // UART_CTRL_CONFIG_SV27

