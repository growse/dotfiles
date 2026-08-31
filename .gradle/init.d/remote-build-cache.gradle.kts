import org.gradle.caching.http.HttpBuildCache
import java.io.IOException
import java.net.InetSocketAddress
import java.net.Socket
import java.util.Properties

val cacheHost = "gradle-cache.hq.growse.com"
val cachePort = 443
val cacheUrl = "https://$cacheHost/cache/"

fun isCacheReachable(): Boolean =
    try {
        Socket().use { socket ->
            socket.connect(InetSocketAddress(cacheHost, cachePort), 300) // ms timeout
        }
        true
    } catch (e: IOException) {
        false
    }

// GRADLE_USER_HOME/gradle.properties isn't loaded as project properties yet at this point in
// the build lifecycle (no Settings/Project exists), so read it directly. Falls back to the
// GRADLE_CACHE_USER/GRADLE_CACHE_PASSWORD env vars for CI.
val userGradleProperties = Properties().apply {
    val propertiesFile = File(gradle.gradleUserHomeDir, "gradle.properties")
    if (propertiesFile.exists()) {
        propertiesFile.inputStream().use { load(it) }
    }
}

fun credential(propertyName: String, envName: String): String? =
    userGradleProperties.getProperty(propertyName) ?: System.getenv(envName)

val cacheAvailable = isCacheReachable()

if (!cacheAvailable) {
    logger.lifecycle("Remote build cache unreachable at $cacheHost — using local cache only.")
}

beforeSettings {
    buildCache {
        local {
            isEnabled = true
        }
        if (cacheAvailable) {
            remote<HttpBuildCache> {
                url = uri(cacheUrl)
                isPush = true // or false if only CI should push
                credentials {
                    username = credential("gradleCacheUser", "GRADLE_CACHE_USER")
                    password = credential("gradleCachePassword", "GRADLE_CACHE_PASSWORD")
                }
                // isAllowUntrustedServer = false
            }
        }
    }
}
