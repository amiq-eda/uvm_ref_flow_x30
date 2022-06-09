// IVB6 checksum6: 2173772784
/*-----------------------------------------------------------------
File6 name     : ahb_transfer6.sv
Created6       : Wed6 May6 19 15:42:20 2010
Description6   :  This6 file declares6 the OVC6 transfer6. It is
              :  used by both master6 and slave6.
Notes6         :
-----------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV6
`define AHB_TRANSFER_SV6

//------------------------------------------------------------------------------
//
// ahb6 transfer6 enums6, parameters6, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE6 = 0,
		HALFWORD6 = 1,
		WORD6 = 2,
		TWO_WORDS6 = 3,
		FOUR_WORDS6 = 4,
		EIGHT_WORDS6 = 5,
		SIXTEEN_WORDS6 = 6,
		K_BITS6 = 7
} ahb_transfer_size6;
typedef enum logic[1:0]  {
		IDLE6 = 0,
		BUSY6 = 1,
		NONSEQ6 = 2,
		SEQ = 3
} ahb_transfer_kind6;
typedef enum logic[1:0]  {
		OKAY6 = 0,
		ERROR6 = 1,
		RETRY6 = 2,
		SPLIT6 = 3
} ahb_response_kind6;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction6;
typedef enum logic[2:0]  {
		SINGLE6 = 0,
		INCR = 1,
		WRAP46 = 2,
		INCR46 = 3,
		WRAP86 = 4,
		INCR86 = 5,
		WRAP166 = 6,
		INCR166 = 7
} ahb_burst_kind6;
 
//------------------------------------------------------------------------------
//
// CLASS6: ahb_transfer6
//
//------------------------------------------------------------------------------

class ahb_transfer6 extends uvm_sequence_item;

  /***************************************************************************
   IVB6-NOTE6 : REQUIRED6 : transfer6 definitions6 : Item6 definitions6
   ---------------------------------------------------------------------------
   Adjust6 the transfer6 attribute6 names as required6 and add any 
   necessary6 attributes6.
   Note6 that if you change an attribute6 name, you must change it in all of your6
   OVC6 files.
   Make6 sure6 to edit6 the uvm_object_utils_begin to get various6 utilities6 (like6
   print and copy) for each attribute6 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH6-1:0] data;
  rand logic [`AHB_ADDR_WIDTH6-1:0] address;
  rand ahb_direction6 direction6 ;
  rand ahb_transfer_size6  hsize6;
  rand ahb_burst_kind6  burst;
  rand logic [3:0] prot6 ;
 
  `uvm_object_utils_begin(ahb_transfer6)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction6,direction6, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size6,hsize6, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind6,burst, UVM_ALL_ON)
    `uvm_field_int(prot6, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor6 - required6 syntax6 for UVM automation6 and utilities6
  function new (string name = "unnamed6-ahb_transfer6");
    super.new(name);
  endfunction : new

endclass : ahb_transfer6

`endif // AHB_TRANSFER_SV6

