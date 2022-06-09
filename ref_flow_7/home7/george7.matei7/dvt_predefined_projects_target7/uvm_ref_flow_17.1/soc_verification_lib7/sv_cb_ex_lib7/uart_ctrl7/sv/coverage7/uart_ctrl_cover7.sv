/*-------------------------------------------------------------------------
File7 name   : uart_cover7.sv
Title7       : APB7<>UART7 coverage7 collection7
Project7     :
Created7     :
Description7 : Collects7 coverage7 around7 the UART7 DUT
            : 
----------------------------------------------------------------------
Copyright7 2007 (c) Cadence7 Design7 Systems7, Inc7. All Rights7 Reserved7.
----------------------------------------------------------------------*/

class uart_ctrl_cover7 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if7 vif7;
  uart_pkg7::uart_config7 uart_cfg7;

  event tx_fifo_ptr_change7;
  event rx_fifo_ptr_change7;


  // Required7 macro7 for UVM automation7 and utilities7
  `uvm_component_utils(uart_ctrl_cover7)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage7();
      collect_rx_coverage7();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if7)::get(this, get_full_name(),"vif7", vif7))
      `uvm_fatal("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
  endfunction : connect_phase

  virtual task collect_tx_coverage7();
    // --------------------------------
    // Extract7 & re-arrange7 to give7 a more useful7 input to covergroups7
    // --------------------------------
    // Calculate7 percentage7 fill7 level of TX7 FIFO
    forever begin
      @(vif7.tx_fifo_ptr7)
    //do any processing here7
      -> tx_fifo_ptr_change7;
    end  
  endtask : collect_tx_coverage7

  virtual task collect_rx_coverage7();
    // --------------------------------
    // Extract7 & re-arrange7 to give7 a more useful7 input to covergroups7
    // --------------------------------
    // Calculate7 percentage7 fill7 level of RX7 FIFO
    forever begin
      @(vif7.rx_fifo_ptr7)
    //do any processing here7
      -> rx_fifo_ptr_change7;
    end  
  endtask : collect_rx_coverage7

  // --------------------------------
  // Covergroup7 definitions7
  // --------------------------------

  // DUT TX7 FIFO covergroup
  covergroup dut_tx_fifo_cg7 @(tx_fifo_ptr_change7);
    tx_level7              : coverpoint vif7.tx_fifo_ptr7 {
                             bins EMPTY7 = {0};
                             bins HALF_FULL7 = {[7:10]};
                             bins FULL7 = {[13:15]};
                            }
  endgroup


  // DUT RX7 FIFO covergroup
  covergroup dut_rx_fifo_cg7 @(rx_fifo_ptr_change7);
    rx_level7              : coverpoint vif7.rx_fifo_ptr7 {
                             bins EMPTY7 = {0};
                             bins HALF_FULL7 = {[7:10]};
                             bins FULL7 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg7 = new();
    dut_rx_fifo_cg7.set_inst_name ("dut_rx_fifo_cg7");

    dut_tx_fifo_cg7 = new();
    dut_tx_fifo_cg7.set_inst_name ("dut_tx_fifo_cg7");

  endfunction
  
endclass : uart_ctrl_cover7
