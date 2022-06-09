/*******************************************************************************
  FILE : apb_slave_seq_lib2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV2
`define APB_SLAVE_SEQ_LIB_SV2

//------------------------------------------------------------------------------
// SEQUENCE2: simple_response_seq2
//------------------------------------------------------------------------------

class simple_response_seq2 extends uvm_sequence #(apb_transfer2);

  function new(string name="simple_response_seq2");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq2)
  `uvm_declare_p_sequencer(apb_slave_sequencer2)

  apb_transfer2 req;
  apb_transfer2 util_transfer2;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port2.peek(util_transfer2);
      if((util_transfer2.direction2 == APB_READ2) && 
        (p_sequencer.cfg.check_address_range2(util_transfer2.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range2 Matching2 read.  Responding2...", util_transfer2.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction2 == APB_READ2; } )
      end
    end
  endtask : body

endclass : simple_response_seq2

//------------------------------------------------------------------------------
// SEQUENCE2: mem_response_seq2
//------------------------------------------------------------------------------
class mem_response_seq2 extends uvm_sequence #(apb_transfer2);

  function new(string name="mem_response_seq2");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data2;

  `uvm_object_utils(mem_response_seq2)
  `uvm_declare_p_sequencer(apb_slave_sequencer2)

  //simple2 assoc2 array to hold2 values
  logic [31:0] slave_mem2[int];

  apb_transfer2 req;
  apb_transfer2 util_transfer2;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port2.peek(util_transfer2);
      if((util_transfer2.direction2 == APB_READ2) && 
        (p_sequencer.cfg.check_address_range2(util_transfer2.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range2 Matching2 APB_READ2.  Responding2...", util_transfer2.addr), UVM_MEDIUM);
        if (slave_mem2.exists(util_transfer2.addr))
        `uvm_do_with(req, { req.direction2 == APB_READ2;
                            req.addr == util_transfer2.addr;
                            req.data == slave_mem2[util_transfer2.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction2 == APB_READ2;
                            req.addr == util_transfer2.addr;
                            req.data == mem_data2; } )
         mem_data2++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range2(util_transfer2.addr) == 1) begin
        slave_mem2[util_transfer2.addr] = util_transfer2.data;
        // DUMMY2 response with same information
        `uvm_do_with(req, { req.direction2 == APB_WRITE2;
                            req.addr == util_transfer2.addr;
                            req.data == util_transfer2.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq2

`endif // APB_SLAVE_SEQ_LIB_SV2
