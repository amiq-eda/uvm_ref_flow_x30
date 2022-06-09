/*-------------------------------------------------------------------------
File13 name   : uart_seq_lib13.sv
Title13       : sequence library file for uart13 uvc13
Project13     :
Created13     :
Description13 : describes13 all UART13 UVC13 sequences
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

//-------------------------------------------------
// SEQUENCE13: uart_base_seq13
//-------------------------------------------------
class uart_base_seq13 extends uvm_sequence #(uart_frame13);
  function new(string name="uart_base_seq13");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq13)
  `uvm_declare_p_sequencer(uart_sequencer13)

  // Use a base sequence to raise/drop13 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running13 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq13

//-------------------------------------------------
// SEQUENCE13: uart_incr_payload_seq13
//-------------------------------------------------
class uart_incr_payload_seq13 extends uart_base_seq13;
    rand int unsigned cnt;
    rand bit [7:0] start_payload13;

    function new(string name="uart_incr_payload_seq13");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq13)
   `uvm_declare_p_sequencer(uart_sequencer13)

    constraint count_ct13 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART13 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload13 == (start_payload13 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq13

//-------------------------------------------------
// SEQUENCE13: uart_bad_parity_seq13
//-------------------------------------------------
class uart_bad_parity_seq13 extends uart_base_seq13;
    rand int unsigned cnt;
    rand bit [7:0] start_payload13;

    function new(string name="uart_bad_parity_seq13");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq13)
   `uvm_declare_p_sequencer(uart_sequencer13)

    constraint count_ct13 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART13 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create13 the frame13
        `uvm_create(req)
         // Nullify13 the constrain13 on the parity13
         req.default_parity_type13.constraint_mode(0);
   
         // Now13 send the packed with parity13 constrained13 to BAD_PARITY13
        `uvm_rand_send_with(req, { req.parity_type13 == BAD_PARITY13;})
      end
    endtask
endclass: uart_bad_parity_seq13

//-------------------------------------------------
// SEQUENCE13: uart_transmit_seq13
//-------------------------------------------------
class uart_transmit_seq13 extends uart_base_seq13;

   rand int unsigned num_of_tx13;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq13)
   `uvm_declare_p_sequencer(uart_sequencer13)
   
   function new(string name="uart_transmit_seq13");
      super.new(name);
   endfunction

   constraint num_of_tx_ct13 { num_of_tx13 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART13 sequencer: Executing %0d Frames13", num_of_tx13), UVM_LOW)
     for (int i = 0; i < num_of_tx13; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq13

//-------------------------------------------------
// SEQUENCE13: uart_no_activity_seq13
//-------------------------------------------------
class no_activity_seq13 extends uart_base_seq13;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq13)
  `uvm_declare_p_sequencer(uart_sequencer13)

  function new(string name="no_activity_seq13");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART13 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq13

//-------------------------------------------------
// SEQUENCE13: uart_short_transmit_seq13
//-------------------------------------------------
class uart_short_transmit_seq13 extends uart_base_seq13;

   rand int unsigned num_of_tx13;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq13)
   `uvm_declare_p_sequencer(uart_sequencer13)
   
   function new(string name="uart_short_transmit_seq13");
      super.new(name);
   endfunction

   constraint num_of_tx_ct13 { num_of_tx13 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART13 sequencer: Executing %0d Frames13", num_of_tx13), UVM_LOW)
     for (int i = 0; i < num_of_tx13; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq13
