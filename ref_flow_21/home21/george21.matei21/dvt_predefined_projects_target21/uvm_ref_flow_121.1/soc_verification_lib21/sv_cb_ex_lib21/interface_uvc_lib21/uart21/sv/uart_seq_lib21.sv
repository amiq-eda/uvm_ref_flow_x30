/*-------------------------------------------------------------------------
File21 name   : uart_seq_lib21.sv
Title21       : sequence library file for uart21 uvc21
Project21     :
Created21     :
Description21 : describes21 all UART21 UVC21 sequences
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE21: uart_base_seq21
//-------------------------------------------------
class uart_base_seq21 extends uvm_sequence #(uart_frame21);
  function new(string name="uart_base_seq21");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq21)
  `uvm_declare_p_sequencer(uart_sequencer21)

  // Use a base sequence to raise/drop21 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running21 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq21

//-------------------------------------------------
// SEQUENCE21: uart_incr_payload_seq21
//-------------------------------------------------
class uart_incr_payload_seq21 extends uart_base_seq21;
    rand int unsigned cnt;
    rand bit [7:0] start_payload21;

    function new(string name="uart_incr_payload_seq21");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq21)
   `uvm_declare_p_sequencer(uart_sequencer21)

    constraint count_ct21 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART21 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload21 == (start_payload21 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq21

//-------------------------------------------------
// SEQUENCE21: uart_bad_parity_seq21
//-------------------------------------------------
class uart_bad_parity_seq21 extends uart_base_seq21;
    rand int unsigned cnt;
    rand bit [7:0] start_payload21;

    function new(string name="uart_bad_parity_seq21");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq21)
   `uvm_declare_p_sequencer(uart_sequencer21)

    constraint count_ct21 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART21 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create21 the frame21
        `uvm_create(req)
         // Nullify21 the constrain21 on the parity21
         req.default_parity_type21.constraint_mode(0);
   
         // Now21 send the packed with parity21 constrained21 to BAD_PARITY21
        `uvm_rand_send_with(req, { req.parity_type21 == BAD_PARITY21;})
      end
    endtask
endclass: uart_bad_parity_seq21

//-------------------------------------------------
// SEQUENCE21: uart_transmit_seq21
//-------------------------------------------------
class uart_transmit_seq21 extends uart_base_seq21;

   rand int unsigned num_of_tx21;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq21)
   `uvm_declare_p_sequencer(uart_sequencer21)
   
   function new(string name="uart_transmit_seq21");
      super.new(name);
   endfunction

   constraint num_of_tx_ct21 { num_of_tx21 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART21 sequencer: Executing %0d Frames21", num_of_tx21), UVM_LOW)
     for (int i = 0; i < num_of_tx21; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq21

//-------------------------------------------------
// SEQUENCE21: uart_no_activity_seq21
//-------------------------------------------------
class no_activity_seq21 extends uart_base_seq21;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq21)
  `uvm_declare_p_sequencer(uart_sequencer21)

  function new(string name="no_activity_seq21");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART21 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq21

//-------------------------------------------------
// SEQUENCE21: uart_short_transmit_seq21
//-------------------------------------------------
class uart_short_transmit_seq21 extends uart_base_seq21;

   rand int unsigned num_of_tx21;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq21)
   `uvm_declare_p_sequencer(uart_sequencer21)
   
   function new(string name="uart_short_transmit_seq21");
      super.new(name);
   endfunction

   constraint num_of_tx_ct21 { num_of_tx21 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART21 sequencer: Executing %0d Frames21", num_of_tx21), UVM_LOW)
     for (int i = 0; i < num_of_tx21; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq21
