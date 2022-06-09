//File4 name   : alut_addr_checker4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

// compiler4 directives4
`include "alut_defines4.v"


module alut_addr_checker4
(   
   // Inputs4
   pclk4,
   n_p_reset4,
   command,
   mac_addr4,
   d_addr4,
   s_addr4,
   s_port4,
   curr_time4,
   mem_read_data_add4,
   age_confirmed4,
   age_ok4,
   clear_reused4,

   //outputs4
   d_port4,
   add_check_active4,
   mem_addr_add4,
   mem_write_add4,
   mem_write_data_add4,
   lst_inv_addr_nrm4,
   lst_inv_port_nrm4,
   check_age4,
   last_accessed4,
   reused4
);



   input               pclk4;               // APB4 clock4                           
   input               n_p_reset4;          // Reset4                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr4;           // address of the switch4              
   input [47:0]        d_addr4;             // address of frame4 to be checked4     
   input [47:0]        s_addr4;             // address of frame4 to be stored4      
   input [1:0]         s_port4;             // source4 port of current frame4       
   input [31:0]        curr_time4;          // current time,for storing4 in mem    
   input [82:0]        mem_read_data_add4;  // read data from mem                 
   input               age_confirmed4;      // valid flag4 from age4 checker        
   input               age_ok4;             // result from age4 checker 
   input               clear_reused4;       // read/clear flag4 for reused4 signal4           

   output [4:0]        d_port4;             // calculated4 destination4 port for tx4 
   output              add_check_active4;   // bit 0 of status register           
   output [7:0]        mem_addr_add4;       // hash4 address for R/W4 to memory     
   output              mem_write_add4;      // R/W4 flag4 (write = high4)            
   output [82:0]       mem_write_data_add4; // write data for memory             
   output [47:0]       lst_inv_addr_nrm4;   // last invalidated4 addr normal4 op    
   output [1:0]        lst_inv_port_nrm4;   // last invalidated4 port normal4 op    
   output              check_age4;          // request flag4 for age4 check
   output [31:0]       last_accessed4;      // time field sent4 for age4 check
   output              reused4;             // indicates4 ALUT4 location4 overwritten4

   reg   [2:0]         add_chk_state4;      // current address checker state
   reg   [2:0]         nxt_add_chk_state4;  // current address checker state
   reg   [4:0]         d_port4;             // calculated4 destination4 port for tx4 
   reg   [3:0]         port_mem4;           // bitwise4 conversion4 of 2bit port
   reg   [7:0]         mem_addr_add4;       // hash4 address for R/W4 to memory
   reg                 mem_write_add4;      // R/W4 flag4 (write = high4)            
   reg                 reused4;             // indicates4 ALUT4 location4 overwritten4
   reg   [47:0]        lst_inv_addr_nrm4;   // last invalidated4 addr normal4 op    
   reg   [1:0]         lst_inv_port_nrm4;   // last invalidated4 port normal4 op    
   reg                 check_age4;          // request flag4 for age4 checker
   reg   [31:0]        last_accessed4;      // time field sent4 for age4 check


   wire   [7:0]        s_addr_hash4;        // hash4 of address for storing4
   wire   [7:0]        d_addr_hash4;        // hash4 of address for checking
   wire   [82:0]       mem_write_data_add4; // write data for memory  
   wire                add_check_active4;   // bit 0 of status register           


// Parameters4 for Address Checking4 FSM4 states4
   parameter idle4           = 3'b000;
   parameter mac_addr_chk4   = 3'b001;
   parameter read_dest_add4  = 3'b010;
   parameter valid_chk4      = 3'b011;
   parameter age_chk4        = 3'b100;
   parameter addr_chk4       = 3'b101;
   parameter read_src_add4   = 3'b110;
   parameter write_src4      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash4 conversion4 of source4 and destination4 addresses4
// -----------------------------------------------------------------------------
   assign s_addr_hash4 = s_addr4[7:0] ^ s_addr4[15:8] ^ s_addr4[23:16] ^
                        s_addr4[31:24] ^ s_addr4[39:32] ^ s_addr4[47:40];

   assign d_addr_hash4 = d_addr4[7:0] ^ d_addr4[15:8] ^ d_addr4[23:16] ^
                        d_addr4[31:24] ^ d_addr4[39:32] ^ d_addr4[47:40];



// -----------------------------------------------------------------------------
//   State4 Machine4 For4 handling4 the destination4 address checking process and
//   and storing4 of new source4 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state4 or age_confirmed4 or age_ok4)
   begin
      case (add_chk_state4)
      
      idle4:
         if (command == 2'b01)
            nxt_add_chk_state4 = mac_addr_chk4;
         else
            nxt_add_chk_state4 = idle4;

      mac_addr_chk4:   // check if destination4 address match MAC4 switch4 address
         if (d_addr4 == mac_addr4)
            nxt_add_chk_state4 = idle4;  // return dest4 port as 5'b1_0000
         else
            nxt_add_chk_state4 = read_dest_add4;

      read_dest_add4:       // read data from memory using hash4 of destination4 address
            nxt_add_chk_state4 = valid_chk4;

      valid_chk4:      // check if read data had4 valid bit set
         nxt_add_chk_state4 = age_chk4;

      age_chk4:        // request age4 checker to check if still in date4
         if (age_confirmed4)
            nxt_add_chk_state4 = addr_chk4;
         else
            nxt_add_chk_state4 = age_chk4; 

      addr_chk4:       // perform4 compare between dest4 and read addresses4
            nxt_add_chk_state4 = read_src_add4; // return read port from ALUT4 mem

      read_src_add4:   // read from memory location4 about4 to be overwritten4
            nxt_add_chk_state4 = write_src4; 

      write_src4:      // write new source4 data (addr and port) to memory
            nxt_add_chk_state4 = idle4; 

      default:
            nxt_add_chk_state4 = idle4;
      endcase
   end


// destination4 check FSM4 current state
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      add_chk_state4 <= idle4;
   else
      add_chk_state4 <= nxt_add_chk_state4;
   end



// -----------------------------------------------------------------------------
//   Generate4 returned value of port for sending4 new frame4 to
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      d_port4 <= 5'b0_1111;
   else if ((add_chk_state4 == mac_addr_chk4) & (d_addr4 == mac_addr4))
      d_port4 <= 5'b1_0000;
   else if (((add_chk_state4 == valid_chk4) & ~mem_read_data_add4[82]) |
            ((add_chk_state4 == age_chk4) & ~(age_confirmed4 & age_ok4)) |
            ((add_chk_state4 == addr_chk4) & (d_addr4 != mem_read_data_add4[47:0])))
      d_port4 <= 5'b0_1111 & ~( 1 << s_port4 );
   else if ((add_chk_state4 == addr_chk4) & (d_addr4 == mem_read_data_add4[47:0]))
      d_port4 <= {1'b0, port_mem4} & ~( 1 << s_port4 );
   else
      d_port4 <= d_port4;
   end


// -----------------------------------------------------------------------------
//   convert read port source4 value from 2bits to bitwise4 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      port_mem4 <= 4'b1111;
   else begin
      case (mem_read_data_add4[49:48])
         2'b00: port_mem4 <= 4'b0001;
         2'b01: port_mem4 <= 4'b0010;
         2'b10: port_mem4 <= 4'b0100;
         2'b11: port_mem4 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded4 off4 add_chk_state4
// -----------------------------------------------------------------------------
assign add_check_active4 = (add_chk_state4 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate4 memory addressing4 signals4.
//   The check address command will be taken4 as the indication4 from SW4 that the 
//   source4 fields (address and port) can be written4 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4) 
   begin
       mem_write_add4 <= 1'b0;
       mem_addr_add4  <= 8'd0;
   end
   else if (add_chk_state4 == read_dest_add4)
   begin
       mem_write_add4 <= 1'b0;
       mem_addr_add4  <= d_addr_hash4;
   end
// Need4 to set address two4 cycles4 before check
   else if ( (add_chk_state4 == age_chk4) && age_confirmed4 )
   begin
       mem_write_add4 <= 1'b0;
       mem_addr_add4  <= s_addr_hash4;
   end
   else if (add_chk_state4 == write_src4)
   begin
       mem_write_add4 <= 1'b1;
       mem_addr_add4  <= s_addr_hash4;
   end
   else
   begin
       mem_write_add4 <= 1'b0;
       mem_addr_add4  <= d_addr_hash4;
   end
   end


// -----------------------------------------------------------------------------
//   Generate4 databus4 for writing to memory
//   Data written4 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add4 = {1'b1, curr_time4, s_port4, s_addr4};



// -----------------------------------------------------------------------------
//   Evaluate4 read back data that is about4 to be overwritten4 with new source4 
//   address and port values. Decide4 whether4 the reused4 flag4 must be set and
//   last_inval4 address and port values updated.
//   reused4 needs4 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4) 
   begin
      reused4 <= 1'b0;
      lst_inv_addr_nrm4 <= 48'd0;
      lst_inv_port_nrm4 <= 2'd0;
   end
   else if ((add_chk_state4 == read_src_add4) & mem_read_data_add4[82] &
            (s_addr4 != mem_read_data_add4[47:0]))
   begin
      reused4 <= 1'b1;
      lst_inv_addr_nrm4 <= mem_read_data_add4[47:0];
      lst_inv_port_nrm4 <= mem_read_data_add4[49:48];
   end
   else if (clear_reused4)
   begin
      reused4 <= 1'b0;
      lst_inv_addr_nrm4 <= lst_inv_addr_nrm4;
      lst_inv_port_nrm4 <= lst_inv_addr_nrm4;
   end
   else 
   begin
      reused4 <= reused4;
      lst_inv_addr_nrm4 <= lst_inv_addr_nrm4;
      lst_inv_port_nrm4 <= lst_inv_addr_nrm4;
   end
   end


// -----------------------------------------------------------------------------
//   Generate4 signals4 for age4 checker to perform4 in-date4 check
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4) 
   begin
      check_age4 <= 1'b0;  
      last_accessed4 <= 32'd0;
   end
   else if (check_age4)
   begin
      check_age4 <= 1'b0;  
      last_accessed4 <= mem_read_data_add4[81:50];
   end
   else if (add_chk_state4 == age_chk4)
   begin
      check_age4 <= 1'b1;  
      last_accessed4 <= mem_read_data_add4[81:50];
   end
   else 
   begin
      check_age4 <= 1'b0;  
      last_accessed4 <= 32'd0;
   end
   end


`ifdef ABV_ON4

// psl4 default clock4 = (posedge pclk4);

// ASSERTION4 CHECKS4
/* Commented4 out as also checking in toplevel4
// it should never be possible4 for the destination4 port to indicate4 the MAC4
// switch4 address and one of the other 4 Ethernets4
// psl4 assert_valid_dest_port4 : assert never (d_port4[4] & |{d_port4[3:0]});


// COVER4 SANITY4 CHECKS4
// check all values of destination4 port can be returned.
// psl4 cover_d_port_04 : cover { d_port4 == 5'b0_0001 };
// psl4 cover_d_port_14 : cover { d_port4 == 5'b0_0010 };
// psl4 cover_d_port_24 : cover { d_port4 == 5'b0_0100 };
// psl4 cover_d_port_34 : cover { d_port4 == 5'b0_1000 };
// psl4 cover_d_port_44 : cover { d_port4 == 5'b1_0000 };
// psl4 cover_d_port_all4 : cover { d_port4 == 5'b0_1111 };
*/
`endif


endmodule 









