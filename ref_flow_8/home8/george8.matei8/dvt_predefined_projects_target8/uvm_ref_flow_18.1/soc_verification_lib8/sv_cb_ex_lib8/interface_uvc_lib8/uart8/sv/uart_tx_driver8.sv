/*-------------------------------------------------------------------------
File8 name   : uart_tx_driver8.sv
Title8       : TX8 Driver8
Project8     :
Created8     :
Description8 : Describes8 UART8 Trasmit8 Driver8 for UART8 UVC8
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER8
`define UART_TX_DRIVER8

class uart_tx_driver8 extends uvm_driver #(uart_frame8) ;

  // The virtual interface used to drive8 and view8 HDL signals8.
  virtual interface uart_if8 vif8;

  // handle to  a cfg class
  uart_config8 cfg;

  bit sample_clk8;
  bit baud_clk8;
  bit [15:0] ua_brgr8;
  bit [7:0] ua_bdiv8;
  int num_of_bits_sent8;
  int num_frames_sent8;

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver8)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk8, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk8, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr8, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv8, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor8 - required8 UVM syntax8
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive8();
  extern virtual task gen_sample_rate8(ref bit [15:0] ua_brgr8, ref bit sample_clk8);
  extern virtual task send_tx_frame8(input uart_frame8 frame8);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver8

// UVM build_phase
function void uart_tx_driver8::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config8)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG8", "uart_config8 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if8)::get(this, "", "vif8", vif8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver8::run_phase(uvm_phase phase);
  fork
    get_and_drive8();
    gen_sample_rate8(ua_brgr8, sample_clk8);
  join
endtask : run_phase

// reset
task uart_tx_driver8::reset();
  @(negedge vif8.reset);
  `uvm_info(get_type_name(), "Reset8 Asserted8", UVM_MEDIUM)
   vif8.txd8 = 1;        //Transmit8 Data
   vif8.rts_n8 = 0;      //Request8 to Send8
   vif8.dtr_n8 = 0;      //Data Terminal8 Ready8
   vif8.dcd_n8 = 0;      //Data Carrier8 Detect8
   vif8.baud_clk8 = 0;       //Baud8 Data
endtask : reset

//  get_and8 drive8
task uart_tx_driver8::get_and_drive8();
  while (1) begin
    reset();
    fork
      @(negedge vif8.reset)
        `uvm_info(get_type_name(), "Reset8 asserted8", UVM_LOW)
    begin
      forever begin
        @(posedge vif8.clock8 iff (vif8.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame8(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If8 we8 are in the middle8 of a transfer8, need to end the tx8. Also8,
    //do any reset cleanup8 here8. The only way8 we8 got8 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive8

task uart_tx_driver8::gen_sample_rate8(ref bit [15:0] ua_brgr8, ref bit sample_clk8);
  forever begin
    @(posedge vif8.clock8);
    if (!vif8.reset) begin
      ua_brgr8 = 0;
      sample_clk8 = 0;
    end else begin
      if (ua_brgr8 == ({cfg.baud_rate_div8, cfg.baud_rate_gen8})) begin
        ua_brgr8 = 0;
        sample_clk8 = 1;
      end else begin
        sample_clk8 = 0;
        ua_brgr8++;
      end
    end
  end
endtask : gen_sample_rate8

// -------------------
// send_tx_frame8
// -------------------
task uart_tx_driver8::send_tx_frame8(input uart_frame8 frame8);
  bit [7:0] payload_byte8;
  num_of_bits_sent8 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver8 Sending8 TX8 Frame8...\n%s", frame8.sprint()),
            UVM_HIGH)
 
  repeat (frame8.transmit_delay8)
    @(posedge vif8.clock8);
  void'(this.begin_tr(frame8));
   
  wait((!cfg.rts_en8)||(!vif8.cts_n8));
  `uvm_info(get_type_name(), "Driver8 - Modem8 RTS8 or CTS8 asserted8", UVM_HIGH)

  while (num_of_bits_sent8 <= (1 + cfg.char_len_val8 + cfg.parity_en8 + cfg.nbstop8)) begin
    @(posedge vif8.clock8);
    #1;
    if (sample_clk8) begin
      if (num_of_bits_sent8 == 0) begin
        // Start8 sending8 tx_frame8 with "start bit"
        vif8.txd8 = frame8.start_bit8;
        `uvm_info(get_type_name(),
                  $psprintf("Driver8 Sending8 Frame8 SOP8: %b", frame8.start_bit8),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent8 > 0) && (num_of_bits_sent8 < (1 + cfg.char_len_val8))) begin
        // sending8 "data bits" 
        payload_byte8 = frame8.payload8[num_of_bits_sent8-1] ;
        vif8.txd8 = frame8.payload8[num_of_bits_sent8-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver8 Sending8 Frame8 data bit number8:%0d value:'b%b",
             (num_of_bits_sent8-1), payload_byte8), UVM_HIGH)
      end
      if ((num_of_bits_sent8 == (1 + cfg.char_len_val8)) && (cfg.parity_en8)) begin
        // sending8 "parity8 bit" if parity8 is enabled
        vif8.txd8 = frame8.calc_parity8(cfg.char_len_val8, cfg.parity_mode8);
        `uvm_info(get_type_name(),
             $psprintf("Driver8 Sending8 Frame8 Parity8 bit:'b%b",
             frame8.calc_parity8(cfg.char_len_val8, cfg.parity_mode8)), UVM_HIGH)
      end
      if (num_of_bits_sent8 == (1 + cfg.char_len_val8 + cfg.parity_en8)) begin
        // sending8 "stop/error bits"
        for (int i = 0; i < cfg.nbstop8; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver8 Sending8 Frame8 Stop bit:'b%b",
               frame8.stop_bits8[i]), UVM_HIGH)
          wait (sample_clk8);
          if (frame8.error_bits8[i]) begin
            vif8.txd8 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver8 intensionally8 corrupting8 Stop bit since8 error_bits8['b%b] is 'b%b", i, frame8.error_bits8[i]),
                 UVM_HIGH)
          end else
          vif8.txd8 = frame8.stop_bits8[i];
          num_of_bits_sent8++;
          wait (!sample_clk8);
        end
      end
    num_of_bits_sent8++;
    wait (!sample_clk8);
    end
  end
  
  num_frames_sent8++;
  `uvm_info(get_type_name(),
       $psprintf("Frame8 **%0d** Sent8...", num_frames_sent8), UVM_MEDIUM)
  wait (sample_clk8);
  vif8.txd8 = 1;

  `uvm_info(get_type_name(), "Frame8 complete...", UVM_MEDIUM)
  this.end_tr(frame8);
   
endtask : send_tx_frame8

//UVM report_phase
function void uart_tx_driver8::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART8 Frames8 Sent8:%0d", num_frames_sent8),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER8
