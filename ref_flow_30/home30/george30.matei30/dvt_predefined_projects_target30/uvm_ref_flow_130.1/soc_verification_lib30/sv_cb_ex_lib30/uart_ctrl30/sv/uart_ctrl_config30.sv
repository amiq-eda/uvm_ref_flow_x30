/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_config30.svh
Title30       : UART30 Controller30 configuration
Project30     :
Created30     :
Description30 : This30 file contains30 multiple configuration classes30:
                apb_config30
                   master_config30
                   slave_configs30[N]
                uart_config30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV30
`define UART_CTRL_CONFIG_SV30

// UART30 Controller30 Configuration30 Class30
class uart_ctrl_config30 extends uvm_object;

  apb_config30 apb_cfg30;
  uart_config30 uart_cfg30;

  `uvm_object_utils_begin(uart_ctrl_config30)
      `uvm_field_object(apb_cfg30, UVM_DEFAULT)
      `uvm_field_object(uart_cfg30, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config30");
    super.new(name);
    uart_cfg30 = uart_config30::type_id::create("uart_cfg30");
    apb_cfg30 = apb_config30::type_id::create("apb_cfg30"); 
  endfunction : new

endclass : uart_ctrl_config30

//================================================================
class default_uart_ctrl_config30 extends uart_ctrl_config30;

  `uvm_object_utils(default_uart_ctrl_config30)

  function new(string name = "default_uart_ctrl_config30");
    super.new(name);
    uart_cfg30 = uart_config30::type_id::create("uart_cfg30");
    apb_cfg30 = apb_config30::type_id::create("apb_cfg30"); 
    apb_cfg30.add_slave30("slave030", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg30.add_master30("master30", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config30

`endif // UART_CTRL_CONFIG_SV30
