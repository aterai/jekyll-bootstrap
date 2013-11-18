---
layout: post
title: DefaultHighlighterの描画方法を変更する
category: swing
folder: DrawsLayeredHighlights
tags: [DefaultHighlighter, JTextArea, JTextComponent]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-08-26

## DefaultHighlighterの描画方法を変更する
`DefaultHighlighter`の描画方法を変更して、文字列が選択されている場合のハイライト表示を変更します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-yXndYI0LTyA/UhoR8XLek3I/AAAAAAAABy0/BpEfTjjAGwU/s800/DrawsLayeredHighlights.png)

### サンプルコード
<pre class="prettyprint"><code>DefaultHighlighter dh = (DefaultHighlighter)textArea.getHighlighter();
dh.setDrawsLayeredHighlights(false);
</code></pre>

### 解説
- `DefaultHighlighter#setDrawsLayeredHighlights(ture)`
    - デフォルト
    - 文字列の描画直前にハイライトも描画されるため、文字列の選択描画より手前にハイライトの矩形が表示される
    - 選択時の文字色が反転する場合(`MetalLookAndFeel`以外の`LookAndFeel`など)、ハイライトの色によっては見づらくなる
- `DefaultHighlighter#setDrawsLayeredHighlights(false)`
    - 文字列の選択描画より奥にハイライトが表示されるため、ハイライトの矩形は塗り潰れさて非表示となる
    - 文字列選択で、ハイライトされている箇所がわかりづらくなる
    - 改行を含む文字列を選択すると選択の描画がおかしくなる？

<!-- dummy comment line for breaking list -->

### 参考リンク
- [DefaultHighlighter#setDrawsLayeredHighlights(boolean) (Java Platform SE 7 )](http://docs.oracle.com/javase/jp/7/api/javax/swing/text/DefaultHighlighter.html#setDrawsLayeredHighlights%28boolean%29)

<!-- dummy comment line for breaking list -->

### コメント
