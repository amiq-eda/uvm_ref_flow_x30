/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_scoreboard26.sv
Title26       : APB26 - UART26 Scoreboard26
Project26     :
Created26     :
Description26 : Scoreboard26 for data integrity26 check between APB26 UVC26 and UART26 UVC26
Notes26       : Two26 similar26 scoreboards26 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb26)
`uvm_analysis_imp_decl(_uart26)

class uart_ctrl_tx_scbd26 extends uvm_scoreboard;
  bit [7:0] data_to_apb26[$];
  bit [7:0] temp126;
  bit div_en26;

  // Hooks26 to cause in scoroboard26 check errors26
  // This26 resulting26 failure26 is used in MDV26 workshop26 for failure26 analysis26
  `ifdef UVM_WKSHP26
    bit apb_error26;
  `endif

  // Config26 Information26 
  uart_pkg26::uart_config26 uart_cfg26;
  apb_pkg26::apb_slave_config26 slave_cfg26;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd26)
     `uvm_field_object(uart_cfg26, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg26, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb26 #(apb_pkg26::apb_transfer26, uart_ctrl_tx_scbd26) apb_match26;
  uvm_analysis_imp_uart26 #(uart_pkg26::uart_frame26, uart_ctrl_tx_scbd26) uart_add26;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add26  = new("uart_add26", this);
    apb_match26 = new("apb_match26", this);
  endfunction : new

  // implement UART26 Tx26 analysis26 port from reference model
  virtual function void write_uart26(uart_pkg26::uart_frame26 frame26);
    data_to_apb26.push_back(frame26.payload26);	
  endfunction : write_uart26
     
  // implement APB26 READ analysis26 port from reference model
  virtual function void write_apb26(input apb_pkg26::apb_transfer26 transfer26);

    if (transfer26.addr == (slave_cfg26.start_address26 + `LINE_CTRL26)) begin
      div_en26 = transfer26.data[7];
      `uvm_info("SCRBD26",
              $psprintf("LINE_CTRL26 Write with addr = 'h%0h and data = 'h%0h div_en26 = %0b",
              transfer26.addr, transfer26.data, div_en26 ), UVM_HIGH)
    end

    if (!div_en26) begin
    if ((transfer26.addr ==   (slave_cfg26.start_address26 + `RX_FIFO_REG26)) && (transfer26.direction26 == apb_pkg26::APB_READ26))
      begin
       `ifdef UVM_WKSHP26
          corrupt_data26(transfer26);
       `endif
          temp126 = data_to_apb26.pop_front();
       
        if (temp126 == transfer26.data ) 
          `uvm_info("SCRBD26", $psprintf("####### PASS26 : APB26 RECEIVED26 CORRECT26 DATA26 from %s  expected = 'h%0h, received26 = 'h%0h", slave_cfg26.name, temp126, transfer26.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD26", $psprintf("####### FAIL26 : APB26 RECEIVED26 WRONG26 DATA26 from %s", slave_cfg26.name))
          `uvm_info("SCRBD26", $psprintf("expected = 'h%0h, received26 = 'h%0h", temp126, transfer26.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb26
   
  function void assign_cfg26(uart_pkg26::uart_config26 u_cfg26);
    uart_cfg26 = u_cfg26;
  endfunction : assign_cfg26

  function void update_config26(uart_pkg26::uart_config26 u_cfg26);
    `uvm_info(get_type_name(), {"Updating Config26\n", u_cfg26.sprint}, UVM_HIGH)
    uart_cfg26 = u_cfg26;
  endfunction : update_config26

 `ifdef UVM_WKSHP26
    function void corrupt_data26 (apb_pkg26::apb_transfer26 transfer26);
      if (!randomize(apb_error26) with {apb_error26 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL26", $psprintf("Randomization failed for apb_error26"))
      `uvm_info("SCRBD26",(""), UVM_HIGH)
      transfer26.data+=apb_error26;    	
    endfunction : corrupt_data26
  `endif

  // Add task run to debug26 TLM connectivity26 -- dbg_lab626
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG26", "SB: Verify connections26 TX26 of scorebboard26 - using debug_provided_to", UVM_NONE)
      // Implement26 here26 the checks26 
    apb_match26.debug_provided_to();
    uart_add26.debug_provided_to();
      `uvm_info("TX_SCRB_DBG26", "SB: Verify connections26 of TX26 scorebboard26 - using debug_connected_to", UVM_NONE)
      // Implement26 here26 the checks26 
    apb_match26.debug_connected_to();
    uart_add26.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd26

class uart_ctrl_rx_scbd26 extends uvm_scoreboard;
  bit [7:0] data_from_apb26[$];
  bit [7:0] data_to_apb26[$]; // Relevant26 for Remoteloopback26 case only
  bit div_en26;

  bit [7:0] temp126;
  bit [7:0] mask;

  // Hooks26 to cause in scoroboard26 check errors26
  // This26 resulting26 failure26 is used in MDV26 workshop26 for failure26 analysis26
  `ifdef UVM_WKSHP26
    bit uart_error26;
  `endif

  uart_pkg26::uart_config26 uart_cfg26;
  apb_pkg26::apb_slave_config26 slave_cfg26;

  `uvm_component_utils(uart_ctrl_rx_scbd26)
  uvm_analysis_imp_apb26 #(apb_pkg26::apb_transfer26, uart_ctrl_rx_scbd26) apb_add26;
  uvm_analysis_imp_uart26 #(uart_pkg26::uart_frame26, uart_ctrl_rx_scbd26) uart_match26;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match26 = new("uart_match26", this);
    apb_add26    = new("apb_add26", this);
  endfunction : new
   
  // implement APB26 WRITE analysis26 port from reference model
  virtual function void write_apb26(input apb_pkg26::apb_transfer26 transfer26);
    `uvm_info("SCRBD26",
              $psprintf("write_apb26 called with addr = 'h%0h and data = 'h%0h",
              transfer26.addr, transfer26.data), UVM_HIGH)
    if ((transfer26.addr == (slave_cfg26.start_address26 + `LINE_CTRL26)) &&
        (transfer26.direction26 == apb_pkg26::APB_WRITE26)) begin
      div_en26 = transfer26.data[7];
      `uvm_info("SCRBD26",
              $psprintf("LINE_CTRL26 Write with addr = 'h%0h and data = 'h%0h div_en26 = %0b",
              transfer26.addr, transfer26.data, div_en26 ), UVM_HIGH)
    end

    if (!div_en26) begin
      if ((transfer26.addr == (slave_cfg26.start_address26 + `TX_FIFO_REG26)) &&
          (transfer26.direction26 == apb_pkg26::APB_WRITE26)) begin 
        `uvm_info("SCRBD26",
               $psprintf("write_apb26 called pushing26 into queue with data = 'h%0h",
               transfer26.data ), UVM_HIGH)
        data_from_apb26.push_back(transfer26.data);
      end
    end
  endfunction : write_apb26
   
  // implement UART26 Rx26 analysis26 port from reference model
  virtual function void write_uart26( uart_pkg26::uart_frame26 frame26);
    mask = calc_mask26();

    //In case of remote26 loopback26, the data does not get into the rx26/fifo and it gets26 
    // loopbacked26 to ua_txd26. 
    data_to_apb26.push_back(frame26.payload26);	

      temp126 = data_from_apb26.pop_front();

    `ifdef UVM_WKSHP26
        corrupt_payload26 (frame26);
    `endif 
    if ((temp126 & mask) == frame26.payload26) 
      `uvm_info("SCRBD26", $psprintf("####### PASS26 : %s RECEIVED26 CORRECT26 DATA26 expected = 'h%0h, received26 = 'h%0h", slave_cfg26.name, (temp126 & mask), frame26.payload26), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD26", $psprintf("####### FAIL26 : %s RECEIVED26 WRONG26 DATA26", slave_cfg26.name))
      `uvm_info("SCRBD26", $psprintf("expected = 'h%0h, received26 = 'h%0h", temp126, frame26.payload26), UVM_LOW)
    end
  endfunction : write_uart26
   
  function void assign_cfg26(uart_pkg26::uart_config26 u_cfg26);
     uart_cfg26 = u_cfg26;
  endfunction : assign_cfg26
   
  function void update_config26(uart_pkg26::uart_config26 u_cfg26);
   `uvm_info(get_type_name(), {"Updating Config26\n", u_cfg26.sprint}, UVM_HIGH)
    uart_cfg26 = u_cfg26;
  endfunction : update_config26

  function bit[7:0] calc_mask26();
    case (uart_cfg26.char_len_val26)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask26

  `ifdef UVM_WKSHP26
   function void corrupt_payload26 (uart_pkg26::uart_frame26 frame26);
      if(!randomize(uart_error26) with {uart_error26 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL26", $psprintf("Randomization failed for apb_error26"))
      `uvm_info("SCRBD26",(""), UVM_HIGH)
      frame26.payload26+=uart_error26;    	
   endfunction : corrupt_payload26

  `endif

  // Add task run to debug26 TLM connectivity26
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist26;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG26", "SB: Verify connections26 RX26 of scorebboard26 - using debug_provided_to", UVM_NONE)
      // Implement26 here26 the checks26 
    apb_add26.debug_provided_to();
    uart_match26.debug_provided_to();
      `uvm_info("RX_SCRB_DBG26", "SB: Verify connections26 of RX26 scorebboard26 - using debug_connected_to", UVM_NONE)
      // Implement26 here26 the checks26 
    apb_add26.debug_connected_to();
    uart_match26.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd26
