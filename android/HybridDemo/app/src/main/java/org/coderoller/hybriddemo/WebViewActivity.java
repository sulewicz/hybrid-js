package org.coderoller.hybriddemo;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

public class WebViewActivity extends AppCompatActivity {
    public static final String PARAM_URL = "PARAM_URL";
    private static final String WEBVIEW_SCHEME = "webview://";
    private static final String ALERT_SCHEME = "alert://";
    private WebView mWebView;
    private WebViewClient mWebViewClient = new CustomWebViewClient();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webview);
        mWebView = findViewById(R.id.webview);
        mWebView.setWebViewClient(mWebViewClient);
        final String url = getIntent().getStringExtra(PARAM_URL);
        if (url != null) {
            mWebView.loadUrl(url);
        }
    }

    @Override
    public void onBackPressed() {
        if (mWebView.canGoBack()) {
            mWebView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    private static class CustomWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (url.startsWith(WEBVIEW_SCHEME)) {
                Context context = view.getContext();
                Intent intent = new Intent(context, WebViewActivity.class);
                intent.putExtra(WebViewActivity.PARAM_URL, "file:///android_asset/" + url.substring(WEBVIEW_SCHEME.length()));
                context.startActivity(intent);
                return true;
            } else if (url.startsWith(ALERT_SCHEME)) {
                Context context = view.getContext();
                String message = url.substring(ALERT_SCHEME.length());
                Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
                return true;
            }
            return super.shouldOverrideUrlLoading(view, url);
        }
    }
}
