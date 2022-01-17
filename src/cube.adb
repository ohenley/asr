with soft_renderer.line;
with soft_renderer;

with x11_window;

with geometry; use geometry;

with Ada.text_io; use Ada.text_io;

with importer;

procedure cube is
img : soft_renderer.image (600, 600);
c : soft_renderer.color := (1.0, 1.0, 1.0, 1.0);
nbr_vertices : natural;
nbr_faces : natural;
face_t : geometry.face_type;
begin
    importer.get_model_stats ("data/african_head.obj", nbr_vertices, nbr_faces, face_t);
    declare
        m : mesh (face_t, nbr_faces, nbr_vertices);
    begin
        importer.fill_mesh ("data/african_head.obj", m);

        for f in m.f.tris_indices'range loop
            for i in m.f.tris_indices (f)'range loop
                declare
                    i0 : positive := m.f.tris_indices (f)(i);
                    x0 : real := (m.x (i0) + 1.0) * 300;
                    y0 : real := (m.y (i0) + 1.0) * 300;
                    i1 : positive := m.f.tris_indices (f)((i mod 3) + 1);
                    x1 : real := (m.x (i1) + 1.0) * 300;
                    y1 : real := (m.y (i1) + 1.0) * 300;
                begin
                    --if f = 6 and i = 3 then 
                    soft_renderer.line.line (integer(x0), integer(y0), integer(x1), integer(y1), c, img);
                    --end if;
                    --put_line("face: " & f'image & ", i: " & i0'image & ", idx: " & i1'image);
                    --put_line("(" & x0'image & "),(" & y0'image & ")");
                    --put_line("(" & x1'image & "),(" & y1'image & ")");
                    --put_line("----------");
                    null;
                end;
            end loop;
        end loop;
        null;
    end;
 
    x11_window.open_window (img);
end;
