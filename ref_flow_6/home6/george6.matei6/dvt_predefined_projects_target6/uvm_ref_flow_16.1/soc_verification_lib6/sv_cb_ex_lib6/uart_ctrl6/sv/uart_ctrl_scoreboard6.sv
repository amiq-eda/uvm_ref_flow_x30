/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_scoreboard6.sv
Title6       : APB6 - UART6 Scoreboard6
Project6     :
Created6     :
Description6 : Scoreboard6 for data integrity6 check between APB6 UVC6 and UART6 UVC6
Notes6       : Two6 similar6 scoreboards6 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb6)
`uvm_analysis_imp_decl(_uart6)

class uart_ctrl_tx_scbd6 extends uvm_scoreboard;
  bit [7:0] data_to_apb6[$];
  bit [7:0] temp16;
  bit div_en6;

  // Hooks6 to cause in scoroboard6 check errors6
  // This6 resulting6 failure6 is used in MDV6 workshop6 for failure6 analysis6
  `ifdef UVM_WKSHP6
    bit apb_error6;
  `endif

  // Config6 Information6 
  uart_pkg6::uart_config6 uart_cfg6;
  apb_pkg6::apb_slave_config6 slave_cfg6;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd6)
     `uvm_field_object(uart_cfg6, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg6, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb6 #(apb_pkg6::apb_transfer6, uart_ctrl_tx_scbd6) apb_match6;
  uvm_analysis_imp_uart6 #(uart_pkg6::uart_frame6, uart_ctrl_tx_scbd6) uart_add6;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add6  = new("uart_add6", this);
    apb_match6 = new("apb_match6", this);
  endfunction : new

  // implement UART6 Tx6 analysis6 port from reference model
  virtual function void write_uart6(uart_pkg6::uart_frame6 frame6);
    data_to_apb6.push_back(frame6.payload6);	
  endfunction : write_uart6
     
  // implement APB6 READ analysis6 port from reference model
  virtual function void write_apb6(input apb_pkg6::apb_transfer6 transfer6);

    if (transfer6.addr == (slave_cfg6.start_address6 + `LINE_CTRL6)) begin
      div_en6 = transfer6.data[7];
      `uvm_info("SCRBD6",
              $psprintf("LINE_CTRL6 Write with addr = 'h%0h and data = 'h%0h div_en6 = %0b",
              transfer6.addr, transfer6.data, div_en6 ), UVM_HIGH)
    end

    if (!div_en6) begin
    if ((transfer6.addr ==   (slave_cfg6.start_address6 + `RX_FIFO_REG6)) && (transfer6.direction6 == apb_pkg6::APB_READ6))
      begin
       `ifdef UVM_WKSHP6
          corrupt_data6(transfer6);
       `endif
          temp16 = data_to_apb6.pop_front();
       
        if (temp16 == transfer6.data ) 
          `uvm_info("SCRBD6", $psprintf("####### PASS6 : APB6 RECEIVED6 CORRECT6 DATA6 from %s  expected = 'h%0h, received6 = 'h%0h", slave_cfg6.name, temp16, transfer6.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD6", $psprintf("####### FAIL6 : APB6 RECEIVED6 WRONG6 DATA6 from %s", slave_cfg6.name))
          `uvm_info("SCRBD6", $psprintf("expected = 'h%0h, received6 = 'h%0h", temp16, transfer6.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb6
   
  function void assign_cfg6(uart_pkg6::uart_config6 u_cfg6);
    uart_cfg6 = u_cfg6;
  endfunction : assign_cfg6

  function void update_config6(uart_pkg6::uart_config6 u_cfg6);
    `uvm_info(get_type_name(), {"Updating Config6\n", u_cfg6.sprint}, UVM_HIGH)
    uart_cfg6 = u_cfg6;
  endfunction : update_config6

 `ifdef UVM_WKSHP6
    function void corrupt_data6 (apb_pkg6::apb_transfer6 transfer6);
      if (!randomize(apb_error6) with {apb_error6 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL6", $psprintf("Randomization failed for apb_error6"))
      `uvm_info("SCRBD6",(""), UVM_HIGH)
      transfer6.data+=apb_error6;    	
    endfunction : corrupt_data6
  `endif

  // Add task run to debug6 TLM connectivity6 -- dbg_lab66
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG6", "SB: Verify connections6 TX6 of scorebboard6 - using debug_provided_to", UVM_NONE)
      // Implement6 here6 the checks6 
    apb_match6.debug_provided_to();
    uart_add6.debug_provided_to();
      `uvm_info("TX_SCRB_DBG6", "SB: Verify connections6 of TX6 scorebboard6 - using debug_connected_to", UVM_NONE)
      // Implement6 here6 the checks6 
    apb_match6.debug_connected_to();
    uart_add6.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd6

class uart_ctrl_rx_scbd6 extends uvm_scoreboard;
  bit [7:0] data_from_apb6[$];
  bit [7:0] data_to_apb6[$]; // Relevant6 for Remoteloopback6 case only
  bit div_en6;

  bit [7:0] temp16;
  bit [7:0] mask;

  // Hooks6 to cause in scoroboard6 check errors6
  // This6 resulting6 failure6 is used in MDV6 workshop6 for failure6 analysis6
  `ifdef UVM_WKSHP6
    bit uart_error6;
  `endif

  uart_pkg6::uart_config6 uart_cfg6;
  apb_pkg6::apb_slave_config6 slave_cfg6;

  `uvm_component_utils(uart_ctrl_rx_scbd6)
  uvm_analysis_imp_apb6 #(apb_pkg6::apb_transfer6, uart_ctrl_rx_scbd6) apb_add6;
  uvm_analysis_imp_uart6 #(uart_pkg6::uart_frame6, uart_ctrl_rx_scbd6) uart_match6;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match6 = new("uart_match6", this);
    apb_add6    = new("apb_add6", this);
  endfunction : new
   
  // implement APB6 WRITE analysis6 port from reference model
  virtual function void write_apb6(input apb_pkg6::apb_transfer6 transfer6);
    `uvm_info("SCRBD6",
              $psprintf("write_apb6 called with addr = 'h%0h and data = 'h%0h",
              transfer6.addr, transfer6.data), UVM_HIGH)
    if ((transfer6.addr == (slave_cfg6.start_address6 + `LINE_CTRL6)) &&
        (transfer6.direction6 == apb_pkg6::APB_WRITE6)) begin
      div_en6 = transfer6.data[7];
      `uvm_info("SCRBD6",
              $psprintf("LINE_CTRL6 Write with addr = 'h%0h and data = 'h%0h div_en6 = %0b",
              transfer6.addr, transfer6.data, div_en6 ), UVM_HIGH)
    end

    if (!div_en6) begin
      if ((transfer6.addr == (slave_cfg6.start_address6 + `TX_FIFO_REG6)) &&
          (transfer6.direction6 == apb_pkg6::APB_WRITE6)) begin 
        `uvm_info("SCRBD6",
               $psprintf("write_apb6 called pushing6 into queue with data = 'h%0h",
               transfer6.data ), UVM_HIGH)
        data_from_apb6.push_back(transfer6.data);
      end
    end
  endfunction : write_apb6
   
  // implement UART6 Rx6 analysis6 port from reference model
  virtual function void write_uart6( uart_pkg6::uart_frame6 frame6);
    mask = calc_mask6();

    //In case of remote6 loopback6, the data does not get into the rx6/fifo and it gets6 
    // loopbacked6 to ua_txd6. 
    data_to_apb6.push_back(frame6.payload6);	

      temp16 = data_from_apb6.pop_front();

    `ifdef UVM_WKSHP6
        corrupt_payload6 (frame6);
    `endif 
    if ((temp16 & mask) == frame6.payload6) 
      `uvm_info("SCRBD6", $psprintf("####### PASS6 : %s RECEIVED6 CORRECT6 DATA6 expected = 'h%0h, received6 = 'h%0h", slave_cfg6.name, (temp16 & mask), frame6.payload6), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD6", $psprintf("####### FAIL6 : %s RECEIVED6 WRONG6 DATA6", slave_cfg6.name))
      `uvm_info("SCRBD6", $psprintf("expected = 'h%0h, received6 = 'h%0h", temp16, frame6.payload6), UVM_LOW)
    end
  endfunction : write_uart6
   
  function void assign_cfg6(uart_pkg6::uart_config6 u_cfg6);
     uart_cfg6 = u_cfg6;
  endfunction : assign_cfg6
   
  function void update_config6(uart_pkg6::uart_config6 u_cfg6);
   `uvm_info(get_type_name(), {"Updating Config6\n", u_cfg6.sprint}, UVM_HIGH)
    uart_cfg6 = u_cfg6;
  endfunction : update_config6

  function bit[7:0] calc_mask6();
    case (uart_cfg6.char_len_val6)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask6

  `ifdef UVM_WKSHP6
   function void corrupt_payload6 (uart_pkg6::uart_frame6 frame6);
      if(!randomize(uart_error6) with {uart_error6 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL6", $psprintf("Randomization failed for apb_error6"))
      `uvm_info("SCRBD6",(""), UVM_HIGH)
      frame6.payload6+=uart_error6;    	
   endfunction : corrupt_payload6

  `endif

  // Add task run to debug6 TLM connectivity6
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist6;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG6", "SB: Verify connections6 RX6 of scorebboard6 - using debug_provided_to", UVM_NONE)
      // Implement6 here6 the checks6 
    apb_add6.debug_provided_to();
    uart_match6.debug_provided_to();
      `uvm_info("RX_SCRB_DBG6", "SB: Verify connections6 of RX6 scorebboard6 - using debug_connected_to", UVM_NONE)
      // Implement6 here6 the checks6 
    apb_add6.debug_connected_to();
    uart_match6.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd6
