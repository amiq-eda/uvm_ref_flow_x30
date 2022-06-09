//File20 name   : alut20.v
//Title20       : ALUT20 top level
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
module alut20
(   
   // Inputs20
   pclk20,
   n_p_reset20,
   psel20,            
   penable20,       
   pwrite20,         
   paddr20,           
   pwdata20,          

   // Outputs20
   prdata20  
);

   parameter   DW20 = 83;          // width of data busses20
   parameter   DD20 = 256;         // depth of RAM20


   // APB20 Inputs20
   input             pclk20;               // APB20 clock20                          
   input             n_p_reset20;          // Reset20                              
   input             psel20;               // Module20 select20 signal20               
   input             penable20;            // Enable20 signal20                      
   input             pwrite20;             // Write when HIGH20 and read when LOW20  
   input [6:0]       paddr20;              // Address bus for read write         
   input [31:0]      pwdata20;             // APB20 write bus                      

   output [31:0]     prdata20;             // APB20 read bus                       

   wire              pclk20;               // APB20 clock20                           
   wire [7:0]        mem_addr_add20;       // hash20 address for R/W20 to memory     
   wire              mem_write_add20;      // R/W20 flag20 (write = high20)            
   wire [DW20-1:0]     mem_write_data_add20; // write data for memory             
   wire [7:0]        mem_addr_age20;       // hash20 address for R/W20 to memory     
   wire              mem_write_age20;      // R/W20 flag20 (write = high20)            
   wire [DW20-1:0]     mem_write_data_age20; // write data for memory             
   wire [DW20-1:0]     mem_read_data_add20;  // read data from mem                 
   wire [DW20-1:0]     mem_read_data_age20;  // read data from mem  
   wire [31:0]       curr_time20;          // current time
   wire              active;             // status[0] adress20 checker active
   wire              inval_in_prog20;      // status[1] 
   wire              reused20;             // status[2] ALUT20 location20 overwritten20
   wire [4:0]        d_port20;             // calculated20 destination20 port for tx20
   wire [47:0]       lst_inv_addr_nrm20;   // last invalidated20 addr normal20 op
   wire [1:0]        lst_inv_port_nrm20;   // last invalidated20 port normal20 op
   wire [47:0]       lst_inv_addr_cmd20;   // last invalidated20 addr via cmd20
   wire [1:0]        lst_inv_port_cmd20;   // last invalidated20 port via cmd20
   wire [47:0]       mac_addr20;           // address of the switch20
   wire [47:0]       d_addr20;             // address of frame20 to be checked20
   wire [47:0]       s_addr20;             // address of frame20 to be stored20
   wire [1:0]        s_port20;             // source20 port of current frame20
   wire [31:0]       best_bfr_age20;       // best20 before age20
   wire [7:0]        div_clk20;            // programmed20 clock20 divider20 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata20;             // APB20 read bus
   wire              age_confirmed20;      // valid flag20 from age20 checker        
   wire              age_ok20;             // result from age20 checker 
   wire              clear_reused20;       // read/clear flag20 for reused20 signal20           
   wire              check_age20;          // request flag20 for age20 check
   wire [31:0]       last_accessed20;      // time field sent20 for age20 check




alut_reg_bank20 i_alut_reg_bank20
(   
   // Inputs20
   .pclk20(pclk20),
   .n_p_reset20(n_p_reset20),
   .psel20(psel20),            
   .penable20(penable20),       
   .pwrite20(pwrite20),         
   .paddr20(paddr20),           
   .pwdata20(pwdata20),          
   .curr_time20(curr_time20),
   .add_check_active20(add_check_active20),
   .age_check_active20(age_check_active20),
   .inval_in_prog20(inval_in_prog20),
   .reused20(reused20),
   .d_port20(d_port20),
   .lst_inv_addr_nrm20(lst_inv_addr_nrm20),
   .lst_inv_port_nrm20(lst_inv_port_nrm20),
   .lst_inv_addr_cmd20(lst_inv_addr_cmd20),
   .lst_inv_port_cmd20(lst_inv_port_cmd20),

   // Outputs20
   .mac_addr20(mac_addr20),    
   .d_addr20(d_addr20),   
   .s_addr20(s_addr20),    
   .s_port20(s_port20),    
   .best_bfr_age20(best_bfr_age20),
   .div_clk20(div_clk20),     
   .command(command), 
   .prdata20(prdata20),  
   .clear_reused20(clear_reused20)           
);


