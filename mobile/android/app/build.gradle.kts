import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing key — gitignored (key.properties + the .jks it points to).
// Google Sign-In is tied to the SHA-1 of whatever key signs the APK, so this
// has to be a *fixed* key reused by every release build (local or CI), never
// the auto-generated debug key (which is random per machine/runner and would
// break Sign-In — that's what happened with the first CI-built APK).
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.patrickcaloriocarvalho.strideclash"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.patrickcaloriocarvalho.strideclash"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Falls back to the debug key when key.properties isn't present
            // (a contributor's machine without the release keystore) so the
            // build still works — just won't produce a Sign-In-capable APK.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }

    lint {
        // AGP's "lint vital" pass on this setup throws a tooling-level
        // NumberFormatException ("For input string: 37.2") in every plugin's
        // release build, unrelated to any actual lint finding in our code —
        // skip it so `assembleRelease` can complete.
        checkReleaseBuilds = false
        abortOnError = false
    }
}

flutter {
    source = "../.."
}
