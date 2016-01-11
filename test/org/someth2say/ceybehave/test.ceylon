import ceylon.test {
	test,
	fail
}

test void simpleTest() {
	try {
		SimpleJBehave("example.story");
	} catch (Exception e){
		fail("What? ``e.message``");
	}
}


"Failure is expected"
test void negativeTest() {
	try {
		SimpleJBehave("negative_example.story");
	} catch (Exception e){
		return;
	}
	fail("What?");
}