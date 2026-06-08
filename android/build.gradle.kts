allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Fix: AGP 8+ requires namespace on all library modules.
// Some older packages (e.g. flutter_windowmanager 0.2.0) don't specify one.
// plugins.withId is evaluation-safe and avoids the "already evaluated" error.
subprojects {
    plugins.withId("com.android.library") {
        val android = extensions
            .findByType(com.android.build.gradle.LibraryExtension::class.java)
            ?: return@withId
        if (android.namespace == null) {
            android.namespace = project.group?.toString() ?: "com.futurebank"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
