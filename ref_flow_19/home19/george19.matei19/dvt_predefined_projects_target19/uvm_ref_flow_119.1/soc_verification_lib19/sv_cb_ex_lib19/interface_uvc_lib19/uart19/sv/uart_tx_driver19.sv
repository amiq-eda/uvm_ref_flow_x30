/*-------------------------------------------------------------------------
File19 name   : uart_tx_driver19.sv
Title19       : TX19 Driver19
Project19     :
Created19     :
Description19 : Describes19 UART19 Trasmit19 Driver19 for UART19 UVC19
Notes19       :  
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

`ifndef UART_TX_DRIVER19
`define UART_TX_DRIVER19

class uart_tx_driver19 extends uvm_driver #(uart_frame19) ;

  // The virtual interface used to drive19 and view19 HDL signals19.
  virtual interface uart_if19 vif19;

  // handle to  a cfg class
  uart_config19 cfg;

  bit sample_clk19;
  bit baud_clk19;
  bit [15:0] ua_brgr19;
  bit [7:0] ua_bdiv19;
  int num_of_bits_sent19;
  int num_frames_sent19;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver19)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk19, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk19, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr19, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv19, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor19 - required19 UVM syntax19
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive19();
  extern virtual task gen_sample_rate19(ref bit [15:0] ua_brgr19, ref bit sample_clk19);
  extern virtual task send_tx_frame19(input uart_frame19 frame19);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver19

// UVM build_phase
function void uart_tx_driver19::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config19)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG19", "uart_config19 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if19)::get(this, "", "vif19", vif19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver19::run_phase(uvm_phase phase);
  fork
    get_and_drive19();
    gen_sample_rate19(ua_brgr19, sample_clk19);
  join
endtask : run_phase

// reset
task uart_tx_driver19::reset();
  @(negedge vif19.reset);
  `uvm_info(get_type_name(), "Reset19 Asserted19", UVM_MEDIUM)
   vif19.txd19 = 1;        //Transmit19 Data
   vif19.rts_n19 = 0;      //Request19 to Send19
   vif19.dtr_n19 = 0;      //Data Terminal19 Ready19
   vif19.dcd_n19 = 0;      //Data Carrier19 Detect19
   vif19.baud_clk19 = 0;       //Baud19 Data
endtask : reset

//  get_and19 drive19
task uart_tx_driver19::get_and_drive19();
  while (1) begin
    reset();
    fork
      @(negedge vif19.reset)
        `uvm_info(get_type_name(), "Reset19 asserted19", UVM_LOW)
    begin
      forever begin
        @(posedge vif19.clock19 iff (vif19.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame19(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If19 we19 are in the middle19 of a transfer19, need to end the tx19. Also19,
    //do any reset cleanup19 here19. The only way19 we19 got19 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive19

task uart_tx_driver19::gen_sample_rate19(ref bit [15:0] ua_brgr19, ref bit sample_clk19);
  forever begin
    @(posedge vif19.clock19);
    if (!vif19.reset) begin
      ua_brgr19 = 0;
      sample_clk19 = 0;
    end else begin
      if (ua_brgr19 == ({cfg.baud_rate_div19, cfg.baud_rate_gen19})) begin
        ua_brgr19 = 0;
        sample_clk19 = 1;
      end else begin
        sample_clk19 = 0;
        ua_brgr19++;
      end
    end
  end
endtask : gen_sample_rate19

// -------------------
// send_tx_frame19
// -------------------
task uart_tx_driver19::send_tx_frame19(input uart_frame19 frame19);
  bit [7:0] payload_byte19;
  num_of_bits_sent19 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver19 Sending19 TX19 Frame19...\n%s", frame19.sprint()),
            UVM_HIGH)
 
  repeat (frame19.transmit_delay19)
    @(posedge vif19.clock19);
  void'(this.begin_tr(frame19));
   
  wait((!cfg.rts_en19)||(!vif19.cts_n19));
  `uvm_info(get_type_name(), "Driver19 - Modem19 RTS19 or CTS19 asserted19", UVM_HIGH)

  while (num_of_bits_sent19 <= (1 + cfg.char_len_val19 + cfg.parity_en19 + cfg.nbstop19)) begin
    @(posedge vif19.clock19);
    #1;
    if (sample_clk19) begin
      if (num_of_bits_sent19 == 0) begin
        // Start19 sending19 tx_frame19 with "start bit"
        vif19.txd19 = frame19.start_bit19;
        `uvm_info(get_type_name(),
                  $psprintf("Driver19 Sending19 Frame19 SOP19: %b", frame19.start_bit19),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent19 > 0) && (num_of_bits_sent19 < (1 + cfg.char_len_val19))) begin
        // sending19 "data bits" 
        payload_byte19 = frame19.payload19[num_of_bits_sent19-1] ;
        vif19.txd19 = frame19.payload19[num_of_bits_sent19-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver19 Sending19 Frame19 data bit number19:%0d value:'b%b",
             (num_of_bits_sent19-1), payload_byte19), UVM_HIGH)
      end
      if ((num_of_bits_sent19 == (1 + cfg.char_len_val19)) && (cfg.parity_en19)) begin
        // sending19 "parity19 bit" if parity19 is enabled
        vif19.txd19 = frame19.calc_parity19(cfg.char_len_val19, cfg.parity_mode19);
        `uvm_info(get_type_name(),
             $psprintf("Driver19 Sending19 Frame19 Parity19 bit:'b%b",
             frame19.calc_parity19(cfg.char_len_val19, cfg.parity_mode19)), UVM_HIGH)
      end
      if (num_of_bits_sent19 == (1 + cfg.char_len_val19 + cfg.parity_en19)) begin
        // sending19 "stop/error bits"
        for (int i = 0; i < cfg.nbstop19; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver19 Sending19 Frame19 Stop bit:'b%b",
               frame19.stop_bits19[i]), UVM_HIGH)
          wait (sample_clk19);
          if (frame19.error_bits19[i]) begin
            vif19.txd19 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver19 intensionally19 corrupting19 Stop bit since19 error_bits19['b%b] is 'b%b", i, frame19.error_bits19[i]),
                 UVM_HIGH)
          end else
          vif19.txd19 = frame19.stop_bits19[i];
          num_of_bits_sent19++;
          wait (!sample_clk19);
        end
      end
    num_of_bits_sent19++;
    wait (!sample_clk19);
    end
  end
  
  num_frames_sent19++;
  `uvm_info(get_type_name(),
       $psprintf("Frame19 **%0d** Sent19...", num_frames_sent19), UVM_MEDIUM)
  wait (sample_clk19);
  vif19.txd19 = 1;

  `uvm_info(get_type_name(), "Frame19 complete...", UVM_MEDIUM)
  this.end_tr(frame19);
   
endtask : send_tx_frame19

//UVM report_phase
function void uart_tx_driver19::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART19 Frames19 Sent19:%0d", num_frames_sent19),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER19
