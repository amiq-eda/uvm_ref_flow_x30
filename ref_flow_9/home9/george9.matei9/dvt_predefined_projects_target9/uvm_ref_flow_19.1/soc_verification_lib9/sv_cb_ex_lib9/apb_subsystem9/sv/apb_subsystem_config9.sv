/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_config9.svh
Title9       : APB9 Subsystem9 configuration
Project9     :
Created9     :
Description9 : This9 file contains9 multiple configuration classes9:
                apb_config9
                   master_config9
                   slave_configs9[N]
                uart_config9
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV9
`define APB_SUBSYSTEM_CTRL_CONFIG_SV9

// APB9 Subsystem9 Configuration9 Class9
class apb_subsystem_config9 extends uvm_object;

  uart_ctrl_config9 uart_cfg09;
  uart_ctrl_config9 uart_cfg19;
  spi_pkg9::spi_config9 spi_cfg9;  //Sharon9 - ok to use as is, as a shortcut9 - document9 this
  gpio_pkg9::gpio_config9 gpio_cfg9;

  `uvm_object_utils_begin(apb_subsystem_config9)
      `uvm_field_object(uart_cfg09, UVM_DEFAULT)
      `uvm_field_object(uart_cfg19, UVM_DEFAULT)
      `uvm_field_object(spi_cfg9, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg9, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config9");
    super.new(name);
    uart_cfg09 = uart_ctrl_config9::type_id::create("uart_cfg09");
    uart_cfg19 = uart_ctrl_config9::type_id::create("uart_cfg19");
    spi_cfg9   = spi_pkg9::spi_config9::type_id::create("spi_cfg9"); 
    gpio_cfg9  = gpio_pkg9::gpio_config9::type_id::create("gpio_cfg9"); 
  endfunction : new

endclass : apb_subsystem_config9

//================================================================
class default_apb_subsystem_config9 extends apb_subsystem_config9;

  `uvm_object_utils(default_apb_subsystem_config9)

  function new(string name = "default_apb_subsystem_config9");
    super.new(name);
    uart_cfg09 = uart_ctrl_config9::type_id::create("uart_cfg09");
    uart_cfg19 = uart_ctrl_config9::type_id::create("uart_cfg19");
    spi_cfg9   = spi_pkg9::spi_config9::type_id::create("spi_cfg9"); 
    gpio_cfg9  = gpio_pkg9::gpio_config9::type_id::create("gpio_cfg9"); 
    uart_cfg09.apb_cfg9.add_master9("master9", UVM_PASSIVE);
    uart_cfg09.apb_cfg9.add_slave9("spi09",  `AM_SPI0_BASE_ADDRESS9,  `AM_SPI0_END_ADDRESS9,  0, UVM_PASSIVE);
    uart_cfg09.apb_cfg9.add_slave9("uart09", `AM_UART0_BASE_ADDRESS9, `AM_UART0_END_ADDRESS9, 0, UVM_PASSIVE);
    uart_cfg09.apb_cfg9.add_slave9("gpio09", `AM_GPIO0_BASE_ADDRESS9, `AM_GPIO0_END_ADDRESS9, 0, UVM_PASSIVE);
    uart_cfg09.apb_cfg9.add_slave9("uart19", `AM_UART1_BASE_ADDRESS9, `AM_UART1_END_ADDRESS9, 1, UVM_PASSIVE);
    uart_cfg19.apb_cfg9.add_master9("master9", UVM_PASSIVE);
    uart_cfg19.apb_cfg9.add_slave9("spi09",  `AM_SPI0_BASE_ADDRESS9,  `AM_SPI0_END_ADDRESS9,  0, UVM_PASSIVE);
    uart_cfg19.apb_cfg9.add_slave9("uart09", `AM_UART0_BASE_ADDRESS9, `AM_UART0_END_ADDRESS9, 0, UVM_PASSIVE);
    uart_cfg19.apb_cfg9.add_slave9("gpio09", `AM_GPIO0_BASE_ADDRESS9, `AM_GPIO0_END_ADDRESS9, 0, UVM_PASSIVE);
    uart_cfg19.apb_cfg9.add_slave9("uart19", `AM_UART1_BASE_ADDRESS9, `AM_UART1_END_ADDRESS9, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config9

`endif // UART_CTRL_CONFIG_SV9

