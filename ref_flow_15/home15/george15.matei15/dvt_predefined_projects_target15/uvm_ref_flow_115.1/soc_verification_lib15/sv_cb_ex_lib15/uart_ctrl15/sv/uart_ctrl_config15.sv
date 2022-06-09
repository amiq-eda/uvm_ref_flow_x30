/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_config15.svh
Title15       : UART15 Controller15 configuration
Project15     :
Created15     :
Description15 : This15 file contains15 multiple configuration classes15:
                apb_config15
                   master_config15
                   slave_configs15[N]
                uart_config15
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV15
`define UART_CTRL_CONFIG_SV15

// UART15 Controller15 Configuration15 Class15
class uart_ctrl_config15 extends uvm_object;

  apb_config15 apb_cfg15;
  uart_config15 uart_cfg15;

  `uvm_object_utils_begin(uart_ctrl_config15)
      `uvm_field_object(apb_cfg15, UVM_DEFAULT)
      `uvm_field_object(uart_cfg15, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config15");
    super.new(name);
    uart_cfg15 = uart_config15::type_id::create("uart_cfg15");
    apb_cfg15 = apb_config15::type_id::create("apb_cfg15"); 
  endfunction : new

endclass : uart_ctrl_config15

//================================================================
class default_uart_ctrl_config15 extends uart_ctrl_config15;

  `uvm_object_utils(default_uart_ctrl_config15)

  function new(string name = "default_uart_ctrl_config15");
    super.new(name);
    uart_cfg15 = uart_config15::type_id::create("uart_cfg15");
    apb_cfg15 = apb_config15::type_id::create("apb_cfg15"); 
    apb_cfg15.add_slave15("slave015", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg15.add_master15("master15", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config15

`endif // UART_CTRL_CONFIG_SV15
