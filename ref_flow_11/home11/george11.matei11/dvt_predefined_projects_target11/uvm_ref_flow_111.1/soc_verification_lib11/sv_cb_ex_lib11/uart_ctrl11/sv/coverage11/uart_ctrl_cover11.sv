/*-------------------------------------------------------------------------
File11 name   : uart_cover11.sv
Title11       : APB11<>UART11 coverage11 collection11
Project11     :
Created11     :
Description11 : Collects11 coverage11 around11 the UART11 DUT
            : 
----------------------------------------------------------------------
Copyright11 2007 (c) Cadence11 Design11 Systems11, Inc11. All Rights11 Reserved11.
----------------------------------------------------------------------*/

class uart_ctrl_cover11 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if11 vif11;
  uart_pkg11::uart_config11 uart_cfg11;

  event tx_fifo_ptr_change11;
  event rx_fifo_ptr_change11;


  // Required11 macro11 for UVM automation11 and utilities11
  `uvm_component_utils(uart_ctrl_cover11)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage11();
      collect_rx_coverage11();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if11)::get(this, get_full_name(),"vif11", vif11))
      `uvm_fatal("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
  endfunction : connect_phase

  virtual task collect_tx_coverage11();
    // --------------------------------
    // Extract11 & re-arrange11 to give11 a more useful11 input to covergroups11
    // --------------------------------
    // Calculate11 percentage11 fill11 level of TX11 FIFO
    forever begin
      @(vif11.tx_fifo_ptr11)
    //do any processing here11
      -> tx_fifo_ptr_change11;
    end  
  endtask : collect_tx_coverage11

  virtual task collect_rx_coverage11();
    // --------------------------------
    // Extract11 & re-arrange11 to give11 a more useful11 input to covergroups11
    // --------------------------------
    // Calculate11 percentage11 fill11 level of RX11 FIFO
    forever begin
      @(vif11.rx_fifo_ptr11)
    //do any processing here11
      -> rx_fifo_ptr_change11;
    end  
  endtask : collect_rx_coverage11

  // --------------------------------
  // Covergroup11 definitions11
  // --------------------------------

  // DUT TX11 FIFO covergroup
  covergroup dut_tx_fifo_cg11 @(tx_fifo_ptr_change11);
    tx_level11              : coverpoint vif11.tx_fifo_ptr11 {
                             bins EMPTY11 = {0};
                             bins HALF_FULL11 = {[7:10]};
                             bins FULL11 = {[13:15]};
                            }
  endgroup


  // DUT RX11 FIFO covergroup
  covergroup dut_rx_fifo_cg11 @(rx_fifo_ptr_change11);
    rx_level11              : coverpoint vif11.rx_fifo_ptr11 {
                             bins EMPTY11 = {0};
                             bins HALF_FULL11 = {[7:10]};
                             bins FULL11 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg11 = new();
    dut_rx_fifo_cg11.set_inst_name ("dut_rx_fifo_cg11");

    dut_tx_fifo_cg11 = new();
    dut_tx_fifo_cg11.set_inst_name ("dut_tx_fifo_cg11");

  endfunction
  
endclass : uart_ctrl_cover11
