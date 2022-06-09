/*-------------------------------------------------------------------------
File24 name   : uart_rx_driver24.sv
Title24       : RX24 Driver24
Project24     :
Created24     :
Description24 : Describes24 UART24 Receiver24 Driver24 for UART24 UVC24
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER24
`define UART_RX_DRIVER24

class uart_rx_driver24 extends uvm_driver #(uart_frame24) ;

  // The virtual interface used to drive24 and view24 HDL signals24.
  virtual interface uart_if24 vif24;

  // handle to  a cfg class
  uart_config24 cfg;

  bit sample_clk24;
  bit [15:0] ua_brgr24;
  bit [7:0] ua_bdiv24;
  int num_of_bits_sent24;
  int num_frames_sent24;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver24)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr24, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv24, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor24 - required24 UVM syntax24
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive24();
  extern virtual task gen_sample_rate24(ref bit [15:0] ua_brgr24, ref bit sample_clk24);
  extern virtual task send_rx_frame24(input uart_frame24 frame24);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver24

// UVM build_phase
function void uart_rx_driver24::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config24)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG24", "uart_config24 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if24)::get(this, "", "vif24", vif24))
   `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver24::run_phase(uvm_phase phase);
  fork
    get_and_drive24();
    gen_sample_rate24(ua_brgr24, sample_clk24);
  join
endtask : run_phase

// reset
task uart_rx_driver24::reset();
  @(negedge vif24.reset);
  `uvm_info(get_type_name(), "Reset24 Asserted24", UVM_MEDIUM)
   vif24.rxd24 = 1;        //Receive24 Data
   vif24.cts_n24 = 0;      //Clear to Send24
   vif24.dsr_n24 = 0;      //Data Set Ready24
   vif24.ri_n24 = 0;       //Ring24 Indicator24
   vif24.baud_clk24 = 0;   //Baud24 Clk24 - NOT24 USED24
endtask : reset

//  get_and24 drive24
task uart_rx_driver24::get_and_drive24();
  while (1) begin
    reset();
    fork
      @(negedge vif24.reset)
        `uvm_info(get_type_name(), "Reset24 asserted24", UVM_LOW)
    begin
      forever begin
        @(posedge vif24.clock24 iff (vif24.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame24(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If24 we24 are in the middle24 of a transfer24, need to end the rx24. Also24,
    //do any reset cleanup24 here24. The only way24 we24 got24 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive24

task uart_rx_driver24::gen_sample_rate24(ref bit [15:0] ua_brgr24, ref bit sample_clk24);
  forever begin
    @(posedge vif24.clock24);
    if (!vif24.reset) begin
      ua_brgr24 = 0;
      sample_clk24 = 0;
    end else begin
      if (ua_brgr24 == ({cfg.baud_rate_div24, cfg.baud_rate_gen24})) begin
        ua_brgr24 = 0;
        sample_clk24 = 1;
      end else begin
        sample_clk24 = 0;
        ua_brgr24++;
      end
    end
  end
endtask : gen_sample_rate24

// -------------------
// send_rx_frame24
// -------------------
task uart_rx_driver24::send_rx_frame24(input uart_frame24 frame24);
  bit [7:0] payload_byte24;
  num_of_bits_sent24 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver24 Sending24 RX24 Frame24...\n%s", frame24.sprint()),
            UVM_HIGH)
 
  repeat (frame24.transmit_delay24)
    @(posedge vif24.clock24);
  void'(this.begin_tr(frame24));
   
  wait((!cfg.rts_en24)||(!vif24.cts_n24));
  `uvm_info(get_type_name(), "Driver24 - Modem24 RTS24 or CTS24 asserted24", UVM_HIGH)

  while (num_of_bits_sent24 <= (1 + cfg.char_len_val24 + cfg.parity_en24 + cfg.nbstop24)) begin
    @(posedge vif24.clock24);
    #1;
    if (sample_clk24) begin
      if (num_of_bits_sent24 == 0) begin
        // Start24 sending24 rx_frame24 with "start bit"
        vif24.rxd24 = frame24.start_bit24;
        `uvm_info(get_type_name(),
                  $psprintf("Driver24 Sending24 Frame24 SOP24: %b", frame24.start_bit24),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent24 > 0) && (num_of_bits_sent24 < (1 + cfg.char_len_val24))) begin
        // sending24 "data bits" 
        payload_byte24 = frame24.payload24[num_of_bits_sent24-1] ;
        vif24.rxd24 = frame24.payload24[num_of_bits_sent24-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver24 Sending24 Frame24 data bit number24:%0d value:'b%b",
             (num_of_bits_sent24-1), payload_byte24), UVM_HIGH)
      end
      if ((num_of_bits_sent24 == (1 + cfg.char_len_val24)) && (cfg.parity_en24)) begin
        // sending24 "parity24 bit" if parity24 is enabled
        vif24.rxd24 = frame24.calc_parity24(cfg.char_len_val24, cfg.parity_mode24);
        `uvm_info(get_type_name(),
             $psprintf("Driver24 Sending24 Frame24 Parity24 bit:'b%b",
             frame24.calc_parity24(cfg.char_len_val24, cfg.parity_mode24)), UVM_HIGH)
      end
      if (num_of_bits_sent24 == (1 + cfg.char_len_val24 + cfg.parity_en24)) begin
        // sending24 "stop/error bits"
        for (int i = 0; i < cfg.nbstop24; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver24 Sending24 Frame24 Stop bit:'b%b",
               frame24.stop_bits24[i]), UVM_HIGH)
          wait (sample_clk24);
          if (frame24.error_bits24[i]) begin
            vif24.rxd24 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver24 intensionally24 corrupting24 Stop bit since24 error_bits24['b%b] is 'b%b", i, frame24.error_bits24[i]),
                 UVM_HIGH)
          end else
          vif24.rxd24 = frame24.stop_bits24[i];
          num_of_bits_sent24++;
          wait (!sample_clk24);
        end
      end
    num_of_bits_sent24++;
    wait (!sample_clk24);
    end
  end
  
  num_frames_sent24++;
  `uvm_info(get_type_name(),
       $psprintf("Frame24 **%0d** Sent24...", num_frames_sent24), UVM_MEDIUM)
  wait (sample_clk24);
  vif24.rxd24 = 1;

  `uvm_info(get_type_name(), "Frame24 complete...", UVM_MEDIUM)
  this.end_tr(frame24);
   
endtask : send_rx_frame24

//UVM report_phase
function void uart_rx_driver24::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART24 Frames24 Sent24:%0d", num_frames_sent24),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER24
