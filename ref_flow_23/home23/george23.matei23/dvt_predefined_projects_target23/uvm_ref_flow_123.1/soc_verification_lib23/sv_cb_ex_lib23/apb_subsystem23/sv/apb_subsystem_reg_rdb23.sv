/*---------------------------------------------------------------------
File23 name   : apb_subsystem_reg_rdb23.sv
Title23       : Reg23 Mem23 data base
Project23     :
Created23     :
Description23 : reg data base for APB23 Subsystem23
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map23 definition23
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c23 extends uvm_reg_block;

  //rand uart_ctrl_rf_c23 uart0_rf23;
  //rand uart_ctrl_rf_c23 uart1_rf23;
  rand uart_ctrl_reg_model_c23 uart0_rm23;
  rand uart_ctrl_reg_model_c23 uart1_rm23;
  rand spi_regfile23 spi_rf23;
  rand gpio_regfile23 gpio_rf23;

  function void build();
    // Now23 define address mappings23
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf23 = uart_ctrl_rf_c23::type_id::create("uart0_rf23", , get_full_name());
    uart0_rf23.configure(this, "rf023");
    uart0_rf23.build();
    uart0_rf23.lock_model();
    default_map.add_submap(uart0_rf23.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model23");
    uart1_rf23 = uart_ctrl_rf_c23::type_id::create("uart1_rf23", , get_full_name());
    uart1_rf23.configure(this, "rf123");
    uart1_rf23.build();
    uart1_rf23.lock_model();
    default_map.add_submap(uart1_rf23.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm23 = uart_ctrl_reg_model_c23::type_id::create("uart0_rm23", , get_full_name());
    uart0_rm23.configure(this, "rf023");
    uart0_rm23.build();
    uart0_rm23.lock_model();
    default_map.add_submap(uart0_rm23.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model23");
    uart1_rm23 = uart_ctrl_reg_model_c23::type_id::create("uart1_rm23", , get_full_name());
    uart1_rm23.configure(this, "rf123");
    uart1_rm23.build();
    uart1_rm23.lock_model();
    default_map.add_submap(uart1_rm23.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model123");

    spi_rf23 = spi_regfile23::type_id::create("spi_rf23", , get_full_name());
    spi_rf23.configure(this, "rf223");
    spi_rf23.build();
    spi_rf23.lock_model();
    default_map.add_submap(spi_rf23.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c23");
    gpio_rf23 = gpio_regfile23::type_id::create("gpio_rf23", , get_full_name());
    gpio_rf23.configure(this, "rf323");
    gpio_rf23.build();
    gpio_rf23.lock_model();
    default_map.add_submap(gpio_rf23.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c23");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c23)

  function new(input string name="unnamed23-apb_ss_reg_model_c23");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c23

