/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_config16.svh
Title16       : UART16 Controller16 configuration
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


`ifndef UART_CTRL_CONFIG_SV16
`define UART_CTRL_CONFIG_SV16

// UART16 Controller16 Configuration16 Class16
class uart_ctrl_config16 extends uvm_object;

  apb_config16 apb_cfg16;
  uart_config16 uart_cfg16;

  `uvm_object_utils_begin(uart_ctrl_config16)
      `uvm_field_object(apb_cfg16, UVM_DEFAULT)
      `uvm_field_object(uart_cfg16, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config16");
    super.new(name);
    uart_cfg16 = uart_config16::type_id::create("uart_cfg16");
    apb_cfg16 = apb_config16::type_id::create("apb_cfg16"); 
  endfunction : new

endclass : uart_ctrl_config16

//================================================================
class default_uart_ctrl_config16 extends uart_ctrl_config16;

  `uvm_object_utils(default_uart_ctrl_config16)

  function new(string name = "default_uart_ctrl_config16");
    super.new(name);
    uart_cfg16 = uart_config16::type_id::create("uart_cfg16");
    apb_cfg16 = apb_config16::type_id::create("apb_cfg16"); 
    apb_cfg16.add_slave16("slave016", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg16.add_master16("master16", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config16

`endif // UART_CTRL_CONFIG_SV16
