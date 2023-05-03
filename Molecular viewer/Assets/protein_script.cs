using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class protein_script : MonoBehaviour
{
    public GameObject cartoon,ball_n_stick,spacefill,surface,sur_cartoon,sur_ball_n_stick,sur_spacefill,mis_unit_sur,mis_unit_car,mis_unit_sur_n_car,right_hand,left_hand;
    public InputActionProperty stick,left_grab,right_grab,left_grip,right_grip;
    public grab_script left_grab_info,right_grab_info;
    public MeshRenderer instructions;

    private Vector3 base_size,start_scale;
    private Collider protien_collider;
    private Rigidbody rb;
    private float predistance,base_scale,cur_scale;
    private int frame,mode,protein_index,pre_index;
    private bool pre_up_turn,mid_turn,pregrabbed;
    private GameObject rep;
    private UnityEngine.XR.InputDevice left_con;
    // Update is called once per frame
    void Start(){
        rep=Instantiate(cartoon);
        rep.transform.position=new Vector3(0.0F,1.5F,1.0F);
        messure(0);
    }
    float dis_form(Vector3 tp1,Vector3 tp2){
        return Mathf.Sqrt(Mathf.Pow(tp1.x-tp2.x,2)+Mathf.Pow(tp1.y-tp2.y,2)+Mathf.Pow(tp1.z-tp2.z,2));
    }
    void LateUpdate()
    {
        float lgb=left_grab.action.ReadValue<float>();
        float lgp=left_grip.action.ReadValue<float>();
        float rgp=right_grip.action.ReadValue<float>();
        float rgb=right_grab.action.ReadValue<float>();
        
        var leftHandDevices = new List<UnityEngine.XR.InputDevice>();
        UnityEngine.XR.InputDevices.GetDevicesAtXRNode(UnityEngine.XR.XRNode.LeftHand, leftHandDevices);
        if (leftHandDevices.Count==1){
            var left_con=leftHandDevices[0];
            bool padvalue;
            bool A_pressed=Input.GetKeyDown(KeyCode.JoystickButton0);
            if ((left_con.TryGetFeatureValue(UnityEngine.XR.CommonUsages.secondary2DAxisClick, out padvalue)&&padvalue)||A_pressed){
                rep.transform.position=new Vector3(0.0F,1.5F,1.0F);
                cur_scale=start_scale.x;
                rep.transform.localScale=new Vector3(cur_scale,cur_scale,cur_scale);
                instructions.enabled=true;
            }
        }
        bool change=false;
        Vector2 stick_vec=stick.action.ReadValue<Vector2>();
        if (stick_vec.y>0.5&&(frame>90||!pre_up_turn||mid_turn)){
            pre_up_turn=true;
            mid_turn=false;
            pre_index=protein_index;
            protein_index++;
            change=true;
            frame=0;
        }
        else if (stick_vec.y<-0.5&&(frame>90||pre_up_turn||mid_turn)){
            pre_up_turn=false;
            mid_turn=false;
            pre_index=protein_index;
            protein_index--;
            change=true;
            frame=0;
        }
        else if (!mid_turn&&Mathf.Round(stick_vec.y*10)==0){
            mid_turn=true;
        }
        protein_index=(protein_index+10)%10;
        if (change){
            Vector3 temp_locat=rep.transform.position;
            Quaternion temp_rotat=rep.transform.rotation;
            float temp_scale=cur_scale;
            Destroy(rep);
            switch (protein_index){
                case 0:
                if (pre_index==9){
                    temp_scale/=100;
                }
                rep=Instantiate(cartoon);
                break;
                case 1:
                rep=Instantiate(ball_n_stick);
                break;
                case 2:
                rep=Instantiate(spacefill);
                if (pre_index==3){
                    temp_scale/=100;
                }
                break;
                case 3:
                rep=Instantiate(surface);
                if (pre_index==2){
                    temp_scale*=100;
                }
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
                case 7:
                rep=Instantiate(mis_unit_sur);
                break;
                case 8:
                rep=Instantiate(mis_unit_car);
                break;
                case 9:
                if (pre_index==0){
                    temp_scale*=100;
                }
                rep=Instantiate(mis_unit_sur_n_car);
                break;
            }
            rep.transform.position=temp_locat;
            rep.transform.rotation=temp_rotat;
            messure(protein_index);
            cur_scale=temp_scale;
            rep.transform.localScale=new Vector3(cur_scale,cur_scale,cur_scale);
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

        if ((lgb>.5||lgp>.5)&&(rgb>.5||rgp>.5)){
            float new_distance=dis_form(right_hand.transform.position,left_hand.transform.position);
            if (pregrabbed){
                cur_scale+=(new_distance-predistance)*base_scale;
                if (cur_scale<0){
                    cur_scale=start_scale.x;
                }
                rep.transform.localScale=new Vector3(cur_scale,cur_scale,cur_scale);
            }else{
                pregrabbed=true;
            }
            predistance=new_distance;
        }else{
            pregrabbed=false;
        }
        frame++;
    }
    void messure(int pt){
        cur_scale=rep.transform.localScale.x;
        rb=rep.GetComponent<Rigidbody>();
        protien_collider=rep.GetComponent<MeshCollider>();
        base_size=protien_collider.bounds.size;
        base_scale=cur_scale*3/(base_size.x+base_size.y+base_size.z);
        start_scale=rep.transform.localScale;
        if (pt>2&&pt<7){
            start_scale*=100;   
        }

    }
}
