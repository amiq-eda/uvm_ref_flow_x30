/*-------------------------------------------------------------------------
File28 name   : reg_to_ahb_adapter28.sv
Title28       : Register Operations28 to AHB28 Transactions28 Adapter Sequence
Project28     :
Created28     :
Description28 : UVM_REG - Adapter Sequence converts28 UVM register operations28
            : to AHB28 bus transactions
Notes28       : This28 example28 does not provide28 any random transfer28 delay
            : for the transaction.  This28 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright28 1999-2011 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

class reg_to_ahb_adapter28 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter28)

  function new(string name="reg_to_ahb_adapter28");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer28 transfer28;
    transfer28 = ahb_transfer28::type_id::create("transfer28");
    transfer28.address = rw.addr;
    transfer28.data = rw.data;
    transfer28.direction28 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer28);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer28 transfer28;
    if (!$cast(transfer28, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE28",
       "Provided bus_item is not of the correct28 type. Expecting28 ahb_transfer28")
       return;
    end
    rw.kind =  (transfer28.direction28 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer28.address;
    rw.data = transfer28.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter28
