with geometry;

package importer is

    procedure get_model_stats (file_path : string; nbr_vertices: out natural; nbr_faces: out natural; face_t: out geometry.face_type);
    procedure fill_mesh (file_path : string; m : in out geometry.mesh);

end importer;