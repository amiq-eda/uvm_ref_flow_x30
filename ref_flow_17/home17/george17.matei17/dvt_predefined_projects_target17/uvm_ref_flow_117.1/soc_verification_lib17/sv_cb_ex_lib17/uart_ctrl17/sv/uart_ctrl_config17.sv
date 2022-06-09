/*-------------------------------------------------------------------------
File17 name   : uart_ctrl_config17.svh
Title17       : UART17 Controller17 configuration
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


`ifndef UART_CTRL_CONFIG_SV17
`define UART_CTRL_CONFIG_SV17

// UART17 Controller17 Configuration17 Class17
class uart_ctrl_config17 extends uvm_object;

  apb_config17 apb_cfg17;
  uart_config17 uart_cfg17;

  `uvm_object_utils_begin(uart_ctrl_config17)
      `uvm_field_object(apb_cfg17, UVM_DEFAULT)
      `uvm_field_object(uart_cfg17, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config17");
    super.new(name);
    uart_cfg17 = uart_config17::type_id::create("uart_cfg17");
    apb_cfg17 = apb_config17::type_id::create("apb_cfg17"); 
  endfunction : new

endclass : uart_ctrl_config17

//================================================================
class default_uart_ctrl_config17 extends uart_ctrl_config17;

  `uvm_object_utils(default_uart_ctrl_config17)

  function new(string name = "default_uart_ctrl_config17");
    super.new(name);
    uart_cfg17 = uart_config17::type_id::create("uart_cfg17");
    apb_cfg17 = apb_config17::type_id::create("apb_cfg17"); 
    apb_cfg17.add_slave17("slave017", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg17.add_master17("master17", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config17

`endif // UART_CTRL_CONFIG_SV17
