/*---------------------------------------------------------------------
File26 name   : apb_subsystem_reg_rdb26.sv
Title26       : Reg26 Mem26 data base
Project26     :
Created26     :
Description26 : reg data base for APB26 Subsystem26
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map26 definition26
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c26 extends uvm_reg_block;

  //rand uart_ctrl_rf_c26 uart0_rf26;
  //rand uart_ctrl_rf_c26 uart1_rf26;
  rand uart_ctrl_reg_model_c26 uart0_rm26;
  rand uart_ctrl_reg_model_c26 uart1_rm26;
  rand spi_regfile26 spi_rf26;
  rand gpio_regfile26 gpio_rf26;

  function void build();
    // Now26 define address mappings26
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf26 = uart_ctrl_rf_c26::type_id::create("uart0_rf26", , get_full_name());
    uart0_rf26.configure(this, "rf026");
    uart0_rf26.build();
    uart0_rf26.lock_model();
    default_map.add_submap(uart0_rf26.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model26");
    uart1_rf26 = uart_ctrl_rf_c26::type_id::create("uart1_rf26", , get_full_name());
    uart1_rf26.configure(this, "rf126");
    uart1_rf26.build();
    uart1_rf26.lock_model();
    default_map.add_submap(uart1_rf26.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm26 = uart_ctrl_reg_model_c26::type_id::create("uart0_rm26", , get_full_name());
    uart0_rm26.configure(this, "rf026");
    uart0_rm26.build();
    uart0_rm26.lock_model();
    default_map.add_submap(uart0_rm26.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model26");
    uart1_rm26 = uart_ctrl_reg_model_c26::type_id::create("uart1_rm26", , get_full_name());
    uart1_rm26.configure(this, "rf126");
    uart1_rm26.build();
    uart1_rm26.lock_model();
    default_map.add_submap(uart1_rm26.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model126");

    spi_rf26 = spi_regfile26::type_id::create("spi_rf26", , get_full_name());
    spi_rf26.configure(this, "rf226");
    spi_rf26.build();
    spi_rf26.lock_model();
    default_map.add_submap(spi_rf26.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c26");
    gpio_rf26 = gpio_regfile26::type_id::create("gpio_rf26", , get_full_name());
    gpio_rf26.configure(this, "rf326");
    gpio_rf26.build();
    gpio_rf26.lock_model();
    default_map.add_submap(gpio_rf26.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c26");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c26)

  function new(input string name="unnamed26-apb_ss_reg_model_c26");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c26

