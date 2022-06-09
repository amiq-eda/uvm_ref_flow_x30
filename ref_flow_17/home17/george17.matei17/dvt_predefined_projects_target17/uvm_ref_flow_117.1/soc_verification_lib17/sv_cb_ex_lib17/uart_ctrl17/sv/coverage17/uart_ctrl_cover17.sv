/*-------------------------------------------------------------------------
File17 name   : uart_cover17.sv
Title17       : APB17<>UART17 coverage17 collection17
Project17     :
Created17     :
Description17 : Collects17 coverage17 around17 the UART17 DUT
            : 
----------------------------------------------------------------------
Copyright17 2007 (c) Cadence17 Design17 Systems17, Inc17. All Rights17 Reserved17.
----------------------------------------------------------------------*/

class uart_ctrl_cover17 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if17 vif17;
  uart_pkg17::uart_config17 uart_cfg17;

  event tx_fifo_ptr_change17;
  event rx_fifo_ptr_change17;


  // Required17 macro17 for UVM automation17 and utilities17
  `uvm_component_utils(uart_ctrl_cover17)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage17();
      collect_rx_coverage17();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if17)::get(this, get_full_name(),"vif17", vif17))
      `uvm_fatal("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
  endfunction : connect_phase

  virtual task collect_tx_coverage17();
    // --------------------------------
    // Extract17 & re-arrange17 to give17 a more useful17 input to covergroups17
    // --------------------------------
    // Calculate17 percentage17 fill17 level of TX17 FIFO
    forever begin
      @(vif17.tx_fifo_ptr17)
    //do any processing here17
      -> tx_fifo_ptr_change17;
    end  
  endtask : collect_tx_coverage17

  virtual task collect_rx_coverage17();
    // --------------------------------
    // Extract17 & re-arrange17 to give17 a more useful17 input to covergroups17
    // --------------------------------
    // Calculate17 percentage17 fill17 level of RX17 FIFO
    forever begin
      @(vif17.rx_fifo_ptr17)
    //do any processing here17
      -> rx_fifo_ptr_change17;
    end  
  endtask : collect_rx_coverage17

  // --------------------------------
  // Covergroup17 definitions17
  // --------------------------------

  // DUT TX17 FIFO covergroup
  covergroup dut_tx_fifo_cg17 @(tx_fifo_ptr_change17);
    tx_level17              : coverpoint vif17.tx_fifo_ptr17 {
                             bins EMPTY17 = {0};
                             bins HALF_FULL17 = {[7:10]};
                             bins FULL17 = {[13:15]};
                            }
  endgroup


  // DUT RX17 FIFO covergroup
  covergroup dut_rx_fifo_cg17 @(rx_fifo_ptr_change17);
    rx_level17              : coverpoint vif17.rx_fifo_ptr17 {
                             bins EMPTY17 = {0};
                             bins HALF_FULL17 = {[7:10]};
                             bins FULL17 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg17 = new();
    dut_rx_fifo_cg17.set_inst_name ("dut_rx_fifo_cg17");

    dut_tx_fifo_cg17 = new();
    dut_tx_fifo_cg17.set_inst_name ("dut_tx_fifo_cg17");

  endfunction
  
endclass : uart_ctrl_cover17
