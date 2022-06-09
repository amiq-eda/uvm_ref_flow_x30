/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_config17.svh
Title17       : APB17 Subsystem17 configuration
Project17     :
Created17     :
Description17 : This17 file contains17 multiple configuration classes17:
                apb_config17
                   master_config17
                   slave_configs17[N]
                uart_config17
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV17
`define APB_SUBSYSTEM_CTRL_CONFIG_SV17

// APB17 Subsystem17 Configuration17 Class17
class apb_subsystem_config17 extends uvm_object;

  uart_ctrl_config17 uart_cfg017;
  uart_ctrl_config17 uart_cfg117;
  spi_pkg17::spi_config17 spi_cfg17;  //Sharon17 - ok to use as is, as a shortcut17 - document17 this
  gpio_pkg17::gpio_config17 gpio_cfg17;

  `uvm_object_utils_begin(apb_subsystem_config17)
      `uvm_field_object(uart_cfg017, UVM_DEFAULT)
      `uvm_field_object(uart_cfg117, UVM_DEFAULT)
      `uvm_field_object(spi_cfg17, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg17, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config17");
    super.new(name);
    uart_cfg017 = uart_ctrl_config17::type_id::create("uart_cfg017");
    uart_cfg117 = uart_ctrl_config17::type_id::create("uart_cfg117");
    spi_cfg17   = spi_pkg17::spi_config17::type_id::create("spi_cfg17"); 
    gpio_cfg17  = gpio_pkg17::gpio_config17::type_id::create("gpio_cfg17"); 
  endfunction : new

endclass : apb_subsystem_config17

//================================================================
class default_apb_subsystem_config17 extends apb_subsystem_config17;

  `uvm_object_utils(default_apb_subsystem_config17)

  function new(string name = "default_apb_subsystem_config17");
    super.new(name);
    uart_cfg017 = uart_ctrl_config17::type_id::create("uart_cfg017");
    uart_cfg117 = uart_ctrl_config17::type_id::create("uart_cfg117");
    spi_cfg17   = spi_pkg17::spi_config17::type_id::create("spi_cfg17"); 
    gpio_cfg17  = gpio_pkg17::gpio_config17::type_id::create("gpio_cfg17"); 
    uart_cfg017.apb_cfg17.add_master17("master17", UVM_PASSIVE);
    uart_cfg017.apb_cfg17.add_slave17("spi017",  `AM_SPI0_BASE_ADDRESS17,  `AM_SPI0_END_ADDRESS17,  0, UVM_PASSIVE);
    uart_cfg017.apb_cfg17.add_slave17("uart017", `AM_UART0_BASE_ADDRESS17, `AM_UART0_END_ADDRESS17, 0, UVM_PASSIVE);
    uart_cfg017.apb_cfg17.add_slave17("gpio017", `AM_GPIO0_BASE_ADDRESS17, `AM_GPIO0_END_ADDRESS17, 0, UVM_PASSIVE);
    uart_cfg017.apb_cfg17.add_slave17("uart117", `AM_UART1_BASE_ADDRESS17, `AM_UART1_END_ADDRESS17, 1, UVM_PASSIVE);
    uart_cfg117.apb_cfg17.add_master17("master17", UVM_PASSIVE);
    uart_cfg117.apb_cfg17.add_slave17("spi017",  `AM_SPI0_BASE_ADDRESS17,  `AM_SPI0_END_ADDRESS17,  0, UVM_PASSIVE);
    uart_cfg117.apb_cfg17.add_slave17("uart017", `AM_UART0_BASE_ADDRESS17, `AM_UART0_END_ADDRESS17, 0, UVM_PASSIVE);
    uart_cfg117.apb_cfg17.add_slave17("gpio017", `AM_GPIO0_BASE_ADDRESS17, `AM_GPIO0_END_ADDRESS17, 0, UVM_PASSIVE);
    uart_cfg117.apb_cfg17.add_slave17("uart117", `AM_UART1_BASE_ADDRESS17, `AM_UART1_END_ADDRESS17, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config17

`endif // UART_CTRL_CONFIG_SV17

