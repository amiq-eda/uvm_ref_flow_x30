/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_config25.svh
Title25       : UART25 Controller25 configuration
Project25     :
Created25     :
Description25 : This25 file contains25 multiple configuration classes25:
                apb_config25
                   master_config25
                   slave_configs25[N]
                uart_config25
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV25
`define UART_CTRL_CONFIG_SV25

// UART25 Controller25 Configuration25 Class25
class uart_ctrl_config25 extends uvm_object;

  apb_config25 apb_cfg25;
  uart_config25 uart_cfg25;

  `uvm_object_utils_begin(uart_ctrl_config25)
      `uvm_field_object(apb_cfg25, UVM_DEFAULT)
      `uvm_field_object(uart_cfg25, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config25");
    super.new(name);
    uart_cfg25 = uart_config25::type_id::create("uart_cfg25");
    apb_cfg25 = apb_config25::type_id::create("apb_cfg25"); 
  endfunction : new

endclass : uart_ctrl_config25

//================================================================
class default_uart_ctrl_config25 extends uart_ctrl_config25;

  `uvm_object_utils(default_uart_ctrl_config25)

  function new(string name = "default_uart_ctrl_config25");
    super.new(name);
    uart_cfg25 = uart_config25::type_id::create("uart_cfg25");
    apb_cfg25 = apb_config25::type_id::create("apb_cfg25"); 
    apb_cfg25.add_slave25("slave025", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg25.add_master25("master25", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config25

`endif // UART_CTRL_CONFIG_SV25
