/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_scoreboard19.sv
Title19       : APB19 - UART19 Scoreboard19
Project19     :
Created19     :
Description19 : Scoreboard19 for data integrity19 check between APB19 UVC19 and UART19 UVC19
Notes19       : Two19 similar19 scoreboards19 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb19)
`uvm_analysis_imp_decl(_uart19)

class uart_ctrl_tx_scbd19 extends uvm_scoreboard;
  bit [7:0] data_to_apb19[$];
  bit [7:0] temp119;
  bit div_en19;

  // Hooks19 to cause in scoroboard19 check errors19
  // This19 resulting19 failure19 is used in MDV19 workshop19 for failure19 analysis19
  `ifdef UVM_WKSHP19
    bit apb_error19;
  `endif

  // Config19 Information19 
  uart_pkg19::uart_config19 uart_cfg19;
  apb_pkg19::apb_slave_config19 slave_cfg19;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd19)
     `uvm_field_object(uart_cfg19, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg19, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb19 #(apb_pkg19::apb_transfer19, uart_ctrl_tx_scbd19) apb_match19;
  uvm_analysis_imp_uart19 #(uart_pkg19::uart_frame19, uart_ctrl_tx_scbd19) uart_add19;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add19  = new("uart_add19", this);
    apb_match19 = new("apb_match19", this);
  endfunction : new

  // implement UART19 Tx19 analysis19 port from reference model
  virtual function void write_uart19(uart_pkg19::uart_frame19 frame19);
    data_to_apb19.push_back(frame19.payload19);	
  endfunction : write_uart19
     
  // implement APB19 READ analysis19 port from reference model
  virtual function void write_apb19(input apb_pkg19::apb_transfer19 transfer19);

    if (transfer19.addr == (slave_cfg19.start_address19 + `LINE_CTRL19)) begin
      div_en19 = transfer19.data[7];
      `uvm_info("SCRBD19",
              $psprintf("LINE_CTRL19 Write with addr = 'h%0h and data = 'h%0h div_en19 = %0b",
              transfer19.addr, transfer19.data, div_en19 ), UVM_HIGH)
    end

    if (!div_en19) begin
    if ((transfer19.addr ==   (slave_cfg19.start_address19 + `RX_FIFO_REG19)) && (transfer19.direction19 == apb_pkg19::APB_READ19))
      begin
       `ifdef UVM_WKSHP19
          corrupt_data19(transfer19);
       `endif
          temp119 = data_to_apb19.pop_front();
       
        if (temp119 == transfer19.data ) 
          `uvm_info("SCRBD19", $psprintf("####### PASS19 : APB19 RECEIVED19 CORRECT19 DATA19 from %s  expected = 'h%0h, received19 = 'h%0h", slave_cfg19.name, temp119, transfer19.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD19", $psprintf("####### FAIL19 : APB19 RECEIVED19 WRONG19 DATA19 from %s", slave_cfg19.name))
          `uvm_info("SCRBD19", $psprintf("expected = 'h%0h, received19 = 'h%0h", temp119, transfer19.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb19
   
  function void assign_cfg19(uart_pkg19::uart_config19 u_cfg19);
    uart_cfg19 = u_cfg19;
  endfunction : assign_cfg19

  function void update_config19(uart_pkg19::uart_config19 u_cfg19);
    `uvm_info(get_type_name(), {"Updating Config19\n", u_cfg19.sprint}, UVM_HIGH)
    uart_cfg19 = u_cfg19;
  endfunction : update_config19

 `ifdef UVM_WKSHP19
    function void corrupt_data19 (apb_pkg19::apb_transfer19 transfer19);
      if (!randomize(apb_error19) with {apb_error19 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL19", $psprintf("Randomization failed for apb_error19"))
      `uvm_info("SCRBD19",(""), UVM_HIGH)
      transfer19.data+=apb_error19;    	
    endfunction : corrupt_data19
  `endif

  // Add task run to debug19 TLM connectivity19 -- dbg_lab619
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG19", "SB: Verify connections19 TX19 of scorebboard19 - using debug_provided_to", UVM_NONE)
      // Implement19 here19 the checks19 
    apb_match19.debug_provided_to();
    uart_add19.debug_provided_to();
      `uvm_info("TX_SCRB_DBG19", "SB: Verify connections19 of TX19 scorebboard19 - using debug_connected_to", UVM_NONE)
      // Implement19 here19 the checks19 
    apb_match19.debug_connected_to();
    uart_add19.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd19

class uart_ctrl_rx_scbd19 extends uvm_scoreboard;
  bit [7:0] data_from_apb19[$];
  bit [7:0] data_to_apb19[$]; // Relevant19 for Remoteloopback19 case only
  bit div_en19;

  bit [7:0] temp119;
  bit [7:0] mask;

  // Hooks19 to cause in scoroboard19 check errors19
  // This19 resulting19 failure19 is used in MDV19 workshop19 for failure19 analysis19
  `ifdef UVM_WKSHP19
    bit uart_error19;
  `endif

  uart_pkg19::uart_config19 uart_cfg19;
  apb_pkg19::apb_slave_config19 slave_cfg19;

  `uvm_component_utils(uart_ctrl_rx_scbd19)
  uvm_analysis_imp_apb19 #(apb_pkg19::apb_transfer19, uart_ctrl_rx_scbd19) apb_add19;
  uvm_analysis_imp_uart19 #(uart_pkg19::uart_frame19, uart_ctrl_rx_scbd19) uart_match19;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match19 = new("uart_match19", this);
    apb_add19    = new("apb_add19", this);
  endfunction : new
   
  // implement APB19 WRITE analysis19 port from reference model
  virtual function void write_apb19(input apb_pkg19::apb_transfer19 transfer19);
    `uvm_info("SCRBD19",
              $psprintf("write_apb19 called with addr = 'h%0h and data = 'h%0h",
              transfer19.addr, transfer19.data), UVM_HIGH)
    if ((transfer19.addr == (slave_cfg19.start_address19 + `LINE_CTRL19)) &&
        (transfer19.direction19 == apb_pkg19::APB_WRITE19)) begin
      div_en19 = transfer19.data[7];
      `uvm_info("SCRBD19",
              $psprintf("LINE_CTRL19 Write with addr = 'h%0h and data = 'h%0h div_en19 = %0b",
              transfer19.addr, transfer19.data, div_en19 ), UVM_HIGH)
    end

    if (!div_en19) begin
      if ((transfer19.addr == (slave_cfg19.start_address19 + `TX_FIFO_REG19)) &&
          (transfer19.direction19 == apb_pkg19::APB_WRITE19)) begin 
        `uvm_info("SCRBD19",
               $psprintf("write_apb19 called pushing19 into queue with data = 'h%0h",
               transfer19.data ), UVM_HIGH)
        data_from_apb19.push_back(transfer19.data);
      end
    end
  endfunction : write_apb19
   
  // implement UART19 Rx19 analysis19 port from reference model
  virtual function void write_uart19( uart_pkg19::uart_frame19 frame19);
    mask = calc_mask19();

    //In case of remote19 loopback19, the data does not get into the rx19/fifo and it gets19 
    // loopbacked19 to ua_txd19. 
    data_to_apb19.push_back(frame19.payload19);	

      temp119 = data_from_apb19.pop_front();

    `ifdef UVM_WKSHP19
        corrupt_payload19 (frame19);
    `endif 
    if ((temp119 & mask) == frame19.payload19) 
      `uvm_info("SCRBD19", $psprintf("####### PASS19 : %s RECEIVED19 CORRECT19 DATA19 expected = 'h%0h, received19 = 'h%0h", slave_cfg19.name, (temp119 & mask), frame19.payload19), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD19", $psprintf("####### FAIL19 : %s RECEIVED19 WRONG19 DATA19", slave_cfg19.name))
      `uvm_info("SCRBD19", $psprintf("expected = 'h%0h, received19 = 'h%0h", temp119, frame19.payload19), UVM_LOW)
    end
  endfunction : write_uart19
   
  function void assign_cfg19(uart_pkg19::uart_config19 u_cfg19);
     uart_cfg19 = u_cfg19;
  endfunction : assign_cfg19
   
  function void update_config19(uart_pkg19::uart_config19 u_cfg19);
   `uvm_info(get_type_name(), {"Updating Config19\n", u_cfg19.sprint}, UVM_HIGH)
    uart_cfg19 = u_cfg19;
  endfunction : update_config19

  function bit[7:0] calc_mask19();
    case (uart_cfg19.char_len_val19)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask19

  `ifdef UVM_WKSHP19
   function void corrupt_payload19 (uart_pkg19::uart_frame19 frame19);
      if(!randomize(uart_error19) with {uart_error19 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL19", $psprintf("Randomization failed for apb_error19"))
      `uvm_info("SCRBD19",(""), UVM_HIGH)
      frame19.payload19+=uart_error19;    	
   endfunction : corrupt_payload19

  `endif

  // Add task run to debug19 TLM connectivity19
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist19;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG19", "SB: Verify connections19 RX19 of scorebboard19 - using debug_provided_to", UVM_NONE)
      // Implement19 here19 the checks19 
    apb_add19.debug_provided_to();
    uart_match19.debug_provided_to();
      `uvm_info("RX_SCRB_DBG19", "SB: Verify connections19 of RX19 scorebboard19 - using debug_connected_to", UVM_NONE)
      // Implement19 here19 the checks19 
    apb_add19.debug_connected_to();
    uart_match19.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd19
