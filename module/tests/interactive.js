module("tribr_multi_image_select");

// In this test we call the example showAlert API method with an example string
asyncTest("Attempt to select images", 1, function() {
	forge.tribr_multi_image_select.getImages(function (images) {
		askQuestion("Are these the images you selected: " + JSON.stringify(images), {
			Yes: function () {
				ok(true, "User claims success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	}, function () {
		ok(false, "API method returned failure");
		start();
	});
});
