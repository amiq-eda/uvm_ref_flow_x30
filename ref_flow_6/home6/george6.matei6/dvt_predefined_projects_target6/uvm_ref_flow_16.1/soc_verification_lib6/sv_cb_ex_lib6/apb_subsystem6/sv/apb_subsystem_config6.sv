/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_config6.svh
Title6       : APB6 Subsystem6 configuration
Project6     :
Created6     :
Description6 : This6 file contains6 multiple configuration classes6:
                apb_config6
                   master_config6
                   slave_configs6[N]
                uart_config6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV6
`define APB_SUBSYSTEM_CTRL_CONFIG_SV6

// APB6 Subsystem6 Configuration6 Class6
class apb_subsystem_config6 extends uvm_object;

  uart_ctrl_config6 uart_cfg06;
  uart_ctrl_config6 uart_cfg16;
  spi_pkg6::spi_config6 spi_cfg6;  //Sharon6 - ok to use as is, as a shortcut6 - document6 this
  gpio_pkg6::gpio_config6 gpio_cfg6;

  `uvm_object_utils_begin(apb_subsystem_config6)
      `uvm_field_object(uart_cfg06, UVM_DEFAULT)
      `uvm_field_object(uart_cfg16, UVM_DEFAULT)
      `uvm_field_object(spi_cfg6, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg6, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config6");
    super.new(name);
    uart_cfg06 = uart_ctrl_config6::type_id::create("uart_cfg06");
    uart_cfg16 = uart_ctrl_config6::type_id::create("uart_cfg16");
    spi_cfg6   = spi_pkg6::spi_config6::type_id::create("spi_cfg6"); 
    gpio_cfg6  = gpio_pkg6::gpio_config6::type_id::create("gpio_cfg6"); 
  endfunction : new

endclass : apb_subsystem_config6

//================================================================
class default_apb_subsystem_config6 extends apb_subsystem_config6;

  `uvm_object_utils(default_apb_subsystem_config6)

  function new(string name = "default_apb_subsystem_config6");
    super.new(name);
    uart_cfg06 = uart_ctrl_config6::type_id::create("uart_cfg06");
    uart_cfg16 = uart_ctrl_config6::type_id::create("uart_cfg16");
    spi_cfg6   = spi_pkg6::spi_config6::type_id::create("spi_cfg6"); 
    gpio_cfg6  = gpio_pkg6::gpio_config6::type_id::create("gpio_cfg6"); 
    uart_cfg06.apb_cfg6.add_master6("master6", UVM_PASSIVE);
    uart_cfg06.apb_cfg6.add_slave6("spi06",  `AM_SPI0_BASE_ADDRESS6,  `AM_SPI0_END_ADDRESS6,  0, UVM_PASSIVE);
    uart_cfg06.apb_cfg6.add_slave6("uart06", `AM_UART0_BASE_ADDRESS6, `AM_UART0_END_ADDRESS6, 0, UVM_PASSIVE);
    uart_cfg06.apb_cfg6.add_slave6("gpio06", `AM_GPIO0_BASE_ADDRESS6, `AM_GPIO0_END_ADDRESS6, 0, UVM_PASSIVE);
    uart_cfg06.apb_cfg6.add_slave6("uart16", `AM_UART1_BASE_ADDRESS6, `AM_UART1_END_ADDRESS6, 1, UVM_PASSIVE);
    uart_cfg16.apb_cfg6.add_master6("master6", UVM_PASSIVE);
    uart_cfg16.apb_cfg6.add_slave6("spi06",  `AM_SPI0_BASE_ADDRESS6,  `AM_SPI0_END_ADDRESS6,  0, UVM_PASSIVE);
    uart_cfg16.apb_cfg6.add_slave6("uart06", `AM_UART0_BASE_ADDRESS6, `AM_UART0_END_ADDRESS6, 0, UVM_PASSIVE);
    uart_cfg16.apb_cfg6.add_slave6("gpio06", `AM_GPIO0_BASE_ADDRESS6, `AM_GPIO0_END_ADDRESS6, 0, UVM_PASSIVE);
    uart_cfg16.apb_cfg6.add_slave6("uart16", `AM_UART1_BASE_ADDRESS6, `AM_UART1_END_ADDRESS6, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config6

`endif // UART_CTRL_CONFIG_SV6

