/*---------------------------------------------------------------------
File20 name   : apb_subsystem_reg_rdb20.sv
Title20       : Reg20 Mem20 data base
Project20     :
Created20     :
Description20 : reg data base for APB20 Subsystem20
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map20 definition20
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c20 extends uvm_reg_block;

  //rand uart_ctrl_rf_c20 uart0_rf20;
  //rand uart_ctrl_rf_c20 uart1_rf20;
  rand uart_ctrl_reg_model_c20 uart0_rm20;
  rand uart_ctrl_reg_model_c20 uart1_rm20;
  rand spi_regfile20 spi_rf20;
  rand gpio_regfile20 gpio_rf20;

  function void build();
    // Now20 define address mappings20
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf20 = uart_ctrl_rf_c20::type_id::create("uart0_rf20", , get_full_name());
    uart0_rf20.configure(this, "rf020");
    uart0_rf20.build();
    uart0_rf20.lock_model();
    default_map.add_submap(uart0_rf20.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model20");
    uart1_rf20 = uart_ctrl_rf_c20::type_id::create("uart1_rf20", , get_full_name());
    uart1_rf20.configure(this, "rf120");
    uart1_rf20.build();
    uart1_rf20.lock_model();
    default_map.add_submap(uart1_rf20.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm20 = uart_ctrl_reg_model_c20::type_id::create("uart0_rm20", , get_full_name());
    uart0_rm20.configure(this, "rf020");
    uart0_rm20.build();
    uart0_rm20.lock_model();
    default_map.add_submap(uart0_rm20.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model20");
    uart1_rm20 = uart_ctrl_reg_model_c20::type_id::create("uart1_rm20", , get_full_name());
    uart1_rm20.configure(this, "rf120");
    uart1_rm20.build();
    uart1_rm20.lock_model();
    default_map.add_submap(uart1_rm20.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model120");

    spi_rf20 = spi_regfile20::type_id::create("spi_rf20", , get_full_name());
    spi_rf20.configure(this, "rf220");
    spi_rf20.build();
    spi_rf20.lock_model();
    default_map.add_submap(spi_rf20.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c20");
    gpio_rf20 = gpio_regfile20::type_id::create("gpio_rf20", , get_full_name());
    gpio_rf20.configure(this, "rf320");
    gpio_rf20.build();
    gpio_rf20.lock_model();
    default_map.add_submap(gpio_rf20.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c20");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c20)

  function new(input string name="unnamed20-apb_ss_reg_model_c20");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c20

