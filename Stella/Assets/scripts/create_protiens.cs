using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class create_protiens : MonoBehaviour
{
    public GameObject pro1,pro2;
    private bool prepressed,type;
    private GameObject temp_pro;
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T)){
            if (!prepressed){
                prepressed=true;
                if (type){
                    Destroy(temp_pro);
                    temp_pro=Instantiate(pro1);
                    type=false;
                }else{
                    Destroy(temp_pro);
                    temp_pro=Instantiate(pro2);
                    type=true;
                }
            }
        }else{
            prepressed=false;
        }
    }
}
