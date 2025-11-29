import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    
}

// Membaca file dev.properties
val devProperties = Properties()
val devPropertiesFile = rootProject.file("dev.properties")
if (devPropertiesFile.exists()) {
    devProperties.load(FileInputStream(devPropertiesFile))
}

val minSdkValue: Int = devProperties.getProperty("minSdk")?.toInt() ?: 21 // Default ke 21 jika tidak ada
val targetSdkValue: Int = devProperties.getProperty("targetSdk")?.toInt() ?: 33 // Default ke 33 jika tidak ada
val compileSdkValue: Int = devProperties.getProperty("compileSdk")?.toInt() ?: flutter.compileSdkVersion // Gunakan flutter.compileSdkVersion sebagai default
val ndkVersionValue: String = devProperties.getProperty("ndkVersion") ?: flutter.ndkVersion // Gunakan flutter.ndkVersion sebagai default

android {
    namespace = "com.bayarbuddy.app"
    compileSdk = compileSdkValue // Menggunakan nilai dari dev.properties
    ndkVersion = ndkVersionValue // Menggunakan nilai dari dev.properties   

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.bayarbuddy.app"
        minSdk = minSdkValue // Menggunakan nilai dari dev.properties
        targetSdk = targetSdkValue // Menggunakan nilai dari dev.properties
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
  implementation(platform("com.google.firebase:firebase-bom:34.5.0"))
  implementation("androidx.multidex:multidex:2.0.1")
  implementation("com.google.firebase:firebase-analytics")
  implementation("androidx.window:window:1.0.0")
  implementation("androidx.window:window-java:1.0.0")
}