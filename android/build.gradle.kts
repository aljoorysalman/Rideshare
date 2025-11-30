buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.5.2")
        classpath("com.google.gms:google-services:4.3.15")
        // DO NOT add kotlin-gradle-plugin 2.1.0 (breaks Flutter)
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Kotlin DSL version of setting build directory
rootProject.buildDir = File("../build")

subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
