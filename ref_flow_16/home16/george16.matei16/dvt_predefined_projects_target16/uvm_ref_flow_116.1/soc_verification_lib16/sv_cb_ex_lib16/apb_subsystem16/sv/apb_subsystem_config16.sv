/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_config16.svh
Title16       : APB16 Subsystem16 configuration
Project16     :
Created16     :
Description16 : This16 file contains16 multiple configuration classes16:
                apb_config16
                   master_config16
                   slave_configs16[N]
                uart_config16
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV16
`define APB_SUBSYSTEM_CTRL_CONFIG_SV16

// APB16 Subsystem16 Configuration16 Class16
class apb_subsystem_config16 extends uvm_object;

  uart_ctrl_config16 uart_cfg016;
  uart_ctrl_config16 uart_cfg116;
  spi_pkg16::spi_config16 spi_cfg16;  //Sharon16 - ok to use as is, as a shortcut16 - document16 this
  gpio_pkg16::gpio_config16 gpio_cfg16;

  `uvm_object_utils_begin(apb_subsystem_config16)
      `uvm_field_object(uart_cfg016, UVM_DEFAULT)
      `uvm_field_object(uart_cfg116, UVM_DEFAULT)
      `uvm_field_object(spi_cfg16, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg16, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config16");
    super.new(name);
    uart_cfg016 = uart_ctrl_config16::type_id::create("uart_cfg016");
    uart_cfg116 = uart_ctrl_config16::type_id::create("uart_cfg116");
    spi_cfg16   = spi_pkg16::spi_config16::type_id::create("spi_cfg16"); 
    gpio_cfg16  = gpio_pkg16::gpio_config16::type_id::create("gpio_cfg16"); 
  endfunction : new

endclass : apb_subsystem_config16

//================================================================
class default_apb_subsystem_config16 extends apb_subsystem_config16;

  `uvm_object_utils(default_apb_subsystem_config16)

  function new(string name = "default_apb_subsystem_config16");
    super.new(name);
    uart_cfg016 = uart_ctrl_config16::type_id::create("uart_cfg016");
    uart_cfg116 = uart_ctrl_config16::type_id::create("uart_cfg116");
    spi_cfg16   = spi_pkg16::spi_config16::type_id::create("spi_cfg16"); 
    gpio_cfg16  = gpio_pkg16::gpio_config16::type_id::create("gpio_cfg16"); 
    uart_cfg016.apb_cfg16.add_master16("master16", UVM_PASSIVE);
    uart_cfg016.apb_cfg16.add_slave16("spi016",  `AM_SPI0_BASE_ADDRESS16,  `AM_SPI0_END_ADDRESS16,  0, UVM_PASSIVE);
    uart_cfg016.apb_cfg16.add_slave16("uart016", `AM_UART0_BASE_ADDRESS16, `AM_UART0_END_ADDRESS16, 0, UVM_PASSIVE);
    uart_cfg016.apb_cfg16.add_slave16("gpio016", `AM_GPIO0_BASE_ADDRESS16, `AM_GPIO0_END_ADDRESS16, 0, UVM_PASSIVE);
    uart_cfg016.apb_cfg16.add_slave16("uart116", `AM_UART1_BASE_ADDRESS16, `AM_UART1_END_ADDRESS16, 1, UVM_PASSIVE);
    uart_cfg116.apb_cfg16.add_master16("master16", UVM_PASSIVE);
    uart_cfg116.apb_cfg16.add_slave16("spi016",  `AM_SPI0_BASE_ADDRESS16,  `AM_SPI0_END_ADDRESS16,  0, UVM_PASSIVE);
    uart_cfg116.apb_cfg16.add_slave16("uart016", `AM_UART0_BASE_ADDRESS16, `AM_UART0_END_ADDRESS16, 0, UVM_PASSIVE);
    uart_cfg116.apb_cfg16.add_slave16("gpio016", `AM_GPIO0_BASE_ADDRESS16, `AM_GPIO0_END_ADDRESS16, 0, UVM_PASSIVE);
    uart_cfg116.apb_cfg16.add_slave16("uart116", `AM_UART1_BASE_ADDRESS16, `AM_UART1_END_ADDRESS16, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config16

`endif // UART_CTRL_CONFIG_SV16

