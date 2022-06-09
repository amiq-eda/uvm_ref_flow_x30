// IVB29 checksum29: 2173772784
/*-----------------------------------------------------------------
File29 name     : ahb_transfer29.sv
Created29       : Wed29 May29 19 15:42:20 2010
Description29   :  This29 file declares29 the OVC29 transfer29. It is
              :  used by both master29 and slave29.
Notes29         :
-----------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV29
`define AHB_TRANSFER_SV29

//------------------------------------------------------------------------------
//
// ahb29 transfer29 enums29, parameters29, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE29 = 0,
		HALFWORD29 = 1,
		WORD29 = 2,
		TWO_WORDS29 = 3,
		FOUR_WORDS29 = 4,
		EIGHT_WORDS29 = 5,
		SIXTEEN_WORDS29 = 6,
		K_BITS29 = 7
} ahb_transfer_size29;
typedef enum logic[1:0]  {
		IDLE29 = 0,
		BUSY29 = 1,
		NONSEQ29 = 2,
		SEQ = 3
} ahb_transfer_kind29;
typedef enum logic[1:0]  {
		OKAY29 = 0,
		ERROR29 = 1,
		RETRY29 = 2,
		SPLIT29 = 3
} ahb_response_kind29;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction29;
typedef enum logic[2:0]  {
		SINGLE29 = 0,
		INCR = 1,
		WRAP429 = 2,
		INCR429 = 3,
		WRAP829 = 4,
		INCR829 = 5,
		WRAP1629 = 6,
		INCR1629 = 7
} ahb_burst_kind29;
 
//------------------------------------------------------------------------------
//
// CLASS29: ahb_transfer29
//
//------------------------------------------------------------------------------

class ahb_transfer29 extends uvm_sequence_item;

  /***************************************************************************
   IVB29-NOTE29 : REQUIRED29 : transfer29 definitions29 : Item29 definitions29
   ---------------------------------------------------------------------------
   Adjust29 the transfer29 attribute29 names as required29 and add any 
   necessary29 attributes29.
   Note29 that if you change an attribute29 name, you must change it in all of your29
   OVC29 files.
   Make29 sure29 to edit29 the uvm_object_utils_begin to get various29 utilities29 (like29
   print and copy) for each attribute29 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH29-1:0] data;
  rand logic [`AHB_ADDR_WIDTH29-1:0] address;
  rand ahb_direction29 direction29 ;
  rand ahb_transfer_size29  hsize29;
  rand ahb_burst_kind29  burst;
  rand logic [3:0] prot29 ;
 
  `uvm_object_utils_begin(ahb_transfer29)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction29,direction29, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size29,hsize29, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind29,burst, UVM_ALL_ON)
    `uvm_field_int(prot29, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor29 - required29 syntax29 for UVM automation29 and utilities29
  function new (string name = "unnamed29-ahb_transfer29");
    super.new(name);
  endfunction : new

endclass : ahb_transfer29

`endif // AHB_TRANSFER_SV29

