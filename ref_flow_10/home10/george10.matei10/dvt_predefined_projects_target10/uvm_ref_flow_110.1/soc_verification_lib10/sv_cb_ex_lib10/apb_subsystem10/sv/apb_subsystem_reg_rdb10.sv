/*---------------------------------------------------------------------
File10 name   : apb_subsystem_reg_rdb10.sv
Title10       : Reg10 Mem10 data base
Project10     :
Created10     :
Description10 : reg data base for APB10 Subsystem10
Notes10       :
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map10 definition10
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c10 extends uvm_reg_block;

  //rand uart_ctrl_rf_c10 uart0_rf10;
  //rand uart_ctrl_rf_c10 uart1_rf10;
  rand uart_ctrl_reg_model_c10 uart0_rm10;
  rand uart_ctrl_reg_model_c10 uart1_rm10;
  rand spi_regfile10 spi_rf10;
  rand gpio_regfile10 gpio_rf10;

  function void build();
    // Now10 define address mappings10
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf10 = uart_ctrl_rf_c10::type_id::create("uart0_rf10", , get_full_name());
    uart0_rf10.configure(this, "rf010");
    uart0_rf10.build();
    uart0_rf10.lock_model();
    default_map.add_submap(uart0_rf10.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model10");
    uart1_rf10 = uart_ctrl_rf_c10::type_id::create("uart1_rf10", , get_full_name());
    uart1_rf10.configure(this, "rf110");
    uart1_rf10.build();
    uart1_rf10.lock_model();
    default_map.add_submap(uart1_rf10.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm10 = uart_ctrl_reg_model_c10::type_id::create("uart0_rm10", , get_full_name());
    uart0_rm10.configure(this, "rf010");
    uart0_rm10.build();
    uart0_rm10.lock_model();
    default_map.add_submap(uart0_rm10.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model10");
    uart1_rm10 = uart_ctrl_reg_model_c10::type_id::create("uart1_rm10", , get_full_name());
    uart1_rm10.configure(this, "rf110");
    uart1_rm10.build();
    uart1_rm10.lock_model();
    default_map.add_submap(uart1_rm10.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model110");

    spi_rf10 = spi_regfile10::type_id::create("spi_rf10", , get_full_name());
    spi_rf10.configure(this, "rf210");
    spi_rf10.build();
    spi_rf10.lock_model();
    default_map.add_submap(spi_rf10.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c10");
    gpio_rf10 = gpio_regfile10::type_id::create("gpio_rf10", , get_full_name());
    gpio_rf10.configure(this, "rf310");
    gpio_rf10.build();
    gpio_rf10.lock_model();
    default_map.add_submap(gpio_rf10.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c10");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c10)

  function new(input string name="unnamed10-apb_ss_reg_model_c10");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c10

