import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

fun localProperties(): Properties {
    val properties = Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.reader().use { reader ->
            properties.load(reader)
        }
    }
    return properties
}

val flutterVersionCode: String = localProperties().getProperty("flutter.versionCode") ?: "1"
val flutterVersionName: String = localProperties().getProperty("flutter.versionName") ?: "1.0"
// Read the correct variable name from the root project's extra properties
val kotlinVersion: String = rootProject.extra.get("kotlin_version") as String

android {
    namespace = "com.example.myapp"
    compileSdkVersion(35)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.example.myapp"
        minSdkVersion(21)
        targetSdkVersion(flutter.targetSdkVersion)
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = rootProject.file("../..").path
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlinVersion")
}
