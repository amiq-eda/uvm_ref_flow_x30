/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_config23.svh
Title23       : UART23 Controller23 configuration
Project23     :
Created23     :
Description23 : This23 file contains23 multiple configuration classes23:
                apb_config23
                   master_config23
                   slave_configs23[N]
                uart_config23
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV23
`define UART_CTRL_CONFIG_SV23

// UART23 Controller23 Configuration23 Class23
class uart_ctrl_config23 extends uvm_object;

  apb_config23 apb_cfg23;
  uart_config23 uart_cfg23;

  `uvm_object_utils_begin(uart_ctrl_config23)
      `uvm_field_object(apb_cfg23, UVM_DEFAULT)
      `uvm_field_object(uart_cfg23, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config23");
    super.new(name);
    uart_cfg23 = uart_config23::type_id::create("uart_cfg23");
    apb_cfg23 = apb_config23::type_id::create("apb_cfg23"); 
  endfunction : new

endclass : uart_ctrl_config23

//================================================================
class default_uart_ctrl_config23 extends uart_ctrl_config23;

  `uvm_object_utils(default_uart_ctrl_config23)

  function new(string name = "default_uart_ctrl_config23");
    super.new(name);
    uart_cfg23 = uart_config23::type_id::create("uart_cfg23");
    apb_cfg23 = apb_config23::type_id::create("apb_cfg23"); 
    apb_cfg23.add_slave23("slave023", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg23.add_master23("master23", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config23

`endif // UART_CTRL_CONFIG_SV23
