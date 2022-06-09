/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_scoreboard15.sv
Title15       : APB15 - UART15 Scoreboard15
Project15     :
Created15     :
Description15 : Scoreboard15 for data integrity15 check between APB15 UVC15 and UART15 UVC15
Notes15       : Two15 similar15 scoreboards15 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb15)
`uvm_analysis_imp_decl(_uart15)

class uart_ctrl_tx_scbd15 extends uvm_scoreboard;
  bit [7:0] data_to_apb15[$];
  bit [7:0] temp115;
  bit div_en15;

  // Hooks15 to cause in scoroboard15 check errors15
  // This15 resulting15 failure15 is used in MDV15 workshop15 for failure15 analysis15
  `ifdef UVM_WKSHP15
    bit apb_error15;
  `endif

  // Config15 Information15 
  uart_pkg15::uart_config15 uart_cfg15;
  apb_pkg15::apb_slave_config15 slave_cfg15;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd15)
     `uvm_field_object(uart_cfg15, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg15, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb15 #(apb_pkg15::apb_transfer15, uart_ctrl_tx_scbd15) apb_match15;
  uvm_analysis_imp_uart15 #(uart_pkg15::uart_frame15, uart_ctrl_tx_scbd15) uart_add15;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add15  = new("uart_add15", this);
    apb_match15 = new("apb_match15", this);
  endfunction : new

  // implement UART15 Tx15 analysis15 port from reference model
  virtual function void write_uart15(uart_pkg15::uart_frame15 frame15);
    data_to_apb15.push_back(frame15.payload15);	
  endfunction : write_uart15
     
  // implement APB15 READ analysis15 port from reference model
  virtual function void write_apb15(input apb_pkg15::apb_transfer15 transfer15);

    if (transfer15.addr == (slave_cfg15.start_address15 + `LINE_CTRL15)) begin
      div_en15 = transfer15.data[7];
      `uvm_info("SCRBD15",
              $psprintf("LINE_CTRL15 Write with addr = 'h%0h and data = 'h%0h div_en15 = %0b",
              transfer15.addr, transfer15.data, div_en15 ), UVM_HIGH)
    end

    if (!div_en15) begin
    if ((transfer15.addr ==   (slave_cfg15.start_address15 + `RX_FIFO_REG15)) && (transfer15.direction15 == apb_pkg15::APB_READ15))
      begin
       `ifdef UVM_WKSHP15
          corrupt_data15(transfer15);
       `endif
          temp115 = data_to_apb15.pop_front();
       
        if (temp115 == transfer15.data ) 
          `uvm_info("SCRBD15", $psprintf("####### PASS15 : APB15 RECEIVED15 CORRECT15 DATA15 from %s  expected = 'h%0h, received15 = 'h%0h", slave_cfg15.name, temp115, transfer15.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD15", $psprintf("####### FAIL15 : APB15 RECEIVED15 WRONG15 DATA15 from %s", slave_cfg15.name))
          `uvm_info("SCRBD15", $psprintf("expected = 'h%0h, received15 = 'h%0h", temp115, transfer15.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb15
   
  function void assign_cfg15(uart_pkg15::uart_config15 u_cfg15);
    uart_cfg15 = u_cfg15;
  endfunction : assign_cfg15

  function void update_config15(uart_pkg15::uart_config15 u_cfg15);
    `uvm_info(get_type_name(), {"Updating Config15\n", u_cfg15.sprint}, UVM_HIGH)
    uart_cfg15 = u_cfg15;
  endfunction : update_config15

 `ifdef UVM_WKSHP15
    function void corrupt_data15 (apb_pkg15::apb_transfer15 transfer15);
      if (!randomize(apb_error15) with {apb_error15 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL15", $psprintf("Randomization failed for apb_error15"))
      `uvm_info("SCRBD15",(""), UVM_HIGH)
      transfer15.data+=apb_error15;    	
    endfunction : corrupt_data15
  `endif

  // Add task run to debug15 TLM connectivity15 -- dbg_lab615
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG15", "SB: Verify connections15 TX15 of scorebboard15 - using debug_provided_to", UVM_NONE)
      // Implement15 here15 the checks15 
    apb_match15.debug_provided_to();
    uart_add15.debug_provided_to();
      `uvm_info("TX_SCRB_DBG15", "SB: Verify connections15 of TX15 scorebboard15 - using debug_connected_to", UVM_NONE)
      // Implement15 here15 the checks15 
    apb_match15.debug_connected_to();
    uart_add15.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd15

class uart_ctrl_rx_scbd15 extends uvm_scoreboard;
  bit [7:0] data_from_apb15[$];
  bit [7:0] data_to_apb15[$]; // Relevant15 for Remoteloopback15 case only
  bit div_en15;

  bit [7:0] temp115;
  bit [7:0] mask;

  // Hooks15 to cause in scoroboard15 check errors15
  // This15 resulting15 failure15 is used in MDV15 workshop15 for failure15 analysis15
  `ifdef UVM_WKSHP15
    bit uart_error15;
  `endif

  uart_pkg15::uart_config15 uart_cfg15;
  apb_pkg15::apb_slave_config15 slave_cfg15;

  `uvm_component_utils(uart_ctrl_rx_scbd15)
  uvm_analysis_imp_apb15 #(apb_pkg15::apb_transfer15, uart_ctrl_rx_scbd15) apb_add15;
  uvm_analysis_imp_uart15 #(uart_pkg15::uart_frame15, uart_ctrl_rx_scbd15) uart_match15;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match15 = new("uart_match15", this);
    apb_add15    = new("apb_add15", this);
  endfunction : new
   
  // implement APB15 WRITE analysis15 port from reference model
  virtual function void write_apb15(input apb_pkg15::apb_transfer15 transfer15);
    `uvm_info("SCRBD15",
              $psprintf("write_apb15 called with addr = 'h%0h and data = 'h%0h",
              transfer15.addr, transfer15.data), UVM_HIGH)
    if ((transfer15.addr == (slave_cfg15.start_address15 + `LINE_CTRL15)) &&
        (transfer15.direction15 == apb_pkg15::APB_WRITE15)) begin
      div_en15 = transfer15.data[7];
      `uvm_info("SCRBD15",
              $psprintf("LINE_CTRL15 Write with addr = 'h%0h and data = 'h%0h div_en15 = %0b",
              transfer15.addr, transfer15.data, div_en15 ), UVM_HIGH)
    end

    if (!div_en15) begin
      if ((transfer15.addr == (slave_cfg15.start_address15 + `TX_FIFO_REG15)) &&
          (transfer15.direction15 == apb_pkg15::APB_WRITE15)) begin 
        `uvm_info("SCRBD15",
               $psprintf("write_apb15 called pushing15 into queue with data = 'h%0h",
               transfer15.data ), UVM_HIGH)
        data_from_apb15.push_back(transfer15.data);
      end
    end
  endfunction : write_apb15
   
  // implement UART15 Rx15 analysis15 port from reference model
  virtual function void write_uart15( uart_pkg15::uart_frame15 frame15);
    mask = calc_mask15();

    //In case of remote15 loopback15, the data does not get into the rx15/fifo and it gets15 
    // loopbacked15 to ua_txd15. 
    data_to_apb15.push_back(frame15.payload15);	

      temp115 = data_from_apb15.pop_front();

    `ifdef UVM_WKSHP15
        corrupt_payload15 (frame15);
    `endif 
    if ((temp115 & mask) == frame15.payload15) 
      `uvm_info("SCRBD15", $psprintf("####### PASS15 : %s RECEIVED15 CORRECT15 DATA15 expected = 'h%0h, received15 = 'h%0h", slave_cfg15.name, (temp115 & mask), frame15.payload15), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD15", $psprintf("####### FAIL15 : %s RECEIVED15 WRONG15 DATA15", slave_cfg15.name))
      `uvm_info("SCRBD15", $psprintf("expected = 'h%0h, received15 = 'h%0h", temp115, frame15.payload15), UVM_LOW)
    end
  endfunction : write_uart15
   
  function void assign_cfg15(uart_pkg15::uart_config15 u_cfg15);
     uart_cfg15 = u_cfg15;
  endfunction : assign_cfg15
   
  function void update_config15(uart_pkg15::uart_config15 u_cfg15);
   `uvm_info(get_type_name(), {"Updating Config15\n", u_cfg15.sprint}, UVM_HIGH)
    uart_cfg15 = u_cfg15;
  endfunction : update_config15

  function bit[7:0] calc_mask15();
    case (uart_cfg15.char_len_val15)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask15

  `ifdef UVM_WKSHP15
   function void corrupt_payload15 (uart_pkg15::uart_frame15 frame15);
      if(!randomize(uart_error15) with {uart_error15 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL15", $psprintf("Randomization failed for apb_error15"))
      `uvm_info("SCRBD15",(""), UVM_HIGH)
      frame15.payload15+=uart_error15;    	
   endfunction : corrupt_payload15

  `endif

  // Add task run to debug15 TLM connectivity15
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist15;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG15", "SB: Verify connections15 RX15 of scorebboard15 - using debug_provided_to", UVM_NONE)
      // Implement15 here15 the checks15 
    apb_add15.debug_provided_to();
    uart_match15.debug_provided_to();
      `uvm_info("RX_SCRB_DBG15", "SB: Verify connections15 of RX15 scorebboard15 - using debug_connected_to", UVM_NONE)
      // Implement15 here15 the checks15 
    apb_add15.debug_connected_to();
    uart_match15.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd15
