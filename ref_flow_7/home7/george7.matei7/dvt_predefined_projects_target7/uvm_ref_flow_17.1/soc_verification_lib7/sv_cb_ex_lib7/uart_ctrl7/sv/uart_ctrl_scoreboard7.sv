/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_scoreboard7.sv
Title7       : APB7 - UART7 Scoreboard7
Project7     :
Created7     :
Description7 : Scoreboard7 for data integrity7 check between APB7 UVC7 and UART7 UVC7
Notes7       : Two7 similar7 scoreboards7 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb7)
`uvm_analysis_imp_decl(_uart7)

class uart_ctrl_tx_scbd7 extends uvm_scoreboard;
  bit [7:0] data_to_apb7[$];
  bit [7:0] temp17;
  bit div_en7;

  // Hooks7 to cause in scoroboard7 check errors7
  // This7 resulting7 failure7 is used in MDV7 workshop7 for failure7 analysis7
  `ifdef UVM_WKSHP7
    bit apb_error7;
  `endif

  // Config7 Information7 
  uart_pkg7::uart_config7 uart_cfg7;
  apb_pkg7::apb_slave_config7 slave_cfg7;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd7)
     `uvm_field_object(uart_cfg7, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg7, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb7 #(apb_pkg7::apb_transfer7, uart_ctrl_tx_scbd7) apb_match7;
  uvm_analysis_imp_uart7 #(uart_pkg7::uart_frame7, uart_ctrl_tx_scbd7) uart_add7;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add7  = new("uart_add7", this);
    apb_match7 = new("apb_match7", this);
  endfunction : new

  // implement UART7 Tx7 analysis7 port from reference model
  virtual function void write_uart7(uart_pkg7::uart_frame7 frame7);
    data_to_apb7.push_back(frame7.payload7);	
  endfunction : write_uart7
     
  // implement APB7 READ analysis7 port from reference model
  virtual function void write_apb7(input apb_pkg7::apb_transfer7 transfer7);

    if (transfer7.addr == (slave_cfg7.start_address7 + `LINE_CTRL7)) begin
      div_en7 = transfer7.data[7];
      `uvm_info("SCRBD7",
              $psprintf("LINE_CTRL7 Write with addr = 'h%0h and data = 'h%0h div_en7 = %0b",
              transfer7.addr, transfer7.data, div_en7 ), UVM_HIGH)
    end

    if (!div_en7) begin
    if ((transfer7.addr ==   (slave_cfg7.start_address7 + `RX_FIFO_REG7)) && (transfer7.direction7 == apb_pkg7::APB_READ7))
      begin
       `ifdef UVM_WKSHP7
          corrupt_data7(transfer7);
       `endif
          temp17 = data_to_apb7.pop_front();
       
        if (temp17 == transfer7.data ) 
          `uvm_info("SCRBD7", $psprintf("####### PASS7 : APB7 RECEIVED7 CORRECT7 DATA7 from %s  expected = 'h%0h, received7 = 'h%0h", slave_cfg7.name, temp17, transfer7.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD7", $psprintf("####### FAIL7 : APB7 RECEIVED7 WRONG7 DATA7 from %s", slave_cfg7.name))
          `uvm_info("SCRBD7", $psprintf("expected = 'h%0h, received7 = 'h%0h", temp17, transfer7.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb7
   
  function void assign_cfg7(uart_pkg7::uart_config7 u_cfg7);
    uart_cfg7 = u_cfg7;
  endfunction : assign_cfg7

  function void update_config7(uart_pkg7::uart_config7 u_cfg7);
    `uvm_info(get_type_name(), {"Updating Config7\n", u_cfg7.sprint}, UVM_HIGH)
    uart_cfg7 = u_cfg7;
  endfunction : update_config7

 `ifdef UVM_WKSHP7
    function void corrupt_data7 (apb_pkg7::apb_transfer7 transfer7);
      if (!randomize(apb_error7) with {apb_error7 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL7", $psprintf("Randomization failed for apb_error7"))
      `uvm_info("SCRBD7",(""), UVM_HIGH)
      transfer7.data+=apb_error7;    	
    endfunction : corrupt_data7
  `endif

  // Add task run to debug7 TLM connectivity7 -- dbg_lab67
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG7", "SB: Verify connections7 TX7 of scorebboard7 - using debug_provided_to", UVM_NONE)
      // Implement7 here7 the checks7 
    apb_match7.debug_provided_to();
    uart_add7.debug_provided_to();
      `uvm_info("TX_SCRB_DBG7", "SB: Verify connections7 of TX7 scorebboard7 - using debug_connected_to", UVM_NONE)
      // Implement7 here7 the checks7 
    apb_match7.debug_connected_to();
    uart_add7.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd7

class uart_ctrl_rx_scbd7 extends uvm_scoreboard;
  bit [7:0] data_from_apb7[$];
  bit [7:0] data_to_apb7[$]; // Relevant7 for Remoteloopback7 case only
  bit div_en7;

  bit [7:0] temp17;
  bit [7:0] mask;

  // Hooks7 to cause in scoroboard7 check errors7
  // This7 resulting7 failure7 is used in MDV7 workshop7 for failure7 analysis7
  `ifdef UVM_WKSHP7
    bit uart_error7;
  `endif

  uart_pkg7::uart_config7 uart_cfg7;
  apb_pkg7::apb_slave_config7 slave_cfg7;

  `uvm_component_utils(uart_ctrl_rx_scbd7)
  uvm_analysis_imp_apb7 #(apb_pkg7::apb_transfer7, uart_ctrl_rx_scbd7) apb_add7;
  uvm_analysis_imp_uart7 #(uart_pkg7::uart_frame7, uart_ctrl_rx_scbd7) uart_match7;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match7 = new("uart_match7", this);
    apb_add7    = new("apb_add7", this);
  endfunction : new
   
  // implement APB7 WRITE analysis7 port from reference model
  virtual function void write_apb7(input apb_pkg7::apb_transfer7 transfer7);
    `uvm_info("SCRBD7",
              $psprintf("write_apb7 called with addr = 'h%0h and data = 'h%0h",
              transfer7.addr, transfer7.data), UVM_HIGH)
    if ((transfer7.addr == (slave_cfg7.start_address7 + `LINE_CTRL7)) &&
        (transfer7.direction7 == apb_pkg7::APB_WRITE7)) begin
      div_en7 = transfer7.data[7];
      `uvm_info("SCRBD7",
              $psprintf("LINE_CTRL7 Write with addr = 'h%0h and data = 'h%0h div_en7 = %0b",
              transfer7.addr, transfer7.data, div_en7 ), UVM_HIGH)
    end

    if (!div_en7) begin
      if ((transfer7.addr == (slave_cfg7.start_address7 + `TX_FIFO_REG7)) &&
          (transfer7.direction7 == apb_pkg7::APB_WRITE7)) begin 
        `uvm_info("SCRBD7",
               $psprintf("write_apb7 called pushing7 into queue with data = 'h%0h",
               transfer7.data ), UVM_HIGH)
        data_from_apb7.push_back(transfer7.data);
      end
    end
  endfunction : write_apb7
   
  // implement UART7 Rx7 analysis7 port from reference model
  virtual function void write_uart7( uart_pkg7::uart_frame7 frame7);
    mask = calc_mask7();

    //In case of remote7 loopback7, the data does not get into the rx7/fifo and it gets7 
    // loopbacked7 to ua_txd7. 
    data_to_apb7.push_back(frame7.payload7);	

      temp17 = data_from_apb7.pop_front();

    `ifdef UVM_WKSHP7
        corrupt_payload7 (frame7);
    `endif 
    if ((temp17 & mask) == frame7.payload7) 
      `uvm_info("SCRBD7", $psprintf("####### PASS7 : %s RECEIVED7 CORRECT7 DATA7 expected = 'h%0h, received7 = 'h%0h", slave_cfg7.name, (temp17 & mask), frame7.payload7), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD7", $psprintf("####### FAIL7 : %s RECEIVED7 WRONG7 DATA7", slave_cfg7.name))
      `uvm_info("SCRBD7", $psprintf("expected = 'h%0h, received7 = 'h%0h", temp17, frame7.payload7), UVM_LOW)
    end
  endfunction : write_uart7
   
  function void assign_cfg7(uart_pkg7::uart_config7 u_cfg7);
     uart_cfg7 = u_cfg7;
  endfunction : assign_cfg7
   
  function void update_config7(uart_pkg7::uart_config7 u_cfg7);
   `uvm_info(get_type_name(), {"Updating Config7\n", u_cfg7.sprint}, UVM_HIGH)
    uart_cfg7 = u_cfg7;
  endfunction : update_config7

  function bit[7:0] calc_mask7();
    case (uart_cfg7.char_len_val7)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask7

  `ifdef UVM_WKSHP7
   function void corrupt_payload7 (uart_pkg7::uart_frame7 frame7);
      if(!randomize(uart_error7) with {uart_error7 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL7", $psprintf("Randomization failed for apb_error7"))
      `uvm_info("SCRBD7",(""), UVM_HIGH)
      frame7.payload7+=uart_error7;    	
   endfunction : corrupt_payload7

  `endif

  // Add task run to debug7 TLM connectivity7
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist7;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG7", "SB: Verify connections7 RX7 of scorebboard7 - using debug_provided_to", UVM_NONE)
      // Implement7 here7 the checks7 
    apb_add7.debug_provided_to();
    uart_match7.debug_provided_to();
      `uvm_info("RX_SCRB_DBG7", "SB: Verify connections7 of RX7 scorebboard7 - using debug_connected_to", UVM_NONE)
      // Implement7 here7 the checks7 
    apb_add7.debug_connected_to();
    uart_match7.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd7
