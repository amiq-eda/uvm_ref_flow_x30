/*-------------------------------------------------------------------------
File8 name   : uart_cover8.sv
Title8       : APB8<>UART8 coverage8 collection8
Project8     :
Created8     :
Description8 : Collects8 coverage8 around8 the UART8 DUT
            : 
----------------------------------------------------------------------
Copyright8 2007 (c) Cadence8 Design8 Systems8, Inc8. All Rights8 Reserved8.
----------------------------------------------------------------------*/

class uart_ctrl_cover8 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if8 vif8;
  uart_pkg8::uart_config8 uart_cfg8;

  event tx_fifo_ptr_change8;
  event rx_fifo_ptr_change8;


  // Required8 macro8 for UVM automation8 and utilities8
  `uvm_component_utils(uart_ctrl_cover8)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage8();
      collect_rx_coverage8();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if8)::get(this, get_full_name(),"vif8", vif8))
      `uvm_fatal("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
  endfunction : connect_phase

  virtual task collect_tx_coverage8();
    // --------------------------------
    // Extract8 & re-arrange8 to give8 a more useful8 input to covergroups8
    // --------------------------------
    // Calculate8 percentage8 fill8 level of TX8 FIFO
    forever begin
      @(vif8.tx_fifo_ptr8)
    //do any processing here8
      -> tx_fifo_ptr_change8;
    end  
  endtask : collect_tx_coverage8

  virtual task collect_rx_coverage8();
    // --------------------------------
    // Extract8 & re-arrange8 to give8 a more useful8 input to covergroups8
    // --------------------------------
    // Calculate8 percentage8 fill8 level of RX8 FIFO
    forever begin
      @(vif8.rx_fifo_ptr8)
    //do any processing here8
      -> rx_fifo_ptr_change8;
    end  
  endtask : collect_rx_coverage8

  // --------------------------------
  // Covergroup8 definitions8
  // --------------------------------

  // DUT TX8 FIFO covergroup
  covergroup dut_tx_fifo_cg8 @(tx_fifo_ptr_change8);
    tx_level8              : coverpoint vif8.tx_fifo_ptr8 {
                             bins EMPTY8 = {0};
                             bins HALF_FULL8 = {[7:10]};
                             bins FULL8 = {[13:15]};
                            }
  endgroup


  // DUT RX8 FIFO covergroup
  covergroup dut_rx_fifo_cg8 @(rx_fifo_ptr_change8);
    rx_level8              : coverpoint vif8.rx_fifo_ptr8 {
                             bins EMPTY8 = {0};
                             bins HALF_FULL8 = {[7:10]};
                             bins FULL8 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg8 = new();
    dut_rx_fifo_cg8.set_inst_name ("dut_rx_fifo_cg8");

    dut_tx_fifo_cg8 = new();
    dut_tx_fifo_cg8.set_inst_name ("dut_tx_fifo_cg8");

  endfunction
  
endclass : uart_ctrl_cover8
