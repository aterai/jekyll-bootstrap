---
layout: post
category: swing
folder: FormSubmitEvent
title: JEditorPaneに表示されたフォームからの送信データを取得する
tags: [JEditorPane, HTML, HTMLEditorKit]
author: aterai
pubdate: 2019-01-28T16:21:00+09:00
description: JEditorPaneに表示されたフォームの送信データを取得し、パーセントエンコーディングされた文字列をデコードします。
image: https://drive.google.com/uc?id=1yNsrqYvmMYj9LVvDEEoyCpo-jKwfVcylKg
comments: true
---
## 概要
`JEditorPane`に表示されたフォームの送信データを取得し、パーセントエンコーディングされた文字列をデコードします。

{% download https://drive.google.com/uc?id=1yNsrqYvmMYj9LVvDEEoyCpo-jKwfVcylKg %}

## サンプルコード
<pre class="prettyprint"><code>JEditorPane editor = new JEditorPane();
HTMLEditorKit kit = new HTMLEditorKit();
kit.setAutoFormSubmission(false);
editor.setEditorKit(kit);
editor.setEditable(false);

String form = "&lt;form action='#'&gt;&lt;input type='text' name='word' value='' /&gt;&lt;/form&gt;";
editor.setText("&lt;html&gt;&lt;h1&gt;Form test&lt;/h1&gt;" + form);
editor.addHyperlinkListener(e -&gt; {
  if (e instanceof FormSubmitEvent) {
    String data = ((FormSubmitEvent) e).getData();
    logger.append(data + "\n");

    String charset = Charset.defaultCharset().toString();
    logger.append("default charset: " + charset + "\n");

    try {
      String txt = URLDecoder.decode(data, charset);
      logger.append(txt + "\n");
    } catch (UnsupportedEncodingException ex) {
      ex.printStackTrace();
      logger.append(ex.getMessage() + "\n");
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JEditorPane`に表示されたフォームの送信データを`HyperlinkListener`で取得し、`application/x-www-form-urlencoded`形式でパーセントエンコーディングされた文字列をデコードするテストを行っています。

- `HTMLEditorKit#setAutoFormSubmission(false)`で`html`フォームの送信を自動的に処理ではなく、`FormSubmitEvent`がトリガーされるように設定して`HyperlinkListener`でデータを取得
- `<form>`要素に`action='#'`のような属性の指定がない場合、`NullPointerException`が発生する？
    - [java - Making HyperlinkListener Work with JeditorPane NullPointerException - Stack Overflow](https://stackoverflow.com/questions/27131420/making-hyperlinklistener-work-with-jeditorpane-nullpointerexception)
- フォームの送信データは`java -Dfile.encoding=UTF-8 ...`などで指定したファイルエンコーディングに基づいてパーセントエンコーディングされている
    - このサンプルではファイルエンコーディングを`UTF-8`に設定しているが、日本語Windows環境のデフォルトでは`Shift_JIS`(`windows-31j`)のためその範囲外の文字は文字化けする
- `application/x-www-form-urlencoded`形式でパーセントエンコーディングされているので、半角スペースは`%20`ではなく`+`に符号化されている

<!-- dummy comment line for breaking list -->

## 参考リンク
- [FormSubmitEvent (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/FormSubmitEvent.html)
- [HTMLEditorKit#setAutoFormSubmission(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/HTMLEditorKit.html#setAutoFormSubmission-boolean-)
- [URLDecoder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/net/URLDecoder.html)
- [Charset#defaultCharset() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/nio/charset/Charset.html#defaultCharset--)
- [java - Making HyperlinkListener Work with JeditorPane NullPointerException - Stack Overflow](https://stackoverflow.com/questions/27131420/making-hyperlinklistener-work-with-jeditorpane-nullpointerexception)
- [submitイベントでフォームの入力内容を取得](https://pieceofnostalgia-bd472.firebaseapp.com/java/jeditorpane_submit.html)

<!-- dummy comment line for breaking list -->

## コメント
