/*---------------------------------------------------------------------
File8 name   : apb_subsystem_reg_rdb8.sv
Title8       : Reg8 Mem8 data base
Project8     :
Created8     :
Description8 : reg data base for APB8 Subsystem8
Notes8       :
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map8 definition8
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c8 extends uvm_reg_block;

  //rand uart_ctrl_rf_c8 uart0_rf8;
  //rand uart_ctrl_rf_c8 uart1_rf8;
  rand uart_ctrl_reg_model_c8 uart0_rm8;
  rand uart_ctrl_reg_model_c8 uart1_rm8;
  rand spi_regfile8 spi_rf8;
  rand gpio_regfile8 gpio_rf8;

  function void build();
    // Now8 define address mappings8
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf8 = uart_ctrl_rf_c8::type_id::create("uart0_rf8", , get_full_name());
    uart0_rf8.configure(this, "rf08");
    uart0_rf8.build();
    uart0_rf8.lock_model();
    default_map.add_submap(uart0_rf8.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model8");
    uart1_rf8 = uart_ctrl_rf_c8::type_id::create("uart1_rf8", , get_full_name());
    uart1_rf8.configure(this, "rf18");
    uart1_rf8.build();
    uart1_rf8.lock_model();
    default_map.add_submap(uart1_rf8.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm8 = uart_ctrl_reg_model_c8::type_id::create("uart0_rm8", , get_full_name());
    uart0_rm8.configure(this, "rf08");
    uart0_rm8.build();
    uart0_rm8.lock_model();
    default_map.add_submap(uart0_rm8.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model8");
    uart1_rm8 = uart_ctrl_reg_model_c8::type_id::create("uart1_rm8", , get_full_name());
    uart1_rm8.configure(this, "rf18");
    uart1_rm8.build();
    uart1_rm8.lock_model();
    default_map.add_submap(uart1_rm8.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model18");

    spi_rf8 = spi_regfile8::type_id::create("spi_rf8", , get_full_name());
    spi_rf8.configure(this, "rf28");
    spi_rf8.build();
    spi_rf8.lock_model();
    default_map.add_submap(spi_rf8.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c8");
    gpio_rf8 = gpio_regfile8::type_id::create("gpio_rf8", , get_full_name());
    gpio_rf8.configure(this, "rf38");
    gpio_rf8.build();
    gpio_rf8.lock_model();
    default_map.add_submap(gpio_rf8.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c8");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c8)

  function new(input string name="unnamed8-apb_ss_reg_model_c8");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c8

