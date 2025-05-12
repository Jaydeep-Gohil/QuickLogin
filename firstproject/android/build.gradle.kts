// File: android/build.gradle.kts

buildscript {
    repositories {
        google() // Google repository for Firebase & other dependencies
        mavenCentral() // Maven central repository for other dependencies
        jcenter()
    }
    dependencies {
        // Android build tools plugin
        classpath("com.android.tools.build:gradle:8.2.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20")

        // Firebase Google services plugin
        classpath("com.google.gms:google-services:4.4.1")
    }

}

allprojects {
    repositories {
        google() // Google repository
        mavenCentral() // Maven central repository
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
