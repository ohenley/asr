package soft_renderer is

    d : constant := 2.0 ** (-31);
    type fixed is delta d range -d .. 1.0 + d;

    type color is
    record
        r : fixed := 0.0;
        g : fixed := 0.0;
        b : fixed := 0.0;
        a : fixed := 0.0;
    end record;

  -- Note that Max_Lines and Max_Length need to be static
    type color_data is array (positive range <>, positive range <>) of fixed;

    type image (width : natural := 0; height : natural := 0) is
    record
        r : color_data (1 .. width, 1 .. height);
        g : color_data (1 .. width, 1 .. height);
        b : color_data (1 .. width, 1 .. height);
        a : color_data (1 .. width, 1 .. height);
    end record;

    procedure set_pixel_color (img : in out image; 
                                x : natural; 
                                y : natural;
                                c : color);

end soft_renderer;