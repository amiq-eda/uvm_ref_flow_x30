/*---------------------------------------------------------------------
File9 name   : apb_subsystem_reg_rdb9.sv
Title9       : Reg9 Mem9 data base
Project9     :
Created9     :
Description9 : reg data base for APB9 Subsystem9
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map9 definition9
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c9 extends uvm_reg_block;

  //rand uart_ctrl_rf_c9 uart0_rf9;
  //rand uart_ctrl_rf_c9 uart1_rf9;
  rand uart_ctrl_reg_model_c9 uart0_rm9;
  rand uart_ctrl_reg_model_c9 uart1_rm9;
  rand spi_regfile9 spi_rf9;
  rand gpio_regfile9 gpio_rf9;

  function void build();
    // Now9 define address mappings9
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf9 = uart_ctrl_rf_c9::type_id::create("uart0_rf9", , get_full_name());
    uart0_rf9.configure(this, "rf09");
    uart0_rf9.build();
    uart0_rf9.lock_model();
    default_map.add_submap(uart0_rf9.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model9");
    uart1_rf9 = uart_ctrl_rf_c9::type_id::create("uart1_rf9", , get_full_name());
    uart1_rf9.configure(this, "rf19");
    uart1_rf9.build();
    uart1_rf9.lock_model();
    default_map.add_submap(uart1_rf9.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm9 = uart_ctrl_reg_model_c9::type_id::create("uart0_rm9", , get_full_name());
    uart0_rm9.configure(this, "rf09");
    uart0_rm9.build();
    uart0_rm9.lock_model();
    default_map.add_submap(uart0_rm9.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model9");
    uart1_rm9 = uart_ctrl_reg_model_c9::type_id::create("uart1_rm9", , get_full_name());
    uart1_rm9.configure(this, "rf19");
    uart1_rm9.build();
    uart1_rm9.lock_model();
    default_map.add_submap(uart1_rm9.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model19");

    spi_rf9 = spi_regfile9::type_id::create("spi_rf9", , get_full_name());
    spi_rf9.configure(this, "rf29");
    spi_rf9.build();
    spi_rf9.lock_model();
    default_map.add_submap(spi_rf9.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c9");
    gpio_rf9 = gpio_regfile9::type_id::create("gpio_rf9", , get_full_name());
    gpio_rf9.configure(this, "rf39");
    gpio_rf9.build();
    gpio_rf9.lock_model();
    default_map.add_submap(gpio_rf9.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c9");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c9)

  function new(input string name="unnamed9-apb_ss_reg_model_c9");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c9

