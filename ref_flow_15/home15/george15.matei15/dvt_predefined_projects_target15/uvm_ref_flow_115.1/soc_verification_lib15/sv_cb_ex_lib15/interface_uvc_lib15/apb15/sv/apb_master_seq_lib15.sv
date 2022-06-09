/*******************************************************************************
  FILE : apb_master_seq_lib15.sv
*******************************************************************************/
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


`ifndef APB_MASTER_SEQ_LIB_SV15
`define APB_MASTER_SEQ_LIB_SV15

//------------------------------------------------------------------------------
// SEQUENCE15: read_byte_seq15
//------------------------------------------------------------------------------
class apb_master_base_seq15 extends uvm_sequence #(apb_transfer15);
  // NOTE15: KATHLEEN15 - ALSO15 NEED15 TO HANDLE15 KILL15 HERE15??

  function new(string name="apb_master_base_seq15");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq15)
  `uvm_declare_p_sequencer(apb_master_sequencer15)

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
endclass : apb_master_base_seq15

//------------------------------------------------------------------------------
// SEQUENCE15: read_byte_seq15
//------------------------------------------------------------------------------
class read_byte_seq15 extends apb_master_base_seq15;
  rand bit [31:0] start_addr15;
  rand int unsigned transmit_del15;

  function new(string name="read_byte_seq15");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq15)

  constraint transmit_del_ct15 { (transmit_del15 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr15;
        req.direction15 == APB_READ15;
        req.transmit_delay15 == transmit_del15; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr15 = 'h%0h, req_data15 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr15 = 'h%0h, rsp_data15 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq15

// SEQUENCE15: write_byte_seq15
class write_byte_seq15 extends apb_master_base_seq15;
  rand bit [31:0] start_addr15;
  rand bit [7:0] write_data15;
  rand int unsigned transmit_del15;

  function new(string name="write_byte_seq15");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq15)

  constraint transmit_del_ct15 { (transmit_del15 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr15;
        req.direction15 == APB_WRITE15;
        req.data == write_data15;
        req.transmit_delay15 == transmit_del15; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq15

//------------------------------------------------------------------------------
// SEQUENCE15: read_word_seq15
//------------------------------------------------------------------------------
class read_word_seq15 extends apb_master_base_seq15;
  rand bit [31:0] start_addr15;
  rand int unsigned transmit_del15;

  function new(string name="read_word_seq15");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq15)

  constraint transmit_del_ct15 { (transmit_del15 <= 10); }
  constraint addr_ct15 {(start_addr15[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr15;
        req.direction15 == APB_READ15;
        req.transmit_delay15 == transmit_del15; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr15 = 'h%0h, req_data15 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr15 = 'h%0h, rsp_data15 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq15

// SEQUENCE15: write_word_seq15
class write_word_seq15 extends apb_master_base_seq15;
  rand bit [31:0] start_addr15;
  rand bit [31:0] write_data15;
  rand int unsigned transmit_del15;

  function new(string name="write_word_seq15");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq15)

  constraint transmit_del_ct15 { (transmit_del15 <= 10); }
  constraint addr_ct15 {(start_addr15[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr15;
        req.direction15 == APB_WRITE15;
        req.data == write_data15;
        req.transmit_delay15 == transmit_del15; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq15

// SEQUENCE15: read_after_write_seq15
class read_after_write_seq15 extends apb_master_base_seq15;

  rand bit [31:0] start_addr15;
  rand bit [31:0] write_data15;
  rand int unsigned transmit_del15;

  function new(string name="read_after_write_seq15");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq15)

  constraint transmit_del_ct15 { (transmit_del15 <= 10); }
  constraint addr_ct15 {(start_addr15[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr15;
        req.direction15 == APB_WRITE15;
        req.data == write_data15;
        req.transmit_delay15 == transmit_del15; } )
    `uvm_do_with(req, 
      { req.addr == start_addr15;
        req.direction15 == APB_READ15;
        req.transmit_delay15 == transmit_del15; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq15

// SEQUENCE15: multiple_read_after_write_seq15
class multiple_read_after_write_seq15 extends apb_master_base_seq15;

    read_after_write_seq15 raw_seq15;
    write_byte_seq15 w_seq15;
    read_byte_seq15 r_seq15;
    rand int unsigned num_of_seq15;

    function new(string name="multiple_read_after_write_seq15");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq15)

    constraint num_of_seq_c15 { num_of_seq15 <= 10; num_of_seq15 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq15; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq15)
      end
      repeat (3) `uvm_do_with(w_seq15, {transmit_del15 == 1;} )
      repeat (3) `uvm_do_with(r_seq15, {transmit_del15 == 1;} )
    endtask
endclass : multiple_read_after_write_seq15
`endif // APB_MASTER_SEQ_LIB_SV15
