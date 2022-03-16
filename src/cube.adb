--with soft_renderer.line;
--with soft_renderer.triangle;

with basics; use basics;

with soft_renderer;

with x11_window;

with geometry; use geometry;

with Ada.text_io; use Ada.text_io;

with importer;

with ada.numerics.discrete_random;

with linear_algebra;

procedure cube is
    img          : soft_renderer.image (600, 600);
    c            : soft_renderer.color := (others => 0.95);
    nbr_vertices : Natural;
    nbr_faces    : Natural;
    face_t       : geometry.face_type;
begin
    importer.get_model_stats
       ("data/african_head.obj", nbr_vertices, nbr_faces, face_t);
    declare
        m : mesh (face_t, nbr_faces, nbr_vertices);
    begin
        importer.fill_mesh ("data/african_head.obj", m);

        for f in m.f.tris_indices'Range loop
            declare
                i0 : positive := m.f.tris_indices (f) (1);
                x0 : real     := (m.x (i0) + 1.0) * 300.0;
                y0 : real     :=
                   (600.0 - (m.y (i0) + 1.0) * 300.0) +
                   1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11

                i1 : positive := m.f.tris_indices (f) (2);
                x1 : real     := (m.x (i1) + 1.0) * 300.0;
                y1 : real     :=
                   (600.0 - (m.y (i1) + 1.0) * 300.0) +
                   1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11

                i2 : positive := m.f.tris_indices (f) (3);
                x2 : real     := (m.x (i2) + 1.0) * 300.0;
                y2 : real     :=
                   (600.0 - (m.y (i2) + 1.0) * 300.0) +
                   1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11

                package screen_coords is new linear_algebra (base => real);
                use screen_coords;

                w0 : vec := (m.x (i0), m.y (i0), m.z (i0));
                w1 : vec := (m.x (i1), m.y (i1), m.z (i1));
                w2 : vec := (m.x (i2), m.y (i2), m.z (i2));

                n         : vec := cross ((w2 - w0), (w1 - w0));
                light_dir : vec := (0.0, 0.0, -1.0);
                v         : real;
            begin

                normalize (n);
                v := dot (n, light_dir);
                if v < small then
                    v := small;
                else
                    if v > last then
                        v := last;
                    end if;

                    c := (intensity (v), intensity (v), intensity (v), small);

                    soft_renderer.triangle
                       (Natural (x0), Natural (y0), Natural (x1), Natural (y1),
                        Natural (x2), Natural (y2), c, img);
                end if;
            end;
        end loop;
    end;

    x11_window.open_window (img);
end cube;

--for f in m.f.tris_indices'range loop
--    --for i in m.f.tris_indices (f)'range loop
--        --declare
--        --    i0 : positive := m.f.tris_indices (f)(i);
--        --    x0 : real := (m.x (i0) + 1.0) * 300;
--        --    y0 : real := (600.0 - (m.y (i0) + 1.0) * 300) + 1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
--        --
--        --    i1 : positive := m.f.tris_indices (f)((i mod 3) + 1);
--        --    x1 : real := (m.x (i1) + 1.0) * 300;
--        --    y1 : real := (600.0 - (m.y (i1) + 1.0) * 300) + 1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
--        --begin
--        --    --if f = 6 and i = 3 then
--        --    soft_renderer.line (integer(x0), integer(y0), integer(x1), integer(y1), c, img);
--        --    --end if;
--        --    --put_line("face: " & f'image & ", i: " & i0'image & ", idx: " & i1'image);
--        --    --put_line("(" & x0'image & "),(" & y0'image & ")");
--        --    --put_line("(" & x1'image & "),(" & y1'image & ")");
--        --    --put_line("----------");
--        --    null;
--        --end;
--    --end loop;
--    declare
--        --i0 : positive := m.f.tris_indices (f)(1);
--        --x0 : real := (m.x (i0) + 1.0) * 300;
--        --y0 : real := (600.0 - (m.y (i0) + 1.0) * 300) + 1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
----
--        --i1 : positive := m.f.tris_indices (f)(2);
--        --x1 : real := (m.x (i1) + 1.0) * 300;
--        --y1 : real := (600.0 - (m.y (i1) + 1.0) * 300) + 1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
----
--        --i2 : positive := m.f.tris_indices (f)(3);
--        --x2 : real := (m.x (i2) + 1.0) * 300;
--        --y2 : real := (600.0 - (m.y (i2) + 1.0) * 300) + 1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
--
--        x0 : real := 1.0;
--        y0 : real := 1.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
--
--        x1 : real := 1.0;
--        y1 : real := 200.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
--
--        x2 : real := 200.0;
--        y2 : real := 100.0; -- (600.0 ...) + 1.0 // necessary to flip y for drawing on X11
--
--    begin
--        soft_renderer.triangle (natural(x0),
--                                natural(y0),
--                                natural(x1),
--                                natural(y1),
--                                natural(x2),
--                                natural(y2),
--                                c,
--                                img);
--    end;
--end loop;
--null;
