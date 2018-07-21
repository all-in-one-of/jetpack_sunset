using System;

namespace Assets.MaterializeFX.Scripts
{
    internal static class MfxExtensions
    {
        private const string MfxStandardShaderName = "QFX/MFX/Uber/Standard";
        private const string MfxStandardSpecularShaderName = "QFX/MFX/Uber/Standard Specular";

        private const string MfxAseStandardShaderName = "QFX/MFX/ASE/Uber/Standard";
        private const string MfxAseStandardSpecularShaderName = "QFX/MFX/ASE/Uber/Standard Specular";

        public static string GetShaderName(this MfxShaderType mfxShaderType)
        {
            switch (mfxShaderType)
            {
                case MfxShaderType.UberStandard:
                    return MfxStandardShaderName;
                case MfxShaderType.UberStandardSpecular:
                    return MfxStandardSpecularShaderName;
                case MfxShaderType.AseUberStandard:
                    return MfxAseStandardShaderName;
                case MfxShaderType.AseUberStandardSpecular:
                    return MfxAseStandardSpecularShaderName;
                default:
                    throw new ArgumentOutOfRangeException("mfxShaderType", mfxShaderType, null);
            }
        }
    }
}