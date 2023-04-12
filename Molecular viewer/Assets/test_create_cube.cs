using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class test_create_cube : MonoBehaviour
{
    public GameObject cube;
    public Transform parent;
    // Start is called before the first frame update
    void Start()
    {
        GameObject temp_cube=Instantiate(cube,parent);
        temp_cube.transform.position=new Vector3(0,0,0)+parent.transform.position;
    }
}
