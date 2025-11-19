import java.io.File

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.24")
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
