/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_config26.svh
Title26       : APB26 Subsystem26 configuration
Project26     :
Created26     :
Description26 : This26 file contains26 multiple configuration classes26:
                apb_config26
                   master_config26
                   slave_configs26[N]
                uart_config26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV26
`define APB_SUBSYSTEM_CTRL_CONFIG_SV26

// APB26 Subsystem26 Configuration26 Class26
class apb_subsystem_config26 extends uvm_object;

  uart_ctrl_config26 uart_cfg026;
  uart_ctrl_config26 uart_cfg126;
  spi_pkg26::spi_config26 spi_cfg26;  //Sharon26 - ok to use as is, as a shortcut26 - document26 this
  gpio_pkg26::gpio_config26 gpio_cfg26;

  `uvm_object_utils_begin(apb_subsystem_config26)
      `uvm_field_object(uart_cfg026, UVM_DEFAULT)
      `uvm_field_object(uart_cfg126, UVM_DEFAULT)
      `uvm_field_object(spi_cfg26, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg26, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config26");
    super.new(name);
    uart_cfg026 = uart_ctrl_config26::type_id::create("uart_cfg026");
    uart_cfg126 = uart_ctrl_config26::type_id::create("uart_cfg126");
    spi_cfg26   = spi_pkg26::spi_config26::type_id::create("spi_cfg26"); 
    gpio_cfg26  = gpio_pkg26::gpio_config26::type_id::create("gpio_cfg26"); 
  endfunction : new

endclass : apb_subsystem_config26

//================================================================
class default_apb_subsystem_config26 extends apb_subsystem_config26;

  `uvm_object_utils(default_apb_subsystem_config26)

  function new(string name = "default_apb_subsystem_config26");
    super.new(name);
    uart_cfg026 = uart_ctrl_config26::type_id::create("uart_cfg026");
    uart_cfg126 = uart_ctrl_config26::type_id::create("uart_cfg126");
    spi_cfg26   = spi_pkg26::spi_config26::type_id::create("spi_cfg26"); 
    gpio_cfg26  = gpio_pkg26::gpio_config26::type_id::create("gpio_cfg26"); 
    uart_cfg026.apb_cfg26.add_master26("master26", UVM_PASSIVE);
    uart_cfg026.apb_cfg26.add_slave26("spi026",  `AM_SPI0_BASE_ADDRESS26,  `AM_SPI0_END_ADDRESS26,  0, UVM_PASSIVE);
    uart_cfg026.apb_cfg26.add_slave26("uart026", `AM_UART0_BASE_ADDRESS26, `AM_UART0_END_ADDRESS26, 0, UVM_PASSIVE);
    uart_cfg026.apb_cfg26.add_slave26("gpio026", `AM_GPIO0_BASE_ADDRESS26, `AM_GPIO0_END_ADDRESS26, 0, UVM_PASSIVE);
    uart_cfg026.apb_cfg26.add_slave26("uart126", `AM_UART1_BASE_ADDRESS26, `AM_UART1_END_ADDRESS26, 1, UVM_PASSIVE);
    uart_cfg126.apb_cfg26.add_master26("master26", UVM_PASSIVE);
    uart_cfg126.apb_cfg26.add_slave26("spi026",  `AM_SPI0_BASE_ADDRESS26,  `AM_SPI0_END_ADDRESS26,  0, UVM_PASSIVE);
    uart_cfg126.apb_cfg26.add_slave26("uart026", `AM_UART0_BASE_ADDRESS26, `AM_UART0_END_ADDRESS26, 0, UVM_PASSIVE);
    uart_cfg126.apb_cfg26.add_slave26("gpio026", `AM_GPIO0_BASE_ADDRESS26, `AM_GPIO0_END_ADDRESS26, 0, UVM_PASSIVE);
    uart_cfg126.apb_cfg26.add_slave26("uart126", `AM_UART1_BASE_ADDRESS26, `AM_UART1_END_ADDRESS26, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config26

`endif // UART_CTRL_CONFIG_SV26

