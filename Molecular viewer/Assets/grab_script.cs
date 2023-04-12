using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class grab_script : MonoBehaviour
{
    public GameObject hand,other_hand,grabbed_ob;
    public Collider main_Collider;
    public InputActionProperty grip,grab;
    public Rigidbody grabbed_rig;

    public bool grabbed;
    public bool inside;
    private float closest=1000;

    float dis_form(Vector3 tp1,Vector3 tp2){
        return Mathf.Sqrt(Mathf.Pow(tp1.x-tp2.x,2)+Mathf.Pow(tp1.y-tp2.y,2)+Mathf.Pow(tp1.z-tp2.z,2));
    }
    
    void OnTriggerStay(Collider collision)
    {
        if (grabbed){
            return;
        }
        grabbed_ob=collision.gameObject;
        Vector3 temp_vec=grabbed_ob.transform.position;
        float temp_dis=dis_form(temp_vec,hand.transform.position);
        if (temp_dis>closest){
            return;
        }
        grabbed_rig=grabbed_ob.GetComponent<Rigidbody>();
        inside=true;
    }

    void OnTriggerExit(Collider collision){
        if (collision.gameObject==grabbed_ob){
            inside=false;
            grabbed=false;
            grabbed_ob.transform.parent=null;
            grabbed_rig.useGravity=true;
        }
    }

    // Update is called once per frame
    void Update()
    {
        float trigger_grip=grip.action.ReadValue<float>();
        float trigger_grab=grab.action.ReadValue<float>();
        if (grabbed){
            if (trigger_grip<.5&&trigger_grab<.5){
                grabbed=false;
                grabbed_ob.transform.parent=null;
                grabbed_rig.useGravity=true;
                return;
            }
            grabbed_rig.velocity=new Vector3(0,0,0);
            grabbed_rig.angularVelocity=new Vector3(0,0,0);

        }else if ((trigger_grip>.5||trigger_grab>.5)&&inside){
            grabbed_ob.transform.parent=hand.transform; 
            grabbed_rig.useGravity=false;
            grabbed_rig.velocity=new Vector3(0,0,0);
            grabbed_rig.angularVelocity=new Vector3(0,0,0);
            grabbed=true;
        }else{
            return;
        }
    }
}
