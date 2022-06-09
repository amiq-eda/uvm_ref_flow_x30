/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_scoreboard13.sv
Title13       : APB13 - UART13 Scoreboard13
Project13     :
Created13     :
Description13 : Scoreboard13 for data integrity13 check between APB13 UVC13 and UART13 UVC13
Notes13       : Two13 similar13 scoreboards13 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb13)
`uvm_analysis_imp_decl(_uart13)

class uart_ctrl_tx_scbd13 extends uvm_scoreboard;
  bit [7:0] data_to_apb13[$];
  bit [7:0] temp113;
  bit div_en13;

  // Hooks13 to cause in scoroboard13 check errors13
  // This13 resulting13 failure13 is used in MDV13 workshop13 for failure13 analysis13
  `ifdef UVM_WKSHP13
    bit apb_error13;
  `endif

  // Config13 Information13 
  uart_pkg13::uart_config13 uart_cfg13;
  apb_pkg13::apb_slave_config13 slave_cfg13;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd13)
     `uvm_field_object(uart_cfg13, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg13, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb13 #(apb_pkg13::apb_transfer13, uart_ctrl_tx_scbd13) apb_match13;
  uvm_analysis_imp_uart13 #(uart_pkg13::uart_frame13, uart_ctrl_tx_scbd13) uart_add13;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add13  = new("uart_add13", this);
    apb_match13 = new("apb_match13", this);
  endfunction : new

  // implement UART13 Tx13 analysis13 port from reference model
  virtual function void write_uart13(uart_pkg13::uart_frame13 frame13);
    data_to_apb13.push_back(frame13.payload13);	
  endfunction : write_uart13
     
  // implement APB13 READ analysis13 port from reference model
  virtual function void write_apb13(input apb_pkg13::apb_transfer13 transfer13);

    if (transfer13.addr == (slave_cfg13.start_address13 + `LINE_CTRL13)) begin
      div_en13 = transfer13.data[7];
      `uvm_info("SCRBD13",
              $psprintf("LINE_CTRL13 Write with addr = 'h%0h and data = 'h%0h div_en13 = %0b",
              transfer13.addr, transfer13.data, div_en13 ), UVM_HIGH)
    end

    if (!div_en13) begin
    if ((transfer13.addr ==   (slave_cfg13.start_address13 + `RX_FIFO_REG13)) && (transfer13.direction13 == apb_pkg13::APB_READ13))
      begin
       `ifdef UVM_WKSHP13
          corrupt_data13(transfer13);
       `endif
          temp113 = data_to_apb13.pop_front();
       
        if (temp113 == transfer13.data ) 
          `uvm_info("SCRBD13", $psprintf("####### PASS13 : APB13 RECEIVED13 CORRECT13 DATA13 from %s  expected = 'h%0h, received13 = 'h%0h", slave_cfg13.name, temp113, transfer13.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD13", $psprintf("####### FAIL13 : APB13 RECEIVED13 WRONG13 DATA13 from %s", slave_cfg13.name))
          `uvm_info("SCRBD13", $psprintf("expected = 'h%0h, received13 = 'h%0h", temp113, transfer13.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb13
   
  function void assign_cfg13(uart_pkg13::uart_config13 u_cfg13);
    uart_cfg13 = u_cfg13;
  endfunction : assign_cfg13

  function void update_config13(uart_pkg13::uart_config13 u_cfg13);
    `uvm_info(get_type_name(), {"Updating Config13\n", u_cfg13.sprint}, UVM_HIGH)
    uart_cfg13 = u_cfg13;
  endfunction : update_config13

 `ifdef UVM_WKSHP13
    function void corrupt_data13 (apb_pkg13::apb_transfer13 transfer13);
      if (!randomize(apb_error13) with {apb_error13 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL13", $psprintf("Randomization failed for apb_error13"))
      `uvm_info("SCRBD13",(""), UVM_HIGH)
      transfer13.data+=apb_error13;    	
    endfunction : corrupt_data13
  `endif

  // Add task run to debug13 TLM connectivity13 -- dbg_lab613
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG13", "SB: Verify connections13 TX13 of scorebboard13 - using debug_provided_to", UVM_NONE)
      // Implement13 here13 the checks13 
    apb_match13.debug_provided_to();
    uart_add13.debug_provided_to();
      `uvm_info("TX_SCRB_DBG13", "SB: Verify connections13 of TX13 scorebboard13 - using debug_connected_to", UVM_NONE)
      // Implement13 here13 the checks13 
    apb_match13.debug_connected_to();
    uart_add13.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd13

class uart_ctrl_rx_scbd13 extends uvm_scoreboard;
  bit [7:0] data_from_apb13[$];
  bit [7:0] data_to_apb13[$]; // Relevant13 for Remoteloopback13 case only
  bit div_en13;

  bit [7:0] temp113;
  bit [7:0] mask;

  // Hooks13 to cause in scoroboard13 check errors13
  // This13 resulting13 failure13 is used in MDV13 workshop13 for failure13 analysis13
  `ifdef UVM_WKSHP13
    bit uart_error13;
  `endif

  uart_pkg13::uart_config13 uart_cfg13;
  apb_pkg13::apb_slave_config13 slave_cfg13;

  `uvm_component_utils(uart_ctrl_rx_scbd13)
  uvm_analysis_imp_apb13 #(apb_pkg13::apb_transfer13, uart_ctrl_rx_scbd13) apb_add13;
  uvm_analysis_imp_uart13 #(uart_pkg13::uart_frame13, uart_ctrl_rx_scbd13) uart_match13;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match13 = new("uart_match13", this);
    apb_add13    = new("apb_add13", this);
  endfunction : new
   
  // implement APB13 WRITE analysis13 port from reference model
  virtual function void write_apb13(input apb_pkg13::apb_transfer13 transfer13);
    `uvm_info("SCRBD13",
              $psprintf("write_apb13 called with addr = 'h%0h and data = 'h%0h",
              transfer13.addr, transfer13.data), UVM_HIGH)
    if ((transfer13.addr == (slave_cfg13.start_address13 + `LINE_CTRL13)) &&
        (transfer13.direction13 == apb_pkg13::APB_WRITE13)) begin
      div_en13 = transfer13.data[7];
      `uvm_info("SCRBD13",
              $psprintf("LINE_CTRL13 Write with addr = 'h%0h and data = 'h%0h div_en13 = %0b",
              transfer13.addr, transfer13.data, div_en13 ), UVM_HIGH)
    end

    if (!div_en13) begin
      if ((transfer13.addr == (slave_cfg13.start_address13 + `TX_FIFO_REG13)) &&
          (transfer13.direction13 == apb_pkg13::APB_WRITE13)) begin 
        `uvm_info("SCRBD13",
               $psprintf("write_apb13 called pushing13 into queue with data = 'h%0h",
               transfer13.data ), UVM_HIGH)
        data_from_apb13.push_back(transfer13.data);
      end
    end
  endfunction : write_apb13
   
  // implement UART13 Rx13 analysis13 port from reference model
  virtual function void write_uart13( uart_pkg13::uart_frame13 frame13);
    mask = calc_mask13();

    //In case of remote13 loopback13, the data does not get into the rx13/fifo and it gets13 
    // loopbacked13 to ua_txd13. 
    data_to_apb13.push_back(frame13.payload13);	

      temp113 = data_from_apb13.pop_front();

    `ifdef UVM_WKSHP13
        corrupt_payload13 (frame13);
    `endif 
    if ((temp113 & mask) == frame13.payload13) 
      `uvm_info("SCRBD13", $psprintf("####### PASS13 : %s RECEIVED13 CORRECT13 DATA13 expected = 'h%0h, received13 = 'h%0h", slave_cfg13.name, (temp113 & mask), frame13.payload13), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD13", $psprintf("####### FAIL13 : %s RECEIVED13 WRONG13 DATA13", slave_cfg13.name))
      `uvm_info("SCRBD13", $psprintf("expected = 'h%0h, received13 = 'h%0h", temp113, frame13.payload13), UVM_LOW)
    end
  endfunction : write_uart13
   
  function void assign_cfg13(uart_pkg13::uart_config13 u_cfg13);
     uart_cfg13 = u_cfg13;
  endfunction : assign_cfg13
   
  function void update_config13(uart_pkg13::uart_config13 u_cfg13);
   `uvm_info(get_type_name(), {"Updating Config13\n", u_cfg13.sprint}, UVM_HIGH)
    uart_cfg13 = u_cfg13;
  endfunction : update_config13

  function bit[7:0] calc_mask13();
    case (uart_cfg13.char_len_val13)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask13

  `ifdef UVM_WKSHP13
   function void corrupt_payload13 (uart_pkg13::uart_frame13 frame13);
      if(!randomize(uart_error13) with {uart_error13 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL13", $psprintf("Randomization failed for apb_error13"))
      `uvm_info("SCRBD13",(""), UVM_HIGH)
      frame13.payload13+=uart_error13;    	
   endfunction : corrupt_payload13

  `endif

  // Add task run to debug13 TLM connectivity13
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist13;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG13", "SB: Verify connections13 RX13 of scorebboard13 - using debug_provided_to", UVM_NONE)
      // Implement13 here13 the checks13 
    apb_add13.debug_provided_to();
    uart_match13.debug_provided_to();
      `uvm_info("RX_SCRB_DBG13", "SB: Verify connections13 of RX13 scorebboard13 - using debug_connected_to", UVM_NONE)
      // Implement13 here13 the checks13 
    apb_add13.debug_connected_to();
    uart_match13.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd13
