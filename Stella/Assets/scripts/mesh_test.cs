using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mesh_test : MonoBehaviour
{
    const float gr=1.618f;
    // Start is called before the first frame update
    Vector3[] verts_dodecahedron={
        new Vector3 (-1,-1,-1),
        new Vector3 (1,-1,-1),
        new Vector3 (-1,1,-1),
        new Vector3 (1,1,-1),
        new Vector3 (-1,-1,1),
        new Vector3 (1,-1,1),
        new Vector3 (-1,1,1),
        new Vector3 (1,1,1),
        new Vector3 (0,gr,1/gr),
        new Vector3 (0,-gr,1/gr),
        new Vector3 (0,gr,-1/gr),
        new Vector3 (0,-gr,-1/gr),
        new Vector3 (1/gr,0,-gr),
        new Vector3 (-1/gr,0,-gr),
        new Vector3 (1/gr,0,gr),
        new Vector3 (-1/gr,0,gr),
        new Vector3 (gr,1/gr,0),
        new Vector3 (-gr,1/gr,0),
        new Vector3 (gr,-1/gr,0),
        new Vector3 (-gr,-1/gr,0),
    };
    Vector3[] vertices = {
        new Vector3 (0, 0, 0),
        new Vector3 (1, 0, 0),
        new Vector3 (1, 1, 0),
        new Vector3 (0, 1, 0),
        new Vector3 (0, 1, 1),
        new Vector3 (1, 1, 1),
        new Vector3 (1, 0, 1),
        new Vector3 (0, 0, 1),
    };

    int[] triangles = {
			0, 2, 1, //face front
			0, 3, 2,
			2, 3, 4, //face top
			2, 4, 5,
			1, 2, 5, //face right
			1, 5, 6,
			0, 7, 4, //face left
			0, 4, 3,
			5, 4, 7, //face back
			5, 7, 6,
			0, 6, 7, //face bottom
			0, 1, 6
		};
    void Start()
    {
        //Mesh mesh=new Mesh();
        //mesh.vertices=vertices;
		//mesh.triangles=triangles;
		//mesh.Optimize();
		//mesh.RecalculateNormals();
        //GetComponent<MeshFilter>().mesh=mesh;
        //Mesh mesh=GetComponent<MeshFilter>().mesh;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
