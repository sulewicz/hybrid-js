package org.coderoller.hybriddemo;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.liquidplayer.webkit.javascriptcore.JSContext;
import org.liquidplayer.webkit.javascriptcore.JSFunction;

public class JSRuntimeActivity extends AppCompatActivity {
    private JSContext mJSContext;
    private LinearLayout mContent;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_js);
        mContent = findViewById(R.id.content);

        findViewById(R.id.run_js_button).setOnClickListener(mListener);

        mJSContext = new JSContext();
        JSFunction labelFactory = new JSFunction(mJSContext,"createLabel") {
            public void createLabel(final String label) {
                JSRuntimeActivity.this.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        TextView view = new TextView(JSRuntimeActivity.this);
                        view.setText(label);
                        view.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                        mContent.addView(view);
                    }
                });
            }
        };
        mJSContext.property("createLabel", labelFactory);
    }

    private final View.OnClickListener mListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.run_js_button:
                    mJSContext.evaluateScript("createLabel(\"Label " + mContent.getChildCount() + "\");");
                    break;
            }
        }
    };
}
