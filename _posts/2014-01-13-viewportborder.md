---
layout: post
category: swing
folder: ViewportBorder
title: JViewportにBorderを設定する
tags: [JViewport, Border, JScrollPane, JTextArea, Caret]
author: aterai
pubdate: 2014-01-13T00:01:30+09:00
description: JViewportにBorderを設定して余白を作成します。
comments: true
---
## 概要
`JViewport`に`Border`を設定して余白を作成します。

{% download https://lh6.googleusercontent.com/-dtdRJtfyQqs/UtKoFiKxRVI/AAAAAAAAB-A/QmWEeAHNlmE/s800/ViewportBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>JTextArea textArea2 = new JTextArea("JScrollPane#setViewportBorder(...)\n\n" + initTxt);
textArea2.setMargin(new Insets(0,0,0,0));
JScrollPane scroll2 = new JScrollPane(textArea2);
scroll2.setViewportBorder(BorderFactory.createLineBorder(textArea2.getBackground(), 5));
</code></pre>

## 解説
- 左: `JTextArea#setMargin(Insets)`
    - `JTextArea`に`setMargin(Insets)`で余白を設定
    - 行変更などのカーソル移動で先頭や末尾の余白分まではスクロールされない
- 右: `JScrollPane#setViewportBorder(...)`
    - `JTextArea#setMargin(new Insets(0,0,0,1))`で`JTextArea`自体の余白を変更
        - すべて`0`の場合、一番長い行の末尾でキャレットが表示されない
    - `JScrollPane#setViewportBorder(...)`で`JViewport`の周囲に余白を設定
        - スクロールバーなどの有無によらず、この余白は常に表示されている

<!-- dummy comment line for breaking list -->

## コメント
