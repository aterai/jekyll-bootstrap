---
layout: post
category: swing
folder: HtmlTableBorderStyle
title: JLabelに表示するtableタグの罫線を変更する
tags: [HTML, CSS, StyleSheet, JLabel]
author: aterai
pubdate: 2016-02-08T00:00:25+09:00
description: JLabelなどのコンポーネントにHTMLのtableタグを使用して描画する表の罫線を分離表示ではなく結合表示に変更します。
image: https://lh3.googleusercontent.com/-KUe25svxTkQ/VrdVpBBO6TI/AAAAAAAAONE/x6Lvt2P_x_c/s800-Ic42/HtmlTableBorderStyle.png
comments: true
---
## 概要
`JLabel`などのコンポーネントに`HTML`の`table`タグを使用して描画する表の罫線を分離表示ではなく結合表示に変更します。

{% download https://lh3.googleusercontent.com/-KUe25svxTkQ/VrdVpBBO6TI/AAAAAAAAONE/x6Lvt2P_x_c/s800-Ic42/HtmlTableBorderStyle.png %}

## サンプルコード
<pre class="prettyprint"><code>String TD1 = "&lt;td style='background-color:white;border-right:1px solid green;border-top:1px solid blue'&gt;a...";
String TS1 = "style='border-left:1px solid red;border-bottom:1px solid red;background-color:yellow' cellspacing='0px' cellpadding='5px'";
String html1 = "&lt;html&gt;&lt;table " + TS1 + "&gt;" + "&lt;tr&gt;" + TD1 + TD1 + "&lt;tr&gt;" + TD1 + TD1;

String TD2 = "&lt;td style='background-color:white;border-right:1px solid green;border-bottom:1px solid blue'&gt;a...";
String TS2 = "style='border-left:1px solid red;border-top:1px solid red;background-color:yellow' cellspacing='0px' cellpadding='5px'";
String html2 = "&lt;html&gt;&lt;table " + TS2 + "&gt;" + "&lt;tr&gt;" + TD2 + TD2 + "&lt;tr&gt;" + TD2 + TD2;

String TD3 = "&lt;td style='background-color:white'&gt;a...";
String TS3 = "style='border:0px;background-color:red' cellspacing='1px' cellpadding='5px'";
String html3 = "&lt;html&gt;&lt;table " + TS3 + "&gt;" + "&lt;tr&gt;" + TD3 + TD3 + "&lt;tr&gt;" + TD3 + TD3;
</code></pre>

## 解説
`Swing`の[CSS](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/CSS.html)は、`table`の`border-collapse`プロパティに未対応なので、`border-bottom`などを組み合わせて罫線を結合表示します。

- `border-left, border-bottom`
    - 表に`border-left`と`border-bottom`、セルに`border-right`と`border-top`の罫線を`1px`の実線で描画
- `border-left, border-top`
    - 表に`border-left`と`border-top`、セルに`border-right`と`border-bottom`の罫線を`1px`の実線で描画
    - 表の背景色(このサンプルでは`background-color:yellow`)が上下左右に余分に表示されてしまう(バグ？)
- `cellspacing`
    - 表の属性に`cellspacing='1px'`を指定し、表の背景色(`background-color:red`)を代わりに`1px`の罫線として表示
    - すべての罫線が同じ色になる
    - 参考: [java - 1 pixel table border in JTextPane using HTML - Stack Overflow](https://stackoverflow.com/questions/3355469/1-pixel-table-border-in-jtextpane-using-html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - 1 pixel table border in JTextPane using HTML - Stack Overflow](https://stackoverflow.com/questions/3355469/1-pixel-table-border-in-jtextpane-using-html)
- [BasicStrokeで指定した辺の描画を行うBorderを作成する](https://ateraimemo.com/Swing/StrokeMatteBorder.html)

<!-- dummy comment line for breaking list -->

## コメント
