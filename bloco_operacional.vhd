------------------------------------------------
-- Design: bloco operacional
-- Entity: bloco_operacional
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/16/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY bloco_operacional IS
  PORT (
    i_CLK          : IN  STD_LOGIC;
    i_CLR_N        : IN  STD_LOGIC;
    i_INC_ADDR     : IN  STD_LOGIC;                    -- enable contador
    i_RESET        : IN  STD_LOGIC;                    -- clear contador
    i_DATA_IMG     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input
	 i_DATA_RUIDO_G : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input from GAUSS memory
	 i_DATA_RUIDO_S : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input from Salt memory
	 i_LIMIAR1      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- LIMIAR 1
	 i_LIMIAR2      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- LIMIAR 2
    i_READ_ENABLE  : IN  STD_LOGIC;                    -- input read enable in rom memory
    i_WRITE_ENABLE : IN  STD_LOGIC;                    -- data input 
	 i_SELECAO_RUIDO: IN  STD_LOGIC;                    -- seleciona entre os tipo de ruido
    o_NEXT         : OUT STD_LOGIC;                    -- data output continue
    o_READ_ENABLE  : OUT STD_LOGIC;                    -- output read enable in rom memory  
    o_WRITE_ENABLE : OUT STD_LOGIC;                    -- output write enable ram 
	 o_ADDR         : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr out image
	 o_ADDR_GAUSS   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr gauss noise
	 o_ADDR_SAL     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr sal noise
	 o_PIXEL        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- data output
  );
END bloco_operacional;

