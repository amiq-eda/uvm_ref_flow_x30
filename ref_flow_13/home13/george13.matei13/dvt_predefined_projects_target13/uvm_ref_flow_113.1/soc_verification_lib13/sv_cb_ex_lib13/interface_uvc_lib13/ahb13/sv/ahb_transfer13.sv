// IVB13 checksum13: 2173772784
/*-----------------------------------------------------------------
File13 name     : ahb_transfer13.sv
Created13       : Wed13 May13 19 15:42:20 2010
Description13   :  This13 file declares13 the OVC13 transfer13. It is
              :  used by both master13 and slave13.
Notes13         :
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV13
`define AHB_TRANSFER_SV13

//------------------------------------------------------------------------------
//
// ahb13 transfer13 enums13, parameters13, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE13 = 0,
		HALFWORD13 = 1,
		WORD13 = 2,
		TWO_WORDS13 = 3,
		FOUR_WORDS13 = 4,
		EIGHT_WORDS13 = 5,
		SIXTEEN_WORDS13 = 6,
		K_BITS13 = 7
} ahb_transfer_size13;
typedef enum logic[1:0]  {
		IDLE13 = 0,
		BUSY13 = 1,
		NONSEQ13 = 2,
		SEQ = 3
} ahb_transfer_kind13;
typedef enum logic[1:0]  {
		OKAY13 = 0,
		ERROR13 = 1,
		RETRY13 = 2,
		SPLIT13 = 3
} ahb_response_kind13;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction13;
typedef enum logic[2:0]  {
		SINGLE13 = 0,
		INCR = 1,
		WRAP413 = 2,
		INCR413 = 3,
		WRAP813 = 4,
		INCR813 = 5,
		WRAP1613 = 6,
		INCR1613 = 7
} ahb_burst_kind13;
 
//------------------------------------------------------------------------------
//
// CLASS13: ahb_transfer13
//
//------------------------------------------------------------------------------

class ahb_transfer13 extends uvm_sequence_item;

  /***************************************************************************
   IVB13-NOTE13 : REQUIRED13 : transfer13 definitions13 : Item13 definitions13
   ---------------------------------------------------------------------------
   Adjust13 the transfer13 attribute13 names as required13 and add any 
   necessary13 attributes13.
   Note13 that if you change an attribute13 name, you must change it in all of your13
   OVC13 files.
   Make13 sure13 to edit13 the uvm_object_utils_begin to get various13 utilities13 (like13
   print and copy) for each attribute13 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH13-1:0] data;
  rand logic [`AHB_ADDR_WIDTH13-1:0] address;
  rand ahb_direction13 direction13 ;
  rand ahb_transfer_size13  hsize13;
  rand ahb_burst_kind13  burst;
  rand logic [3:0] prot13 ;
 
  `uvm_object_utils_begin(ahb_transfer13)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction13,direction13, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size13,hsize13, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind13,burst, UVM_ALL_ON)
    `uvm_field_int(prot13, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new (string name = "unnamed13-ahb_transfer13");
    super.new(name);
  endfunction : new

endclass : ahb_transfer13

`endif // AHB_TRANSFER_SV13

