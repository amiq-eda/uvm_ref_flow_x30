/*-------------------------------------------------------------------------
File9 name   : uart_rx_driver9.sv
Title9       : RX9 Driver9
Project9     :
Created9     :
Description9 : Describes9 UART9 Receiver9 Driver9 for UART9 UVC9
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER9
`define UART_RX_DRIVER9

class uart_rx_driver9 extends uvm_driver #(uart_frame9) ;

  // The virtual interface used to drive9 and view9 HDL signals9.
  virtual interface uart_if9 vif9;

  // handle to  a cfg class
  uart_config9 cfg;

  bit sample_clk9;
  bit [15:0] ua_brgr9;
  bit [7:0] ua_bdiv9;
  int num_of_bits_sent9;
  int num_frames_sent9;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver9)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr9, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv9, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor9 - required9 UVM syntax9
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive9();
  extern virtual task gen_sample_rate9(ref bit [15:0] ua_brgr9, ref bit sample_clk9);
  extern virtual task send_rx_frame9(input uart_frame9 frame9);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver9

// UVM build_phase
function void uart_rx_driver9::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config9)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG9", "uart_config9 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if9)::get(this, "", "vif9", vif9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver9::run_phase(uvm_phase phase);
  fork
    get_and_drive9();
    gen_sample_rate9(ua_brgr9, sample_clk9);
  join
endtask : run_phase

// reset
task uart_rx_driver9::reset();
  @(negedge vif9.reset);
  `uvm_info(get_type_name(), "Reset9 Asserted9", UVM_MEDIUM)
   vif9.rxd9 = 1;        //Receive9 Data
   vif9.cts_n9 = 0;      //Clear to Send9
   vif9.dsr_n9 = 0;      //Data Set Ready9
   vif9.ri_n9 = 0;       //Ring9 Indicator9
   vif9.baud_clk9 = 0;   //Baud9 Clk9 - NOT9 USED9
endtask : reset

//  get_and9 drive9
task uart_rx_driver9::get_and_drive9();
  while (1) begin
    reset();
    fork
      @(negedge vif9.reset)
        `uvm_info(get_type_name(), "Reset9 asserted9", UVM_LOW)
    begin
      forever begin
        @(posedge vif9.clock9 iff (vif9.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame9(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If9 we9 are in the middle9 of a transfer9, need to end the rx9. Also9,
    //do any reset cleanup9 here9. The only way9 we9 got9 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive9

task uart_rx_driver9::gen_sample_rate9(ref bit [15:0] ua_brgr9, ref bit sample_clk9);
  forever begin
    @(posedge vif9.clock9);
    if (!vif9.reset) begin
      ua_brgr9 = 0;
      sample_clk9 = 0;
    end else begin
      if (ua_brgr9 == ({cfg.baud_rate_div9, cfg.baud_rate_gen9})) begin
        ua_brgr9 = 0;
        sample_clk9 = 1;
      end else begin
        sample_clk9 = 0;
        ua_brgr9++;
      end
    end
  end
endtask : gen_sample_rate9

// -------------------
// send_rx_frame9
// -------------------
task uart_rx_driver9::send_rx_frame9(input uart_frame9 frame9);
  bit [7:0] payload_byte9;
  num_of_bits_sent9 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver9 Sending9 RX9 Frame9...\n%s", frame9.sprint()),
            UVM_HIGH)
 
  repeat (frame9.transmit_delay9)
    @(posedge vif9.clock9);
  void'(this.begin_tr(frame9));
   
  wait((!cfg.rts_en9)||(!vif9.cts_n9));
  `uvm_info(get_type_name(), "Driver9 - Modem9 RTS9 or CTS9 asserted9", UVM_HIGH)

  while (num_of_bits_sent9 <= (1 + cfg.char_len_val9 + cfg.parity_en9 + cfg.nbstop9)) begin
    @(posedge vif9.clock9);
    #1;
    if (sample_clk9) begin
      if (num_of_bits_sent9 == 0) begin
        // Start9 sending9 rx_frame9 with "start bit"
        vif9.rxd9 = frame9.start_bit9;
        `uvm_info(get_type_name(),
                  $psprintf("Driver9 Sending9 Frame9 SOP9: %b", frame9.start_bit9),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent9 > 0) && (num_of_bits_sent9 < (1 + cfg.char_len_val9))) begin
        // sending9 "data bits" 
        payload_byte9 = frame9.payload9[num_of_bits_sent9-1] ;
        vif9.rxd9 = frame9.payload9[num_of_bits_sent9-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver9 Sending9 Frame9 data bit number9:%0d value:'b%b",
             (num_of_bits_sent9-1), payload_byte9), UVM_HIGH)
      end
      if ((num_of_bits_sent9 == (1 + cfg.char_len_val9)) && (cfg.parity_en9)) begin
        // sending9 "parity9 bit" if parity9 is enabled
        vif9.rxd9 = frame9.calc_parity9(cfg.char_len_val9, cfg.parity_mode9);
        `uvm_info(get_type_name(),
             $psprintf("Driver9 Sending9 Frame9 Parity9 bit:'b%b",
             frame9.calc_parity9(cfg.char_len_val9, cfg.parity_mode9)), UVM_HIGH)
      end
      if (num_of_bits_sent9 == (1 + cfg.char_len_val9 + cfg.parity_en9)) begin
        // sending9 "stop/error bits"
        for (int i = 0; i < cfg.nbstop9; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver9 Sending9 Frame9 Stop bit:'b%b",
               frame9.stop_bits9[i]), UVM_HIGH)
          wait (sample_clk9);
          if (frame9.error_bits9[i]) begin
            vif9.rxd9 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver9 intensionally9 corrupting9 Stop bit since9 error_bits9['b%b] is 'b%b", i, frame9.error_bits9[i]),
                 UVM_HIGH)
          end else
          vif9.rxd9 = frame9.stop_bits9[i];
          num_of_bits_sent9++;
          wait (!sample_clk9);
        end
      end
    num_of_bits_sent9++;
    wait (!sample_clk9);
    end
  end
  
  num_frames_sent9++;
  `uvm_info(get_type_name(),
       $psprintf("Frame9 **%0d** Sent9...", num_frames_sent9), UVM_MEDIUM)
  wait (sample_clk9);
  vif9.rxd9 = 1;

  `uvm_info(get_type_name(), "Frame9 complete...", UVM_MEDIUM)
  this.end_tr(frame9);
   
endtask : send_rx_frame9

//UVM report_phase
function void uart_rx_driver9::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART9 Frames9 Sent9:%0d", num_frames_sent9),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER9
