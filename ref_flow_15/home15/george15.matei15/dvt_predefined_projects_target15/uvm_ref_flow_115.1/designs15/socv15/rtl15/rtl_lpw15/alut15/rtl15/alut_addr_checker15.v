//File15 name   : alut_addr_checker15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

// compiler15 directives15
`include "alut_defines15.v"


module alut_addr_checker15
(   
   // Inputs15
   pclk15,
   n_p_reset15,
   command,
   mac_addr15,
   d_addr15,
   s_addr15,
   s_port15,
   curr_time15,
   mem_read_data_add15,
   age_confirmed15,
   age_ok15,
   clear_reused15,

   //outputs15
   d_port15,
   add_check_active15,
   mem_addr_add15,
   mem_write_add15,
   mem_write_data_add15,
   lst_inv_addr_nrm15,
   lst_inv_port_nrm15,
   check_age15,
   last_accessed15,
   reused15
);



   input               pclk15;               // APB15 clock15                           
   input               n_p_reset15;          // Reset15                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr15;           // address of the switch15              
   input [47:0]        d_addr15;             // address of frame15 to be checked15     
   input [47:0]        s_addr15;             // address of frame15 to be stored15      
   input [1:0]         s_port15;             // source15 port of current frame15       
   input [31:0]        curr_time15;          // current time,for storing15 in mem    
   input [82:0]        mem_read_data_add15;  // read data from mem                 
   input               age_confirmed15;      // valid flag15 from age15 checker        
   input               age_ok15;             // result from age15 checker 
   input               clear_reused15;       // read/clear flag15 for reused15 signal15           

   output [4:0]        d_port15;             // calculated15 destination15 port for tx15 
   output              add_check_active15;   // bit 0 of status register           
   output [7:0]        mem_addr_add15;       // hash15 address for R/W15 to memory     
   output              mem_write_add15;      // R/W15 flag15 (write = high15)            
   output [82:0]       mem_write_data_add15; // write data for memory             
   output [47:0]       lst_inv_addr_nrm15;   // last invalidated15 addr normal15 op    
   output [1:0]        lst_inv_port_nrm15;   // last invalidated15 port normal15 op    
   output              check_age15;          // request flag15 for age15 check
   output [31:0]       last_accessed15;      // time field sent15 for age15 check
   output              reused15;             // indicates15 ALUT15 location15 overwritten15

   reg   [2:0]         add_chk_state15;      // current address checker state
   reg   [2:0]         nxt_add_chk_state15;  // current address checker state
   reg   [4:0]         d_port15;             // calculated15 destination15 port for tx15 
   reg   [3:0]         port_mem15;           // bitwise15 conversion15 of 2bit port
   reg   [7:0]         mem_addr_add15;       // hash15 address for R/W15 to memory
   reg                 mem_write_add15;      // R/W15 flag15 (write = high15)            
   reg                 reused15;             // indicates15 ALUT15 location15 overwritten15
   reg   [47:0]        lst_inv_addr_nrm15;   // last invalidated15 addr normal15 op    
   reg   [1:0]         lst_inv_port_nrm15;   // last invalidated15 port normal15 op    
   reg                 check_age15;          // request flag15 for age15 checker
   reg   [31:0]        last_accessed15;      // time field sent15 for age15 check


   wire   [7:0]        s_addr_hash15;        // hash15 of address for storing15
   wire   [7:0]        d_addr_hash15;        // hash15 of address for checking
   wire   [82:0]       mem_write_data_add15; // write data for memory  
   wire                add_check_active15;   // bit 0 of status register           


// Parameters15 for Address Checking15 FSM15 states15
   parameter idle15           = 3'b000;
   parameter mac_addr_chk15   = 3'b001;
   parameter read_dest_add15  = 3'b010;
   parameter valid_chk15      = 3'b011;
   parameter age_chk15        = 3'b100;
   parameter addr_chk15       = 3'b101;
   parameter read_src_add15   = 3'b110;
   parameter write_src15      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash15 conversion15 of source15 and destination15 addresses15
// -----------------------------------------------------------------------------
   assign s_addr_hash15 = s_addr15[7:0] ^ s_addr15[15:8] ^ s_addr15[23:16] ^
                        s_addr15[31:24] ^ s_addr15[39:32] ^ s_addr15[47:40];

   assign d_addr_hash15 = d_addr15[7:0] ^ d_addr15[15:8] ^ d_addr15[23:16] ^
                        d_addr15[31:24] ^ d_addr15[39:32] ^ d_addr15[47:40];



// -----------------------------------------------------------------------------
//   State15 Machine15 For15 handling15 the destination15 address checking process and
//   and storing15 of new source15 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state15 or age_confirmed15 or age_ok15)
   begin
      case (add_chk_state15)
      
      idle15:
         if (command == 2'b01)
            nxt_add_chk_state15 = mac_addr_chk15;
         else
            nxt_add_chk_state15 = idle15;

      mac_addr_chk15:   // check if destination15 address match MAC15 switch15 address
         if (d_addr15 == mac_addr15)
            nxt_add_chk_state15 = idle15;  // return dest15 port as 5'b1_0000
         else
            nxt_add_chk_state15 = read_dest_add15;

      read_dest_add15:       // read data from memory using hash15 of destination15 address
            nxt_add_chk_state15 = valid_chk15;

      valid_chk15:      // check if read data had15 valid bit set
         nxt_add_chk_state15 = age_chk15;

      age_chk15:        // request age15 checker to check if still in date15
         if (age_confirmed15)
            nxt_add_chk_state15 = addr_chk15;
         else
            nxt_add_chk_state15 = age_chk15; 

      addr_chk15:       // perform15 compare between dest15 and read addresses15
            nxt_add_chk_state15 = read_src_add15; // return read port from ALUT15 mem

      read_src_add15:   // read from memory location15 about15 to be overwritten15
            nxt_add_chk_state15 = write_src15; 

      write_src15:      // write new source15 data (addr and port) to memory
            nxt_add_chk_state15 = idle15; 

      default:
            nxt_add_chk_state15 = idle15;
      endcase
   end


// destination15 check FSM15 current state
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      add_chk_state15 <= idle15;
   else
      add_chk_state15 <= nxt_add_chk_state15;
   end



// -----------------------------------------------------------------------------
//   Generate15 returned value of port for sending15 new frame15 to
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      d_port15 <= 5'b0_1111;
   else if ((add_chk_state15 == mac_addr_chk15) & (d_addr15 == mac_addr15))
      d_port15 <= 5'b1_0000;
   else if (((add_chk_state15 == valid_chk15) & ~mem_read_data_add15[82]) |
            ((add_chk_state15 == age_chk15) & ~(age_confirmed15 & age_ok15)) |
            ((add_chk_state15 == addr_chk15) & (d_addr15 != mem_read_data_add15[47:0])))
      d_port15 <= 5'b0_1111 & ~( 1 << s_port15 );
   else if ((add_chk_state15 == addr_chk15) & (d_addr15 == mem_read_data_add15[47:0]))
      d_port15 <= {1'b0, port_mem15} & ~( 1 << s_port15 );
   else
      d_port15 <= d_port15;
   end


// -----------------------------------------------------------------------------
//   convert read port source15 value from 2bits to bitwise15 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      port_mem15 <= 4'b1111;
   else begin
      case (mem_read_data_add15[49:48])
         2'b00: port_mem15 <= 4'b0001;
         2'b01: port_mem15 <= 4'b0010;
         2'b10: port_mem15 <= 4'b0100;
         2'b11: port_mem15 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded15 off15 add_chk_state15
// -----------------------------------------------------------------------------
assign add_check_active15 = (add_chk_state15 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate15 memory addressing15 signals15.
//   The check address command will be taken15 as the indication15 from SW15 that the 
//   source15 fields (address and port) can be written15 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15) 
   begin
       mem_write_add15 <= 1'b0;
       mem_addr_add15  <= 8'd0;
   end
   else if (add_chk_state15 == read_dest_add15)
   begin
       mem_write_add15 <= 1'b0;
       mem_addr_add15  <= d_addr_hash15;
   end
// Need15 to set address two15 cycles15 before check
   else if ( (add_chk_state15 == age_chk15) && age_confirmed15 )
   begin
       mem_write_add15 <= 1'b0;
       mem_addr_add15  <= s_addr_hash15;
   end
   else if (add_chk_state15 == write_src15)
   begin
       mem_write_add15 <= 1'b1;
       mem_addr_add15  <= s_addr_hash15;
   end
   else
   begin
       mem_write_add15 <= 1'b0;
       mem_addr_add15  <= d_addr_hash15;
   end
   end


// -----------------------------------------------------------------------------
//   Generate15 databus15 for writing to memory
//   Data written15 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add15 = {1'b1, curr_time15, s_port15, s_addr15};



// -----------------------------------------------------------------------------
//   Evaluate15 read back data that is about15 to be overwritten15 with new source15 
//   address and port values. Decide15 whether15 the reused15 flag15 must be set and
//   last_inval15 address and port values updated.
//   reused15 needs15 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15) 
   begin
      reused15 <= 1'b0;
      lst_inv_addr_nrm15 <= 48'd0;
      lst_inv_port_nrm15 <= 2'd0;
   end
   else if ((add_chk_state15 == read_src_add15) & mem_read_data_add15[82] &
            (s_addr15 != mem_read_data_add15[47:0]))
   begin
      reused15 <= 1'b1;
      lst_inv_addr_nrm15 <= mem_read_data_add15[47:0];
      lst_inv_port_nrm15 <= mem_read_data_add15[49:48];
   end
   else if (clear_reused15)
   begin
      reused15 <= 1'b0;
      lst_inv_addr_nrm15 <= lst_inv_addr_nrm15;
      lst_inv_port_nrm15 <= lst_inv_addr_nrm15;
   end
   else 
   begin
      reused15 <= reused15;
      lst_inv_addr_nrm15 <= lst_inv_addr_nrm15;
      lst_inv_port_nrm15 <= lst_inv_addr_nrm15;
   end
   end


// -----------------------------------------------------------------------------
//   Generate15 signals15 for age15 checker to perform15 in-date15 check
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15) 
   begin
      check_age15 <= 1'b0;  
      last_accessed15 <= 32'd0;
   end
   else if (check_age15)
   begin
      check_age15 <= 1'b0;  
      last_accessed15 <= mem_read_data_add15[81:50];
   end
   else if (add_chk_state15 == age_chk15)
   begin
      check_age15 <= 1'b1;  
      last_accessed15 <= mem_read_data_add15[81:50];
   end
   else 
   begin
      check_age15 <= 1'b0;  
      last_accessed15 <= 32'd0;
   end
   end


`ifdef ABV_ON15

// psl15 default clock15 = (posedge pclk15);

// ASSERTION15 CHECKS15
/* Commented15 out as also checking in toplevel15
// it should never be possible15 for the destination15 port to indicate15 the MAC15
// switch15 address and one of the other 4 Ethernets15
// psl15 assert_valid_dest_port15 : assert never (d_port15[4] & |{d_port15[3:0]});


// COVER15 SANITY15 CHECKS15
// check all values of destination15 port can be returned.
// psl15 cover_d_port_015 : cover { d_port15 == 5'b0_0001 };
// psl15 cover_d_port_115 : cover { d_port15 == 5'b0_0010 };
// psl15 cover_d_port_215 : cover { d_port15 == 5'b0_0100 };
// psl15 cover_d_port_315 : cover { d_port15 == 5'b0_1000 };
// psl15 cover_d_port_415 : cover { d_port15 == 5'b1_0000 };
// psl15 cover_d_port_all15 : cover { d_port15 == 5'b0_1111 };
*/
`endif


endmodule 









