---
layout: post
category: swing
folder: EditorPaneListStyle
title: JEditorPaneのStyleSheetを使ってlist bulletを画像に変更
tags: [JEditorPane, HTMLEditorKit, StyleSheet]
author: aterai
pubdate: 2012-12-10T00:03:24+09:00
description: JEditorPaneのHTMLEditorKitからStyleSheetを取得し、list-style-imageを使ってList bulletを変更します。
image: https://lh4.googleusercontent.com/-cVKrTqKAhYk/UMSbt8J09jI/AAAAAAAABY0/IWonqNua5dM/s800/EditorPaneListStyle.png
comments: true
---
## 概要
`JEditorPane`の`HTMLEditorKit`から`StyleSheet`を取得し、`list-style-image`を使って`List bullet`を変更します。

{% download https://lh4.googleusercontent.com/-cVKrTqKAhYk/UMSbt8J09jI/AAAAAAAABY0/IWonqNua5dM/s800/EditorPaneListStyle.png %}

## サンプルコード
<pre class="prettyprint"><code>JEditorPane pane = new JEditorPane();
pane.setContentType("text/html");
pane.setEditable(false);
HTMLEditorKit htmlEditorKit = (HTMLEditorKit) pane.getEditorKit();
StyleSheet styleSheet = htmlEditorKit.getStyleSheet();
String u = getClass().getResource(bullet).toString();
styleSheet.addRule(String.format("ul{list-style-image:url(%s);margin:0px 20px;}", u));
</code></pre>

## 解説
- 上: `Default`
- 下: `ul{list-style-image:url(bullet.png);}`
    - `CSS`の`list-style-image`プロパティを使って、`bullet`を画像に変更
    - `AlignmentY`を設定しても行揃えが中央にならないので、画像の下に余白を追加
    - `ul`のマージンも`margin:0px 20px;`に変更

<!-- dummy comment line for breaking list -->

- メモ
    - `javax.swing.text.html.CSS`は、`list-style-type`プロパティも対応しているので、`circle`, `square`, `decimal`などが`bullet`として使用可能(サイズは固定)
        
        <pre class="prettyprint"><code>styleSheet.addRule("ul{list-style-type:circle;margin:0px 20px;}");
        //styleSheet.addRule("ul{list-style-type:disc;margin:0px 20px;}");
        //styleSheet.addRule("ul{list-style-type:square;margin:0px 20px;}");
        //styleSheet.addRule("ul{list-style-type:decimal;margin:0px 20px;}");
</code></pre>
    - `javax.swing.text.html.CSS`は、`a:hover`などの擬似クラス(`pseudo-classes`)や、`:before`などの擬似要素(`pseudo elements`)に対応していないので、以下のように`list-style-type:none`として`:before`で任意の文字を`bullet`に適用できない
        
        <pre class="prettyprint"><code>styleSheet.addRule("ul{list-style-type:none;margin:0px 20px;}");
        styleSheet.addRule("ul li:before{content:'\u00BB';}");
</code></pre>
    - `javax.swing.text.html.StyleSheet.ListPainter#drawShape(...)`などをオーバーライドできれば直接`bullet`の形やサイズを変更できそうだが、コンストラクタがパッケージプライベートのため変更不可

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JEditorPaneのHTMLEditorKitにCSSを適用](https://ateraimemo.com/Swing/StyleSheet.html)
- [JDK-8201925 JEditorPane unordered list bullets look pixelated - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8201925)

<!-- dummy comment line for breaking list -->

## コメント