ARCHITECTURE rtl OF bloco_operacional IS


  component registrador8bit IS
    PORT (
      i_CLK   : IN  STD_LOGIC;
      i_CLR_N : IN  STD_LOGIC;
      i_ENA   : IN  STD_LOGIC;                     -- enable
      i_A     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data input       
      o_Q     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)   -- data output
	 ); 
  END component;

  component comparadorMaior8Bit IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
  END component;
  
  component multiplexador IS
  PORT (
    i_SEL : IN  STD_LOGIC;                     -- selector
    i_A   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data A
    i_B   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data B
    o_Q   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- data output
  END component;
  
  component contador IS
  PORT (
    i_CLR  : IN  STD_LOGIC;                    -- clear/reset
    i_CLK  : IN  STD_LOGIC;                    -- clock
    i_ENA  : IN  STD_LOGIC;                    -- enable 		 
    o_CONT : OUT STD_LOGIC_VECTOR(19 DOWNTO 0) -- data output
  );
  END component;
  
  component comparadorMenor8Bit IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
  END component;
  
  component comparador20Bit IS -- A < B
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(19 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(19 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
  END component;
  
  component somador IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)  -- data output
  );
  END component;
  
  component absoluto IS
  PORT (
    i_A    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);-- data input		 
    o_SAIDA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- data output
  );
  END component;
  
  
  component memoria_gauss IS
  PORT
  (
    address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    clock		: IN STD_LOGIC;
    rden		   : IN STD_LOGIC;
    q		      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  ); 
  END component;
    
  component sal_e_pimenta IS
  PORT
  (
    address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    clock		: IN STD_LOGIC;
    rden		   : IN STD_LOGIC;
    q		      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
  END component;

  component memoria_entrada IS
  PORT
  (
    address  : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    clock	: IN STD_LOGIC;
    rden		: IN STD_LOGIC;
    q		   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
  END component;
  
  component memoria_saida IS
  PORT
  (
    address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    clock		: IN STD_LOGIC ;
    data		   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wren		   : IN STD_LOGIC ;
    q		      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
  END component;
  
  component comparadorEnderecoRuidos IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
    o_Q : OUT STD_LOGIC                 -- data output
  );
  END component;
  
  component contadorEnderecoRuidos IS
  PORT (
    i_CLR  : IN  STD_LOGIC;                    -- clear/reset
    i_CLK  : IN  STD_LOGIC;                    -- clock
    i_ENA  : IN  STD_LOGIC;                    -- enable 		 
    o_CONT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- data output
  );
  END component;

  
signal w_o_CNT_ADDR : STD_LOGIC_VECTOR (19 DOWNTO 0); -- vinte bits 
signal w_o_ADDER : STD_LOGIC_VECTOR (8 DOWNTO 0); -- 9 bits
signal w_o_MUX1, w_o_MUX2, w_o_MUX3, w_o_MUX4, w_o_MUX5, w_o_MUX6, w_o_MUX7 : STD_LOGIC_VECTOR (7 DOWNTO 0); -- 8 bits
signal w_o_REG1, w_o_REG2 : STD_LOGIC_VECTOR (7 DOWNTO 0); -- 8 bits
signal w_o_ABS : STD_LOGIC_VECTOR (7 DOWNTO 0); -- 8 bits
signal w_o_COMP2, w_o_COMP3, w_o_COMP4, w_o_COMP_RUIDO : STD_LOGIC;
signal w_o_CONT_RUIDO : STD_LOGIC_VECTOR (7 DOWNTO 0); -- 8 bits
  
  

BEGIN
-- conectar os componentes

  u_CNT_ADDR: contador PORT MAP (
    i_CLR  => i_RESET, 
    i_CLK  => i_CLK, 
    i_ENA  => i_INC_ADDR, 
    o_CONT => w_o_CNT_ADDR 
  );
  
  u_CNT_ADDR_NOIS: contadorEnderecoRuidos PORT MAP (
    i_CLR  => w_o_COMP_RUIDO,
    i_CLK  => i_CLK,
    i_ENA  => i_INC_ADDR,
    o_CONT => w_o_CONT_RUIDO
  );
  
  u_COMP1: comparador20Bit PORT MAP ( -- A < B
    i_A => w_o_CNT_ADDR, 
	 i_B => "10111011101110111011",	 -- MAX_ADDRESS
    o_Q => o_NEXT   
  );
  
  u_COMP_ADDR_RUIDO: comparadorEnderecoRuidos PORT MAP (
    i_A => w_o_CONT_RUIDO,
    o_Q => w_o_COMP_RUIDO
  );
  -----------------------------------------------
  
  u_ADDER: somador PORT MAP (
    i_A => i_DATA_RUIDO_G,	 -- input from gauss memo
	 i_B => i_DATA_IMG,      -- input from img memo
    o_Q => w_o_ADDER
  );

  u_MUX1: multiplexador PORT MAP (
    i_SEL => w_o_ADDER(8),          -- signal from output somador
    i_A   => w_o_ADDER(7 downto 0), -- output from somador
    i_B   => "11111111", 				-- output clip
    o_Q   => w_o_MUX1
  );	

  -----------------------------------------------
	
  u_ABS: absoluto PORT MAP (
    i_A     => i_DATA_RUIDO_G,		 
    o_SAIDA => w_o_ABS
  );
  
  u_COMP2: comparadorMenor8Bit PORT MAP (
    i_A => w_o_ABS,	   
	 i_B => i_DATA_IMG,
    o_Q => w_o_COMP2   
  );
  
  u_MUX2: multiplexador PORT MAP (
    i_SEL => w_o_COMP2,             -- (abs < pixel)
    i_A   => w_o_ADDER(7 downto 0), -- output from somador
    i_B   => "00000000", 				-- output clip
    o_Q   => w_o_MUX2
  );  
  
  ------------------------------------------------
  
  u_MUX3: multiplexador PORT MAP (
    i_SEL => i_DATA_RUIDO_G(7),     -- signal from ruido
    i_A   => w_o_MUX1,           -- output from mux1
    i_B   => w_o_MUX2, 				-- output from mux2
    o_Q   => w_o_MUX3
  ); 
  
  ------------------------------------------------
  
  u_COMP3: comparadorMenor8Bit PORT MAP (
    i_A => i_DATA_RUIDO_S,	   -- input from mem sal
	 i_B => i_LIMIAR1,         -- limiar 1
    o_Q => w_o_COMP3   
  );	
  
  u_MUX4: multiplexador PORT MAP (
    i_SEL => w_o_COMP3,       -- (SAL < LIMIAR1)
    i_A   => i_DATA_IMG,      -- PIXEL
    i_B   => "00000000", 		-- CLIP
    o_Q   => w_o_MUX4
  ); 
  
  ------------------------------------------------
  
  u_COMP4: comparadorMenor8Bit PORT MAP (
    i_A => i_LIMIAR2,	       -- limiar 2
	 i_B => i_DATA_RUIDO_S,     -- input from mem sal
    o_Q => w_o_COMP4   
  );
  
  u_MUX5: multiplexador PORT MAP (
    i_SEL => w_o_COMP4,       -- (SAL > LIMIAR2)
    i_A   => i_DATA_IMG,      -- PIXEL
    i_B   => "11111111", 		-- CLIP
    o_Q   => w_o_MUX5
  ); 
  
  ------------------------------------------------
 
  u_MUX6: multiplexador PORT MAP (
    i_SEL => w_o_COMP4,     -- (SAL > LIMIAR2)
    i_A   => w_o_MUX5,      -- PIXEL
    i_B   => w_o_MUX4, 		 -- CLIP
    o_Q   => w_o_MUX6
  );
  -----------------------------------------------
  
  
  u_REG1 : registrador8bit PORT MAP (
      i_CLK   => i_CLK,
      i_CLR_N => i_CLR_N,
      i_ENA   => '1',
      i_A     => w_o_MUX3,      
      o_Q     => w_o_REG1    
  );
  
  u_REG2 : registrador8bit PORT MAP (
      i_CLK   => i_CLK,
      i_CLR_N => i_CLR_N,
      i_ENA   => '1',
      i_A     => w_o_MUX6,      
      o_Q     => w_o_REG2    
  );
  ---------------------------------------------
  
  u_MUX7: multiplexador PORT MAP (
    i_SEL => i_SELECAO_RUIDO,  
    i_A   => w_o_REG1,      -- resultado ruido gauss
    i_B   => w_o_REG2, 		 -- resultado ruido sal
    o_Q   => w_o_MUX7       -- saida 
  );
  ---------------------------------------------
  
  o_READ_ENABLE  <= i_READ_ENABLE;
  o_WRITE_ENABLE <= i_WRITE_ENABLE;
	
  o_ADDR       <= w_o_CNT_ADDR;
  o_ADDR_GAUSS <= w_o_CONT_RUIDO;
  o_ADDR_SAL   <= w_o_CONT_RUIDO;
  o_PIXEL      <= w_o_MUX7;
    
END rtl;
