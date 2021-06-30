------------------------------------------------
-- Design: comparador 8 bits
-- Entity: comparador
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/15/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY comparadorEnderecoRuidos IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
    o_Q : OUT STD_LOGIC                 -- data output
  );
END comparadorEnderecoRuidos;

ARCHITECTURE arch_1 OF comparadorEnderecoRuidos IS

BEGIN
  -- SAIDA
  o_Q <= '1' WHEN (i_A > "10110011") ELSE '0';

END arch_1;
