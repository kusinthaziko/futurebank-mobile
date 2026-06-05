plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.futurebank.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.futurebank.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    splits {
        abi {
            reset()
            isUniversalApk = true
            include("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }

    signingConfigs {
        create("release") {
            storeFile = System.getenv("FB_KEYSTORE_PATH")?.takeIf { it.isNotBlank() }?.let { file(it) }
            storePassword = System.getenv("FB_KEYSTORE_PASSWORD") ?: ""
            keyAlias = System.getenv("FB_KEY_ALIAS") ?: ""
            keyPassword = System.getenv("FB_KEY_PASSWORD") ?: ""
        }
    }

    buildTypes {
        release {
            signingConfig = if (System.getenv("FB_KEYSTORE_PATH") != null) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
