// IVB27 checksum27: 2173772784
/*-----------------------------------------------------------------
File27 name     : ahb_transfer27.sv
Created27       : Wed27 May27 19 15:42:20 2010
Description27   :  This27 file declares27 the OVC27 transfer27. It is
              :  used by both master27 and slave27.
Notes27         :
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV27
`define AHB_TRANSFER_SV27

//------------------------------------------------------------------------------
//
// ahb27 transfer27 enums27, parameters27, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE27 = 0,
		HALFWORD27 = 1,
		WORD27 = 2,
		TWO_WORDS27 = 3,
		FOUR_WORDS27 = 4,
		EIGHT_WORDS27 = 5,
		SIXTEEN_WORDS27 = 6,
		K_BITS27 = 7
} ahb_transfer_size27;
typedef enum logic[1:0]  {
		IDLE27 = 0,
		BUSY27 = 1,
		NONSEQ27 = 2,
		SEQ = 3
} ahb_transfer_kind27;
typedef enum logic[1:0]  {
		OKAY27 = 0,
		ERROR27 = 1,
		RETRY27 = 2,
		SPLIT27 = 3
} ahb_response_kind27;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction27;
typedef enum logic[2:0]  {
		SINGLE27 = 0,
		INCR = 1,
		WRAP427 = 2,
		INCR427 = 3,
		WRAP827 = 4,
		INCR827 = 5,
		WRAP1627 = 6,
		INCR1627 = 7
} ahb_burst_kind27;
 
//------------------------------------------------------------------------------
//
// CLASS27: ahb_transfer27
//
//------------------------------------------------------------------------------

class ahb_transfer27 extends uvm_sequence_item;

  /***************************************************************************
   IVB27-NOTE27 : REQUIRED27 : transfer27 definitions27 : Item27 definitions27
   ---------------------------------------------------------------------------
   Adjust27 the transfer27 attribute27 names as required27 and add any 
   necessary27 attributes27.
   Note27 that if you change an attribute27 name, you must change it in all of your27
   OVC27 files.
   Make27 sure27 to edit27 the uvm_object_utils_begin to get various27 utilities27 (like27
   print and copy) for each attribute27 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH27-1:0] data;
  rand logic [`AHB_ADDR_WIDTH27-1:0] address;
  rand ahb_direction27 direction27 ;
  rand ahb_transfer_size27  hsize27;
  rand ahb_burst_kind27  burst;
  rand logic [3:0] prot27 ;
 
  `uvm_object_utils_begin(ahb_transfer27)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction27,direction27, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size27,hsize27, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind27,burst, UVM_ALL_ON)
    `uvm_field_int(prot27, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor27 - required27 syntax27 for UVM automation27 and utilities27
  function new (string name = "unnamed27-ahb_transfer27");
    super.new(name);
  endfunction : new

endclass : ahb_transfer27

`endif // AHB_TRANSFER_SV27

