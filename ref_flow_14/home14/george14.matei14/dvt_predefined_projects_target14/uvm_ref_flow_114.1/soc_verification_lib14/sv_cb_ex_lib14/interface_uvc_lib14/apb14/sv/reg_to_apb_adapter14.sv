/*-------------------------------------------------------------------------
File14 name   : reg_to_apb_adapter14.sv
Title14       : Register Operations14 to APB14 Transactions14 Adapter Sequence
Project14     :
Created14     :
Description14 : UVM_REG - Adapter Sequence converts14 UVM register operations14
            : to APB14 bus transactions
Notes14       : This14 example14 does not provide14 any random transfer14 delay
            : for the transaction.  This14 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright14 1999-2011 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

class reg_to_apb_adapter14 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter14)

  function new(string name="reg_to_apb_adapter14");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer14 transfer14;
    transfer14 = apb_transfer14::type_id::create("transfer14");
    transfer14.addr = rw.addr;
    transfer14.data = rw.data;
    transfer14.direction14 = (rw.kind == UVM_READ) ? APB_READ14 : APB_WRITE14;
    return (transfer14);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer14 transfer14;
    if (!$cast(transfer14, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE14",
       "Provided bus_item is not of the correct14 type. Expecting14 apb_transfer14")
       return;
    end
    rw.kind =  (transfer14.direction14 == APB_READ14) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer14.addr;
    rw.data = transfer14.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO14 NOT14 SET IT14 AT14 ALL14 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter14
