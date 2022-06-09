/*---------------------------------------------------------------------
File29 name   : apb_subsystem_reg_rdb29.sv
Title29       : Reg29 Mem29 data base
Project29     :
Created29     :
Description29 : reg data base for APB29 Subsystem29
Notes29       :
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map29 definition29
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c29 extends uvm_reg_block;

  //rand uart_ctrl_rf_c29 uart0_rf29;
  //rand uart_ctrl_rf_c29 uart1_rf29;
  rand uart_ctrl_reg_model_c29 uart0_rm29;
  rand uart_ctrl_reg_model_c29 uart1_rm29;
  rand spi_regfile29 spi_rf29;
  rand gpio_regfile29 gpio_rf29;

  function void build();
    // Now29 define address mappings29
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf29 = uart_ctrl_rf_c29::type_id::create("uart0_rf29", , get_full_name());
    uart0_rf29.configure(this, "rf029");
    uart0_rf29.build();
    uart0_rf29.lock_model();
    default_map.add_submap(uart0_rf29.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model29");
    uart1_rf29 = uart_ctrl_rf_c29::type_id::create("uart1_rf29", , get_full_name());
    uart1_rf29.configure(this, "rf129");
    uart1_rf29.build();
    uart1_rf29.lock_model();
    default_map.add_submap(uart1_rf29.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm29 = uart_ctrl_reg_model_c29::type_id::create("uart0_rm29", , get_full_name());
    uart0_rm29.configure(this, "rf029");
    uart0_rm29.build();
    uart0_rm29.lock_model();
    default_map.add_submap(uart0_rm29.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model29");
    uart1_rm29 = uart_ctrl_reg_model_c29::type_id::create("uart1_rm29", , get_full_name());
    uart1_rm29.configure(this, "rf129");
    uart1_rm29.build();
    uart1_rm29.lock_model();
    default_map.add_submap(uart1_rm29.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model129");

    spi_rf29 = spi_regfile29::type_id::create("spi_rf29", , get_full_name());
    spi_rf29.configure(this, "rf229");
    spi_rf29.build();
    spi_rf29.lock_model();
    default_map.add_submap(spi_rf29.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c29");
    gpio_rf29 = gpio_regfile29::type_id::create("gpio_rf29", , get_full_name());
    gpio_rf29.configure(this, "rf329");
    gpio_rf29.build();
    gpio_rf29.lock_model();
    default_map.add_submap(gpio_rf29.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c29");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c29)

  function new(input string name="unnamed29-apb_ss_reg_model_c29");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c29

