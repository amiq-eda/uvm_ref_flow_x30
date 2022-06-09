/*-------------------------------------------------------------------------
File24 name   : reg_to_ahb_adapter24.sv
Title24       : Register Operations24 to AHB24 Transactions24 Adapter Sequence
Project24     :
Created24     :
Description24 : UVM_REG - Adapter Sequence converts24 UVM register operations24
            : to AHB24 bus transactions
Notes24       : This24 example24 does not provide24 any random transfer24 delay
            : for the transaction.  This24 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright24 1999-2011 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

class reg_to_ahb_adapter24 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter24)

  function new(string name="reg_to_ahb_adapter24");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer24 transfer24;
    transfer24 = ahb_transfer24::type_id::create("transfer24");
    transfer24.address = rw.addr;
    transfer24.data = rw.data;
    transfer24.direction24 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer24);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer24 transfer24;
    if (!$cast(transfer24, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE24",
       "Provided bus_item is not of the correct24 type. Expecting24 ahb_transfer24")
       return;
    end
    rw.kind =  (transfer24.direction24 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer24.address;
    rw.data = transfer24.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter24
