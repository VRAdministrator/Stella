using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;


public class gen_protein : MonoBehaviour
{
    public GameObject atom_model;
    //public Transform parent; 
    
    private GameObject temp_atom;
    private List<GameObject> Cs,Ns,Os,Ss;


    private static float str_to_float(string str,int start){
        int len=6;
        for (;str[start]==32;){
            len--;
            start++;
        }
        return float.Parse(str.Substring(start,len), System.Globalization.CultureInfo.InvariantCulture)/100;
    }
    // Start is called before the first frame update
    void Start()
    {
        //Rigidbody rigidbody = GetComponent<Transform>();
        //Collider collider=GetComponent<Collider>();
        //rigidbody.isKinematic=true;
        Transform trans=GetComponent<Transform>();
        Cs=new List<GameObject>();
        Ns=new List<GameObject>();
        Os=new List<GameObject>();
        Ss=new List<GameObject>();

        TextAsset textFile=(TextAsset)Resources.Load("test");
        string text=textFile.text;
        int start=0;
        int len_string=text.Length-81;
        float sum=0;
        float total=0;
        //Vector3 offset=collider.bounds.center;
        Vector3 offset=new Vector3(-.7f,1.0f,.8f);
        for (;start<len_string;){  
            if (text.Substring(start,4)=="ATOM"){
                temp_atom=Instantiate(atom_model,trans);
                sum+=str_to_float(text,start+48);
                //temp_atom.transform.position=new Vector3(str_to_float(text,start+32)-0.7218993F,str_to_float(text,start+40)-0.2659971F,str_to_float(text,start+48)-0.1989838F)+offset;
                temp_atom.transform.position=new Vector3(str_to_float(text,start+32),str_to_float(text,start+40),str_to_float(text,start+48))+offset;
                switch (text[start+77]){
                    case (char)67:
                    Cs.Add(temp_atom);
                    temp_atom.GetComponent<Renderer>().material.color=Color.gray;
                    break;
                    case (char)78:
                    Ns.Add(temp_atom);
                    temp_atom.GetComponent<Renderer>().material.color=Color.blue;
                    break;
                    case (char)79:
                    Os.Add(temp_atom);
                    temp_atom.GetComponent<Renderer>().material.color=Color.red;
                    break;
                    case (char)83:
                    Ss.Add(temp_atom);
                    temp_atom.GetComponent<Renderer>().material.color=Color.green;
                    break;
                }
                total++;
                start+=81;
            }else{
                for (;text[start]!=10;){
                    start++;
                }
                start++;
            }
        }
    }
}
