/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_config19.svh
Title19       : APB19 Subsystem19 configuration
Project19     :
Created19     :
Description19 : This19 file contains19 multiple configuration classes19:
                apb_config19
                   master_config19
                   slave_configs19[N]
                uart_config19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV19
`define APB_SUBSYSTEM_CTRL_CONFIG_SV19

// APB19 Subsystem19 Configuration19 Class19
class apb_subsystem_config19 extends uvm_object;

  uart_ctrl_config19 uart_cfg019;
  uart_ctrl_config19 uart_cfg119;
  spi_pkg19::spi_config19 spi_cfg19;  //Sharon19 - ok to use as is, as a shortcut19 - document19 this
  gpio_pkg19::gpio_config19 gpio_cfg19;

  `uvm_object_utils_begin(apb_subsystem_config19)
      `uvm_field_object(uart_cfg019, UVM_DEFAULT)
      `uvm_field_object(uart_cfg119, UVM_DEFAULT)
      `uvm_field_object(spi_cfg19, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg19, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config19");
    super.new(name);
    uart_cfg019 = uart_ctrl_config19::type_id::create("uart_cfg019");
    uart_cfg119 = uart_ctrl_config19::type_id::create("uart_cfg119");
    spi_cfg19   = spi_pkg19::spi_config19::type_id::create("spi_cfg19"); 
    gpio_cfg19  = gpio_pkg19::gpio_config19::type_id::create("gpio_cfg19"); 
  endfunction : new

endclass : apb_subsystem_config19

//================================================================
class default_apb_subsystem_config19 extends apb_subsystem_config19;

  `uvm_object_utils(default_apb_subsystem_config19)

  function new(string name = "default_apb_subsystem_config19");
    super.new(name);
    uart_cfg019 = uart_ctrl_config19::type_id::create("uart_cfg019");
    uart_cfg119 = uart_ctrl_config19::type_id::create("uart_cfg119");
    spi_cfg19   = spi_pkg19::spi_config19::type_id::create("spi_cfg19"); 
    gpio_cfg19  = gpio_pkg19::gpio_config19::type_id::create("gpio_cfg19"); 
    uart_cfg019.apb_cfg19.add_master19("master19", UVM_PASSIVE);
    uart_cfg019.apb_cfg19.add_slave19("spi019",  `AM_SPI0_BASE_ADDRESS19,  `AM_SPI0_END_ADDRESS19,  0, UVM_PASSIVE);
    uart_cfg019.apb_cfg19.add_slave19("uart019", `AM_UART0_BASE_ADDRESS19, `AM_UART0_END_ADDRESS19, 0, UVM_PASSIVE);
    uart_cfg019.apb_cfg19.add_slave19("gpio019", `AM_GPIO0_BASE_ADDRESS19, `AM_GPIO0_END_ADDRESS19, 0, UVM_PASSIVE);
    uart_cfg019.apb_cfg19.add_slave19("uart119", `AM_UART1_BASE_ADDRESS19, `AM_UART1_END_ADDRESS19, 1, UVM_PASSIVE);
    uart_cfg119.apb_cfg19.add_master19("master19", UVM_PASSIVE);
    uart_cfg119.apb_cfg19.add_slave19("spi019",  `AM_SPI0_BASE_ADDRESS19,  `AM_SPI0_END_ADDRESS19,  0, UVM_PASSIVE);
    uart_cfg119.apb_cfg19.add_slave19("uart019", `AM_UART0_BASE_ADDRESS19, `AM_UART0_END_ADDRESS19, 0, UVM_PASSIVE);
    uart_cfg119.apb_cfg19.add_slave19("gpio019", `AM_GPIO0_BASE_ADDRESS19, `AM_GPIO0_END_ADDRESS19, 0, UVM_PASSIVE);
    uart_cfg119.apb_cfg19.add_slave19("uart119", `AM_UART1_BASE_ADDRESS19, `AM_UART1_END_ADDRESS19, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config19

`endif // UART_CTRL_CONFIG_SV19

