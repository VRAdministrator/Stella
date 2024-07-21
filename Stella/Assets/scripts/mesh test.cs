using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class meshtest : MonoBehaviour
{
    //this should be replaced by a far better way of calculating positions relitive to changes in eular angles, quick and dirty hack for now
    public GameObject mesh_helper;
    public GameObject mesh_pt1;
    public GameObject mesh_pt2;
    public GameObject mesh_pt3;
    public GameObject mesh_pt4;



    protected MeshFilter MeshFilter;
    protected Mesh Mesh;
    protected Transform[] mesh_pts;

    const float mesh_resize=0.1F;
    private Vector3[] base_verts=new Vector3[]{
            new Vector3(-1,0,0.1F),
            new Vector3(-1,0,-0.1F),
            new Vector3(-1,0.2F,0.1F),
            new Vector3(-1,0.2F,-0.1F),
    };
    private int[] base_triangles=new int[]{
            //bottom
            4,0,5,
            5,0,1,
            //top
            2,6,7,
            2,7,3,
            //front
            5,3,7,
            5,1,3,
            //back
            2,0,4,
            2,4,6,
        };
    private Transform mesh_help_trans;
    private Vector3 mesh_locat;
    // Start is called before the first frame update
    void Start()
    {
        mesh_help_trans=mesh_helper.transform;
        mesh_locat=transform.position;
        mesh_pts=new Transform[]{mesh_pt1.transform,mesh_pt2.transform,mesh_pt3.transform,mesh_pt4.transform};
        Mesh=new Mesh();
        Mesh.name="test mesh";
        Vector3[] pts=new Vector3[]{
            new Vector3(-1,0,0),
            new Vector3(-1,.1F,0),
            new Vector3(-.1F,1,0),
            new Vector3(0,1,0),
            /*
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.1F)),Mathf.Sin(Mathf.PI*.1F),0.1F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.2F)),Mathf.Sin(Mathf.PI*.2F),0.2F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.3F)),Mathf.Sin(Mathf.PI*.3F),0.3F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.4F)),Mathf.Sin(Mathf.PI*.4F),0.4F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.5F)),Mathf.Sin(Mathf.PI*.5F),0.5F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.6F)),Mathf.Sin(Mathf.PI*.6F),0.6F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.7F)),Mathf.Sin(Mathf.PI*.7F),0.7F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.8F)),Mathf.Sin(Mathf.PI*.8F),0.8F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-0.9F)),Mathf.Sin(Mathf.PI*.9F),0.9F),
            new Vector3(Mathf.Cos(Mathf.PI*(1.0F-1.0F)),Mathf.Sin(Mathf.PI*1.0F),1.0F),
            */
        };
        List<Vector3> verts=new List<Vector3>();
        List<int> triangles=new List<int>();

        int n_pts=100;

        for (int i=0;i<n_pts;i++){
            for (int I=0;I<4;I++){
                verts.Add(mesh_pts[I].position-mesh_locat);
            }
            mesh_help_trans.localPosition+=new Vector3(0,0,0.006F);
            mesh_help_trans.localEulerAngles+=new Vector3(0,0,15);
        }

        int shift=0;
        for (int i=1;i<n_pts;i++){
            for (int I=0;I<24;I++){
                triangles.Add(base_triangles[I]+shift);
            }
            shift+=4;
        }

        Mesh.vertices=verts.ToArray();
        Mesh.triangles=triangles.ToArray();
        Mesh.RecalculateNormals();
        Mesh.RecalculateBounds();
        MeshFilter=gameObject.AddComponent<MeshFilter>();
        MeshFilter.mesh=Mesh;

        //gen_tube_mesh(pts);
    }


    private void gen_tube_mesh(Vector3[] pts){

        List<Vector3> neo_pts=new List<Vector3>();
        int size=pts.Length-1;
        neo_pts.Add(pts[0]);
        for (int i=1;i<size-1;i++){
            Vector3 cur_pt=pts[i];
            Vector3 pt1_angle=dif_to_euler(cur_pt-pts[i-1])+new Vector3(0,90,90);
            Vector3 pt2_angle=dif_to_euler(pts[i+2]-pts[i+1])+new Vector3(0,90,90);
            Vector3 angle_step=(pt2_angle-pt1_angle)/4;
            Vector3 dif_pt=(pts[i+1]-cur_pt);
            float x_step=dif_pt.x/4;
            float start_x=x_step+cur_pt.x;
            float start_z=angle_to_curve(pt1_angle.y);
            float start_y=angle_to_curve(pt1_angle.z);
            float y_resize=dif_pt.y/(angle_to_curve(pt2_angle.z)-start_y);
            float z_resize=dif_pt.z/(angle_to_curve(pt2_angle.y)-start_z);
            if (float.IsNaN(y_resize)){
                y_resize=0;
            }
            if (float.IsNaN(z_resize)){
                z_resize=0;
            }
            Vector3 pt_shift=new Vector3(0,cur_pt.y-start_y*y_resize,cur_pt.z-start_z*z_resize);
            neo_pts.Add(pts[i]);
            for (int I=0;I<3;I++){
                pt1_angle+=angle_step;
                Debug.Log(angle_to_curve(pt1_angle.z));
                neo_pts.Add(new Vector3(start_x,y_resize*angle_to_curve(pt1_angle.z),z_resize*angle_to_curve(pt1_angle.y))+pt_shift);
                start_x+=x_step;
            }
        }
        neo_pts.Add(pts[size-1]);
        neo_pts.Add(pts[size]);
        pts=neo_pts.ToArray();

        List<Vector3> verts=new List<Vector3>();
        List<int> triangles=new List<int>();
        Vector3 temp_vec;
        mesh_help_trans.localPosition=pts[0];
        temp_vec=dif_to_euler(pts[1]-pts[0]);
        //Debug.Log(temp_vec);
        mesh_help_trans.eulerAngles=temp_vec;
        for (int i=0;i<4;i++){
            verts.Add(mesh_pts[i].position-mesh_locat);
        }
        int end_pt=pts.Length-1;
        for (int i=1;i<end_pt;i++){
            mesh_help_trans.localPosition=pts[i];
            temp_vec=(dif_to_euler(pts[i+1]-pts[i])+dif_to_euler(pts[i]-pts[i-1]))/2.0F;//-new Vector3(0,90,0)
            //Debug.Log(pts[i-1]);
            //Debug.Log(pts[i]);
            Debug.Log(temp_vec);
            mesh_help_trans.eulerAngles=temp_vec;
            for (int I=0;I<4;I++){
                verts.Add(mesh_pts[I].position-mesh_locat);
            }
        }
        mesh_help_trans.localPosition=pts[end_pt];
        temp_vec=dif_to_euler(pts[end_pt]-pts[end_pt-1]);
        //Debug.Log(temp_vec);
        mesh_help_trans.eulerAngles=temp_vec;
        for (int i=0;i<4;i++){
            verts.Add(mesh_pts[i].position-mesh_locat);
        }
        int shift=0;
        for (int i=1;i<pts.Length;i++){
            for (int I=0;I<24;I++){
                triangles.Add(base_triangles[I]+shift);
            }
            shift+=4;
        }
        Mesh.vertices=verts.ToArray();
        Mesh.triangles=triangles.ToArray();
        Mesh.RecalculateNormals();
        Mesh.RecalculateBounds();
        MeshFilter=gameObject.AddComponent<MeshFilter>();
        MeshFilter.mesh=Mesh;
    }
    private Vector3 dif_to_euler(Vector3 dif_pt){
        return(rm_nan(new Vector3(
            0,
            float_to_sin(dif_pt.z,dif_pt.x),
            float_to_sin(dif_pt.y,dif_pt.x))));
    }
    private Vector3 rm_nan(Vector3 vec){
        for (int i=0;i<3;i++){
            if (float.IsNaN(vec[i])){
                vec[i]=0;
            }
        }
        return(vec);
    }

    private float angle_to_curve(float angle){
        float curve=Mathf.Cos(Mathf.Asin(1-((angle+360)%180)/90));
        if (angle>180){
            return(-curve);
        }
        return(curve);
    }

    private float float_to_sin(float op,float ad){
        float angle=180*Mathf.Asin(op/Mathf.Sqrt(op*op+ad*ad))/Mathf.PI;
        if (ad<0){
            return((180-angle)%360);
        }
        return(angle);
    }
}
