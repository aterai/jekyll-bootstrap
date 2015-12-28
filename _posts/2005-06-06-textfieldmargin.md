---
layout: post
category: swing
folder: TextFieldMargin
title: JTextFieldのMarginを設定する
tags: [JTextField, UIManager, Border]
author: aterai
pubdate: 2005-06-06T00:34:45+09:00
description: JTextFieldにMargin、または二重のBorderを設定して、内余白の変化をテストします。
comments: true
---
## 概要
`JTextField`に`Margin`、または二重の`Border`を設定して、内余白の変化をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVM2PvsXI/AAAAAAAAAnQ/3wxfaHXrEUk/s800/TextFieldMargin.png %}

## サンプルコード
<pre class="prettyprint"><code>Insets m = UIManager.getInsets("TextField.margin");
InsetsUIResource iur = new InsetsUIResource(m.top, m.left + 5, m.bottom, m.right);
UIManager.put("TextField.margin", iur);
</code></pre>
<pre class="prettyprint"><code>Insets m = field01.getMargin();
Insets margin = new Insets(m.top, m.left + 10, m.bottom, m.right);
field01.setMargin(margin);
</code></pre>
<pre class="prettyprint"><code>Border b1 = BorderFactory.createEmptyBorder(0, 20, 0, 0);
Border b2 = BorderFactory.createCompoundBorder(field02.getBorder(), b1);
field02.setBorder(b2);
</code></pre>

## 解説
以下のサンプルでは、それぞれ左側の内余白のサイズのみを変更しています。


- 上: `UIManager.put()`ですべての`JTextField`の余白を指定
    - `getMargin().left`: `7`
    - `getInsets().left`: `8`
    - `getBorder().getBorderInsets(c).left`: `8`
- 中: 一番上 + `setMargin()`で余白を指定
    - `getMargin().left`: `17`
    - `getInsets().left`: `18`
    - `getBorder().getBorderInsets(c).left`: `18`
- 下: 一番上 + `setBorder()`で余白を指定
    - `getMargin().left`: `7`
    - `getInsets().left`: `28`
    - `getBorder().getBorderInsets(c).left`: `28`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextField内にアイコンを追加](http://ateraimemo.com/Swing/IconTextField.html)
- [JComboBoxにアイコンを表示](http://ateraimemo.com/Swing/IconComboBox.html)

<!-- dummy comment line for breaking list -->

## コメント
