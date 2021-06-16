------------------------------------------------
-- Design: register
-- Entity: register
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/15/2021
------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registrador8bit IS
  PORT (
    i_CLK   : IN  STD_LOGIC;
    i_CLR_N : IN  STD_LOGIC;
    i_ENA   : IN  STD_LOGIC;                     -- enable
    i_A     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data input       
    o_Q     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- data output

END registrador8bit;

ARCHITECTURE arch1 OF registrador8bit IS

  SIGNAL w_SAIDA : STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN
  PROCESS (i_CLR_N, i_CLK)
  BEGIN
    IF (i_CLR_N = '0') THEN
      w_SAIDA <= "00000000";
    ELSIF (rising_edge(i_CLK)) THEN
      IF (i_ENA = '1') THEN
        w_SAIDA <= i_A;
      END IF;
    END IF;
  END PROCESS;

  o_Q <= w_SAIDA;

END arch1;
