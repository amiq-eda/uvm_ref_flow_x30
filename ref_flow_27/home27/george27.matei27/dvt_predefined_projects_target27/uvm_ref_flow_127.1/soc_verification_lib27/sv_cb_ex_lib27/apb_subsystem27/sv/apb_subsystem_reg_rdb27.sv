/*---------------------------------------------------------------------
File27 name   : apb_subsystem_reg_rdb27.sv
Title27       : Reg27 Mem27 data base
Project27     :
Created27     :
Description27 : reg data base for APB27 Subsystem27
Notes27       :
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map27 definition27
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c27 extends uvm_reg_block;

  //rand uart_ctrl_rf_c27 uart0_rf27;
  //rand uart_ctrl_rf_c27 uart1_rf27;
  rand uart_ctrl_reg_model_c27 uart0_rm27;
  rand uart_ctrl_reg_model_c27 uart1_rm27;
  rand spi_regfile27 spi_rf27;
  rand gpio_regfile27 gpio_rf27;

  function void build();
    // Now27 define address mappings27
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf27 = uart_ctrl_rf_c27::type_id::create("uart0_rf27", , get_full_name());
    uart0_rf27.configure(this, "rf027");
    uart0_rf27.build();
    uart0_rf27.lock_model();
    default_map.add_submap(uart0_rf27.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model27");
    uart1_rf27 = uart_ctrl_rf_c27::type_id::create("uart1_rf27", , get_full_name());
    uart1_rf27.configure(this, "rf127");
    uart1_rf27.build();
    uart1_rf27.lock_model();
    default_map.add_submap(uart1_rf27.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm27 = uart_ctrl_reg_model_c27::type_id::create("uart0_rm27", , get_full_name());
    uart0_rm27.configure(this, "rf027");
    uart0_rm27.build();
    uart0_rm27.lock_model();
    default_map.add_submap(uart0_rm27.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model27");
    uart1_rm27 = uart_ctrl_reg_model_c27::type_id::create("uart1_rm27", , get_full_name());
    uart1_rm27.configure(this, "rf127");
    uart1_rm27.build();
    uart1_rm27.lock_model();
    default_map.add_submap(uart1_rm27.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model127");

    spi_rf27 = spi_regfile27::type_id::create("spi_rf27", , get_full_name());
    spi_rf27.configure(this, "rf227");
    spi_rf27.build();
    spi_rf27.lock_model();
    default_map.add_submap(spi_rf27.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c27");
    gpio_rf27 = gpio_regfile27::type_id::create("gpio_rf27", , get_full_name());
    gpio_rf27.configure(this, "rf327");
    gpio_rf27.build();
    gpio_rf27.lock_model();
    default_map.add_submap(gpio_rf27.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c27");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c27)

  function new(input string name="unnamed27-apb_ss_reg_model_c27");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c27

