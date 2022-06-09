/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_config13.svh
Title13       : UART13 Controller13 configuration
Project13     :
Created13     :
Description13 : This13 file contains13 multiple configuration classes13:
                apb_config13
                   master_config13
                   slave_configs13[N]
                uart_config13
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV13
`define UART_CTRL_CONFIG_SV13

// UART13 Controller13 Configuration13 Class13
class uart_ctrl_config13 extends uvm_object;

  apb_config13 apb_cfg13;
  uart_config13 uart_cfg13;

  `uvm_object_utils_begin(uart_ctrl_config13)
      `uvm_field_object(apb_cfg13, UVM_DEFAULT)
      `uvm_field_object(uart_cfg13, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config13");
    super.new(name);
    uart_cfg13 = uart_config13::type_id::create("uart_cfg13");
    apb_cfg13 = apb_config13::type_id::create("apb_cfg13"); 
  endfunction : new

endclass : uart_ctrl_config13

//================================================================
class default_uart_ctrl_config13 extends uart_ctrl_config13;

  `uvm_object_utils(default_uart_ctrl_config13)

  function new(string name = "default_uart_ctrl_config13");
    super.new(name);
    uart_cfg13 = uart_config13::type_id::create("uart_cfg13");
    apb_cfg13 = apb_config13::type_id::create("apb_cfg13"); 
    apb_cfg13.add_slave13("slave013", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg13.add_master13("master13", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config13

`endif // UART_CTRL_CONFIG_SV13
