/*-------------------------------------------------------------------------
File10 name   : uart_rx_driver10.sv
Title10       : RX10 Driver10
Project10     :
Created10     :
Description10 : Describes10 UART10 Receiver10 Driver10 for UART10 UVC10
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER10
`define UART_RX_DRIVER10

class uart_rx_driver10 extends uvm_driver #(uart_frame10) ;

  // The virtual interface used to drive10 and view10 HDL signals10.
  virtual interface uart_if10 vif10;

  // handle to  a cfg class
  uart_config10 cfg;

  bit sample_clk10;
  bit [15:0] ua_brgr10;
  bit [7:0] ua_bdiv10;
  int num_of_bits_sent10;
  int num_frames_sent10;

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver10)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr10, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv10, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor10 - required10 UVM syntax10
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive10();
  extern virtual task gen_sample_rate10(ref bit [15:0] ua_brgr10, ref bit sample_clk10);
  extern virtual task send_rx_frame10(input uart_frame10 frame10);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver10

// UVM build_phase
function void uart_rx_driver10::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config10)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG10", "uart_config10 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if10)::get(this, "", "vif10", vif10))
   `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver10::run_phase(uvm_phase phase);
  fork
    get_and_drive10();
    gen_sample_rate10(ua_brgr10, sample_clk10);
  join
endtask : run_phase

// reset
task uart_rx_driver10::reset();
  @(negedge vif10.reset);
  `uvm_info(get_type_name(), "Reset10 Asserted10", UVM_MEDIUM)
   vif10.rxd10 = 1;        //Receive10 Data
   vif10.cts_n10 = 0;      //Clear to Send10
   vif10.dsr_n10 = 0;      //Data Set Ready10
   vif10.ri_n10 = 0;       //Ring10 Indicator10
   vif10.baud_clk10 = 0;   //Baud10 Clk10 - NOT10 USED10
endtask : reset

//  get_and10 drive10
task uart_rx_driver10::get_and_drive10();
  while (1) begin
    reset();
    fork
      @(negedge vif10.reset)
        `uvm_info(get_type_name(), "Reset10 asserted10", UVM_LOW)
    begin
      forever begin
        @(posedge vif10.clock10 iff (vif10.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame10(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If10 we10 are in the middle10 of a transfer10, need to end the rx10. Also10,
    //do any reset cleanup10 here10. The only way10 we10 got10 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive10

task uart_rx_driver10::gen_sample_rate10(ref bit [15:0] ua_brgr10, ref bit sample_clk10);
  forever begin
    @(posedge vif10.clock10);
    if (!vif10.reset) begin
      ua_brgr10 = 0;
      sample_clk10 = 0;
    end else begin
      if (ua_brgr10 == ({cfg.baud_rate_div10, cfg.baud_rate_gen10})) begin
        ua_brgr10 = 0;
        sample_clk10 = 1;
      end else begin
        sample_clk10 = 0;
        ua_brgr10++;
      end
    end
  end
endtask : gen_sample_rate10

// -------------------
// send_rx_frame10
// -------------------
task uart_rx_driver10::send_rx_frame10(input uart_frame10 frame10);
  bit [7:0] payload_byte10;
  num_of_bits_sent10 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver10 Sending10 RX10 Frame10...\n%s", frame10.sprint()),
            UVM_HIGH)
 
  repeat (frame10.transmit_delay10)
    @(posedge vif10.clock10);
  void'(this.begin_tr(frame10));
   
  wait((!cfg.rts_en10)||(!vif10.cts_n10));
  `uvm_info(get_type_name(), "Driver10 - Modem10 RTS10 or CTS10 asserted10", UVM_HIGH)

  while (num_of_bits_sent10 <= (1 + cfg.char_len_val10 + cfg.parity_en10 + cfg.nbstop10)) begin
    @(posedge vif10.clock10);
    #1;
    if (sample_clk10) begin
      if (num_of_bits_sent10 == 0) begin
        // Start10 sending10 rx_frame10 with "start bit"
        vif10.rxd10 = frame10.start_bit10;
        `uvm_info(get_type_name(),
                  $psprintf("Driver10 Sending10 Frame10 SOP10: %b", frame10.start_bit10),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent10 > 0) && (num_of_bits_sent10 < (1 + cfg.char_len_val10))) begin
        // sending10 "data bits" 
        payload_byte10 = frame10.payload10[num_of_bits_sent10-1] ;
        vif10.rxd10 = frame10.payload10[num_of_bits_sent10-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver10 Sending10 Frame10 data bit number10:%0d value:'b%b",
             (num_of_bits_sent10-1), payload_byte10), UVM_HIGH)
      end
      if ((num_of_bits_sent10 == (1 + cfg.char_len_val10)) && (cfg.parity_en10)) begin
        // sending10 "parity10 bit" if parity10 is enabled
        vif10.rxd10 = frame10.calc_parity10(cfg.char_len_val10, cfg.parity_mode10);
        `uvm_info(get_type_name(),
             $psprintf("Driver10 Sending10 Frame10 Parity10 bit:'b%b",
             frame10.calc_parity10(cfg.char_len_val10, cfg.parity_mode10)), UVM_HIGH)
      end
      if (num_of_bits_sent10 == (1 + cfg.char_len_val10 + cfg.parity_en10)) begin
        // sending10 "stop/error bits"
        for (int i = 0; i < cfg.nbstop10; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver10 Sending10 Frame10 Stop bit:'b%b",
               frame10.stop_bits10[i]), UVM_HIGH)
          wait (sample_clk10);
          if (frame10.error_bits10[i]) begin
            vif10.rxd10 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver10 intensionally10 corrupting10 Stop bit since10 error_bits10['b%b] is 'b%b", i, frame10.error_bits10[i]),
                 UVM_HIGH)
          end else
          vif10.rxd10 = frame10.stop_bits10[i];
          num_of_bits_sent10++;
          wait (!sample_clk10);
        end
      end
    num_of_bits_sent10++;
    wait (!sample_clk10);
    end
  end
  
  num_frames_sent10++;
  `uvm_info(get_type_name(),
       $psprintf("Frame10 **%0d** Sent10...", num_frames_sent10), UVM_MEDIUM)
  wait (sample_clk10);
  vif10.rxd10 = 1;

  `uvm_info(get_type_name(), "Frame10 complete...", UVM_MEDIUM)
  this.end_tr(frame10);
   
endtask : send_rx_frame10

//UVM report_phase
function void uart_rx_driver10::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART10 Frames10 Sent10:%0d", num_frames_sent10),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER10
