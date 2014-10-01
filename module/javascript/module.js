// Expose the native API to javascript
forge.tribr_multi_image_select = {
    getImages: function (success, error) {
        forge.internal.call('tribr_multi_image_select.getImages', {}, success, error);
    }
};
