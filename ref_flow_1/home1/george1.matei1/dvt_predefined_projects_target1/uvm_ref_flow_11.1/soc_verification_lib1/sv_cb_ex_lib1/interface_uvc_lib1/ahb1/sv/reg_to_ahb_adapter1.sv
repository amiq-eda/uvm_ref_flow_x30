/*-------------------------------------------------------------------------
File1 name   : reg_to_ahb_adapter1.sv
Title1       : Register Operations1 to AHB1 Transactions1 Adapter Sequence
Project1     :
Created1     :
Description1 : UVM_REG - Adapter Sequence converts1 UVM register operations1
            : to AHB1 bus transactions
Notes1       : This1 example1 does not provide1 any random transfer1 delay
            : for the transaction.  This1 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright1 1999-2011 Cadence1 Design1 Systems1, Inc1.
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

class reg_to_ahb_adapter1 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter1)

  function new(string name="reg_to_ahb_adapter1");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer1 transfer1;
    transfer1 = ahb_transfer1::type_id::create("transfer1");
    transfer1.address = rw.addr;
    transfer1.data = rw.data;
    transfer1.direction1 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer1);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer1 transfer1;
    if (!$cast(transfer1, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE1",
       "Provided bus_item is not of the correct1 type. Expecting1 ahb_transfer1")
       return;
    end
    rw.kind =  (transfer1.direction1 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer1.address;
    rw.data = transfer1.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter1
