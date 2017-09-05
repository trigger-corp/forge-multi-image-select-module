module("tribr_multi_image_select");

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


if (forge.is.ios()) {
    asyncTest("Attempt to select videos", 1, function() {
        forge.tribr_multi_image_select.getVideos(function (videos) {
            askQuestion("Are these the videos you selected: " + JSON.stringify(videos), {
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
}
