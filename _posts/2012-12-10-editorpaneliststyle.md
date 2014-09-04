---
layout: post
title: JEditorPaneのStyleSheetを使ってlist bulletを画像に変更
category: swing
folder: EditorPaneListStyle
tags: [JEditorPane, HTMLEditorKit, StyleSheet]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-12-10

## 概要
`JEditorPane`の`HTMLEditorKit`から`StyleSheet`を取得し、`list-style-image`を使って`List bullet`を変更します。

{% download https://lh4.googleusercontent.com/-cVKrTqKAhYk/UMSbt8J09jI/AAAAAAAABY0/IWonqNua5dM/s800/EditorPaneListStyle.png %}

## サンプルコード
<pre class="prettyprint"><code>HTMLEditorKit htmlEditorKit = (HTMLEditorKit)pane.getEditorKit();
StyleSheet styleSheet = htmlEditorKit.getStyleSheet();
String u = getClass().getResource(bullet).toString();
styleSheet.addRule(String.format("ul{list-style-image:url(%s);margin:0px 20px;}", u));
</code></pre>

## 解説
- 上: `Default`
- 下: `ul{list-style-image:url(bullet.png);}`
    - `CSS`の`list-style-image`プロパティを使って、`bullet`を画像に変更
    - `AlignmentY`が中心にならない？ので、画像の下に余白を追加
    - `ul`のマージンも`margin:0px 20px;`に変更

<!-- dummy comment line for breaking list -->

- - - -
- `javax.swing.text.html.CSS`は、`list-style-type`プロパティも対応しているので、`circle`, `square`, `decimal`などが`bullet`として使用できるが、サイズは固定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>styleSheet.addRule("ul{list-style-type:circle;margin:0px 20px;}");
//styleSheet.addRule("ul{list-style-type:disc;margin:0px 20px;}");
//styleSheet.addRule("ul{list-style-type:square;margin:0px 20px;}");
//styleSheet.addRule("ul{list-style-type:decimal;margin:0px 20px;}");
</code></pre>

- - - -
- `javax.swing.text.html.CSS`は、`a:hover`などの擬似クラス(`pseudo-classes`)や、`:before`などの擬似要素(`pseudo elements`)に対応していないので、以下のように`list-style-type:none`として`:before`で任意の文字を`bullet`に適用することができない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>styleSheet.addRule("ul{list-style-type:none;margin:0px 20px;}");
styleSheet.addRule("ul li:before{content: "\u00BB";}");
</code></pre>

- - - -
- `javax.swing.text.html.StyleSheet.ListPainter#drawShape(...)`などをオーバーライドできれば直接`bullet`の形やサイズを変更できそうだが、コンストラクタがパッケージプライベート

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JEditorPaneのHTMLEditorKitにCSSを適用](http://terai.xrea.jp/Swing/StyleSheet.html)

<!-- dummy comment line for breaking list -->

## コメント
