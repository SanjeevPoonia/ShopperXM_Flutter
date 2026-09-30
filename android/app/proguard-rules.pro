# ML Kit full fix (IMPORTANT)
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.common.** { *; }

# Google internal MLKit
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_common.** { *; }

# Kotlin metadata (important for your error)
-keep class kotlin.Metadata { *; }

# keep annotations
-keepattributes *Annotation*