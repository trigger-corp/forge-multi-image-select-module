package io.trigger.forge.android.modules.gallery;

import io.trigger.forge.android.core.ForgeApp;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.provider.MediaStore;
import android.widget.ImageView;

import java.lang.ref.WeakReference;


class LazyImageView extends ImageView {

	private int     imageId;
	private boolean isActual = false;
	private Bitmap  placeholder;
	private Bitmap  errorBitmap;


	public LazyImageView(Context context, int imageId, Bitmap placeholder, Bitmap errorBitmap) {
		super(context);
		this.imageId     = imageId;
		this.placeholder = placeholder;
		this.errorBitmap = errorBitmap;
		this.setImageBitmap(placeholder);
	}


	private static class ThumbnailTask extends AsyncTask<Object, Object, Object> {
        private WeakReference<LazyImageView> contextRef;

        ThumbnailTask(LazyImageView context) {
            this.contextRef = new WeakReference<>(context);
        }

        @Override
        protected String doInBackground(Object... params) {
            final LazyImageView context = contextRef.get();
            try {
                if (!context.isActual) {
                    return null;
                }
                final Bitmap thumb = MediaStore.Images.Thumbnails.getThumbnail(ForgeApp.getActivity().getContentResolver(),
                                                                               context.imageId,
                                                                               MediaStore.Images.Thumbnails.MINI_KIND,
                                                                               null);

                if (thumb != null && thumb.getWidth() > 0 && thumb.getHeight() > 0) {
                    final Bitmap bm = Bitmap.createBitmap(thumb,
                                                          0,
                                                          0,
                                                          Math.min(200, thumb.getWidth()),
                                                          Math.min(200, thumb.getHeight()));

                    ForgeApp.getActivity().runOnUiThread(new Runnable() {
                        public void run() {
                            context.setImageBitmap(bm);
                        }
                    });

                } else {
                    ForgeApp.getActivity().runOnUiThread(new Runnable() {
                        public void run() {
                            context.setImageBitmap(context.errorBitmap);
                        }
                    });
                }
            } catch (Exception e) {
            }

            context.setTag(null);

            return null;
        }
	}


    public void showIfRequired() {
        final LazyImageView self = this;
        int[] position = new int[2];
        this.getLocationOnScreen(position);

        if (-1000 < position[1] && 2000 > position[1]) {
            if (!isActual) {
                isActual = true;
                AsyncTask task = new ThumbnailTask(self).execute();
                self.setTag(task);
            }

        } else {
            if (isActual) {
                isActual = false;

                new Thread(new Runnable() {
                    public void run() {
                        if (self.getTag() != null) {
                            AsyncTask task = (AsyncTask)self.getTag();
                            task.cancel(true);
                            MediaStore.Images.Thumbnails.cancelThumbnailRequest(ForgeApp.getActivity().getContentResolver(), imageId);
                            self.setTag(null);
                        }
                    }
                }).start();

                self.setImageBitmap(placeholder);
            }
        }
    }
}