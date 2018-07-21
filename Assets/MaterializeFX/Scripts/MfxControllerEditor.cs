#if UNITY_EDITOR
using System.Globalization;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Assets.MaterializeFX.Scripts
{
    [CustomEditor(typeof(MfxController))]
    internal sealed class MfxControllerEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            var mfxController = (MfxController)target;

            // Modify children
            EditorGUILayout.Separator();
            mfxController.ModifyChildren = EditorGUILayout.Toggle(MfxEditorLocalization.ModifyChildrenLabel, mfxController.ModifyChildren);

            // Target object
            mfxController.TargetObject = (GameObject)EditorGUILayout.ObjectField(MfxEditorLocalization.TargetObjectLabel, mfxController.TargetObject, typeof(GameObject), true);

            ShowByDistanceUi(mfxController);

            if (!mfxController.ByDistance)
                ShowMaskOffsetUi(mfxController);

            ShowReplaceMaterialsUi(mfxController);

            if (GUI.changed)
            {
                EditorUtility.SetDirty((MfxController)target);
                EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            }
        }

        private static void ShowByDistanceUi(MfxController mfxController)
        {
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField(MfxEditorLocalization.DistanceParamsLabel, EditorStyles.boldLabel);

            // ReplaceMaterials depending on the distance
            mfxController.ByDistance = EditorGUILayout.Toggle(MfxEditorLocalization.ByDistanceLabel, mfxController.ByDistance);

            // Object To Calculate Distance
            if (mfxController.ByDistance)
                mfxController.DistanceBasedObject = (GameObject)EditorGUILayout.ObjectField(MfxEditorLocalization.DistanceBasedObjectLabel, mfxController.DistanceBasedObject, typeof(GameObject), true);
        }

        private static void ShowReplaceMaterialsUi(MfxController mfxController)
        {
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField(MfxEditorLocalization.ReplaceMaterialParamsLabel, EditorStyles.boldLabel);

            mfxController.ReplaceMaterial =
                EditorGUILayout.Toggle(MfxEditorLocalization.ReplaceMaterialLabel, mfxController.ReplaceMaterial);

            if (mfxController.ReplaceMaterial)
            {
                // Shader type
                mfxController.MfxShaderType = (MfxShaderType)EditorGUILayout.EnumPopup(MfxEditorLocalization.ShaderTypeLabel, mfxController.MfxShaderType);

                mfxController.MfxMaterial = (Material)EditorGUILayout.ObjectField(MfxEditorLocalization.MaterialLabel, mfxController.MfxMaterial, typeof(Material), true);

                mfxController.ReplaceMaterialMode = EditorGUILayout.Toggle(MfxEditorLocalization.ReplaceMaterialInEditorLabel, mfxController.ReplaceMaterialMode);

                if (mfxController.ReplaceMaterialMode)
                {
                    if (GUILayout.Button(MfxEditorLocalization.ReplaceMaterialButton))
                    {
                        if (mfxController.MfxMaterial == null)
                            Debug.LogWarning("template mfx materials is not selected");
                        else
                        {
                            var targetObject = mfxController.Target;

                            MfxMaterialUtil.ReplaceRenderersMaterials(mfxController.MfxMaterial, targetObject, mfxController.MfxShaderType, true);
                        }
                    }
                }
            }
        }

        private static void ShowMaskOffsetUi(MfxController mfxController)
        {
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField(MfxEditorLocalization.MfxParamsLabel, EditorStyles.boldLabel);

            mfxController.MaskOffsetDirection = (MaskOffsetDirection)EditorGUILayout.EnumPopup(MfxEditorLocalization.MaskOffsetDirection, mfxController.MaskOffsetDirection);
            mfxController.MaskOffsetCurve = EditorGUILayout.CurveField(MfxEditorLocalization.MaskOffsetCurve, mfxController.MaskOffsetCurve);
            mfxController.ScaleTimeFactor = float.Parse(EditorGUILayout.TextField(MfxEditorLocalization.ScaleTimeLabel, mfxController.ScaleTimeFactor.ToString(CultureInfo.InvariantCulture)));
            mfxController.ScaleOffsetFactor = float.Parse(EditorGUILayout.TextField(MfxEditorLocalization.ScalePositionLabel, mfxController.ScaleOffsetFactor.ToString(CultureInfo.InvariantCulture)));
        }

        private static class MfxEditorLocalization
        {
            public const string ShaderTypeLabel = "Shader Type";

            public const string TargetObjectLabel = "Target Object";
            public const string ModifyChildrenLabel = "Modify Children";
            public const string DistanceParamsLabel = "Distance Params";
            public const string ByDistanceLabel = "Depending on the distance";
            public const string DistanceBasedObjectLabel = "Object to calcualte distance";

            public const string MfxParamsLabel = "Mfx Params";
            public const string MaskOffsetDirection = "Mask Direction";
            public const string MaskOffsetCurve = "Mask Offset Curve";
            public const string ScaleTimeLabel = "Scale Time Factor";
            public const string ScalePositionLabel = "Scale Offset Factor";

            public const string ReplaceMaterialParamsLabel = "Replace Material Params";
            public const string ReplaceMaterialLabel = "Replace Material";
            public const string ReplaceMaterialInEditorLabel = "Replace in Editor";
            public const string ReplaceMaterialButton = "Copy & Replace";
            public const string MaterialLabel = "Mfx Material Template";
        }
    }
}
#endif