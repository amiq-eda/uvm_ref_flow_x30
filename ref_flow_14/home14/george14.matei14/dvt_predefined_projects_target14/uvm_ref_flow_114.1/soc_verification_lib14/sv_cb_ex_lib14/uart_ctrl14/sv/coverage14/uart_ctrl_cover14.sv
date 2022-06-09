/*-------------------------------------------------------------------------
File14 name   : uart_cover14.sv
Title14       : APB14<>UART14 coverage14 collection14
Project14     :
Created14     :
Description14 : Collects14 coverage14 around14 the UART14 DUT
            : 
----------------------------------------------------------------------
Copyright14 2007 (c) Cadence14 Design14 Systems14, Inc14. All Rights14 Reserved14.
----------------------------------------------------------------------*/

class uart_ctrl_cover14 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if14 vif14;
  uart_pkg14::uart_config14 uart_cfg14;

  event tx_fifo_ptr_change14;
  event rx_fifo_ptr_change14;


  // Required14 macro14 for UVM automation14 and utilities14
  `uvm_component_utils(uart_ctrl_cover14)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage14();
      collect_rx_coverage14();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if14)::get(this, get_full_name(),"vif14", vif14))
      `uvm_fatal("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
  endfunction : connect_phase

  virtual task collect_tx_coverage14();
    // --------------------------------
    // Extract14 & re-arrange14 to give14 a more useful14 input to covergroups14
    // --------------------------------
    // Calculate14 percentage14 fill14 level of TX14 FIFO
    forever begin
      @(vif14.tx_fifo_ptr14)
    //do any processing here14
      -> tx_fifo_ptr_change14;
    end  
  endtask : collect_tx_coverage14

  virtual task collect_rx_coverage14();
    // --------------------------------
    // Extract14 & re-arrange14 to give14 a more useful14 input to covergroups14
    // --------------------------------
    // Calculate14 percentage14 fill14 level of RX14 FIFO
    forever begin
      @(vif14.rx_fifo_ptr14)
    //do any processing here14
      -> rx_fifo_ptr_change14;
    end  
  endtask : collect_rx_coverage14

  // --------------------------------
  // Covergroup14 definitions14
  // --------------------------------

  // DUT TX14 FIFO covergroup
  covergroup dut_tx_fifo_cg14 @(tx_fifo_ptr_change14);
    tx_level14              : coverpoint vif14.tx_fifo_ptr14 {
                             bins EMPTY14 = {0};
                             bins HALF_FULL14 = {[7:10]};
                             bins FULL14 = {[13:15]};
                            }
  endgroup


  // DUT RX14 FIFO covergroup
  covergroup dut_rx_fifo_cg14 @(rx_fifo_ptr_change14);
    rx_level14              : coverpoint vif14.rx_fifo_ptr14 {
                             bins EMPTY14 = {0};
                             bins HALF_FULL14 = {[7:10]};
                             bins FULL14 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg14 = new();
    dut_rx_fifo_cg14.set_inst_name ("dut_rx_fifo_cg14");

    dut_tx_fifo_cg14 = new();
    dut_tx_fifo_cg14.set_inst_name ("dut_tx_fifo_cg14");

  endfunction
  
endclass : uart_ctrl_cover14
