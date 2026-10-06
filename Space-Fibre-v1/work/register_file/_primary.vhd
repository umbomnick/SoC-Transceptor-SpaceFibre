library verilog;
use verilog.vl_types.all;
entity register_file is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        we              : in     vl_logic;
        w_addr          : in     vl_logic_vector(3 downto 0);
        w_data          : in     vl_logic_vector(7 downto 0);
        r_addr          : in     vl_logic_vector(3 downto 0);
        r_data          : out    vl_logic_vector(7 downto 0)
    );
end register_file;
