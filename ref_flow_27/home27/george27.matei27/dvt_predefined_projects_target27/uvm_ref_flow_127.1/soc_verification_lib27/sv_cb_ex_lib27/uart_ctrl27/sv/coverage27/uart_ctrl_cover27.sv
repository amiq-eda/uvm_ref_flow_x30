/*-------------------------------------------------------------------------
File27 name   : uart_cover27.sv
Title27       : APB27<>UART27 coverage27 collection27
Project27     :
Created27     :
Description27 : Collects27 coverage27 around27 the UART27 DUT
            : 
----------------------------------------------------------------------
Copyright27 2007 (c) Cadence27 Design27 Systems27, Inc27. All Rights27 Reserved27.
----------------------------------------------------------------------*/

class uart_ctrl_cover27 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if27 vif27;
  uart_pkg27::uart_config27 uart_cfg27;

  event tx_fifo_ptr_change27;
  event rx_fifo_ptr_change27;


  // Required27 macro27 for UVM automation27 and utilities27
  `uvm_component_utils(uart_ctrl_cover27)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage27();
      collect_rx_coverage27();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if27)::get(this, get_full_name(),"vif27", vif27))
      `uvm_fatal("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
  endfunction : connect_phase

  virtual task collect_tx_coverage27();
    // --------------------------------
    // Extract27 & re-arrange27 to give27 a more useful27 input to covergroups27
    // --------------------------------
    // Calculate27 percentage27 fill27 level of TX27 FIFO
    forever begin
      @(vif27.tx_fifo_ptr27)
    //do any processing here27
      -> tx_fifo_ptr_change27;
    end  
  endtask : collect_tx_coverage27

  virtual task collect_rx_coverage27();
    // --------------------------------
    // Extract27 & re-arrange27 to give27 a more useful27 input to covergroups27
    // --------------------------------
    // Calculate27 percentage27 fill27 level of RX27 FIFO
    forever begin
      @(vif27.rx_fifo_ptr27)
    //do any processing here27
      -> rx_fifo_ptr_change27;
    end  
  endtask : collect_rx_coverage27

  // --------------------------------
  // Covergroup27 definitions27
  // --------------------------------

  // DUT TX27 FIFO covergroup
  covergroup dut_tx_fifo_cg27 @(tx_fifo_ptr_change27);
    tx_level27              : coverpoint vif27.tx_fifo_ptr27 {
                             bins EMPTY27 = {0};
                             bins HALF_FULL27 = {[7:10]};
                             bins FULL27 = {[13:15]};
                            }
  endgroup


  // DUT RX27 FIFO covergroup
  covergroup dut_rx_fifo_cg27 @(rx_fifo_ptr_change27);
    rx_level27              : coverpoint vif27.rx_fifo_ptr27 {
                             bins EMPTY27 = {0};
                             bins HALF_FULL27 = {[7:10]};
                             bins FULL27 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg27 = new();
    dut_rx_fifo_cg27.set_inst_name ("dut_rx_fifo_cg27");

    dut_tx_fifo_cg27 = new();
    dut_tx_fifo_cg27.set_inst_name ("dut_tx_fifo_cg27");

  endfunction
  
endclass : uart_ctrl_cover27
