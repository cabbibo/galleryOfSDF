using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class sdfRenderer : MonoBehaviour
{

    public Transform world;


    public MaterialPropertyBlock mpb;
    private Material mat;
    private Renderer render;

    // Start is called before the first frame update
    void Awake()
    {

      render = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
      if(render == null){render = GetComponent<Renderer>();}
      if(mpb== null){mpb = new MaterialPropertyBlock();}
      mpb.SetMatrix("_WTL",world.worldToLocalMatrix);
      mpb.SetMatrix("_LTW",world.localToWorldMatrix);

      render.SetPropertyBlock(mpb);
        
    }
}
