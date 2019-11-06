/* global forge, asyncTest, askQuestion, ok, start */

module("gallery");

if (forge.file && forge.request) {
    var upload_url = "https://httpbin.org/post";

    asyncTest("gallery.getImages upload", 1, function() {
        forge.gallery.getImages(function (files) {
            forge.logging.log("getImages returned: " + JSON.stringify(files));
            forge.request.ajax({
                url: upload_url,
                files: files,
                success: function (data) {
                    forge.logging.log("RECEIVED RESPONSE: " + JSON.stringify(data));
                    ok(true, "Success");
                    start();
                },
                error: function (e) {
                    ok(false, "forge.request.ajax failed: " + JSON.stringify(e));
                    start();
                }
            });
        });
    });

}


asyncTest("Attempt to select images", 1, function() {
    forge.gallery.getImages(function (images) {
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
        forge.gallery.getVideos(function (videos) {
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
