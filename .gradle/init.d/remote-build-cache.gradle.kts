import org.gradle.caching.http.HttpBuildCache
import java.io.IOException
import java.net.InetSocketAddress
import java.net.Socket

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

val cacheAvailable = isCacheReachable()

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
                    username = System.getenv("GRADLE_CACHE_USER")
                    password = System.getenv("GRADLE_CACHE_PASSWORD")
                }
                // isAllowUntrustedServer = false
            }
        }
    }
}

gradle.buildFinished {
    if (!cacheAvailable) {
        logger.lifecycle("Remote build cache unreachable at $cacheHost — using local cache only.")
    }
}
