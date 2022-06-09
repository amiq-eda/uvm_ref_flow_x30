/*-------------------------------------------------------------------------
File13 name   : uart_rx_driver13.sv
Title13       : RX13 Driver13
Project13     :
Created13     :
Description13 : Describes13 UART13 Receiver13 Driver13 for UART13 UVC13
Notes13       :  
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

`ifndef UART_RX_DRIVER13
`define UART_RX_DRIVER13

class uart_rx_driver13 extends uvm_driver #(uart_frame13) ;

  // The virtual interface used to drive13 and view13 HDL signals13.
  virtual interface uart_if13 vif13;

  // handle to  a cfg class
  uart_config13 cfg;

  bit sample_clk13;
  bit [15:0] ua_brgr13;
  bit [7:0] ua_bdiv13;
  int num_of_bits_sent13;
  int num_frames_sent13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver13)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr13, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv13, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor13 - required13 UVM syntax13
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive13();
  extern virtual task gen_sample_rate13(ref bit [15:0] ua_brgr13, ref bit sample_clk13);
  extern virtual task send_rx_frame13(input uart_frame13 frame13);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver13

// UVM build_phase
function void uart_rx_driver13::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config13)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG13", "uart_config13 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if13)::get(this, "", "vif13", vif13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver13::run_phase(uvm_phase phase);
  fork
    get_and_drive13();
    gen_sample_rate13(ua_brgr13, sample_clk13);
  join
endtask : run_phase

// reset
task uart_rx_driver13::reset();
  @(negedge vif13.reset);
  `uvm_info(get_type_name(), "Reset13 Asserted13", UVM_MEDIUM)
   vif13.rxd13 = 1;        //Receive13 Data
   vif13.cts_n13 = 0;      //Clear to Send13
   vif13.dsr_n13 = 0;      //Data Set Ready13
   vif13.ri_n13 = 0;       //Ring13 Indicator13
   vif13.baud_clk13 = 0;   //Baud13 Clk13 - NOT13 USED13
endtask : reset

//  get_and13 drive13
task uart_rx_driver13::get_and_drive13();
  while (1) begin
    reset();
    fork
      @(negedge vif13.reset)
        `uvm_info(get_type_name(), "Reset13 asserted13", UVM_LOW)
    begin
      forever begin
        @(posedge vif13.clock13 iff (vif13.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame13(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If13 we13 are in the middle13 of a transfer13, need to end the rx13. Also13,
    //do any reset cleanup13 here13. The only way13 we13 got13 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive13

task uart_rx_driver13::gen_sample_rate13(ref bit [15:0] ua_brgr13, ref bit sample_clk13);
  forever begin
    @(posedge vif13.clock13);
    if (!vif13.reset) begin
      ua_brgr13 = 0;
      sample_clk13 = 0;
    end else begin
      if (ua_brgr13 == ({cfg.baud_rate_div13, cfg.baud_rate_gen13})) begin
        ua_brgr13 = 0;
        sample_clk13 = 1;
      end else begin
        sample_clk13 = 0;
        ua_brgr13++;
      end
    end
  end
endtask : gen_sample_rate13

// -------------------
// send_rx_frame13
// -------------------
task uart_rx_driver13::send_rx_frame13(input uart_frame13 frame13);
  bit [7:0] payload_byte13;
  num_of_bits_sent13 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver13 Sending13 RX13 Frame13...\n%s", frame13.sprint()),
            UVM_HIGH)
 
  repeat (frame13.transmit_delay13)
    @(posedge vif13.clock13);
  void'(this.begin_tr(frame13));
   
  wait((!cfg.rts_en13)||(!vif13.cts_n13));
  `uvm_info(get_type_name(), "Driver13 - Modem13 RTS13 or CTS13 asserted13", UVM_HIGH)

  while (num_of_bits_sent13 <= (1 + cfg.char_len_val13 + cfg.parity_en13 + cfg.nbstop13)) begin
    @(posedge vif13.clock13);
    #1;
    if (sample_clk13) begin
      if (num_of_bits_sent13 == 0) begin
        // Start13 sending13 rx_frame13 with "start bit"
        vif13.rxd13 = frame13.start_bit13;
        `uvm_info(get_type_name(),
                  $psprintf("Driver13 Sending13 Frame13 SOP13: %b", frame13.start_bit13),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent13 > 0) && (num_of_bits_sent13 < (1 + cfg.char_len_val13))) begin
        // sending13 "data bits" 
        payload_byte13 = frame13.payload13[num_of_bits_sent13-1] ;
        vif13.rxd13 = frame13.payload13[num_of_bits_sent13-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver13 Sending13 Frame13 data bit number13:%0d value:'b%b",
             (num_of_bits_sent13-1), payload_byte13), UVM_HIGH)
      end
      if ((num_of_bits_sent13 == (1 + cfg.char_len_val13)) && (cfg.parity_en13)) begin
        // sending13 "parity13 bit" if parity13 is enabled
        vif13.rxd13 = frame13.calc_parity13(cfg.char_len_val13, cfg.parity_mode13);
        `uvm_info(get_type_name(),
             $psprintf("Driver13 Sending13 Frame13 Parity13 bit:'b%b",
             frame13.calc_parity13(cfg.char_len_val13, cfg.parity_mode13)), UVM_HIGH)
      end
      if (num_of_bits_sent13 == (1 + cfg.char_len_val13 + cfg.parity_en13)) begin
        // sending13 "stop/error bits"
        for (int i = 0; i < cfg.nbstop13; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver13 Sending13 Frame13 Stop bit:'b%b",
               frame13.stop_bits13[i]), UVM_HIGH)
          wait (sample_clk13);
          if (frame13.error_bits13[i]) begin
            vif13.rxd13 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver13 intensionally13 corrupting13 Stop bit since13 error_bits13['b%b] is 'b%b", i, frame13.error_bits13[i]),
                 UVM_HIGH)
          end else
          vif13.rxd13 = frame13.stop_bits13[i];
          num_of_bits_sent13++;
          wait (!sample_clk13);
        end
      end
    num_of_bits_sent13++;
    wait (!sample_clk13);
    end
  end
  
  num_frames_sent13++;
  `uvm_info(get_type_name(),
       $psprintf("Frame13 **%0d** Sent13...", num_frames_sent13), UVM_MEDIUM)
  wait (sample_clk13);
  vif13.rxd13 = 1;

  `uvm_info(get_type_name(), "Frame13 complete...", UVM_MEDIUM)
  this.end_tr(frame13);
   
endtask : send_rx_frame13

//UVM report_phase
function void uart_rx_driver13::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART13 Frames13 Sent13:%0d", num_frames_sent13),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER13
