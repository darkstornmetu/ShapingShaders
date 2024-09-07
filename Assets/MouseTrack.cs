using UnityEngine;

public class MouseTrack : MonoBehaviour
{
    private Material material;
    private Camera cam;

    private Ray ray;
    private RaycastHit hit;

    private void Awake()
    {
        cam = Camera.main;
        material = GetComponent<MeshRenderer>().sharedMaterial;
    }

    private void Update()
    {
        if (Input.GetMouseButton(0))
        {
            ray = cam.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out hit))
                material.SetVector("_Center", hit.textureCoord);
        }
    }
}
