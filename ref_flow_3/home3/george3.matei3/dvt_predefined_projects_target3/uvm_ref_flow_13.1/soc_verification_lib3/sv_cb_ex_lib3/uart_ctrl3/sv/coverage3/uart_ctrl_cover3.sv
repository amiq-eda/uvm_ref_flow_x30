/*-------------------------------------------------------------------------
File3 name   : uart_cover3.sv
Title3       : APB3<>UART3 coverage3 collection3
Project3     :
Created3     :
Description3 : Collects3 coverage3 around3 the UART3 DUT
            : 
----------------------------------------------------------------------
Copyright3 2007 (c) Cadence3 Design3 Systems3, Inc3. All Rights3 Reserved3.
----------------------------------------------------------------------*/

class uart_ctrl_cover3 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if3 vif3;
  uart_pkg3::uart_config3 uart_cfg3;

  event tx_fifo_ptr_change3;
  event rx_fifo_ptr_change3;


  // Required3 macro3 for UVM automation3 and utilities3
  `uvm_component_utils(uart_ctrl_cover3)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage3();
      collect_rx_coverage3();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if3)::get(this, get_full_name(),"vif3", vif3))
      `uvm_fatal("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
  endfunction : connect_phase

  virtual task collect_tx_coverage3();
    // --------------------------------
    // Extract3 & re-arrange3 to give3 a more useful3 input to covergroups3
    // --------------------------------
    // Calculate3 percentage3 fill3 level of TX3 FIFO
    forever begin
      @(vif3.tx_fifo_ptr3)
    //do any processing here3
      -> tx_fifo_ptr_change3;
    end  
  endtask : collect_tx_coverage3

  virtual task collect_rx_coverage3();
    // --------------------------------
    // Extract3 & re-arrange3 to give3 a more useful3 input to covergroups3
    // --------------------------------
    // Calculate3 percentage3 fill3 level of RX3 FIFO
    forever begin
      @(vif3.rx_fifo_ptr3)
    //do any processing here3
      -> rx_fifo_ptr_change3;
    end  
  endtask : collect_rx_coverage3

  // --------------------------------
  // Covergroup3 definitions3
  // --------------------------------

  // DUT TX3 FIFO covergroup
  covergroup dut_tx_fifo_cg3 @(tx_fifo_ptr_change3);
    tx_level3              : coverpoint vif3.tx_fifo_ptr3 {
                             bins EMPTY3 = {0};
                             bins HALF_FULL3 = {[7:10]};
                             bins FULL3 = {[13:15]};
                            }
  endgroup


  // DUT RX3 FIFO covergroup
  covergroup dut_rx_fifo_cg3 @(rx_fifo_ptr_change3);
    rx_level3              : coverpoint vif3.rx_fifo_ptr3 {
                             bins EMPTY3 = {0};
                             bins HALF_FULL3 = {[7:10]};
                             bins FULL3 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg3 = new();
    dut_rx_fifo_cg3.set_inst_name ("dut_rx_fifo_cg3");

    dut_tx_fifo_cg3 = new();
    dut_tx_fifo_cg3.set_inst_name ("dut_tx_fifo_cg3");

  endfunction
  
endclass : uart_ctrl_cover3
