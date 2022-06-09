/*-------------------------------------------------------------------------
File16 name   : uart_rx_driver16.sv
Title16       : RX16 Driver16
Project16     :
Created16     :
Description16 : Describes16 UART16 Receiver16 Driver16 for UART16 UVC16
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER16
`define UART_RX_DRIVER16

class uart_rx_driver16 extends uvm_driver #(uart_frame16) ;

  // The virtual interface used to drive16 and view16 HDL signals16.
  virtual interface uart_if16 vif16;

  // handle to  a cfg class
  uart_config16 cfg;

  bit sample_clk16;
  bit [15:0] ua_brgr16;
  bit [7:0] ua_bdiv16;
  int num_of_bits_sent16;
  int num_frames_sent16;

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver16)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr16, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv16, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor16 - required16 UVM syntax16
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive16();
  extern virtual task gen_sample_rate16(ref bit [15:0] ua_brgr16, ref bit sample_clk16);
  extern virtual task send_rx_frame16(input uart_frame16 frame16);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver16

// UVM build_phase
function void uart_rx_driver16::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config16)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG16", "uart_config16 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if16)::get(this, "", "vif16", vif16))
   `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver16::run_phase(uvm_phase phase);
  fork
    get_and_drive16();
    gen_sample_rate16(ua_brgr16, sample_clk16);
  join
endtask : run_phase

// reset
task uart_rx_driver16::reset();
  @(negedge vif16.reset);
  `uvm_info(get_type_name(), "Reset16 Asserted16", UVM_MEDIUM)
   vif16.rxd16 = 1;        //Receive16 Data
   vif16.cts_n16 = 0;      //Clear to Send16
   vif16.dsr_n16 = 0;      //Data Set Ready16
   vif16.ri_n16 = 0;       //Ring16 Indicator16
   vif16.baud_clk16 = 0;   //Baud16 Clk16 - NOT16 USED16
endtask : reset

//  get_and16 drive16
task uart_rx_driver16::get_and_drive16();
  while (1) begin
    reset();
    fork
      @(negedge vif16.reset)
        `uvm_info(get_type_name(), "Reset16 asserted16", UVM_LOW)
    begin
      forever begin
        @(posedge vif16.clock16 iff (vif16.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame16(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If16 we16 are in the middle16 of a transfer16, need to end the rx16. Also16,
    //do any reset cleanup16 here16. The only way16 we16 got16 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive16

task uart_rx_driver16::gen_sample_rate16(ref bit [15:0] ua_brgr16, ref bit sample_clk16);
  forever begin
    @(posedge vif16.clock16);
    if (!vif16.reset) begin
      ua_brgr16 = 0;
      sample_clk16 = 0;
    end else begin
      if (ua_brgr16 == ({cfg.baud_rate_div16, cfg.baud_rate_gen16})) begin
        ua_brgr16 = 0;
        sample_clk16 = 1;
      end else begin
        sample_clk16 = 0;
        ua_brgr16++;
      end
    end
  end
endtask : gen_sample_rate16

// -------------------
// send_rx_frame16
// -------------------
task uart_rx_driver16::send_rx_frame16(input uart_frame16 frame16);
  bit [7:0] payload_byte16;
  num_of_bits_sent16 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver16 Sending16 RX16 Frame16...\n%s", frame16.sprint()),
            UVM_HIGH)
 
  repeat (frame16.transmit_delay16)
    @(posedge vif16.clock16);
  void'(this.begin_tr(frame16));
   
  wait((!cfg.rts_en16)||(!vif16.cts_n16));
  `uvm_info(get_type_name(), "Driver16 - Modem16 RTS16 or CTS16 asserted16", UVM_HIGH)

  while (num_of_bits_sent16 <= (1 + cfg.char_len_val16 + cfg.parity_en16 + cfg.nbstop16)) begin
    @(posedge vif16.clock16);
    #1;
    if (sample_clk16) begin
      if (num_of_bits_sent16 == 0) begin
        // Start16 sending16 rx_frame16 with "start bit"
        vif16.rxd16 = frame16.start_bit16;
        `uvm_info(get_type_name(),
                  $psprintf("Driver16 Sending16 Frame16 SOP16: %b", frame16.start_bit16),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent16 > 0) && (num_of_bits_sent16 < (1 + cfg.char_len_val16))) begin
        // sending16 "data bits" 
        payload_byte16 = frame16.payload16[num_of_bits_sent16-1] ;
        vif16.rxd16 = frame16.payload16[num_of_bits_sent16-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver16 Sending16 Frame16 data bit number16:%0d value:'b%b",
             (num_of_bits_sent16-1), payload_byte16), UVM_HIGH)
      end
      if ((num_of_bits_sent16 == (1 + cfg.char_len_val16)) && (cfg.parity_en16)) begin
        // sending16 "parity16 bit" if parity16 is enabled
        vif16.rxd16 = frame16.calc_parity16(cfg.char_len_val16, cfg.parity_mode16);
        `uvm_info(get_type_name(),
             $psprintf("Driver16 Sending16 Frame16 Parity16 bit:'b%b",
             frame16.calc_parity16(cfg.char_len_val16, cfg.parity_mode16)), UVM_HIGH)
      end
      if (num_of_bits_sent16 == (1 + cfg.char_len_val16 + cfg.parity_en16)) begin
        // sending16 "stop/error bits"
        for (int i = 0; i < cfg.nbstop16; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver16 Sending16 Frame16 Stop bit:'b%b",
               frame16.stop_bits16[i]), UVM_HIGH)
          wait (sample_clk16);
          if (frame16.error_bits16[i]) begin
            vif16.rxd16 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver16 intensionally16 corrupting16 Stop bit since16 error_bits16['b%b] is 'b%b", i, frame16.error_bits16[i]),
                 UVM_HIGH)
          end else
          vif16.rxd16 = frame16.stop_bits16[i];
          num_of_bits_sent16++;
          wait (!sample_clk16);
        end
      end
    num_of_bits_sent16++;
    wait (!sample_clk16);
    end
  end
  
  num_frames_sent16++;
  `uvm_info(get_type_name(),
       $psprintf("Frame16 **%0d** Sent16...", num_frames_sent16), UVM_MEDIUM)
  wait (sample_clk16);
  vif16.rxd16 = 1;

  `uvm_info(get_type_name(), "Frame16 complete...", UVM_MEDIUM)
  this.end_tr(frame16);
   
endtask : send_rx_frame16

//UVM report_phase
function void uart_rx_driver16::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART16 Frames16 Sent16:%0d", num_frames_sent16),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER16
