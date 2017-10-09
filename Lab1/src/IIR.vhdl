library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;

library work;
  use work.resources.all;

entity IIR is
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    v_in    : in  std_logic;
    a       : in  sBIT_WIDTH_array_t (ORDER          downto 0);
    b       : in  sBIT_WIDTH_array_t (ORDER          downto 1);
    d_in    : in  signed      (BIT_WIDTH - 1  downto 0);
    v_out   : out std_logic;
    d_out   : out signed      (BIT_WIDTH - 1  downto 0)
  ) ;
end entity ; -- IIR

architecture arch of IIR is
----------------------------------------------------------------
-- COMPONENTS --------------------------------------------------
----------------------------------------------------------------
  component Adder is 
    generic( N : positive );
    port  (
            sel   : in  std_logic;
            A     : in  signed (N - 1  downto 0);
            B     : in  signed (N - 1  downto 0);
            C     : out signed (N - 1  downto 0)
          );
  end component Adder;
----------------------------------------------------------------
  component Multiplier is 
    generic( N : positive );
    port  ( 
            A     : in  signed (  N - 1 downto 0);
            B     : in  signed (  N - 1 downto 0);
            C     : out signed (2*N - 1 downto 0)
          );
  end component Multiplier;
----------------------------------------------------------------
  component Register is
    generic ( N : positive );
    port  (
            clk   : in  std_logic; 
            rst_n : in  std_logic;
            load  : in  std_logic;
            D     : in  signed (N - 1 downto 0);
            Q     : out signed (N - 1 downto 0)
          );
  end component Register;
----------------------------------------------------------------
  component ShiftRegister is
    generic ( N : positive );
    port (
          clk     : in    std_logic; 
          rst_n   : in    std_logic;
          load    : in    std_logic;
          D       : in    std_logic;
          Q       : out   unsigned (N - 2 downto 0)
        );  
  end component ShiftRegister;
----------------------------------------------------------------

begin
----------------------------------------------------------------
-- SIGNAL DEFINITIONS ------------------------------------------
----------------------------------------------------------------
  signal sD_IN      : signed      (BIT_WIDTH - 1  downto 0);
  signal sD_OUT     : signed      (BIT_WIDTH - 1  downto 0);

  signal sLOAD      : unsigned (ORDER downto 0);

  signal sADD_SUB   : sN_ADD_array_t (N_ADD - 1   downto 0);      -- not yet assigned
  signal sIN_1_ADD  : sN_ADD_array_t (N_ADD - 1   downto 0);
  signal sIN_2_ADD  : sN_ADD_array_t (N_ADD - 1   downto 0);
  signal sOUT_ADD   : sN_ADD_array_t (N_ADD - 1   downto 0);

  signal sIN_MULT   : sN_MULT_array_t (N_MULT - 1  downto 0);
  signal sIN_C_MULT : sN_MULT_array_t (N_MULT - 1  downto 0);
  signal sOUT_MULT  : sN_MULT_array_t (N_MULT - 1  downto 0);

  signal sIN_REG    : sORDER_array_t (ORDER - 1   downto 0);
  signal sOUT_REG   : sORDER_array_t (ORDER - 1   downto 0);

----------------------------------------------------------------
-- CONNECTIONS -------------------------------------------------
----------------------------------------------------------------
  sIN_C_MULT(0) <= a(0);
  sIN_C_MULT(1) <= a(1);
  sIN_C_MULT(2) <= a(2);
  sIN_C_MULT(3) <= b(1);
  sIN_C_MULT(4) <= b(2);

  sIN_MULT(0) <= sOUT_ADD(2);
  sIN_MULT(1) <= sOUT_REG(0);
  sIN_MULT(2) <= sOUT_REG(1);
  sIN_MULT(3) <= sOUT_REG(0);
  sIN_MULT(4) <= sOUT_REG(1);
----------------------------------------------------------------
  sIN_1_ADD(0) <= sOUT_MULT(0);
  sIN_2_ADD(0) <= sOUT_ADD(1);

  sIN_1_ADD(1) <= sOUT_MULT(1);
  sIN_2_ADD(1) <= sOUT_MULT(2);

  sIN_1_ADD(2) <= d_in;
  sIN_2_ADD(2) <= sOUT_ADD(3);
  
  sIN_1_ADD(3) <= sOUT_MULT(3);
  sIN_2_ADD(3) <= sOUT_MULT(4);
----------------------------------------------------------------
  sIN_REG(0) <= sOUT_ADD(2);
  sIN_REG(1) <= sOUT_REG(0);
----------------------------------------------------------------
  d_out <= sOUT_ADD(0);
----------------------------------------------------------------

----------------------------------------------------------------
-- INSTANCES ---------------------------------------------------
----------------------------------------------------------------
    reg_in : 
    Register 
    generic map ( 
                  N   => BIT_WIDTH
                )
    port map    (
                  clk   => clk,
                  rst_n => rst_n,
                  load  => v_in,
                  D     => d_in,
                  Q     => sD_IN
                );
----------------------------------------------------------------
  add_gen : 
  for i in 0 to N_ADD - 1 loop
    add : 
    Adder 
    generic map ( 
                  N   => BIT_WIDTH
                )
    port map    (
                  sel => sADD_SUB(i),
                  A   => sIN_1_REG(i),
                  B   => sIN_2_REG(i),
                  C   => sOUT_REG(i)
                );
  end loop ; -- add_gen
----------------------------------------------------------------
  mult_gen : 
  for i in 0 to N_MULT - 1 loop
    mult : 
    Multiplier 
    generic map ( 
                  N   => BIT_WIDTH
                )
    port map    (
                  A   => sIN_MULT(i),
                  B   => sIN_C_MULT(i),
                  C   => sOUT_MULT(i)
                );
  end loop ; -- mult_gen
----------------------------------------------------------------
  reg_gen : 
  for i in 0 to ORDER - 1 loop
    reg : 
    Multiplier 
    generic map ( 
                  N     => BIT_WIDTH
                )
    port map    (
                  clk   => clk,
                  rst_n => rst_n,
                  load  => sLOAD(i),
                  D     => sIN_REG(i),
                  Q     => sOUT_REG(i)
                );
  end loop ; -- reg_gen
----------------------------------------------------------------
    shift_reg : 
    ShiftRegister 
    generic map ( 
                  N   => '1'
                )
    port map    (
                  clk   => clk,
                  rst_n => rst_n,
                  load  => '1',
                  D     => v_in,
                  Q     => sLOAD
                );
----------------------------------------------------------------
    reg_out :
    Register 
    generic map ( 
                  N   => BIT_WIDTH
                )
    port map    (
                  clk   => clk,
                  rst_n => rst_n,
                  load  => sLOAD(ORDER),
                  D     => sD_OUT,
                  Q     => d_out
                );
----------------------------------------------------------------
end architecture ; -- arch