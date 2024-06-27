using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class combine : MonoBehaviour
{
    float dis_form(Transform t1,Transform t2){
        Vector3 tp1=t1.position;
        Vector3 tp2=t2.position;
        return Mathf.Sqrt(Mathf.Pow(tp1.x-tp2.x,2)+Mathf.Pow(tp1.y-tp2.y,2)+Mathf.Pow(tp1.z-tp2.z,2));
    }
    public GameObject combined,p1_obj,p2_obj;
    public Transform p1,p2,b1,b2,b3,b4,b5,a1,a2,a3,a4,a5;
    private bool joined;
    // Start is called before the first frame update
    // Update is called once per frame
    void Update()
    {
        if (dis_form(b1,a1)<.1&&dis_form(b2,a2)<.1&&dis_form(b3,a3)<.1&&dis_form(b4,a4)<.1&&dis_form(b5,a5)<.1){
            if (!joined){
                joined=true;
            }
        }else if (joined){
            joined=false;
        }else{
            float temp;
            float force=0;
            Transform[] As={a1,a2,a3,a4,a5};
            Transform[] Bs={b1,b2,b3,b4,b5};
            for (int i=0;i<5;i++){
                for (int I=0;I<5;I++){
                    temp=Mathf.Pow(1/dis_form(As[i],Bs[I]),2);
                    if (i==I){
                        force+=temp;
                    }else{
                        force-=temp/5;
                    }
                }
            }
            force*=.00001f;
            Vector3 tp1=p1.position;
            Vector3 tp2=p2.position;
            Vector3 temp_vec=new Vector3(Mathf.Sign(tp1.x-tp2.x)*force,Mathf.Sign(tp1.y-tp2.y)*force,Mathf.Sign(tp1.z-tp2.z)*force);
            p1.position-=temp_vec;
            p2.position+=temp_vec;
        }
    }
}