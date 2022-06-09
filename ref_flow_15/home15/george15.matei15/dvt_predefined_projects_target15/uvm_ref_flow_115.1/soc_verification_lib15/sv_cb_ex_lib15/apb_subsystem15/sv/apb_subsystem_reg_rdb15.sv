/*---------------------------------------------------------------------
File15 name   : apb_subsystem_reg_rdb15.sv
Title15       : Reg15 Mem15 data base
Project15     :
Created15     :
Description15 : reg data base for APB15 Subsystem15
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map15 definition15
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c15 extends uvm_reg_block;

  //rand uart_ctrl_rf_c15 uart0_rf15;
  //rand uart_ctrl_rf_c15 uart1_rf15;
  rand uart_ctrl_reg_model_c15 uart0_rm15;
  rand uart_ctrl_reg_model_c15 uart1_rm15;
  rand spi_regfile15 spi_rf15;
  rand gpio_regfile15 gpio_rf15;

  function void build();
    // Now15 define address mappings15
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf15 = uart_ctrl_rf_c15::type_id::create("uart0_rf15", , get_full_name());
    uart0_rf15.configure(this, "rf015");
    uart0_rf15.build();
    uart0_rf15.lock_model();
    default_map.add_submap(uart0_rf15.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model15");
    uart1_rf15 = uart_ctrl_rf_c15::type_id::create("uart1_rf15", , get_full_name());
    uart1_rf15.configure(this, "rf115");
    uart1_rf15.build();
    uart1_rf15.lock_model();
    default_map.add_submap(uart1_rf15.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm15 = uart_ctrl_reg_model_c15::type_id::create("uart0_rm15", , get_full_name());
    uart0_rm15.configure(this, "rf015");
    uart0_rm15.build();
    uart0_rm15.lock_model();
    default_map.add_submap(uart0_rm15.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model15");
    uart1_rm15 = uart_ctrl_reg_model_c15::type_id::create("uart1_rm15", , get_full_name());
    uart1_rm15.configure(this, "rf115");
    uart1_rm15.build();
    uart1_rm15.lock_model();
    default_map.add_submap(uart1_rm15.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model115");

    spi_rf15 = spi_regfile15::type_id::create("spi_rf15", , get_full_name());
    spi_rf15.configure(this, "rf215");
    spi_rf15.build();
    spi_rf15.lock_model();
    default_map.add_submap(spi_rf15.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c15");
    gpio_rf15 = gpio_regfile15::type_id::create("gpio_rf15", , get_full_name());
    gpio_rf15.configure(this, "rf315");
    gpio_rf15.build();
    gpio_rf15.lock_model();
    default_map.add_submap(gpio_rf15.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c15");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c15)

  function new(input string name="unnamed15-apb_ss_reg_model_c15");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c15

