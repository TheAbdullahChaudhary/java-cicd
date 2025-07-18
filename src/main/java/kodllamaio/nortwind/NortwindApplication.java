package kodllamaio.nortwind;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
// Removed springfox imports and @EnableSwagger2 for springdoc-openapi
@SpringBootApplication
public class NortwindApplication {

	public static void main(String[] args) {
		SpringApplication.run(NortwindApplication.class, args);
	}

	// OpenAPI/Swagger UI is auto-configured by springdoc-openapi-starter-webmvc-ui
	// Access it at /swagger-ui.html after running the app
}
