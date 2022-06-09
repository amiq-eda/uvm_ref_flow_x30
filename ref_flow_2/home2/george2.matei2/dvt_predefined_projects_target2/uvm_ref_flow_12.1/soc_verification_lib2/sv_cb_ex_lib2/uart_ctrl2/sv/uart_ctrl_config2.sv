/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_config2.svh
Title2       : UART2 Controller2 configuration
Project2     :
Created2     :
Description2 : This2 file contains2 multiple configuration classes2:
                apb_config2
                   master_config2
                   slave_configs2[N]
                uart_config2
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV2
`define UART_CTRL_CONFIG_SV2

// UART2 Controller2 Configuration2 Class2
class uart_ctrl_config2 extends uvm_object;

  apb_config2 apb_cfg2;
  uart_config2 uart_cfg2;

  `uvm_object_utils_begin(uart_ctrl_config2)
      `uvm_field_object(apb_cfg2, UVM_DEFAULT)
      `uvm_field_object(uart_cfg2, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config2");
    super.new(name);
    uart_cfg2 = uart_config2::type_id::create("uart_cfg2");
    apb_cfg2 = apb_config2::type_id::create("apb_cfg2"); 
  endfunction : new

endclass : uart_ctrl_config2

//================================================================
class default_uart_ctrl_config2 extends uart_ctrl_config2;

  `uvm_object_utils(default_uart_ctrl_config2)

  function new(string name = "default_uart_ctrl_config2");
    super.new(name);
    uart_cfg2 = uart_config2::type_id::create("uart_cfg2");
    apb_cfg2 = apb_config2::type_id::create("apb_cfg2"); 
    apb_cfg2.add_slave2("slave02", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg2.add_master2("master2", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config2

`endif // UART_CTRL_CONFIG_SV2
