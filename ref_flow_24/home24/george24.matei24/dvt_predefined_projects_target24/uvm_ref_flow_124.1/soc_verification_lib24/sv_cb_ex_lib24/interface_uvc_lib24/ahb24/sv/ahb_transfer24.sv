// IVB24 checksum24: 2173772784
/*-----------------------------------------------------------------
File24 name     : ahb_transfer24.sv
Created24       : Wed24 May24 19 15:42:20 2010
Description24   :  This24 file declares24 the OVC24 transfer24. It is
              :  used by both master24 and slave24.
Notes24         :
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
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


`ifndef AHB_TRANSFER_SV24
`define AHB_TRANSFER_SV24

//------------------------------------------------------------------------------
//
// ahb24 transfer24 enums24, parameters24, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE24 = 0,
		HALFWORD24 = 1,
		WORD24 = 2,
		TWO_WORDS24 = 3,
		FOUR_WORDS24 = 4,
		EIGHT_WORDS24 = 5,
		SIXTEEN_WORDS24 = 6,
		K_BITS24 = 7
} ahb_transfer_size24;
typedef enum logic[1:0]  {
		IDLE24 = 0,
		BUSY24 = 1,
		NONSEQ24 = 2,
		SEQ = 3
} ahb_transfer_kind24;
typedef enum logic[1:0]  {
		OKAY24 = 0,
		ERROR24 = 1,
		RETRY24 = 2,
		SPLIT24 = 3
} ahb_response_kind24;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction24;
typedef enum logic[2:0]  {
		SINGLE24 = 0,
		INCR = 1,
		WRAP424 = 2,
		INCR424 = 3,
		WRAP824 = 4,
		INCR824 = 5,
		WRAP1624 = 6,
		INCR1624 = 7
} ahb_burst_kind24;
 
//------------------------------------------------------------------------------
//
// CLASS24: ahb_transfer24
//
//------------------------------------------------------------------------------

class ahb_transfer24 extends uvm_sequence_item;

  /***************************************************************************
   IVB24-NOTE24 : REQUIRED24 : transfer24 definitions24 : Item24 definitions24
   ---------------------------------------------------------------------------
   Adjust24 the transfer24 attribute24 names as required24 and add any 
   necessary24 attributes24.
   Note24 that if you change an attribute24 name, you must change it in all of your24
   OVC24 files.
   Make24 sure24 to edit24 the uvm_object_utils_begin to get various24 utilities24 (like24
   print and copy) for each attribute24 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH24-1:0] data;
  rand logic [`AHB_ADDR_WIDTH24-1:0] address;
  rand ahb_direction24 direction24 ;
  rand ahb_transfer_size24  hsize24;
  rand ahb_burst_kind24  burst;
  rand logic [3:0] prot24 ;
 
  `uvm_object_utils_begin(ahb_transfer24)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction24,direction24, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size24,hsize24, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind24,burst, UVM_ALL_ON)
    `uvm_field_int(prot24, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor24 - required24 syntax24 for UVM automation24 and utilities24
  function new (string name = "unnamed24-ahb_transfer24");
    super.new(name);
  endfunction : new

endclass : ahb_transfer24

`endif // AHB_TRANSFER_SV24

