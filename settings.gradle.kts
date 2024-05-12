import java.util.Locale

pluginManagement {
    repositories {
        gradlePluginPortal()
        maven("https://repo.papermc.io/repository/maven-public/")
    }
}

plugins {
    id("org.gradle.toolchains.foojay-resolver-convention") version "0.8.0"
}

if (!file(".git").exists()) {
    val errorText = """
        
        =====================[ ERROR ]=====================
         The LinearPaper project directory is not a properly cloned Git repository.
         
         In order to build LinearPaper from source you must clone
         the repository using Git, not download a code zip from GitHub.
        ===================================================
    """.trimIndent()
    error(errorText)
}

rootProject.name = "linearpaper"
for (name in listOf("LinearPaper-API", "LinearPaper-Server")) {
    val projName = name.lowercase(Locale.ENGLISH)
    include(projName)
    findProject(":$projName")!!.projectDir = file(name)
}
