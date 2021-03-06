---
layout: post
category: swing
folder: SyntaxHighlightingEditorPane
title: JEditorPaneにソースコードをシンタックスハイライトして表示する
tags: [JEditorPane, HTMLEditorKit, StyleSheet]
author: aterai
pubdate: 2018-07-30T03:56:00+09:00
description: JEditorPaneのHTMLEditorKitにStyleSheetを設定して、ソースコードをシンタックスハイライト表示します。
image: https://drive.google.com/uc?id=1b_texG1scFcKnOIcUNUHQPdquKal_Fu6OQ
hreflang:
    href: https://java-swing-tips.blogspot.com/2018/07/syntax-highlighting-source-code-in.html
    lang: en
comments: true
---
## 概要
`JEditorPane`の`HTMLEditorKit`に`StyleSheet`を設定して、ソースコードをシンタックスハイライト表示します。

{% download https://drive.google.com/uc?id=1b_texG1scFcKnOIcUNUHQPdquKal_Fu6OQ %}

## サンプルコード
<pre class="prettyprint"><code>private void loadFile(String path) {
  try (Stream&lt;String&gt; lines = Files.lines(
      Paths.get(path), StandardCharsets.UTF_8)) {
    String txt = lines.map(s -&gt; s.replace("&amp;", "&amp;amp;")
                                 .replace("&lt;", "&amp;lt;")
                                 .replace("&gt;", "&amp;gt;"))
      .collect(Collectors.joining("\n"));
    editor.setText("&lt;pre&gt;" + prettify(engine, txt) + "\n&lt;/pre&gt;");
  } catch (IOException ex) {
    ex.printStackTrace();
  }
}
private static String prettify(ScriptEngine engine, String src) {
  try {
    Object w = engine.get("window");
    return (String) ((Invocable) engine).invokeMethod(
        w, "prettyPrintOne", src);
  } catch (ScriptException | NoSuchMethodException ex) {
    ex.printStackTrace();
    return "";
  }
}
</code></pre>

## 解説
上記のサンプルでは、`ScriptEngine`で`google-prettify.js`を実行し、`Open`ボタンで選択したソースコードをハイライト済みの`HTML`テキストに変換して`JEditorPane`で表示しています。

- `ScriptEngine`で`HTML`テキストに変換する前に、ソースコード中の`&`、`<`、`>`を文字実体参照に変換する必要がある
- `HTMLEditorKit`の`CSS`で色は`3`桁表記(`color:#RGB`) には対応していないため、`6`桁表記(`color:#RRGGBB`)に変換して使用
    - [code-prettify/prettify.css at master ・ google/code-prettify](https://github.com/google/code-prettify/blob/master/src/prettify.css)
    - 参考: [JEditorPaneのHTMLEditorKitにCSSを適用](https://ateraimemo.com/Swing/StyleSheet.html)
- [First pass at a way to dodge newline issues in IE.](https://github.com/google/code-prettify/blob/0b3341b3e9105ddaecf93cc632284f8db7994faf/src/prettify.js)の修正以降の`prettify.js`では、`prettyPrintOne`の内部で`Document`型のオブジェクトが使用されるようになったので`ScriptEngine`(`Nashorn`)のみでは実行不可
    - このため、このサンプルでは古いバージョンの`prettify.js`([Fixed prettyPrintOne by removing requirement that a job have a source node. Fixes issues 133 and 134.](https://github.com/google/code-prettify/blob/f5ad44e3253f1bc8e288477a36b2ce5972e8e161/src/prettify.js))を添付して利用している
    - [prettify.js(r120)](https://raw.githubusercontent.com/google/code-prettify/f5ad44e3253f1bc8e288477a36b2ce5972e8e161/src/prettify.js)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [google/code-prettify: Automatically exported from code.google.com/p/google-code-prettify](https://github.com/google/code-prettify)
- [Rhinoでgoogle-code-prettifyを実行する](https://ateraimemo.com/Tips/GooglePrettifyRhino.html)
- [Java access files in jar causes java.nio.file.FileSystemNotFoundException - Stack Overflow](https://stackoverflow.com/questions/22605666/java-access-files-in-jar-causes-java-nio-file-filesystemnotfoundexception)

<!-- dummy comment line for breaking list -->

## コメント
