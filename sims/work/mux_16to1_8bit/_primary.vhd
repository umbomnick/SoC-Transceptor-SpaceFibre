library verilog;
use verilog.vl_types.all;
entity mux_16to1_8bit is
    port(
        in00            : in     vl_logic_vector(7 downto 0);
        in01            : in     vl_logic_vector(7 downto 0);
        in02            : in     vl_logic_vector(7 downto 0);
        in03            : in     vl_logic_vector(7 downto 0);
        in04            : in     vl_logic_vector(7 downto 0);
        in05            : in     vl_logic_vector(7 downto 0);
        in06            : in     vl_logic_vector(7 downto 0);
        in07            : in     vl_logic_vector(7 downto 0);
        in08            : in     vl_logic_vector(7 downto 0);
        in09            : in     vl_logic_vector(7 downto 0);
        in10            : in     vl_logic_vector(7 downto 0);
        in11            : in     vl_logic_vector(7 downto 0);
        in12            : in     vl_logic_vector(7 downto 0);
        in13            : in     vl_logic_vector(7 downto 0);
        in14            : in     vl_logic_vector(7 downto 0);
        in15            : in     vl_logic_vector(7 downto 0);
        sel             : in     vl_logic_vector(3 downto 0);
        \out\           : out    vl_logic_vector(7 downto 0)
    );
end mux_16to1_8bit;
