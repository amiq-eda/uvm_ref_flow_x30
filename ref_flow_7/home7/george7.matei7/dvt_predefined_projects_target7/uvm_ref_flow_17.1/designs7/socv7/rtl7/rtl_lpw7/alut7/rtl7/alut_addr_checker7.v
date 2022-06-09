//File7 name   : alut_addr_checker7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

// compiler7 directives7
`include "alut_defines7.v"


module alut_addr_checker7
(   
   // Inputs7
   pclk7,
   n_p_reset7,
   command,
   mac_addr7,
   d_addr7,
   s_addr7,
   s_port7,
   curr_time7,
   mem_read_data_add7,
   age_confirmed7,
   age_ok7,
   clear_reused7,

   //outputs7
   d_port7,
   add_check_active7,
   mem_addr_add7,
   mem_write_add7,
   mem_write_data_add7,
   lst_inv_addr_nrm7,
   lst_inv_port_nrm7,
   check_age7,
   last_accessed7,
   reused7
);



   input               pclk7;               // APB7 clock7                           
   input               n_p_reset7;          // Reset7                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr7;           // address of the switch7              
   input [47:0]        d_addr7;             // address of frame7 to be checked7     
   input [47:0]        s_addr7;             // address of frame7 to be stored7      
   input [1:0]         s_port7;             // source7 port of current frame7       
   input [31:0]        curr_time7;          // current time,for storing7 in mem    
   input [82:0]        mem_read_data_add7;  // read data from mem                 
   input               age_confirmed7;      // valid flag7 from age7 checker        
   input               age_ok7;             // result from age7 checker 
   input               clear_reused7;       // read/clear flag7 for reused7 signal7           

   output [4:0]        d_port7;             // calculated7 destination7 port for tx7 
   output              add_check_active7;   // bit 0 of status register           
   output [7:0]        mem_addr_add7;       // hash7 address for R/W7 to memory     
   output              mem_write_add7;      // R/W7 flag7 (write = high7)            
   output [82:0]       mem_write_data_add7; // write data for memory             
   output [47:0]       lst_inv_addr_nrm7;   // last invalidated7 addr normal7 op    
   output [1:0]        lst_inv_port_nrm7;   // last invalidated7 port normal7 op    
   output              check_age7;          // request flag7 for age7 check
   output [31:0]       last_accessed7;      // time field sent7 for age7 check
   output              reused7;             // indicates7 ALUT7 location7 overwritten7

   reg   [2:0]         add_chk_state7;      // current address checker state
   reg   [2:0]         nxt_add_chk_state7;  // current address checker state
   reg   [4:0]         d_port7;             // calculated7 destination7 port for tx7 
   reg   [3:0]         port_mem7;           // bitwise7 conversion7 of 2bit port
   reg   [7:0]         mem_addr_add7;       // hash7 address for R/W7 to memory
   reg                 mem_write_add7;      // R/W7 flag7 (write = high7)            
   reg                 reused7;             // indicates7 ALUT7 location7 overwritten7
   reg   [47:0]        lst_inv_addr_nrm7;   // last invalidated7 addr normal7 op    
   reg   [1:0]         lst_inv_port_nrm7;   // last invalidated7 port normal7 op    
   reg                 check_age7;          // request flag7 for age7 checker
   reg   [31:0]        last_accessed7;      // time field sent7 for age7 check


   wire   [7:0]        s_addr_hash7;        // hash7 of address for storing7
   wire   [7:0]        d_addr_hash7;        // hash7 of address for checking
   wire   [82:0]       mem_write_data_add7; // write data for memory  
   wire                add_check_active7;   // bit 0 of status register           


// Parameters7 for Address Checking7 FSM7 states7
   parameter idle7           = 3'b000;
   parameter mac_addr_chk7   = 3'b001;
   parameter read_dest_add7  = 3'b010;
   parameter valid_chk7      = 3'b011;
   parameter age_chk7        = 3'b100;
   parameter addr_chk7       = 3'b101;
   parameter read_src_add7   = 3'b110;
   parameter write_src7      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash7 conversion7 of source7 and destination7 addresses7
// -----------------------------------------------------------------------------
   assign s_addr_hash7 = s_addr7[7:0] ^ s_addr7[15:8] ^ s_addr7[23:16] ^
                        s_addr7[31:24] ^ s_addr7[39:32] ^ s_addr7[47:40];

   assign d_addr_hash7 = d_addr7[7:0] ^ d_addr7[15:8] ^ d_addr7[23:16] ^
                        d_addr7[31:24] ^ d_addr7[39:32] ^ d_addr7[47:40];



// -----------------------------------------------------------------------------
//   State7 Machine7 For7 handling7 the destination7 address checking process and
//   and storing7 of new source7 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state7 or age_confirmed7 or age_ok7)
   begin
      case (add_chk_state7)
      
      idle7:
         if (command == 2'b01)
            nxt_add_chk_state7 = mac_addr_chk7;
         else
            nxt_add_chk_state7 = idle7;

      mac_addr_chk7:   // check if destination7 address match MAC7 switch7 address
         if (d_addr7 == mac_addr7)
            nxt_add_chk_state7 = idle7;  // return dest7 port as 5'b1_0000
         else
            nxt_add_chk_state7 = read_dest_add7;

      read_dest_add7:       // read data from memory using hash7 of destination7 address
            nxt_add_chk_state7 = valid_chk7;

      valid_chk7:      // check if read data had7 valid bit set
         nxt_add_chk_state7 = age_chk7;

      age_chk7:        // request age7 checker to check if still in date7
         if (age_confirmed7)
            nxt_add_chk_state7 = addr_chk7;
         else
            nxt_add_chk_state7 = age_chk7; 

      addr_chk7:       // perform7 compare between dest7 and read addresses7
            nxt_add_chk_state7 = read_src_add7; // return read port from ALUT7 mem

      read_src_add7:   // read from memory location7 about7 to be overwritten7
            nxt_add_chk_state7 = write_src7; 

      write_src7:      // write new source7 data (addr and port) to memory
            nxt_add_chk_state7 = idle7; 

      default:
            nxt_add_chk_state7 = idle7;
      endcase
   end


// destination7 check FSM7 current state
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      add_chk_state7 <= idle7;
   else
      add_chk_state7 <= nxt_add_chk_state7;
   end



// -----------------------------------------------------------------------------
//   Generate7 returned value of port for sending7 new frame7 to
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      d_port7 <= 5'b0_1111;
   else if ((add_chk_state7 == mac_addr_chk7) & (d_addr7 == mac_addr7))
      d_port7 <= 5'b1_0000;
   else if (((add_chk_state7 == valid_chk7) & ~mem_read_data_add7[82]) |
            ((add_chk_state7 == age_chk7) & ~(age_confirmed7 & age_ok7)) |
            ((add_chk_state7 == addr_chk7) & (d_addr7 != mem_read_data_add7[47:0])))
      d_port7 <= 5'b0_1111 & ~( 1 << s_port7 );
   else if ((add_chk_state7 == addr_chk7) & (d_addr7 == mem_read_data_add7[47:0]))
      d_port7 <= {1'b0, port_mem7} & ~( 1 << s_port7 );
   else
      d_port7 <= d_port7;
   end


// -----------------------------------------------------------------------------
//   convert read port source7 value from 2bits to bitwise7 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      port_mem7 <= 4'b1111;
   else begin
      case (mem_read_data_add7[49:48])
         2'b00: port_mem7 <= 4'b0001;
         2'b01: port_mem7 <= 4'b0010;
         2'b10: port_mem7 <= 4'b0100;
         2'b11: port_mem7 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded7 off7 add_chk_state7
// -----------------------------------------------------------------------------
assign add_check_active7 = (add_chk_state7 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate7 memory addressing7 signals7.
//   The check address command will be taken7 as the indication7 from SW7 that the 
//   source7 fields (address and port) can be written7 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7) 
   begin
       mem_write_add7 <= 1'b0;
       mem_addr_add7  <= 8'd0;
   end
   else if (add_chk_state7 == read_dest_add7)
   begin
       mem_write_add7 <= 1'b0;
       mem_addr_add7  <= d_addr_hash7;
   end
// Need7 to set address two7 cycles7 before check
   else if ( (add_chk_state7 == age_chk7) && age_confirmed7 )
   begin
       mem_write_add7 <= 1'b0;
       mem_addr_add7  <= s_addr_hash7;
   end
   else if (add_chk_state7 == write_src7)
   begin
       mem_write_add7 <= 1'b1;
       mem_addr_add7  <= s_addr_hash7;
   end
   else
   begin
       mem_write_add7 <= 1'b0;
       mem_addr_add7  <= d_addr_hash7;
   end
   end


// -----------------------------------------------------------------------------
//   Generate7 databus7 for writing to memory
//   Data written7 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add7 = {1'b1, curr_time7, s_port7, s_addr7};



// -----------------------------------------------------------------------------
//   Evaluate7 read back data that is about7 to be overwritten7 with new source7 
//   address and port values. Decide7 whether7 the reused7 flag7 must be set and
//   last_inval7 address and port values updated.
//   reused7 needs7 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7) 
   begin
      reused7 <= 1'b0;
      lst_inv_addr_nrm7 <= 48'd0;
      lst_inv_port_nrm7 <= 2'd0;
   end
   else if ((add_chk_state7 == read_src_add7) & mem_read_data_add7[82] &
            (s_addr7 != mem_read_data_add7[47:0]))
   begin
      reused7 <= 1'b1;
      lst_inv_addr_nrm7 <= mem_read_data_add7[47:0];
      lst_inv_port_nrm7 <= mem_read_data_add7[49:48];
   end
   else if (clear_reused7)
   begin
      reused7 <= 1'b0;
      lst_inv_addr_nrm7 <= lst_inv_addr_nrm7;
      lst_inv_port_nrm7 <= lst_inv_addr_nrm7;
   end
   else 
   begin
      reused7 <= reused7;
      lst_inv_addr_nrm7 <= lst_inv_addr_nrm7;
      lst_inv_port_nrm7 <= lst_inv_addr_nrm7;
   end
   end


// -----------------------------------------------------------------------------
//   Generate7 signals7 for age7 checker to perform7 in-date7 check
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7) 
   begin
      check_age7 <= 1'b0;  
      last_accessed7 <= 32'd0;
   end
   else if (check_age7)
   begin
      check_age7 <= 1'b0;  
      last_accessed7 <= mem_read_data_add7[81:50];
   end
   else if (add_chk_state7 == age_chk7)
   begin
      check_age7 <= 1'b1;  
      last_accessed7 <= mem_read_data_add7[81:50];
   end
   else 
   begin
      check_age7 <= 1'b0;  
      last_accessed7 <= 32'd0;
   end
   end


`ifdef ABV_ON7

// psl7 default clock7 = (posedge pclk7);

// ASSERTION7 CHECKS7
/* Commented7 out as also checking in toplevel7
// it should never be possible7 for the destination7 port to indicate7 the MAC7
// switch7 address and one of the other 4 Ethernets7
// psl7 assert_valid_dest_port7 : assert never (d_port7[4] & |{d_port7[3:0]});


// COVER7 SANITY7 CHECKS7
// check all values of destination7 port can be returned.
// psl7 cover_d_port_07 : cover { d_port7 == 5'b0_0001 };
// psl7 cover_d_port_17 : cover { d_port7 == 5'b0_0010 };
// psl7 cover_d_port_27 : cover { d_port7 == 5'b0_0100 };
// psl7 cover_d_port_37 : cover { d_port7 == 5'b0_1000 };
// psl7 cover_d_port_47 : cover { d_port7 == 5'b1_0000 };
// psl7 cover_d_port_all7 : cover { d_port7 == 5'b0_1111 };
*/
`endif


endmodule 









