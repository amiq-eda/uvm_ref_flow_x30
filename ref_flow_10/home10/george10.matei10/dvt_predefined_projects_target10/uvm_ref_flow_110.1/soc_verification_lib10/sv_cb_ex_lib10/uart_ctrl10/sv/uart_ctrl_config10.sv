/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_config10.svh
Title10       : UART10 Controller10 configuration
Project10     :
Created10     :
Description10 : This10 file contains10 multiple configuration classes10:
                apb_config10
                   master_config10
                   slave_configs10[N]
                uart_config10
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV10
`define UART_CTRL_CONFIG_SV10

// UART10 Controller10 Configuration10 Class10
class uart_ctrl_config10 extends uvm_object;

  apb_config10 apb_cfg10;
  uart_config10 uart_cfg10;

  `uvm_object_utils_begin(uart_ctrl_config10)
      `uvm_field_object(apb_cfg10, UVM_DEFAULT)
      `uvm_field_object(uart_cfg10, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config10");
    super.new(name);
    uart_cfg10 = uart_config10::type_id::create("uart_cfg10");
    apb_cfg10 = apb_config10::type_id::create("apb_cfg10"); 
  endfunction : new

endclass : uart_ctrl_config10

//================================================================
class default_uart_ctrl_config10 extends uart_ctrl_config10;

  `uvm_object_utils(default_uart_ctrl_config10)

  function new(string name = "default_uart_ctrl_config10");
    super.new(name);
    uart_cfg10 = uart_config10::type_id::create("uart_cfg10");
    apb_cfg10 = apb_config10::type_id::create("apb_cfg10"); 
    apb_cfg10.add_slave10("slave010", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg10.add_master10("master10", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config10

`endif // UART_CTRL_CONFIG_SV10
