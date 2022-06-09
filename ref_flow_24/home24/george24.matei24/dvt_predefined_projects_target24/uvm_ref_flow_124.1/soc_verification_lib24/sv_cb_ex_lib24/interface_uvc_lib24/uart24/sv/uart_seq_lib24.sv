/*-------------------------------------------------------------------------
File24 name   : uart_seq_lib24.sv
Title24       : sequence library file for uart24 uvc24
Project24     :
Created24     :
Description24 : describes24 all UART24 UVC24 sequences
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

//-------------------------------------------------
// SEQUENCE24: uart_base_seq24
//-------------------------------------------------
class uart_base_seq24 extends uvm_sequence #(uart_frame24);
  function new(string name="uart_base_seq24");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq24)
  `uvm_declare_p_sequencer(uart_sequencer24)

  // Use a base sequence to raise/drop24 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running24 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq24

//-------------------------------------------------
// SEQUENCE24: uart_incr_payload_seq24
//-------------------------------------------------
class uart_incr_payload_seq24 extends uart_base_seq24;
    rand int unsigned cnt;
    rand bit [7:0] start_payload24;

    function new(string name="uart_incr_payload_seq24");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq24)
   `uvm_declare_p_sequencer(uart_sequencer24)

    constraint count_ct24 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART24 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload24 == (start_payload24 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq24

//-------------------------------------------------
// SEQUENCE24: uart_bad_parity_seq24
//-------------------------------------------------
class uart_bad_parity_seq24 extends uart_base_seq24;
    rand int unsigned cnt;
    rand bit [7:0] start_payload24;

    function new(string name="uart_bad_parity_seq24");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq24)
   `uvm_declare_p_sequencer(uart_sequencer24)

    constraint count_ct24 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART24 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create24 the frame24
        `uvm_create(req)
         // Nullify24 the constrain24 on the parity24
         req.default_parity_type24.constraint_mode(0);
   
         // Now24 send the packed with parity24 constrained24 to BAD_PARITY24
        `uvm_rand_send_with(req, { req.parity_type24 == BAD_PARITY24;})
      end
    endtask
endclass: uart_bad_parity_seq24

//-------------------------------------------------
// SEQUENCE24: uart_transmit_seq24
//-------------------------------------------------
class uart_transmit_seq24 extends uart_base_seq24;

   rand int unsigned num_of_tx24;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq24)
   `uvm_declare_p_sequencer(uart_sequencer24)
   
   function new(string name="uart_transmit_seq24");
      super.new(name);
   endfunction

   constraint num_of_tx_ct24 { num_of_tx24 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART24 sequencer: Executing %0d Frames24", num_of_tx24), UVM_LOW)
     for (int i = 0; i < num_of_tx24; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq24

//-------------------------------------------------
// SEQUENCE24: uart_no_activity_seq24
//-------------------------------------------------
class no_activity_seq24 extends uart_base_seq24;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq24)
  `uvm_declare_p_sequencer(uart_sequencer24)

  function new(string name="no_activity_seq24");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART24 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq24

//-------------------------------------------------
// SEQUENCE24: uart_short_transmit_seq24
//-------------------------------------------------
class uart_short_transmit_seq24 extends uart_base_seq24;

   rand int unsigned num_of_tx24;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq24)
   `uvm_declare_p_sequencer(uart_sequencer24)
   
   function new(string name="uart_short_transmit_seq24");
      super.new(name);
   endfunction

   constraint num_of_tx_ct24 { num_of_tx24 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART24 sequencer: Executing %0d Frames24", num_of_tx24), UVM_LOW)
     for (int i = 0; i < num_of_tx24; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq24
