/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_config7.svh
Title7       : UART7 Controller7 configuration
Project7     :
Created7     :
Description7 : This7 file contains7 multiple configuration classes7:
                apb_config7
                   master_config7
                   slave_configs7[N]
                uart_config7
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV7
`define UART_CTRL_CONFIG_SV7

// UART7 Controller7 Configuration7 Class7
class uart_ctrl_config7 extends uvm_object;

  apb_config7 apb_cfg7;
  uart_config7 uart_cfg7;

  `uvm_object_utils_begin(uart_ctrl_config7)
      `uvm_field_object(apb_cfg7, UVM_DEFAULT)
      `uvm_field_object(uart_cfg7, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config7");
    super.new(name);
    uart_cfg7 = uart_config7::type_id::create("uart_cfg7");
    apb_cfg7 = apb_config7::type_id::create("apb_cfg7"); 
  endfunction : new

endclass : uart_ctrl_config7

//================================================================
class default_uart_ctrl_config7 extends uart_ctrl_config7;

  `uvm_object_utils(default_uart_ctrl_config7)

  function new(string name = "default_uart_ctrl_config7");
    super.new(name);
    uart_cfg7 = uart_config7::type_id::create("uart_cfg7");
    apb_cfg7 = apb_config7::type_id::create("apb_cfg7"); 
    apb_cfg7.add_slave7("slave07", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg7.add_master7("master7", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config7

`endif // UART_CTRL_CONFIG_SV7
