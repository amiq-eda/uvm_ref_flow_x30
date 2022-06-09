/*---------------------------------------------------------------------
File3 name   : apb_subsystem_reg_rdb3.sv
Title3       : Reg3 Mem3 data base
Project3     :
Created3     :
Description3 : reg data base for APB3 Subsystem3
Notes3       :
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map3 definition3
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c3 extends uvm_reg_block;

  //rand uart_ctrl_rf_c3 uart0_rf3;
  //rand uart_ctrl_rf_c3 uart1_rf3;
  rand uart_ctrl_reg_model_c3 uart0_rm3;
  rand uart_ctrl_reg_model_c3 uart1_rm3;
  rand spi_regfile3 spi_rf3;
  rand gpio_regfile3 gpio_rf3;

  function void build();
    // Now3 define address mappings3
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf3 = uart_ctrl_rf_c3::type_id::create("uart0_rf3", , get_full_name());
    uart0_rf3.configure(this, "rf03");
    uart0_rf3.build();
    uart0_rf3.lock_model();
    default_map.add_submap(uart0_rf3.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model3");
    uart1_rf3 = uart_ctrl_rf_c3::type_id::create("uart1_rf3", , get_full_name());
    uart1_rf3.configure(this, "rf13");
    uart1_rf3.build();
    uart1_rf3.lock_model();
    default_map.add_submap(uart1_rf3.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm3 = uart_ctrl_reg_model_c3::type_id::create("uart0_rm3", , get_full_name());
    uart0_rm3.configure(this, "rf03");
    uart0_rm3.build();
    uart0_rm3.lock_model();
    default_map.add_submap(uart0_rm3.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model3");
    uart1_rm3 = uart_ctrl_reg_model_c3::type_id::create("uart1_rm3", , get_full_name());
    uart1_rm3.configure(this, "rf13");
    uart1_rm3.build();
    uart1_rm3.lock_model();
    default_map.add_submap(uart1_rm3.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model13");

    spi_rf3 = spi_regfile3::type_id::create("spi_rf3", , get_full_name());
    spi_rf3.configure(this, "rf23");
    spi_rf3.build();
    spi_rf3.lock_model();
    default_map.add_submap(spi_rf3.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c3");
    gpio_rf3 = gpio_regfile3::type_id::create("gpio_rf3", , get_full_name());
    gpio_rf3.configure(this, "rf33");
    gpio_rf3.build();
    gpio_rf3.lock_model();
    default_map.add_submap(gpio_rf3.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c3");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c3)

  function new(input string name="unnamed3-apb_ss_reg_model_c3");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c3

