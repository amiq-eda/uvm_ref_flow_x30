/*******************************************************************************
  FILE : apb_slave_seq_lib1.sv
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV1
`define APB_SLAVE_SEQ_LIB_SV1

//------------------------------------------------------------------------------
// SEQUENCE1: simple_response_seq1
//------------------------------------------------------------------------------

class simple_response_seq1 extends uvm_sequence #(apb_transfer1);

  function new(string name="simple_response_seq1");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq1)
  `uvm_declare_p_sequencer(apb_slave_sequencer1)

  apb_transfer1 req;
  apb_transfer1 util_transfer1;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port1.peek(util_transfer1);
      if((util_transfer1.direction1 == APB_READ1) && 
        (p_sequencer.cfg.check_address_range1(util_transfer1.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range1 Matching1 read.  Responding1...", util_transfer1.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction1 == APB_READ1; } )
      end
    end
  endtask : body

endclass : simple_response_seq1

//------------------------------------------------------------------------------
// SEQUENCE1: mem_response_seq1
//------------------------------------------------------------------------------
class mem_response_seq1 extends uvm_sequence #(apb_transfer1);

  function new(string name="mem_response_seq1");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data1;

  `uvm_object_utils(mem_response_seq1)
  `uvm_declare_p_sequencer(apb_slave_sequencer1)

  //simple1 assoc1 array to hold1 values
  logic [31:0] slave_mem1[int];

  apb_transfer1 req;
  apb_transfer1 util_transfer1;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port1.peek(util_transfer1);
      if((util_transfer1.direction1 == APB_READ1) && 
        (p_sequencer.cfg.check_address_range1(util_transfer1.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range1 Matching1 APB_READ1.  Responding1...", util_transfer1.addr), UVM_MEDIUM);
        if (slave_mem1.exists(util_transfer1.addr))
        `uvm_do_with(req, { req.direction1 == APB_READ1;
                            req.addr == util_transfer1.addr;
                            req.data == slave_mem1[util_transfer1.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction1 == APB_READ1;
                            req.addr == util_transfer1.addr;
                            req.data == mem_data1; } )
         mem_data1++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range1(util_transfer1.addr) == 1) begin
        slave_mem1[util_transfer1.addr] = util_transfer1.data;
        // DUMMY1 response with same information
        `uvm_do_with(req, { req.direction1 == APB_WRITE1;
                            req.addr == util_transfer1.addr;
                            req.data == util_transfer1.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq1

`endif // APB_SLAVE_SEQ_LIB_SV1
