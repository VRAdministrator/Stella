using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class protein_script : MonoBehaviour
{
    public GameObject cartoon,ball_n_stick,spacefill,surface,sur_cartoon,sur_ball_n_stick,sur_spacefill;
    public InputActionProperty stick;
    public grab_script left_grab_info,right_grab_info;
    
    private int frame,mode,protein_index;
    private bool pre_up_turn,mid_turn;
    private GameObject rep;
    // Update is called once per frame
    void Start(){
        rep=Instantiate(cartoon);
        rep.transform.position=new Vector3(0.0F,1.5F,1.0F);
    }
    
    void LateUpdate()
    {
        bool change=false;
        Vector2 stick_vec=stick.action.ReadValue<Vector2>();
        if (stick_vec.y>0.5&&(frame>90||!pre_up_turn||mid_turn)){
            pre_up_turn=true;
            mid_turn=false;
            protein_index++;
            change=true;
            frame=0;
        }
        else if (stick_vec.y<-0.5&&(frame>90||pre_up_turn||mid_turn)){
            pre_up_turn=false;
            mid_turn=false;
            protein_index--;
            change=true;
            frame=0;
        }
        else if (!mid_turn&&Mathf.Round(stick_vec.y*10)==0){
            mid_turn=true;
        }
        protein_index=(protein_index+7)%7;
        if (change){
            Vector3 temp_locat=rep.transform.position;
            Quaternion temp_rotat=rep.transform.rotation;
            Destroy(rep);
            switch (protein_index){
                case 0:
                rep=Instantiate(cartoon);
                break;
                case 1:
                rep=Instantiate(ball_n_stick);
                break;
                case 2:
                rep=Instantiate(spacefill);
                break;
                case 3:
                rep=Instantiate(surface);
                break;
                case 4:
                rep=Instantiate(sur_cartoon);
                break;
                case 5:
                rep=Instantiate(sur_ball_n_stick);
                break;
                case 6:
                rep=Instantiate(sur_spacefill);
                break;
            }
            rep.transform.position=temp_locat;
            rep.transform.rotation=temp_rotat;
            if (right_grab_info.grabbed){
                right_grab_info.grabbed_ob=rep;
                right_grab_info.grabbed_rig=rep.GetComponent<Rigidbody>();
                right_grab_info.grabbed_rig.useGravity=false;
                rep.transform.parent=right_grab_info.hand.transform;
            }
            if (left_grab_info.grabbed){
                left_grab_info.grabbed_ob=rep;
                left_grab_info.grabbed_rig=rep.GetComponent<Rigidbody>();
                left_grab_info.grabbed_rig.useGravity=false;
                rep.transform.parent=left_grab_info.hand.transform;
            }

        }



        frame++;
    }
}
