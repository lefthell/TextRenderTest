using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TextTest : MonoBehaviour
{
    public GameObject PlanObj;
    public Font MainFont;
    public string Str;
    public int fontSize;
    public float ScaleSize;
    public float FontST_W;
    public float FontST_Z;
    private Vector4 fontST;
    public Color FontColor;

    public Material combineMaterial;
    public RenderTexture TargetRenderTexture;

    public void RefreshFlagTexture()
    {
        if (TargetRenderTexture != null&& combineMaterial!=null)
        {
            SetFontData();
            Graphics.Blit(null, TargetRenderTexture, combineMaterial);
        }
    }

    public void SetFontData()
    {
        if (MainFont != null && !string.IsNullOrEmpty(Str))
        {
            CharacterInfo info;
            MainFont.RequestCharactersInTexture(Str, fontSize);
            MainFont.GetCharacterInfo(Str[0], out info, fontSize);

            Vector4 OuterV4 = new Vector4(info.uvBottomLeft.x, info.uvBottomRight.y, info.uvTopRight.x, info.uvTopLeft.y);

            float width = info.maxX - info.minY;
            float height = info.maxY - info.minY;
            float a = 1;
            float b = 1;
            if (Mathf.Abs(info.uvBottomLeft.x - info.uvBottomRight.x) < 0.0001)
            {
                b = width / height;
                combineMaterial.SetInt("_Flag", 1);
            }
            else
            {
                a = width / height;
                combineMaterial.SetInt("_Flag", 0);
            }
            combineMaterial.SetTexture("_FontTex", MainFont.material.mainTexture);
            combineMaterial.SetVector("_FontTex_RG", OuterV4);
            fontST = new Vector4(ScaleSize * a, ScaleSize * b, FontST_W,FontST_Z);
            combineMaterial.SetVector("_FontTex_ST", fontST);
            combineMaterial.SetColor("_FontColor", FontColor);
        }
    }
    // Update is called once per frame
    void Update()
    {
        RefreshFlagTexture();
    }
}
