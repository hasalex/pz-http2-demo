package fr.sewatech.boot;

import io.undertow.Undertow;
import io.undertow.UndertowOptions;

import javax.net.ssl.*;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyStore;

public class UndertowApp {
    public static void main(String[] args) throws Exception {


        SSLContext sslContext = createSSLContext(loadKeyStore("server.keystore"), loadKeyStore("server.truststore"));
        Undertow server = Undertow.builder()
                .setServerOption(UndertowOptions.ENABLE_HTTP2, true)
                .addHttpsListener(8443, "0.0.0.0", sslContext)
                .build();
    }

    private static KeyStore loadKeyStore(String name) throws Exception {
        String storeLoc = System.getProperty(name);
        final InputStream stream;
        if (storeLoc == null) {
            stream = UndertowApp.class.getResourceAsStream(name);
        } else {
            stream = Files.newInputStream(Paths.get(storeLoc));
        }

        try (InputStream is = stream) {
            KeyStore loadedKeystore = KeyStore.getInstance("JKS");
            loadedKeystore.load(is, "password".toCharArray());
            return loadedKeystore;
        }
    }

    private static SSLContext createSSLContext(final KeyStore keyStore, final KeyStore trustStore) throws Exception {
        KeyManager[] keyManagers;
        KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
        keyManagerFactory.init(keyStore, "password".toCharArray());
        keyManagers = keyManagerFactory.getKeyManagers();

        TrustManager[] trustManagers;
        TrustManagerFactory trustManagerFactory = TrustManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
        trustManagerFactory.init(trustStore);
        trustManagers = trustManagerFactory.getTrustManagers();

        SSLContext sslContext;
        sslContext = SSLContext.getInstance("TLS");
        sslContext.init(keyManagers, trustManagers, null);

        return sslContext;
    }
}
