/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_scoreboard21.sv
Title21       : APB21 - UART21 Scoreboard21
Project21     :
Created21     :
Description21 : Scoreboard21 for data integrity21 check between APB21 UVC21 and UART21 UVC21
Notes21       : Two21 similar21 scoreboards21 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb21)
`uvm_analysis_imp_decl(_uart21)

class uart_ctrl_tx_scbd21 extends uvm_scoreboard;
  bit [7:0] data_to_apb21[$];
  bit [7:0] temp121;
  bit div_en21;

  // Hooks21 to cause in scoroboard21 check errors21
  // This21 resulting21 failure21 is used in MDV21 workshop21 for failure21 analysis21
  `ifdef UVM_WKSHP21
    bit apb_error21;
  `endif

  // Config21 Information21 
  uart_pkg21::uart_config21 uart_cfg21;
  apb_pkg21::apb_slave_config21 slave_cfg21;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd21)
     `uvm_field_object(uart_cfg21, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg21, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb21 #(apb_pkg21::apb_transfer21, uart_ctrl_tx_scbd21) apb_match21;
  uvm_analysis_imp_uart21 #(uart_pkg21::uart_frame21, uart_ctrl_tx_scbd21) uart_add21;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add21  = new("uart_add21", this);
    apb_match21 = new("apb_match21", this);
  endfunction : new

  // implement UART21 Tx21 analysis21 port from reference model
  virtual function void write_uart21(uart_pkg21::uart_frame21 frame21);
    data_to_apb21.push_back(frame21.payload21);	
  endfunction : write_uart21
     
  // implement APB21 READ analysis21 port from reference model
  virtual function void write_apb21(input apb_pkg21::apb_transfer21 transfer21);

    if (transfer21.addr == (slave_cfg21.start_address21 + `LINE_CTRL21)) begin
      div_en21 = transfer21.data[7];
      `uvm_info("SCRBD21",
              $psprintf("LINE_CTRL21 Write with addr = 'h%0h and data = 'h%0h div_en21 = %0b",
              transfer21.addr, transfer21.data, div_en21 ), UVM_HIGH)
    end

    if (!div_en21) begin
    if ((transfer21.addr ==   (slave_cfg21.start_address21 + `RX_FIFO_REG21)) && (transfer21.direction21 == apb_pkg21::APB_READ21))
      begin
       `ifdef UVM_WKSHP21
          corrupt_data21(transfer21);
       `endif
          temp121 = data_to_apb21.pop_front();
       
        if (temp121 == transfer21.data ) 
          `uvm_info("SCRBD21", $psprintf("####### PASS21 : APB21 RECEIVED21 CORRECT21 DATA21 from %s  expected = 'h%0h, received21 = 'h%0h", slave_cfg21.name, temp121, transfer21.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD21", $psprintf("####### FAIL21 : APB21 RECEIVED21 WRONG21 DATA21 from %s", slave_cfg21.name))
          `uvm_info("SCRBD21", $psprintf("expected = 'h%0h, received21 = 'h%0h", temp121, transfer21.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb21
   
  function void assign_cfg21(uart_pkg21::uart_config21 u_cfg21);
    uart_cfg21 = u_cfg21;
  endfunction : assign_cfg21

  function void update_config21(uart_pkg21::uart_config21 u_cfg21);
    `uvm_info(get_type_name(), {"Updating Config21\n", u_cfg21.sprint}, UVM_HIGH)
    uart_cfg21 = u_cfg21;
  endfunction : update_config21

 `ifdef UVM_WKSHP21
    function void corrupt_data21 (apb_pkg21::apb_transfer21 transfer21);
      if (!randomize(apb_error21) with {apb_error21 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL21", $psprintf("Randomization failed for apb_error21"))
      `uvm_info("SCRBD21",(""), UVM_HIGH)
      transfer21.data+=apb_error21;    	
    endfunction : corrupt_data21
  `endif

  // Add task run to debug21 TLM connectivity21 -- dbg_lab621
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG21", "SB: Verify connections21 TX21 of scorebboard21 - using debug_provided_to", UVM_NONE)
      // Implement21 here21 the checks21 
    apb_match21.debug_provided_to();
    uart_add21.debug_provided_to();
      `uvm_info("TX_SCRB_DBG21", "SB: Verify connections21 of TX21 scorebboard21 - using debug_connected_to", UVM_NONE)
      // Implement21 here21 the checks21 
    apb_match21.debug_connected_to();
    uart_add21.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd21

class uart_ctrl_rx_scbd21 extends uvm_scoreboard;
  bit [7:0] data_from_apb21[$];
  bit [7:0] data_to_apb21[$]; // Relevant21 for Remoteloopback21 case only
  bit div_en21;

  bit [7:0] temp121;
  bit [7:0] mask;

  // Hooks21 to cause in scoroboard21 check errors21
  // This21 resulting21 failure21 is used in MDV21 workshop21 for failure21 analysis21
  `ifdef UVM_WKSHP21
    bit uart_error21;
  `endif

  uart_pkg21::uart_config21 uart_cfg21;
  apb_pkg21::apb_slave_config21 slave_cfg21;

  `uvm_component_utils(uart_ctrl_rx_scbd21)
  uvm_analysis_imp_apb21 #(apb_pkg21::apb_transfer21, uart_ctrl_rx_scbd21) apb_add21;
  uvm_analysis_imp_uart21 #(uart_pkg21::uart_frame21, uart_ctrl_rx_scbd21) uart_match21;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match21 = new("uart_match21", this);
    apb_add21    = new("apb_add21", this);
  endfunction : new
   
  // implement APB21 WRITE analysis21 port from reference model
  virtual function void write_apb21(input apb_pkg21::apb_transfer21 transfer21);
    `uvm_info("SCRBD21",
              $psprintf("write_apb21 called with addr = 'h%0h and data = 'h%0h",
              transfer21.addr, transfer21.data), UVM_HIGH)
    if ((transfer21.addr == (slave_cfg21.start_address21 + `LINE_CTRL21)) &&
        (transfer21.direction21 == apb_pkg21::APB_WRITE21)) begin
      div_en21 = transfer21.data[7];
      `uvm_info("SCRBD21",
              $psprintf("LINE_CTRL21 Write with addr = 'h%0h and data = 'h%0h div_en21 = %0b",
              transfer21.addr, transfer21.data, div_en21 ), UVM_HIGH)
    end

    if (!div_en21) begin
      if ((transfer21.addr == (slave_cfg21.start_address21 + `TX_FIFO_REG21)) &&
          (transfer21.direction21 == apb_pkg21::APB_WRITE21)) begin 
        `uvm_info("SCRBD21",
               $psprintf("write_apb21 called pushing21 into queue with data = 'h%0h",
               transfer21.data ), UVM_HIGH)
        data_from_apb21.push_back(transfer21.data);
      end
    end
  endfunction : write_apb21
   
  // implement UART21 Rx21 analysis21 port from reference model
  virtual function void write_uart21( uart_pkg21::uart_frame21 frame21);
    mask = calc_mask21();

    //In case of remote21 loopback21, the data does not get into the rx21/fifo and it gets21 
    // loopbacked21 to ua_txd21. 
    data_to_apb21.push_back(frame21.payload21);	

      temp121 = data_from_apb21.pop_front();

    `ifdef UVM_WKSHP21
        corrupt_payload21 (frame21);
    `endif 
    if ((temp121 & mask) == frame21.payload21) 
      `uvm_info("SCRBD21", $psprintf("####### PASS21 : %s RECEIVED21 CORRECT21 DATA21 expected = 'h%0h, received21 = 'h%0h", slave_cfg21.name, (temp121 & mask), frame21.payload21), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD21", $psprintf("####### FAIL21 : %s RECEIVED21 WRONG21 DATA21", slave_cfg21.name))
      `uvm_info("SCRBD21", $psprintf("expected = 'h%0h, received21 = 'h%0h", temp121, frame21.payload21), UVM_LOW)
    end
  endfunction : write_uart21
   
  function void assign_cfg21(uart_pkg21::uart_config21 u_cfg21);
     uart_cfg21 = u_cfg21;
  endfunction : assign_cfg21
   
  function void update_config21(uart_pkg21::uart_config21 u_cfg21);
   `uvm_info(get_type_name(), {"Updating Config21\n", u_cfg21.sprint}, UVM_HIGH)
    uart_cfg21 = u_cfg21;
  endfunction : update_config21

  function bit[7:0] calc_mask21();
    case (uart_cfg21.char_len_val21)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask21

  `ifdef UVM_WKSHP21
   function void corrupt_payload21 (uart_pkg21::uart_frame21 frame21);
      if(!randomize(uart_error21) with {uart_error21 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL21", $psprintf("Randomization failed for apb_error21"))
      `uvm_info("SCRBD21",(""), UVM_HIGH)
      frame21.payload21+=uart_error21;    	
   endfunction : corrupt_payload21

  `endif

  // Add task run to debug21 TLM connectivity21
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist21;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG21", "SB: Verify connections21 RX21 of scorebboard21 - using debug_provided_to", UVM_NONE)
      // Implement21 here21 the checks21 
    apb_add21.debug_provided_to();
    uart_match21.debug_provided_to();
      `uvm_info("RX_SCRB_DBG21", "SB: Verify connections21 of RX21 scorebboard21 - using debug_connected_to", UVM_NONE)
      // Implement21 here21 the checks21 
    apb_add21.debug_connected_to();
    uart_match21.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd21
