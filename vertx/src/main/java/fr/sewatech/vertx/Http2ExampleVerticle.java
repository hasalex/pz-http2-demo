package fr.sewatech.vertx;

import io.vertx.core.*;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.HttpServerOptions;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.net.JdkSSLEngineOptions;
import io.vertx.core.net.OpenSSLEngineOptions;
import io.vertx.core.net.PemKeyCertOptions;
import io.vertx.core.net.SSLEngineOptions;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.StaticHandler;

import java.lang.management.ManagementFactory;
import java.util.ArrayList;
import java.util.List;

public class Http2ExampleVerticle extends AbstractVerticle {

    private static final String HOST = "0.0.0.0";
    private static String sslHome;
    private static String siteHome = "../images/160";

    private List<HttpServer> servers = new ArrayList<>();

    @Override
    public void start() {
        startServer(8080, null);         // No SSL
        startServer(8444, new OpenSSLEngineOptions()); // Should not fail
        startServer(8443, new JdkSSLEngineOptions());  // Should fail with Java 8
    }

    private void startServer(int port, SSLEngineOptions sslEngineOptions) {
        try {
            HttpServer server = vertx.createHttpServer(createOptions(port, sslEngineOptions));
            server.requestHandler(createHandler());
            server.listen(this::log);
            servers.add(server);
        } catch (VertxException e) {
            System.out.println("Fail to start server on port "  + port + " : " + e.getMessage());
        }
    }

    @Override
    public void stop(Future<Void> future) {
        servers.forEach(HttpServer::close);
    }

    private Handler<HttpServerRequest> createHandler() {
//        return request -> request.response().end("Hello Vert.x!");
        Router router = Router.router(vertx);
        router.route("/dino.html")
                .handler(event -> event.response().push(HttpMethod.GET, siteHome + "/main.css", response -> {}).sendFile(siteHome + "/dino.html"));
        router.route().handler(StaticHandler.create(siteHome));
        return router::accept;
    }

    private HttpServerOptions createOptions(int port, SSLEngineOptions sslEngineOptions) {
        return new HttpServerOptions()
                .setPort(port)
                .setHost(HOST)
                .setSsl(sslEngineOptions != null)
                .setSslEngineOptions(sslEngineOptions)
                .setUseAlpn(sslEngineOptions != null)
                .setKeyCertOptions(new PemKeyCertOptions().setCertPath(sslHome + "server.crt").setKeyPath(sslHome + "server.key"));
    }

    private void log(AsyncResult<HttpServer> result) {
        if (result.failed()) {
            System.out.println("Fail to start server : " + result.cause().getMessage());
        } else {
            System.out.println("Server successfully started on port " + result.result().actualPort());
        }
    }

    public static void main(String... args) {
        VertxOptions options = new VertxOptions();
        if (ManagementFactory.getRuntimeMXBean()
                .getInputArguments()
                .stream()
                .anyMatch(arg -> arg.startsWith("-agentlib:jdwp"))) {
            options.setBlockedThreadCheckInterval(1_000_000L);
        }

        if (args.length > 0) {
            sslHome = args[0];
        } else {
            sslHome = "";
        }
        Vertx.vertx(options).deployVerticle(Http2ExampleVerticle.class.getName());
        System.out.println("Ready with Java " + System.getProperty("java.version"));
    }

}

/*
Push
h2c => rien à faire !
Jetty ALPN
 */