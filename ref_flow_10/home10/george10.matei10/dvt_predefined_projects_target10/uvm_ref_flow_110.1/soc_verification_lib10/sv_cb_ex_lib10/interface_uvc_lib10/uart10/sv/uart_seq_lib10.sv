/*-------------------------------------------------------------------------
File10 name   : uart_seq_lib10.sv
Title10       : sequence library file for uart10 uvc10
Project10     :
Created10     :
Description10 : describes10 all UART10 UVC10 sequences
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE10: uart_base_seq10
//-------------------------------------------------
class uart_base_seq10 extends uvm_sequence #(uart_frame10);
  function new(string name="uart_base_seq10");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq10)
  `uvm_declare_p_sequencer(uart_sequencer10)

  // Use a base sequence to raise/drop10 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running10 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq10

//-------------------------------------------------
// SEQUENCE10: uart_incr_payload_seq10
//-------------------------------------------------
class uart_incr_payload_seq10 extends uart_base_seq10;
    rand int unsigned cnt;
    rand bit [7:0] start_payload10;

    function new(string name="uart_incr_payload_seq10");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq10)
   `uvm_declare_p_sequencer(uart_sequencer10)

    constraint count_ct10 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART10 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload10 == (start_payload10 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq10

//-------------------------------------------------
// SEQUENCE10: uart_bad_parity_seq10
//-------------------------------------------------
class uart_bad_parity_seq10 extends uart_base_seq10;
    rand int unsigned cnt;
    rand bit [7:0] start_payload10;

    function new(string name="uart_bad_parity_seq10");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq10)
   `uvm_declare_p_sequencer(uart_sequencer10)

    constraint count_ct10 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART10 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create10 the frame10
        `uvm_create(req)
         // Nullify10 the constrain10 on the parity10
         req.default_parity_type10.constraint_mode(0);
   
         // Now10 send the packed with parity10 constrained10 to BAD_PARITY10
        `uvm_rand_send_with(req, { req.parity_type10 == BAD_PARITY10;})
      end
    endtask
endclass: uart_bad_parity_seq10

//-------------------------------------------------
// SEQUENCE10: uart_transmit_seq10
//-------------------------------------------------
class uart_transmit_seq10 extends uart_base_seq10;

   rand int unsigned num_of_tx10;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq10)
   `uvm_declare_p_sequencer(uart_sequencer10)
   
   function new(string name="uart_transmit_seq10");
      super.new(name);
   endfunction

   constraint num_of_tx_ct10 { num_of_tx10 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART10 sequencer: Executing %0d Frames10", num_of_tx10), UVM_LOW)
     for (int i = 0; i < num_of_tx10; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq10

//-------------------------------------------------
// SEQUENCE10: uart_no_activity_seq10
//-------------------------------------------------
class no_activity_seq10 extends uart_base_seq10;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq10)
  `uvm_declare_p_sequencer(uart_sequencer10)

  function new(string name="no_activity_seq10");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART10 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq10

//-------------------------------------------------
// SEQUENCE10: uart_short_transmit_seq10
//-------------------------------------------------
class uart_short_transmit_seq10 extends uart_base_seq10;

   rand int unsigned num_of_tx10;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq10)
   `uvm_declare_p_sequencer(uart_sequencer10)
   
   function new(string name="uart_short_transmit_seq10");
      super.new(name);
   endfunction

   constraint num_of_tx_ct10 { num_of_tx10 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART10 sequencer: Executing %0d Frames10", num_of_tx10), UVM_LOW)
     for (int i = 0; i < num_of_tx10; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq10
