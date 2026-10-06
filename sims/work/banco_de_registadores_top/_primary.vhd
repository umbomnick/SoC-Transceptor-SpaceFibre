library verilog;
use verilog.vl_types.all;
entity banco_de_registadores_top is
    port(
        we              : in     vl_logic;
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        r_addr_a        : in     vl_logic_vector(3 downto 0);
        r_addr_b        : in     vl_logic_vector(3 downto 0);
        w_addr          : in     vl_logic_vector(3 downto 0);
        w_data          : in     vl_logic_vector(7 downto 0);
        r_data_a        : out    vl_logic_vector(7 downto 0);
        r_data_b        : out    vl_logic_vector(7 downto 0);
        we_dec          : out    vl_logic_vector(15 downto 0)
    );
end banco_de_registadores_top;
