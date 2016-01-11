import ceylon.interop.java {
	javaString
}
import ceylon.test {
	fail
}

import java.util {
	JArrays=Arrays
}

import org.jbehave.core.annotations {
	\igiven,
	named,
	when,
	\ithen
}
import org.jbehave.core.configuration {
	MostUsefulConfiguration,
	Configuration
}
import org.jbehave.core.embedder {
	Embedder
}
import org.jbehave.core.io {
	LoadFromURL,
	StoryLoader,
	InvalidStoryResource
}
import org.jbehave.core.steps {
	Steps
}
import ceylon.logging {
	logger,
	Logger
}

Logger log = logger(`package`) ;

shared class ExampleSteps() extends Steps() {
	
	variable Integer x = 0;
	Configuration updatedConfiguration = MostUsefulConfiguration();
	updatedConfiguration.useStoryLoader(LoadFromURL());
	
	shared actual Configuration configuration(){
		return updatedConfiguration;
	}
	
	\igiven ("a variable x with value $value")
	shared void givenXValue(
		named ("value")
		Integer val) {
		log.info("X set to ``val``");
		x = val;
	}
	
	when ("multiply x by $value")
	shared void whenImultiplyXBy(
		named ("value")
		Integer val) {
		log.info("X multiplied by ``val``");
		x = x * val;
	}
	
	\ithen ("x should equal $value")
	shared void thenXshouldBe(
		named ("value")
		Integer val) {
		if (val != x) {
			fail("x is ``x``, but should be ``val``");
		}
		log.info("X asserted to be ``val``");
	}
}

object ceylonStoryLoader satisfies StoryLoader {
	shared actual String? loadResourceAsText(String? string) => loadStoryAsText(string);
	
	shared actual String? loadStoryAsText(String? string)  {		
		if (exists string) {
			Resource? resource = `module`.resourceByPath(string);
			if (exists resource){
				return resource.textContent();
			}
			throw InvalidStoryResource(string, null);
		}	
		return null;
	}
		
}

shared class SimpleJBehave(String story) {
	//initializeLogging();
	variable Embedder embedder = Embedder();
	// Default storyLoader (LoadFromClasspath) does not work with Ceylon classPath, so changed 
	value ceylonConfiguration = MostUsefulConfiguration();
	ceylonConfiguration.useStoryLoader(ceylonStoryLoader);
	embedder.useConfiguration(ceylonConfiguration);
	
	value storyPaths = JArrays.asList(
		javaString(story) 
	);
	embedder.candidateSteps().add(ExampleSteps());
	embedder.runStoriesAsPaths(storyPaths);
}

shared void run() {
	SimpleJBehave("example.story");
}


//shared
//void initializeLogging() {
//	// include the MDC value "userId"
//	value pattern = "%-5p [%t:%X{step}] (%F:%L) - %m%n";
//	
//	// setup Log4j programmatically
//	value console = ConsoleAppender();
//	console.layout = PatternLayout(pattern);
//	console.threshold = Level.\iTRACE;
//	console.activateOptions();
//	JLog4jLogger.rootLogger.addAppender(console);
//	JLog4jLogger.rootLogger.level=Level.\iINFO;
//	
//	// use log4j for:
//	//      ceylon.logging::logger
//	//      com.vasileff.jl4c.log4j::mdc
//	useLog4jLogging();
//}
