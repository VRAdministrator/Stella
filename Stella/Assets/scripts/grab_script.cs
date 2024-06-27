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
    public MeshRenderer instructions;
    public bool before_grabbed;
    public bool grabbed;

    float dis_form(Vector3 tp1,Vector3 tp2){
        return Mathf.Sqrt(Mathf.Pow(tp1.x-tp2.x,2)+Mathf.Pow(tp1.y-tp2.y,2)+Mathf.Pow(tp1.z-tp2.z,2));
    }
    
    void OnTriggerStay(Collider collision)
    {
        if (grabbed){
            return;
        }
        float trigger_grip=grip.action.ReadValue<float>();
        float trigger_grab=grab.action.ReadValue<float>();
        if (trigger_grip>.5||trigger_grab>.5){
            grabbed_ob=collision.gameObject;
            grabbed_ob.transform.parent=hand.transform; 
            grabbed_rig=grabbed_ob.GetComponent<Rigidbody>();
            grabbed_rig.useGravity=false;
            grabbed_rig.isKinematic=false;
            grabbed=true;
        }
    }

    void OnTriggerExit(Collider collision){
        if (collision.gameObject==grabbed_ob){
            grabbed=false;
            grabbed_ob.transform.parent=null;
            grabbed_rig.useGravity=false;
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
                grabbed_rig.useGravity=false;
                grabbed_rig.isKinematic=true;
                return;
            }
            grabbed_rig.velocity=new Vector3(0,0,0);
            grabbed_rig.angularVelocity=new Vector3(0,0,0);
            if (!before_grabbed){
                before_grabbed=true;
                instructions.enabled=false;
            }

        }
    }
}
