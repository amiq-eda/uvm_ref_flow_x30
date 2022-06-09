/*-------------------------------------------------------------------------
File2 name   : uart_tx_driver2.sv
Title2       : TX2 Driver2
Project2     :
Created2     :
Description2 : Describes2 UART2 Trasmit2 Driver2 for UART2 UVC2
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER2
`define UART_TX_DRIVER2

class uart_tx_driver2 extends uvm_driver #(uart_frame2) ;

  // The virtual interface used to drive2 and view2 HDL signals2.
  virtual interface uart_if2 vif2;

  // handle to  a cfg class
  uart_config2 cfg;

  bit sample_clk2;
  bit baud_clk2;
  bit [15:0] ua_brgr2;
  bit [7:0] ua_bdiv2;
  int num_of_bits_sent2;
  int num_frames_sent2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver2)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk2, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk2, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr2, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv2, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor2 - required2 UVM syntax2
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive2();
  extern virtual task gen_sample_rate2(ref bit [15:0] ua_brgr2, ref bit sample_clk2);
  extern virtual task send_tx_frame2(input uart_frame2 frame2);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver2

// UVM build_phase
function void uart_tx_driver2::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config2)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG2", "uart_config2 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if2)::get(this, "", "vif2", vif2))
   `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver2::run_phase(uvm_phase phase);
  fork
    get_and_drive2();
    gen_sample_rate2(ua_brgr2, sample_clk2);
  join
endtask : run_phase

// reset
task uart_tx_driver2::reset();
  @(negedge vif2.reset);
  `uvm_info(get_type_name(), "Reset2 Asserted2", UVM_MEDIUM)
   vif2.txd2 = 1;        //Transmit2 Data
   vif2.rts_n2 = 0;      //Request2 to Send2
   vif2.dtr_n2 = 0;      //Data Terminal2 Ready2
   vif2.dcd_n2 = 0;      //Data Carrier2 Detect2
   vif2.baud_clk2 = 0;       //Baud2 Data
endtask : reset

//  get_and2 drive2
task uart_tx_driver2::get_and_drive2();
  while (1) begin
    reset();
    fork
      @(negedge vif2.reset)
        `uvm_info(get_type_name(), "Reset2 asserted2", UVM_LOW)
    begin
      forever begin
        @(posedge vif2.clock2 iff (vif2.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame2(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If2 we2 are in the middle2 of a transfer2, need to end the tx2. Also2,
    //do any reset cleanup2 here2. The only way2 we2 got2 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive2

task uart_tx_driver2::gen_sample_rate2(ref bit [15:0] ua_brgr2, ref bit sample_clk2);
  forever begin
    @(posedge vif2.clock2);
    if (!vif2.reset) begin
      ua_brgr2 = 0;
      sample_clk2 = 0;
    end else begin
      if (ua_brgr2 == ({cfg.baud_rate_div2, cfg.baud_rate_gen2})) begin
        ua_brgr2 = 0;
        sample_clk2 = 1;
      end else begin
        sample_clk2 = 0;
        ua_brgr2++;
      end
    end
  end
endtask : gen_sample_rate2

// -------------------
// send_tx_frame2
// -------------------
task uart_tx_driver2::send_tx_frame2(input uart_frame2 frame2);
  bit [7:0] payload_byte2;
  num_of_bits_sent2 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver2 Sending2 TX2 Frame2...\n%s", frame2.sprint()),
            UVM_HIGH)
 
  repeat (frame2.transmit_delay2)
    @(posedge vif2.clock2);
  void'(this.begin_tr(frame2));
   
  wait((!cfg.rts_en2)||(!vif2.cts_n2));
  `uvm_info(get_type_name(), "Driver2 - Modem2 RTS2 or CTS2 asserted2", UVM_HIGH)

  while (num_of_bits_sent2 <= (1 + cfg.char_len_val2 + cfg.parity_en2 + cfg.nbstop2)) begin
    @(posedge vif2.clock2);
    #1;
    if (sample_clk2) begin
      if (num_of_bits_sent2 == 0) begin
        // Start2 sending2 tx_frame2 with "start bit"
        vif2.txd2 = frame2.start_bit2;
        `uvm_info(get_type_name(),
                  $psprintf("Driver2 Sending2 Frame2 SOP2: %b", frame2.start_bit2),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent2 > 0) && (num_of_bits_sent2 < (1 + cfg.char_len_val2))) begin
        // sending2 "data bits" 
        payload_byte2 = frame2.payload2[num_of_bits_sent2-1] ;
        vif2.txd2 = frame2.payload2[num_of_bits_sent2-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver2 Sending2 Frame2 data bit number2:%0d value:'b%b",
             (num_of_bits_sent2-1), payload_byte2), UVM_HIGH)
      end
      if ((num_of_bits_sent2 == (1 + cfg.char_len_val2)) && (cfg.parity_en2)) begin
        // sending2 "parity2 bit" if parity2 is enabled
        vif2.txd2 = frame2.calc_parity2(cfg.char_len_val2, cfg.parity_mode2);
        `uvm_info(get_type_name(),
             $psprintf("Driver2 Sending2 Frame2 Parity2 bit:'b%b",
             frame2.calc_parity2(cfg.char_len_val2, cfg.parity_mode2)), UVM_HIGH)
      end
      if (num_of_bits_sent2 == (1 + cfg.char_len_val2 + cfg.parity_en2)) begin
        // sending2 "stop/error bits"
        for (int i = 0; i < cfg.nbstop2; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver2 Sending2 Frame2 Stop bit:'b%b",
               frame2.stop_bits2[i]), UVM_HIGH)
          wait (sample_clk2);
          if (frame2.error_bits2[i]) begin
            vif2.txd2 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver2 intensionally2 corrupting2 Stop bit since2 error_bits2['b%b] is 'b%b", i, frame2.error_bits2[i]),
                 UVM_HIGH)
          end else
          vif2.txd2 = frame2.stop_bits2[i];
          num_of_bits_sent2++;
          wait (!sample_clk2);
        end
      end
    num_of_bits_sent2++;
    wait (!sample_clk2);
    end
  end
  
  num_frames_sent2++;
  `uvm_info(get_type_name(),
       $psprintf("Frame2 **%0d** Sent2...", num_frames_sent2), UVM_MEDIUM)
  wait (sample_clk2);
  vif2.txd2 = 1;

  `uvm_info(get_type_name(), "Frame2 complete...", UVM_MEDIUM)
  this.end_tr(frame2);
   
endtask : send_tx_frame2

//UVM report_phase
function void uart_tx_driver2::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART2 Frames2 Sent2:%0d", num_frames_sent2),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER2
