/* global forge */

forge.gallery = {
    getImages: function (success, error) {
        forge.internal.call("gallery.getImages", {}, success, error);
    },
    getVideos: function (success, error) {
        forge.internal.call("gallery.getVideos", {}, success, error);
    }
};
