with basics; use basics;

package soft_renderer is

    type color is
    record
        r : intensity := 0.0;
        g : intensity := 0.0;
        b : intensity := 0.0;
        a : intensity := 0.0;
    end record;

  -- Note that Max_Lines and Max_Length need to be static
    type color_data is array (positive range <>, positive range <>) of intensity;

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

    procedure line (x0 : in out natural;
                    y0 : in out natural;
                    x1 : in out natural; 
                    y1 : in out natural; 
                    c : color; 
                    img : in out image);

    procedure triangle (px0 : in out natural; 
                        py0 : in out natural; 
                        px1 : in out natural; 
                        py1 : in out natural;
                        px2 : in out natural; 
                        py2 : in out natural;
                        c : color; 
                        img : in out image);

end soft_renderer;