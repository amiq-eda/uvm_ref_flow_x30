/*-------------------------------------------------------------------------
File24 name   : uart_cover24.sv
Title24       : APB24<>UART24 coverage24 collection24
Project24     :
Created24     :
Description24 : Collects24 coverage24 around24 the UART24 DUT
            : 
----------------------------------------------------------------------
Copyright24 2007 (c) Cadence24 Design24 Systems24, Inc24. All Rights24 Reserved24.
----------------------------------------------------------------------*/

class uart_ctrl_cover24 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if24 vif24;
  uart_pkg24::uart_config24 uart_cfg24;

  event tx_fifo_ptr_change24;
  event rx_fifo_ptr_change24;


  // Required24 macro24 for UVM automation24 and utilities24
  `uvm_component_utils(uart_ctrl_cover24)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage24();
      collect_rx_coverage24();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if24)::get(this, get_full_name(),"vif24", vif24))
      `uvm_fatal("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
  endfunction : connect_phase

  virtual task collect_tx_coverage24();
    // --------------------------------
    // Extract24 & re-arrange24 to give24 a more useful24 input to covergroups24
    // --------------------------------
    // Calculate24 percentage24 fill24 level of TX24 FIFO
    forever begin
      @(vif24.tx_fifo_ptr24)
    //do any processing here24
      -> tx_fifo_ptr_change24;
    end  
  endtask : collect_tx_coverage24

  virtual task collect_rx_coverage24();
    // --------------------------------
    // Extract24 & re-arrange24 to give24 a more useful24 input to covergroups24
    // --------------------------------
    // Calculate24 percentage24 fill24 level of RX24 FIFO
    forever begin
      @(vif24.rx_fifo_ptr24)
    //do any processing here24
      -> rx_fifo_ptr_change24;
    end  
  endtask : collect_rx_coverage24

  // --------------------------------
  // Covergroup24 definitions24
  // --------------------------------

  // DUT TX24 FIFO covergroup
  covergroup dut_tx_fifo_cg24 @(tx_fifo_ptr_change24);
    tx_level24              : coverpoint vif24.tx_fifo_ptr24 {
                             bins EMPTY24 = {0};
                             bins HALF_FULL24 = {[7:10]};
                             bins FULL24 = {[13:15]};
                            }
  endgroup


  // DUT RX24 FIFO covergroup
  covergroup dut_rx_fifo_cg24 @(rx_fifo_ptr_change24);
    rx_level24              : coverpoint vif24.rx_fifo_ptr24 {
                             bins EMPTY24 = {0};
                             bins HALF_FULL24 = {[7:10]};
                             bins FULL24 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg24 = new();
    dut_rx_fifo_cg24.set_inst_name ("dut_rx_fifo_cg24");

    dut_tx_fifo_cg24 = new();
    dut_tx_fifo_cg24.set_inst_name ("dut_tx_fifo_cg24");

  endfunction
  
endclass : uart_ctrl_cover24
