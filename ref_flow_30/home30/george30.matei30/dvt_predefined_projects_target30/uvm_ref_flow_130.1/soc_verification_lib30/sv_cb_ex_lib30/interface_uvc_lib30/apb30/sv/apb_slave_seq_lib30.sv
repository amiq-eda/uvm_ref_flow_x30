/*******************************************************************************
  FILE : apb_slave_seq_lib30.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_SEQ_LIB_SV30
`define APB_SLAVE_SEQ_LIB_SV30

//------------------------------------------------------------------------------
// SEQUENCE30: simple_response_seq30
//------------------------------------------------------------------------------

class simple_response_seq30 extends uvm_sequence #(apb_transfer30);

  function new(string name="simple_response_seq30");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq30)
  `uvm_declare_p_sequencer(apb_slave_sequencer30)

  apb_transfer30 req;
  apb_transfer30 util_transfer30;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port30.peek(util_transfer30);
      if((util_transfer30.direction30 == APB_READ30) && 
        (p_sequencer.cfg.check_address_range30(util_transfer30.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range30 Matching30 read.  Responding30...", util_transfer30.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction30 == APB_READ30; } )
      end
    end
  endtask : body

endclass : simple_response_seq30

//------------------------------------------------------------------------------
// SEQUENCE30: mem_response_seq30
//------------------------------------------------------------------------------
class mem_response_seq30 extends uvm_sequence #(apb_transfer30);

  function new(string name="mem_response_seq30");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data30;

  `uvm_object_utils(mem_response_seq30)
  `uvm_declare_p_sequencer(apb_slave_sequencer30)

  //simple30 assoc30 array to hold30 values
  logic [31:0] slave_mem30[int];

  apb_transfer30 req;
  apb_transfer30 util_transfer30;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port30.peek(util_transfer30);
      if((util_transfer30.direction30 == APB_READ30) && 
        (p_sequencer.cfg.check_address_range30(util_transfer30.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range30 Matching30 APB_READ30.  Responding30...", util_transfer30.addr), UVM_MEDIUM);
        if (slave_mem30.exists(util_transfer30.addr))
        `uvm_do_with(req, { req.direction30 == APB_READ30;
                            req.addr == util_transfer30.addr;
                            req.data == slave_mem30[util_transfer30.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction30 == APB_READ30;
                            req.addr == util_transfer30.addr;
                            req.data == mem_data30; } )
         mem_data30++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range30(util_transfer30.addr) == 1) begin
        slave_mem30[util_transfer30.addr] = util_transfer30.data;
        // DUMMY30 response with same information
        `uvm_do_with(req, { req.direction30 == APB_WRITE30;
                            req.addr == util_transfer30.addr;
                            req.data == util_transfer30.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq30

`endif // APB_SLAVE_SEQ_LIB_SV30
