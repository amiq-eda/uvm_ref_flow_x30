/*******************************************************************************
  FILE : apb_slave_seq_lib13.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_SEQ_LIB_SV13
`define APB_SLAVE_SEQ_LIB_SV13

//------------------------------------------------------------------------------
// SEQUENCE13: simple_response_seq13
//------------------------------------------------------------------------------

class simple_response_seq13 extends uvm_sequence #(apb_transfer13);

  function new(string name="simple_response_seq13");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq13)
  `uvm_declare_p_sequencer(apb_slave_sequencer13)

  apb_transfer13 req;
  apb_transfer13 util_transfer13;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port13.peek(util_transfer13);
      if((util_transfer13.direction13 == APB_READ13) && 
        (p_sequencer.cfg.check_address_range13(util_transfer13.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range13 Matching13 read.  Responding13...", util_transfer13.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction13 == APB_READ13; } )
      end
    end
  endtask : body

endclass : simple_response_seq13

//------------------------------------------------------------------------------
// SEQUENCE13: mem_response_seq13
//------------------------------------------------------------------------------
class mem_response_seq13 extends uvm_sequence #(apb_transfer13);

  function new(string name="mem_response_seq13");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data13;

  `uvm_object_utils(mem_response_seq13)
  `uvm_declare_p_sequencer(apb_slave_sequencer13)

  //simple13 assoc13 array to hold13 values
  logic [31:0] slave_mem13[int];

  apb_transfer13 req;
  apb_transfer13 util_transfer13;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port13.peek(util_transfer13);
      if((util_transfer13.direction13 == APB_READ13) && 
        (p_sequencer.cfg.check_address_range13(util_transfer13.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range13 Matching13 APB_READ13.  Responding13...", util_transfer13.addr), UVM_MEDIUM);
        if (slave_mem13.exists(util_transfer13.addr))
        `uvm_do_with(req, { req.direction13 == APB_READ13;
                            req.addr == util_transfer13.addr;
                            req.data == slave_mem13[util_transfer13.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction13 == APB_READ13;
                            req.addr == util_transfer13.addr;
                            req.data == mem_data13; } )
         mem_data13++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range13(util_transfer13.addr) == 1) begin
        slave_mem13[util_transfer13.addr] = util_transfer13.data;
        // DUMMY13 response with same information
        `uvm_do_with(req, { req.direction13 == APB_WRITE13;
                            req.addr == util_transfer13.addr;
                            req.data == util_transfer13.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq13

`endif // APB_SLAVE_SEQ_LIB_SV13
