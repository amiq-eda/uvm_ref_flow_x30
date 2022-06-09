/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_config22.svh
Title22       : UART22 Controller22 configuration
Project22     :
Created22     :
Description22 : This22 file contains22 multiple configuration classes22:
                apb_config22
                   master_config22
                   slave_configs22[N]
                uart_config22
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV22
`define UART_CTRL_CONFIG_SV22

// UART22 Controller22 Configuration22 Class22
class uart_ctrl_config22 extends uvm_object;

  apb_config22 apb_cfg22;
  uart_config22 uart_cfg22;

  `uvm_object_utils_begin(uart_ctrl_config22)
      `uvm_field_object(apb_cfg22, UVM_DEFAULT)
      `uvm_field_object(uart_cfg22, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config22");
    super.new(name);
    uart_cfg22 = uart_config22::type_id::create("uart_cfg22");
    apb_cfg22 = apb_config22::type_id::create("apb_cfg22"); 
  endfunction : new

endclass : uart_ctrl_config22

//================================================================
class default_uart_ctrl_config22 extends uart_ctrl_config22;

  `uvm_object_utils(default_uart_ctrl_config22)

  function new(string name = "default_uart_ctrl_config22");
    super.new(name);
    uart_cfg22 = uart_config22::type_id::create("uart_cfg22");
    apb_cfg22 = apb_config22::type_id::create("apb_cfg22"); 
    apb_cfg22.add_slave22("slave022", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg22.add_master22("master22", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config22

`endif // UART_CTRL_CONFIG_SV22
