# Add project specific ProGuard rules here.

# kotlinx.serialization
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt
-keepclassmembers class kotlinx.serialization.json.** { *; }
-keep,includedescriptorclasses class com.example.malwaredetector.**$$serializer { *; }
-keepclassmembers class com.example.malwaredetector.** {
    *** Companion;
}
-keepclasseswithmembers class com.example.malwaredetector.** {
    kotlinx.serialization.KSerializer serializer(...);
}