alut_addr_checker20 i_alut_addr_checker20
(   
   // Inputs20
   .pclk20(pclk20),
   .n_p_reset20(n_p_reset20),
   .command(command),
   .mac_addr20(mac_addr20),
   .d_addr20(d_addr20),
   .s_addr20(s_addr20),
   .s_port20(s_port20),
   .curr_time20(curr_time20),
   .mem_read_data_add20(mem_read_data_add20),
   .age_confirmed20(age_confirmed20),
   .age_ok20(age_ok20),
   .clear_reused20(clear_reused20),

   //outputs20
   .d_port20(d_port20),
   .add_check_active20(add_check_active20),
   .mem_addr_add20(mem_addr_add20),
   .mem_write_add20(mem_write_add20),
   .mem_write_data_add20(mem_write_data_add20),
   .lst_inv_addr_nrm20(lst_inv_addr_nrm20),
   .lst_inv_port_nrm20(lst_inv_port_nrm20),
   .check_age20(check_age20),
   .last_accessed20(last_accessed20),
   .reused20(reused20)
);


alut_age_checker20 i_alut_age_checker20
(   
   // Inputs20
   .pclk20(pclk20),
   .n_p_reset20(n_p_reset20),
   .command(command),          
   .div_clk20(div_clk20),          
   .mem_read_data_age20(mem_read_data_age20),
   .check_age20(check_age20),        
   .last_accessed20(last_accessed20), 
   .best_bfr_age20(best_bfr_age20),   
   .add_check_active20(add_check_active20),

   // outputs20
   .curr_time20(curr_time20),         
   .mem_addr_age20(mem_addr_age20),      
   .mem_write_age20(mem_write_age20),     
   .mem_write_data_age20(mem_write_data_age20),
   .lst_inv_addr_cmd20(lst_inv_addr_cmd20),  
   .lst_inv_port_cmd20(lst_inv_port_cmd20),  
   .age_confirmed20(age_confirmed20),     
   .age_ok20(age_ok20),
   .inval_in_prog20(inval_in_prog20),            
   .age_check_active20(age_check_active20)
);   


alut_mem20 i_alut_mem20
(   
   // Inputs20
   .pclk20(pclk20),
   .mem_addr_add20(mem_addr_add20),
   .mem_write_add20(mem_write_add20),
   .mem_write_data_add20(mem_write_data_add20),
   .mem_addr_age20(mem_addr_age20),
   .mem_write_age20(mem_write_age20),
   .mem_write_data_age20(mem_write_data_age20),

   .mem_read_data_add20(mem_read_data_add20),  
   .mem_read_data_age20(mem_read_data_age20)
);   



`ifdef ABV_ON20
// psl20 default clock20 = (posedge pclk20);

// ASSUMPTIONS20

// ASSERTION20 CHECKS20
// the invalidate20 aged20 in progress20 flag20 and the active flag20 
// should never both be set.
// psl20 assert_inval_in_prog_active20 : assert never (inval_in_prog20 & active);

// it should never be possible20 for the destination20 port to indicate20 the MAC20
// switch20 address and one of the other 4 Ethernets20
// psl20 assert_valid_dest_port20 : assert never (d_port20[4] & |{d_port20[3:0]});

// COVER20 SANITY20 CHECKS20
// check all values of destination20 port can be returned.
// psl20 cover_d_port_020 : cover { d_port20 == 5'b0_0001 };
// psl20 cover_d_port_120 : cover { d_port20 == 5'b0_0010 };
// psl20 cover_d_port_220 : cover { d_port20 == 5'b0_0100 };
// psl20 cover_d_port_320 : cover { d_port20 == 5'b0_1000 };
// psl20 cover_d_port_420 : cover { d_port20 == 5'b1_0000 };
// psl20 cover_d_port_all20 : cover { d_port20 == 5'b0_1111 };

`endif


endmodule
