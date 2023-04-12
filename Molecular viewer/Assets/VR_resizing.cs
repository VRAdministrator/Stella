using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class VR_resizing : MonoBehaviour
{
    public GameObject left_hand,right_hand,surface,ball_n_stick,cartoon,spacefill;
    public InputActionProperty left_grab,right_grab,left_grip,right_grip;
   
    private GameObject protien;
    private Collider protien_collider;
    private Rigidbody rb;
    private float predistance,base_scale,cur_scale;
    private bool pregrabed,pre_A_pressed,pre_B_pressed;
    private Vector3 scaleChange,base_size,start_position,start_scale;
    private int protien_index;

    void Start(){
        protien=Instantiate(ball_n_stick);
        protien_index=1;
        messure();
    }
    void Update()
    {
        float lgb=left_grab.action.ReadValue<float>();
        float lgp=left_grip.action.ReadValue<float>();
        float rgp=right_grip.action.ReadValue<float>();
        float rgb=right_grab.action.ReadValue<float>();
        bool A_pressed=Input.GetKeyDown(KeyCode.JoystickButton0);
        bool B_pressed=Input.GetKeyDown(KeyCode.JoystickButton1);
        if (!A_pressed){
            A_pressed=Input.GetKeyDown(KeyCode.R);
        }
        if (!B_pressed){
            B_pressed=Input.GetKeyDown(KeyCode.C);
        }
        if (B_pressed&&!pre_B_pressed){
            Vector3 temp_locat=protien.transform.position;
            Quaternion temp_rotat=protien.transform.rotation;
            float temp_scale=cur_scale;
            Destroy(protien);
            switch (protien_index){
                case 1:
                protien=Instantiate(cartoon);
                break;
                case 2:
                protien=Instantiate(spacefill);
                break;
                case 3:
                protien=Instantiate(surface);
                break;
                case 4:
                protien=Instantiate(ball_n_stick);
                protien_index=0;
                break;
            }
            messure();
            cur_scale=temp_scale;
            protien.transform.localScale=new Vector3(cur_scale,cur_scale,cur_scale);
            protien.transform.position=temp_locat;
            protien.transform.rotation=temp_rotat;
            protien_index++;
            pre_B_pressed=true;
        }else{
            pre_B_pressed=false;
        }
        if (A_pressed&&!pre_A_pressed){
            protien.transform.localScale=start_scale;
            protien.transform.position=start_position;
            rb.velocity=new Vector3(0,0,0);
            pre_A_pressed=true;
            cur_scale=start_scale.x;
        }else{
            pre_A_pressed=false;
        }
        if ((lgb>.5||lgp>.5)&&(rgb>.5||rgp>.5)){
            float new_distance=Mathf.Sqrt(Mathf.Pow(right_hand.transform.position.y-left_hand.transform.position.y,2)+Mathf.Pow(right_hand.transform.position.x-left_hand.transform.position.x,2)+Mathf.Pow(right_hand.transform.position.z-left_hand.transform.position.z,2));
            if (pregrabed){
                cur_scale+=(new_distance-predistance)*base_scale;
                if (cur_scale<0){
                    cur_scale=start_scale.x;
                }
                protien.transform.localScale=new Vector3(cur_scale,cur_scale,cur_scale);
            }else{
                pregrabed=true;
            }
            predistance=new_distance;
        }else{
            pregrabed=false;
        }
    }
     void messure(){
        cur_scale=protien.transform.localScale.x;
        rb=protien.GetComponent<Rigidbody>();
        protien_collider=protien.GetComponent<MeshCollider>();
        base_size=protien_collider.bounds.size;
        base_scale=cur_scale*3/(base_size.x+base_size.y+base_size.z);
        start_position=protien.transform.position;
        start_scale=protien.transform.localScale;
    }
}
