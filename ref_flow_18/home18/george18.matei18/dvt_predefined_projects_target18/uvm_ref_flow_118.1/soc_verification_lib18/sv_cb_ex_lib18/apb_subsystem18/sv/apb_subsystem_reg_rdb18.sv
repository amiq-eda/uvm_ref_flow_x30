/*---------------------------------------------------------------------
File18 name   : apb_subsystem_reg_rdb18.sv
Title18       : Reg18 Mem18 data base
Project18     :
Created18     :
Description18 : reg data base for APB18 Subsystem18
Notes18       :
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map18 definition18
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c18 extends uvm_reg_block;

  //rand uart_ctrl_rf_c18 uart0_rf18;
  //rand uart_ctrl_rf_c18 uart1_rf18;
  rand uart_ctrl_reg_model_c18 uart0_rm18;
  rand uart_ctrl_reg_model_c18 uart1_rm18;
  rand spi_regfile18 spi_rf18;
  rand gpio_regfile18 gpio_rf18;

  function void build();
    // Now18 define address mappings18
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf18 = uart_ctrl_rf_c18::type_id::create("uart0_rf18", , get_full_name());
    uart0_rf18.configure(this, "rf018");
    uart0_rf18.build();
    uart0_rf18.lock_model();
    default_map.add_submap(uart0_rf18.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model18");
    uart1_rf18 = uart_ctrl_rf_c18::type_id::create("uart1_rf18", , get_full_name());
    uart1_rf18.configure(this, "rf118");
    uart1_rf18.build();
    uart1_rf18.lock_model();
    default_map.add_submap(uart1_rf18.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm18 = uart_ctrl_reg_model_c18::type_id::create("uart0_rm18", , get_full_name());
    uart0_rm18.configure(this, "rf018");
    uart0_rm18.build();
    uart0_rm18.lock_model();
    default_map.add_submap(uart0_rm18.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model18");
    uart1_rm18 = uart_ctrl_reg_model_c18::type_id::create("uart1_rm18", , get_full_name());
    uart1_rm18.configure(this, "rf118");
    uart1_rm18.build();
    uart1_rm18.lock_model();
    default_map.add_submap(uart1_rm18.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model118");

    spi_rf18 = spi_regfile18::type_id::create("spi_rf18", , get_full_name());
    spi_rf18.configure(this, "rf218");
    spi_rf18.build();
    spi_rf18.lock_model();
    default_map.add_submap(spi_rf18.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c18");
    gpio_rf18 = gpio_regfile18::type_id::create("gpio_rf18", , get_full_name());
    gpio_rf18.configure(this, "rf318");
    gpio_rf18.build();
    gpio_rf18.lock_model();
    default_map.add_submap(gpio_rf18.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c18");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c18)

  function new(input string name="unnamed18-apb_ss_reg_model_c18");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c18

