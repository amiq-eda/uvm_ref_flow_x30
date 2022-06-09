/*-------------------------------------------------------------------------
File17 name   : uart_ctrl_scoreboard17.sv
Title17       : APB17 - UART17 Scoreboard17
Project17     :
Created17     :
Description17 : Scoreboard17 for data integrity17 check between APB17 UVC17 and UART17 UVC17
Notes17       : Two17 similar17 scoreboards17 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb17)
`uvm_analysis_imp_decl(_uart17)

class uart_ctrl_tx_scbd17 extends uvm_scoreboard;
  bit [7:0] data_to_apb17[$];
  bit [7:0] temp117;
  bit div_en17;

  // Hooks17 to cause in scoroboard17 check errors17
  // This17 resulting17 failure17 is used in MDV17 workshop17 for failure17 analysis17
  `ifdef UVM_WKSHP17
    bit apb_error17;
  `endif

  // Config17 Information17 
  uart_pkg17::uart_config17 uart_cfg17;
  apb_pkg17::apb_slave_config17 slave_cfg17;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd17)
     `uvm_field_object(uart_cfg17, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg17, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb17 #(apb_pkg17::apb_transfer17, uart_ctrl_tx_scbd17) apb_match17;
  uvm_analysis_imp_uart17 #(uart_pkg17::uart_frame17, uart_ctrl_tx_scbd17) uart_add17;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add17  = new("uart_add17", this);
    apb_match17 = new("apb_match17", this);
  endfunction : new

  // implement UART17 Tx17 analysis17 port from reference model
  virtual function void write_uart17(uart_pkg17::uart_frame17 frame17);
    data_to_apb17.push_back(frame17.payload17);	
  endfunction : write_uart17
     
  // implement APB17 READ analysis17 port from reference model
  virtual function void write_apb17(input apb_pkg17::apb_transfer17 transfer17);

    if (transfer17.addr == (slave_cfg17.start_address17 + `LINE_CTRL17)) begin
      div_en17 = transfer17.data[7];
      `uvm_info("SCRBD17",
              $psprintf("LINE_CTRL17 Write with addr = 'h%0h and data = 'h%0h div_en17 = %0b",
              transfer17.addr, transfer17.data, div_en17 ), UVM_HIGH)
    end

    if (!div_en17) begin
    if ((transfer17.addr ==   (slave_cfg17.start_address17 + `RX_FIFO_REG17)) && (transfer17.direction17 == apb_pkg17::APB_READ17))
      begin
       `ifdef UVM_WKSHP17
          corrupt_data17(transfer17);
       `endif
          temp117 = data_to_apb17.pop_front();
       
        if (temp117 == transfer17.data ) 
          `uvm_info("SCRBD17", $psprintf("####### PASS17 : APB17 RECEIVED17 CORRECT17 DATA17 from %s  expected = 'h%0h, received17 = 'h%0h", slave_cfg17.name, temp117, transfer17.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD17", $psprintf("####### FAIL17 : APB17 RECEIVED17 WRONG17 DATA17 from %s", slave_cfg17.name))
          `uvm_info("SCRBD17", $psprintf("expected = 'h%0h, received17 = 'h%0h", temp117, transfer17.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb17
   
  function void assign_cfg17(uart_pkg17::uart_config17 u_cfg17);
    uart_cfg17 = u_cfg17;
  endfunction : assign_cfg17

  function void update_config17(uart_pkg17::uart_config17 u_cfg17);
    `uvm_info(get_type_name(), {"Updating Config17\n", u_cfg17.sprint}, UVM_HIGH)
    uart_cfg17 = u_cfg17;
  endfunction : update_config17

 `ifdef UVM_WKSHP17
    function void corrupt_data17 (apb_pkg17::apb_transfer17 transfer17);
      if (!randomize(apb_error17) with {apb_error17 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL17", $psprintf("Randomization failed for apb_error17"))
      `uvm_info("SCRBD17",(""), UVM_HIGH)
      transfer17.data+=apb_error17;    	
    endfunction : corrupt_data17
  `endif

  // Add task run to debug17 TLM connectivity17 -- dbg_lab617
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG17", "SB: Verify connections17 TX17 of scorebboard17 - using debug_provided_to", UVM_NONE)
      // Implement17 here17 the checks17 
    apb_match17.debug_provided_to();
    uart_add17.debug_provided_to();
      `uvm_info("TX_SCRB_DBG17", "SB: Verify connections17 of TX17 scorebboard17 - using debug_connected_to", UVM_NONE)
      // Implement17 here17 the checks17 
    apb_match17.debug_connected_to();
    uart_add17.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd17

class uart_ctrl_rx_scbd17 extends uvm_scoreboard;
  bit [7:0] data_from_apb17[$];
  bit [7:0] data_to_apb17[$]; // Relevant17 for Remoteloopback17 case only
  bit div_en17;

  bit [7:0] temp117;
  bit [7:0] mask;

  // Hooks17 to cause in scoroboard17 check errors17
  // This17 resulting17 failure17 is used in MDV17 workshop17 for failure17 analysis17
  `ifdef UVM_WKSHP17
    bit uart_error17;
  `endif

  uart_pkg17::uart_config17 uart_cfg17;
  apb_pkg17::apb_slave_config17 slave_cfg17;

  `uvm_component_utils(uart_ctrl_rx_scbd17)
  uvm_analysis_imp_apb17 #(apb_pkg17::apb_transfer17, uart_ctrl_rx_scbd17) apb_add17;
  uvm_analysis_imp_uart17 #(uart_pkg17::uart_frame17, uart_ctrl_rx_scbd17) uart_match17;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match17 = new("uart_match17", this);
    apb_add17    = new("apb_add17", this);
  endfunction : new
   
  // implement APB17 WRITE analysis17 port from reference model
  virtual function void write_apb17(input apb_pkg17::apb_transfer17 transfer17);
    `uvm_info("SCRBD17",
              $psprintf("write_apb17 called with addr = 'h%0h and data = 'h%0h",
              transfer17.addr, transfer17.data), UVM_HIGH)
    if ((transfer17.addr == (slave_cfg17.start_address17 + `LINE_CTRL17)) &&
        (transfer17.direction17 == apb_pkg17::APB_WRITE17)) begin
      div_en17 = transfer17.data[7];
      `uvm_info("SCRBD17",
              $psprintf("LINE_CTRL17 Write with addr = 'h%0h and data = 'h%0h div_en17 = %0b",
              transfer17.addr, transfer17.data, div_en17 ), UVM_HIGH)
    end

    if (!div_en17) begin
      if ((transfer17.addr == (slave_cfg17.start_address17 + `TX_FIFO_REG17)) &&
          (transfer17.direction17 == apb_pkg17::APB_WRITE17)) begin 
        `uvm_info("SCRBD17",
               $psprintf("write_apb17 called pushing17 into queue with data = 'h%0h",
               transfer17.data ), UVM_HIGH)
        data_from_apb17.push_back(transfer17.data);
      end
    end
  endfunction : write_apb17
   
  // implement UART17 Rx17 analysis17 port from reference model
  virtual function void write_uart17( uart_pkg17::uart_frame17 frame17);
    mask = calc_mask17();

    //In case of remote17 loopback17, the data does not get into the rx17/fifo and it gets17 
    // loopbacked17 to ua_txd17. 
    data_to_apb17.push_back(frame17.payload17);	

      temp117 = data_from_apb17.pop_front();

    `ifdef UVM_WKSHP17
        corrupt_payload17 (frame17);
    `endif 
    if ((temp117 & mask) == frame17.payload17) 
      `uvm_info("SCRBD17", $psprintf("####### PASS17 : %s RECEIVED17 CORRECT17 DATA17 expected = 'h%0h, received17 = 'h%0h", slave_cfg17.name, (temp117 & mask), frame17.payload17), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD17", $psprintf("####### FAIL17 : %s RECEIVED17 WRONG17 DATA17", slave_cfg17.name))
      `uvm_info("SCRBD17", $psprintf("expected = 'h%0h, received17 = 'h%0h", temp117, frame17.payload17), UVM_LOW)
    end
  endfunction : write_uart17
   
  function void assign_cfg17(uart_pkg17::uart_config17 u_cfg17);
     uart_cfg17 = u_cfg17;
  endfunction : assign_cfg17
   
  function void update_config17(uart_pkg17::uart_config17 u_cfg17);
   `uvm_info(get_type_name(), {"Updating Config17\n", u_cfg17.sprint}, UVM_HIGH)
    uart_cfg17 = u_cfg17;
  endfunction : update_config17

  function bit[7:0] calc_mask17();
    case (uart_cfg17.char_len_val17)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask17

  `ifdef UVM_WKSHP17
   function void corrupt_payload17 (uart_pkg17::uart_frame17 frame17);
      if(!randomize(uart_error17) with {uart_error17 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL17", $psprintf("Randomization failed for apb_error17"))
      `uvm_info("SCRBD17",(""), UVM_HIGH)
      frame17.payload17+=uart_error17;    	
   endfunction : corrupt_payload17

  `endif

  // Add task run to debug17 TLM connectivity17
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist17;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG17", "SB: Verify connections17 RX17 of scorebboard17 - using debug_provided_to", UVM_NONE)
      // Implement17 here17 the checks17 
    apb_add17.debug_provided_to();
    uart_match17.debug_provided_to();
      `uvm_info("RX_SCRB_DBG17", "SB: Verify connections17 of RX17 scorebboard17 - using debug_connected_to", UVM_NONE)
      // Implement17 here17 the checks17 
    apb_add17.debug_connected_to();
    uart_match17.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd17
