/*-------------------------------------------------------------------------
File25 name   : reg_to_ahb_adapter25.sv
Title25       : Register Operations25 to AHB25 Transactions25 Adapter Sequence
Project25     :
Created25     :
Description25 : UVM_REG - Adapter Sequence converts25 UVM register operations25
            : to AHB25 bus transactions
Notes25       : This25 example25 does not provide25 any random transfer25 delay
            : for the transaction.  This25 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright25 1999-2011 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

class reg_to_ahb_adapter25 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter25)

  function new(string name="reg_to_ahb_adapter25");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer25 transfer25;
    transfer25 = ahb_transfer25::type_id::create("transfer25");
    transfer25.address = rw.addr;
    transfer25.data = rw.data;
    transfer25.direction25 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer25);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer25 transfer25;
    if (!$cast(transfer25, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE25",
       "Provided bus_item is not of the correct25 type. Expecting25 ahb_transfer25")
       return;
    end
    rw.kind =  (transfer25.direction25 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer25.address;
    rw.data = transfer25.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter25
