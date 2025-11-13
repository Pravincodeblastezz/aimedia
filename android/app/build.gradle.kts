plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Add this for Firebase
}

android {
    namespace = "com.pravin.aimedia"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // ✅ Needed for flutter_local_notifications
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.pravin.aimedia"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // ✅ Helps with large builds
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Flutter + Kotlin stdlib
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.0")

    // ✅ Firebase Messaging
    implementation("com.google.firebase:firebase-messaging:23.3.1")

    // ✅ AndroidX Core
    implementation("androidx.core:core-ktx:1.12.0")

    // ✅ Multidex (optional but recommended)
    implementation("androidx.multidex:multidex:2.0.1")

    // ✅ For flutter_local_notifications (desugaring)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
