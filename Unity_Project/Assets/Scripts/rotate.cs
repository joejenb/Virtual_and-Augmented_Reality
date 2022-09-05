using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotate : MonoBehaviour
{
    public GameObject[] cubes;
    public Vector3 rate;

    // Start is called before the first frame update
    void Start()
    {
        cubes = GameObject.FindGameObjectsWithTag("cube");
        rate.x = rate.x != 0 ? 360.0f / rate.x : rate.x;
        rate.y = rate.y != 0 ? 360.0f / rate.y : rate.y;
        rate.z = rate.z != 0 ? 360.0f / rate.z : rate.z;
        Debug.Log(cubes.Length);
    }

    // Update is called once per frame
    void Update()
    {
        foreach (GameObject cube in cubes)
        {
            cube.transform.Rotate(Time.deltaTime * rate); 
        }
    }
}
