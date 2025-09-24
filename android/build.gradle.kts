allprojects {
    repositories {
        maven { url = uri("https://mirrors.tuna.tsinghua.edu.cn/google/maven/") }   // Google Maven 镜像
        maven { url = uri("https://mirrors.tuna.tsinghua.edu.cn/maven-central/") }   // Maven Central 镜像
        maven { url = uri("https://mirrors.tuna.tsinghua.edu.cn/gradle-plugin/") }
        maven { url = uri("https://maven.aliyun.com/repository/google") }         // 替代 google()
        maven { url = uri("https://maven.aliyun.com/repository/central") }        // 替代 mavenCentral()
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
