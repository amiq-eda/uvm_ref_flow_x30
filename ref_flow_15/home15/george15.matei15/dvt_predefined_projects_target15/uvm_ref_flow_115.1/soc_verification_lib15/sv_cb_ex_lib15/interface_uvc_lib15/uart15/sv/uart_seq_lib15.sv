/*-------------------------------------------------------------------------
File15 name   : uart_seq_lib15.sv
Title15       : sequence library file for uart15 uvc15
Project15     :
Created15     :
Description15 : describes15 all UART15 UVC15 sequences
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE15: uart_base_seq15
//-------------------------------------------------
class uart_base_seq15 extends uvm_sequence #(uart_frame15);
  function new(string name="uart_base_seq15");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq15)
  `uvm_declare_p_sequencer(uart_sequencer15)

  // Use a base sequence to raise/drop15 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running15 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq15

//-------------------------------------------------
// SEQUENCE15: uart_incr_payload_seq15
//-------------------------------------------------
class uart_incr_payload_seq15 extends uart_base_seq15;
    rand int unsigned cnt;
    rand bit [7:0] start_payload15;

    function new(string name="uart_incr_payload_seq15");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq15)
   `uvm_declare_p_sequencer(uart_sequencer15)

    constraint count_ct15 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART15 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload15 == (start_payload15 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq15

//-------------------------------------------------
// SEQUENCE15: uart_bad_parity_seq15
//-------------------------------------------------
class uart_bad_parity_seq15 extends uart_base_seq15;
    rand int unsigned cnt;
    rand bit [7:0] start_payload15;

    function new(string name="uart_bad_parity_seq15");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq15)
   `uvm_declare_p_sequencer(uart_sequencer15)

    constraint count_ct15 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART15 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create15 the frame15
        `uvm_create(req)
         // Nullify15 the constrain15 on the parity15
         req.default_parity_type15.constraint_mode(0);
   
         // Now15 send the packed with parity15 constrained15 to BAD_PARITY15
        `uvm_rand_send_with(req, { req.parity_type15 == BAD_PARITY15;})
      end
    endtask
endclass: uart_bad_parity_seq15

//-------------------------------------------------
// SEQUENCE15: uart_transmit_seq15
//-------------------------------------------------
class uart_transmit_seq15 extends uart_base_seq15;

   rand int unsigned num_of_tx15;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq15)
   `uvm_declare_p_sequencer(uart_sequencer15)
   
   function new(string name="uart_transmit_seq15");
      super.new(name);
   endfunction

   constraint num_of_tx_ct15 { num_of_tx15 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART15 sequencer: Executing %0d Frames15", num_of_tx15), UVM_LOW)
     for (int i = 0; i < num_of_tx15; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq15

//-------------------------------------------------
// SEQUENCE15: uart_no_activity_seq15
//-------------------------------------------------
class no_activity_seq15 extends uart_base_seq15;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq15)
  `uvm_declare_p_sequencer(uart_sequencer15)

  function new(string name="no_activity_seq15");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART15 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq15

//-------------------------------------------------
// SEQUENCE15: uart_short_transmit_seq15
//-------------------------------------------------
class uart_short_transmit_seq15 extends uart_base_seq15;

   rand int unsigned num_of_tx15;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq15)
   `uvm_declare_p_sequencer(uart_sequencer15)
   
   function new(string name="uart_short_transmit_seq15");
      super.new(name);
   endfunction

   constraint num_of_tx_ct15 { num_of_tx15 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART15 sequencer: Executing %0d Frames15", num_of_tx15), UVM_LOW)
     for (int i = 0; i < num_of_tx15; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq15
