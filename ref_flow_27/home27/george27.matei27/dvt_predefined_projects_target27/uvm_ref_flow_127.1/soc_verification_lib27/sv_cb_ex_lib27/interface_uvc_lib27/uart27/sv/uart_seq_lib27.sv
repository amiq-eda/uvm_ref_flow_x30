/*-------------------------------------------------------------------------
File27 name   : uart_seq_lib27.sv
Title27       : sequence library file for uart27 uvc27
Project27     :
Created27     :
Description27 : describes27 all UART27 UVC27 sequences
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE27: uart_base_seq27
//-------------------------------------------------
class uart_base_seq27 extends uvm_sequence #(uart_frame27);
  function new(string name="uart_base_seq27");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq27)
  `uvm_declare_p_sequencer(uart_sequencer27)

  // Use a base sequence to raise/drop27 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running27 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq27

//-------------------------------------------------
// SEQUENCE27: uart_incr_payload_seq27
//-------------------------------------------------
class uart_incr_payload_seq27 extends uart_base_seq27;
    rand int unsigned cnt;
    rand bit [7:0] start_payload27;

    function new(string name="uart_incr_payload_seq27");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq27)
   `uvm_declare_p_sequencer(uart_sequencer27)

    constraint count_ct27 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART27 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload27 == (start_payload27 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq27

//-------------------------------------------------
// SEQUENCE27: uart_bad_parity_seq27
//-------------------------------------------------
class uart_bad_parity_seq27 extends uart_base_seq27;
    rand int unsigned cnt;
    rand bit [7:0] start_payload27;

    function new(string name="uart_bad_parity_seq27");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq27)
   `uvm_declare_p_sequencer(uart_sequencer27)

    constraint count_ct27 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART27 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create27 the frame27
        `uvm_create(req)
         // Nullify27 the constrain27 on the parity27
         req.default_parity_type27.constraint_mode(0);
   
         // Now27 send the packed with parity27 constrained27 to BAD_PARITY27
        `uvm_rand_send_with(req, { req.parity_type27 == BAD_PARITY27;})
      end
    endtask
endclass: uart_bad_parity_seq27

//-------------------------------------------------
// SEQUENCE27: uart_transmit_seq27
//-------------------------------------------------
class uart_transmit_seq27 extends uart_base_seq27;

   rand int unsigned num_of_tx27;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq27)
   `uvm_declare_p_sequencer(uart_sequencer27)
   
   function new(string name="uart_transmit_seq27");
      super.new(name);
   endfunction

   constraint num_of_tx_ct27 { num_of_tx27 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART27 sequencer: Executing %0d Frames27", num_of_tx27), UVM_LOW)
     for (int i = 0; i < num_of_tx27; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq27

//-------------------------------------------------
// SEQUENCE27: uart_no_activity_seq27
//-------------------------------------------------
class no_activity_seq27 extends uart_base_seq27;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq27)
  `uvm_declare_p_sequencer(uart_sequencer27)

  function new(string name="no_activity_seq27");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART27 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq27

//-------------------------------------------------
// SEQUENCE27: uart_short_transmit_seq27
//-------------------------------------------------
class uart_short_transmit_seq27 extends uart_base_seq27;

   rand int unsigned num_of_tx27;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq27)
   `uvm_declare_p_sequencer(uart_sequencer27)
   
   function new(string name="uart_short_transmit_seq27");
      super.new(name);
   endfunction

   constraint num_of_tx_ct27 { num_of_tx27 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART27 sequencer: Executing %0d Frames27", num_of_tx27), UVM_LOW)
     for (int i = 0; i < num_of_tx27; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq27
