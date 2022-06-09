/*-------------------------------------------------------------------------
File20 name   : uart_ctrl_config20.svh
Title20       : UART20 Controller20 configuration
Project20     :
Created20     :
Description20 : This20 file contains20 multiple configuration classes20:
                apb_config20
                   master_config20
                   slave_configs20[N]
                uart_config20
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV20
`define UART_CTRL_CONFIG_SV20

// UART20 Controller20 Configuration20 Class20
class uart_ctrl_config20 extends uvm_object;

  apb_config20 apb_cfg20;
  uart_config20 uart_cfg20;

  `uvm_object_utils_begin(uart_ctrl_config20)
      `uvm_field_object(apb_cfg20, UVM_DEFAULT)
      `uvm_field_object(uart_cfg20, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config20");
    super.new(name);
    uart_cfg20 = uart_config20::type_id::create("uart_cfg20");
    apb_cfg20 = apb_config20::type_id::create("apb_cfg20"); 
  endfunction : new

endclass : uart_ctrl_config20

//================================================================
class default_uart_ctrl_config20 extends uart_ctrl_config20;

  `uvm_object_utils(default_uart_ctrl_config20)

  function new(string name = "default_uart_ctrl_config20");
    super.new(name);
    uart_cfg20 = uart_config20::type_id::create("uart_cfg20");
    apb_cfg20 = apb_config20::type_id::create("apb_cfg20"); 
    apb_cfg20.add_slave20("slave020", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg20.add_master20("master20", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config20

`endif // UART_CTRL_CONFIG_SV20
