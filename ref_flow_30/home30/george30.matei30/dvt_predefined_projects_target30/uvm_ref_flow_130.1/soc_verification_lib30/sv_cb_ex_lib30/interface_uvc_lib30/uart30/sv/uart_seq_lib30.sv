/*-------------------------------------------------------------------------
File30 name   : uart_seq_lib30.sv
Title30       : sequence library file for uart30 uvc30
Project30     :
Created30     :
Description30 : describes30 all UART30 UVC30 sequences
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE30: uart_base_seq30
//-------------------------------------------------
class uart_base_seq30 extends uvm_sequence #(uart_frame30);
  function new(string name="uart_base_seq30");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq30)
  `uvm_declare_p_sequencer(uart_sequencer30)

  // Use a base sequence to raise/drop30 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running30 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq30

//-------------------------------------------------
// SEQUENCE30: uart_incr_payload_seq30
//-------------------------------------------------
class uart_incr_payload_seq30 extends uart_base_seq30;
    rand int unsigned cnt;
    rand bit [7:0] start_payload30;

    function new(string name="uart_incr_payload_seq30");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq30)
   `uvm_declare_p_sequencer(uart_sequencer30)

    constraint count_ct30 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART30 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload30 == (start_payload30 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq30

//-------------------------------------------------
// SEQUENCE30: uart_bad_parity_seq30
//-------------------------------------------------
class uart_bad_parity_seq30 extends uart_base_seq30;
    rand int unsigned cnt;
    rand bit [7:0] start_payload30;

    function new(string name="uart_bad_parity_seq30");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq30)
   `uvm_declare_p_sequencer(uart_sequencer30)

    constraint count_ct30 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART30 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create30 the frame30
        `uvm_create(req)
         // Nullify30 the constrain30 on the parity30
         req.default_parity_type30.constraint_mode(0);
   
         // Now30 send the packed with parity30 constrained30 to BAD_PARITY30
        `uvm_rand_send_with(req, { req.parity_type30 == BAD_PARITY30;})
      end
    endtask
endclass: uart_bad_parity_seq30

//-------------------------------------------------
// SEQUENCE30: uart_transmit_seq30
//-------------------------------------------------
class uart_transmit_seq30 extends uart_base_seq30;

   rand int unsigned num_of_tx30;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq30)
   `uvm_declare_p_sequencer(uart_sequencer30)
   
   function new(string name="uart_transmit_seq30");
      super.new(name);
   endfunction

   constraint num_of_tx_ct30 { num_of_tx30 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART30 sequencer: Executing %0d Frames30", num_of_tx30), UVM_LOW)
     for (int i = 0; i < num_of_tx30; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq30

//-------------------------------------------------
// SEQUENCE30: uart_no_activity_seq30
//-------------------------------------------------
class no_activity_seq30 extends uart_base_seq30;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq30)
  `uvm_declare_p_sequencer(uart_sequencer30)

  function new(string name="no_activity_seq30");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART30 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq30

//-------------------------------------------------
// SEQUENCE30: uart_short_transmit_seq30
//-------------------------------------------------
class uart_short_transmit_seq30 extends uart_base_seq30;

   rand int unsigned num_of_tx30;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq30)
   `uvm_declare_p_sequencer(uart_sequencer30)
   
   function new(string name="uart_short_transmit_seq30");
      super.new(name);
   endfunction

   constraint num_of_tx_ct30 { num_of_tx30 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART30 sequencer: Executing %0d Frames30", num_of_tx30), UVM_LOW)
     for (int i = 0; i < num_of_tx30; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq30
