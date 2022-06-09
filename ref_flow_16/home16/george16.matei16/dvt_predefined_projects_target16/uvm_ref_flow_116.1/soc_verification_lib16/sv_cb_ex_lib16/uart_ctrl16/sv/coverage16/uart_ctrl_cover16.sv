/*-------------------------------------------------------------------------
File16 name   : uart_cover16.sv
Title16       : APB16<>UART16 coverage16 collection16
Project16     :
Created16     :
Description16 : Collects16 coverage16 around16 the UART16 DUT
            : 
----------------------------------------------------------------------
Copyright16 2007 (c) Cadence16 Design16 Systems16, Inc16. All Rights16 Reserved16.
----------------------------------------------------------------------*/

class uart_ctrl_cover16 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if16 vif16;
  uart_pkg16::uart_config16 uart_cfg16;

  event tx_fifo_ptr_change16;
  event rx_fifo_ptr_change16;


  // Required16 macro16 for UVM automation16 and utilities16
  `uvm_component_utils(uart_ctrl_cover16)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage16();
      collect_rx_coverage16();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if16)::get(this, get_full_name(),"vif16", vif16))
      `uvm_fatal("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
  endfunction : connect_phase

  virtual task collect_tx_coverage16();
    // --------------------------------
    // Extract16 & re-arrange16 to give16 a more useful16 input to covergroups16
    // --------------------------------
    // Calculate16 percentage16 fill16 level of TX16 FIFO
    forever begin
      @(vif16.tx_fifo_ptr16)
    //do any processing here16
      -> tx_fifo_ptr_change16;
    end  
  endtask : collect_tx_coverage16

  virtual task collect_rx_coverage16();
    // --------------------------------
    // Extract16 & re-arrange16 to give16 a more useful16 input to covergroups16
    // --------------------------------
    // Calculate16 percentage16 fill16 level of RX16 FIFO
    forever begin
      @(vif16.rx_fifo_ptr16)
    //do any processing here16
      -> rx_fifo_ptr_change16;
    end  
  endtask : collect_rx_coverage16

  // --------------------------------
  // Covergroup16 definitions16
  // --------------------------------

  // DUT TX16 FIFO covergroup
  covergroup dut_tx_fifo_cg16 @(tx_fifo_ptr_change16);
    tx_level16              : coverpoint vif16.tx_fifo_ptr16 {
                             bins EMPTY16 = {0};
                             bins HALF_FULL16 = {[7:10]};
                             bins FULL16 = {[13:15]};
                            }
  endgroup


  // DUT RX16 FIFO covergroup
  covergroup dut_rx_fifo_cg16 @(rx_fifo_ptr_change16);
    rx_level16              : coverpoint vif16.rx_fifo_ptr16 {
                             bins EMPTY16 = {0};
                             bins HALF_FULL16 = {[7:10]};
                             bins FULL16 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg16 = new();
    dut_rx_fifo_cg16.set_inst_name ("dut_rx_fifo_cg16");

    dut_tx_fifo_cg16 = new();
    dut_tx_fifo_cg16.set_inst_name ("dut_tx_fifo_cg16");

  endfunction
  
endclass : uart_ctrl_cover16
