plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin after Android/Kotlin
    id("com.google.gms.google-services") // For Firebase
}

android {
    namespace = "com.example.flash_chat"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13113456" // Correct as string

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // Optional but good for Java 8+ APIs
    }

    kotlinOptions {
        jvmTarget = "11" // Just set it directly
    }

    defaultConfig {
        applicationId = "com.AbdulSaboor.flash_chat"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Temporary debug signing
            isMinifyEnabled = false // Recommended to disable shrinking for debug
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

    // Firebase core libraries without versions
    implementation("com.google.firebase:firebase-analytics")

    // You can add more Firebase services here
    // Example: implementation("com.google.firebase:firebase-auth")

    // Core library desugaring if needed
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
