/*-------------------------------------------------------------------------
File11 name   : uart_seq_lib11.sv
Title11       : sequence library file for uart11 uvc11
Project11     :
Created11     :
Description11 : describes11 all UART11 UVC11 sequences
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE11: uart_base_seq11
//-------------------------------------------------
class uart_base_seq11 extends uvm_sequence #(uart_frame11);
  function new(string name="uart_base_seq11");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq11)
  `uvm_declare_p_sequencer(uart_sequencer11)

  // Use a base sequence to raise/drop11 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running11 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq11

//-------------------------------------------------
// SEQUENCE11: uart_incr_payload_seq11
//-------------------------------------------------
class uart_incr_payload_seq11 extends uart_base_seq11;
    rand int unsigned cnt;
    rand bit [7:0] start_payload11;

    function new(string name="uart_incr_payload_seq11");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq11)
   `uvm_declare_p_sequencer(uart_sequencer11)

    constraint count_ct11 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART11 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload11 == (start_payload11 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq11

//-------------------------------------------------
// SEQUENCE11: uart_bad_parity_seq11
//-------------------------------------------------
class uart_bad_parity_seq11 extends uart_base_seq11;
    rand int unsigned cnt;
    rand bit [7:0] start_payload11;

    function new(string name="uart_bad_parity_seq11");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq11)
   `uvm_declare_p_sequencer(uart_sequencer11)

    constraint count_ct11 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART11 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create11 the frame11
        `uvm_create(req)
         // Nullify11 the constrain11 on the parity11
         req.default_parity_type11.constraint_mode(0);
   
         // Now11 send the packed with parity11 constrained11 to BAD_PARITY11
        `uvm_rand_send_with(req, { req.parity_type11 == BAD_PARITY11;})
      end
    endtask
endclass: uart_bad_parity_seq11

//-------------------------------------------------
// SEQUENCE11: uart_transmit_seq11
//-------------------------------------------------
class uart_transmit_seq11 extends uart_base_seq11;

   rand int unsigned num_of_tx11;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq11)
   `uvm_declare_p_sequencer(uart_sequencer11)
   
   function new(string name="uart_transmit_seq11");
      super.new(name);
   endfunction

   constraint num_of_tx_ct11 { num_of_tx11 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART11 sequencer: Executing %0d Frames11", num_of_tx11), UVM_LOW)
     for (int i = 0; i < num_of_tx11; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq11

//-------------------------------------------------
// SEQUENCE11: uart_no_activity_seq11
//-------------------------------------------------
class no_activity_seq11 extends uart_base_seq11;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq11)
  `uvm_declare_p_sequencer(uart_sequencer11)

  function new(string name="no_activity_seq11");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART11 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq11

//-------------------------------------------------
// SEQUENCE11: uart_short_transmit_seq11
//-------------------------------------------------
class uart_short_transmit_seq11 extends uart_base_seq11;

   rand int unsigned num_of_tx11;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq11)
   `uvm_declare_p_sequencer(uart_sequencer11)
   
   function new(string name="uart_short_transmit_seq11");
      super.new(name);
   endfunction

   constraint num_of_tx_ct11 { num_of_tx11 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART11 sequencer: Executing %0d Frames11", num_of_tx11), UVM_LOW)
     for (int i = 0; i < num_of_tx11; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq11
