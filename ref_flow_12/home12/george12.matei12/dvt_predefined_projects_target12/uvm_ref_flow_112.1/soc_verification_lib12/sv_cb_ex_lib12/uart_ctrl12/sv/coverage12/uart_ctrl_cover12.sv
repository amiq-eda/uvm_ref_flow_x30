/*-------------------------------------------------------------------------
File12 name   : uart_cover12.sv
Title12       : APB12<>UART12 coverage12 collection12
Project12     :
Created12     :
Description12 : Collects12 coverage12 around12 the UART12 DUT
            : 
----------------------------------------------------------------------
Copyright12 2007 (c) Cadence12 Design12 Systems12, Inc12. All Rights12 Reserved12.
----------------------------------------------------------------------*/

class uart_ctrl_cover12 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if12 vif12;
  uart_pkg12::uart_config12 uart_cfg12;

  event tx_fifo_ptr_change12;
  event rx_fifo_ptr_change12;


  // Required12 macro12 for UVM automation12 and utilities12
  `uvm_component_utils(uart_ctrl_cover12)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage12();
      collect_rx_coverage12();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if12)::get(this, get_full_name(),"vif12", vif12))
      `uvm_fatal("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
  endfunction : connect_phase

  virtual task collect_tx_coverage12();
    // --------------------------------
    // Extract12 & re-arrange12 to give12 a more useful12 input to covergroups12
    // --------------------------------
    // Calculate12 percentage12 fill12 level of TX12 FIFO
    forever begin
      @(vif12.tx_fifo_ptr12)
    //do any processing here12
      -> tx_fifo_ptr_change12;
    end  
  endtask : collect_tx_coverage12

  virtual task collect_rx_coverage12();
    // --------------------------------
    // Extract12 & re-arrange12 to give12 a more useful12 input to covergroups12
    // --------------------------------
    // Calculate12 percentage12 fill12 level of RX12 FIFO
    forever begin
      @(vif12.rx_fifo_ptr12)
    //do any processing here12
      -> rx_fifo_ptr_change12;
    end  
  endtask : collect_rx_coverage12

  // --------------------------------
  // Covergroup12 definitions12
  // --------------------------------

  // DUT TX12 FIFO covergroup
  covergroup dut_tx_fifo_cg12 @(tx_fifo_ptr_change12);
    tx_level12              : coverpoint vif12.tx_fifo_ptr12 {
                             bins EMPTY12 = {0};
                             bins HALF_FULL12 = {[7:10]};
                             bins FULL12 = {[13:15]};
                            }
  endgroup


  // DUT RX12 FIFO covergroup
  covergroup dut_rx_fifo_cg12 @(rx_fifo_ptr_change12);
    rx_level12              : coverpoint vif12.rx_fifo_ptr12 {
                             bins EMPTY12 = {0};
                             bins HALF_FULL12 = {[7:10]};
                             bins FULL12 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg12 = new();
    dut_rx_fifo_cg12.set_inst_name ("dut_rx_fifo_cg12");

    dut_tx_fifo_cg12 = new();
    dut_tx_fifo_cg12.set_inst_name ("dut_tx_fifo_cg12");

  endfunction
  
endclass : uart_ctrl_cover12
