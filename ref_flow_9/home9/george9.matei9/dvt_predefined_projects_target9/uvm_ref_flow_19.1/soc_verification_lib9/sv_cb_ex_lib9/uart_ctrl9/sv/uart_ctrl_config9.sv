/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_config9.svh
Title9       : UART9 Controller9 configuration
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


`ifndef UART_CTRL_CONFIG_SV9
`define UART_CTRL_CONFIG_SV9

// UART9 Controller9 Configuration9 Class9
class uart_ctrl_config9 extends uvm_object;

  apb_config9 apb_cfg9;
  uart_config9 uart_cfg9;

  `uvm_object_utils_begin(uart_ctrl_config9)
      `uvm_field_object(apb_cfg9, UVM_DEFAULT)
      `uvm_field_object(uart_cfg9, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config9");
    super.new(name);
    uart_cfg9 = uart_config9::type_id::create("uart_cfg9");
    apb_cfg9 = apb_config9::type_id::create("apb_cfg9"); 
  endfunction : new

endclass : uart_ctrl_config9

//================================================================
class default_uart_ctrl_config9 extends uart_ctrl_config9;

  `uvm_object_utils(default_uart_ctrl_config9)

  function new(string name = "default_uart_ctrl_config9");
    super.new(name);
    uart_cfg9 = uart_config9::type_id::create("uart_cfg9");
    apb_cfg9 = apb_config9::type_id::create("apb_cfg9"); 
    apb_cfg9.add_slave9("slave09", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg9.add_master9("master9", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config9

`endif // UART_CTRL_CONFIG_SV9
