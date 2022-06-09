/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_config26.svh
Title26       : UART26 Controller26 configuration
Project26     :
Created26     :
Description26 : This26 file contains26 multiple configuration classes26:
                apb_config26
                   master_config26
                   slave_configs26[N]
                uart_config26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV26
`define UART_CTRL_CONFIG_SV26

// UART26 Controller26 Configuration26 Class26
class uart_ctrl_config26 extends uvm_object;

  apb_config26 apb_cfg26;
  uart_config26 uart_cfg26;

  `uvm_object_utils_begin(uart_ctrl_config26)
      `uvm_field_object(apb_cfg26, UVM_DEFAULT)
      `uvm_field_object(uart_cfg26, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config26");
    super.new(name);
    uart_cfg26 = uart_config26::type_id::create("uart_cfg26");
    apb_cfg26 = apb_config26::type_id::create("apb_cfg26"); 
  endfunction : new

endclass : uart_ctrl_config26

//================================================================
class default_uart_ctrl_config26 extends uart_ctrl_config26;

  `uvm_object_utils(default_uart_ctrl_config26)

  function new(string name = "default_uart_ctrl_config26");
    super.new(name);
    uart_cfg26 = uart_config26::type_id::create("uart_cfg26");
    apb_cfg26 = apb_config26::type_id::create("apb_cfg26"); 
    apb_cfg26.add_slave26("slave026", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg26.add_master26("master26", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config26

`endif // UART_CTRL_CONFIG_SV26
