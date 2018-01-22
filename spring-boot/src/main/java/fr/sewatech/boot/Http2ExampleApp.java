package fr.sewatech.boot;

import io.undertow.Undertow;
import io.undertow.UndertowOptions;
import org.apache.coyote.http2.Http2Protocol;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingClass;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.context.embedded.tomcat.TomcatConnectorCustomizer;
import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
import org.springframework.boot.context.embedded.undertow.UndertowBuilderCustomizer;
import org.springframework.boot.context.embedded.undertow.UndertowEmbeddedServletContainerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@EnableAutoConfiguration
public class Http2ExampleApp {

    @RequestMapping("/hello")
    public String hello() {
        return "Hello World!\n";
    }

    @Configuration
    @ConditionalOnMissingClass(TomcatConfiguration.UNDERTOW)
    static class TomcatConfiguration {
        private static final String UNDERTOW = "io.undertow.Undertow";

        @Bean
        public EmbeddedServletContainerCustomizer tomcatCustomizer(TomcatEmbeddedServletContainerFactory tomcat) {
            return container -> {
                TomcatConnectorCustomizer customizer =
                        connector -> connector.addUpgradeProtocol(new Http2Protocol());
                tomcat.addConnectorCustomizers(customizer);
            };
        }
    }

    @Configuration
    @ConditionalOnClass(Undertow.class)
    static class UndertowConfiguration {
        @Bean
        public EmbeddedServletContainerCustomizer undertowCustomizer(UndertowEmbeddedServletContainerFactory undertow) {
            return container -> {
                UndertowBuilderCustomizer customizer =
                        builder -> builder.setServerOption(UndertowOptions.ENABLE_HTTP2, true);
                undertow.addBuilderCustomizers(customizer);
            };
        }
    }

    public static void main(String[] args) {
        SpringApplication.run(Http2ExampleApp.class, args);
    }
}
