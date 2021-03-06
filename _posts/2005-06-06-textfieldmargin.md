---
layout: post
category: swing
folder: TextFieldMargin
title: JTextFieldのMarginを設定する
tags: [JTextField, UIManager, Border]
author: aterai
pubdate: 2005-06-06T00:34:45+09:00
description: JTextFieldにMargin、または二重のBorderを設定して、内余白の変化をテストします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVM2PvsXI/AAAAAAAAAnQ/3wxfaHXrEUk/s800/TextFieldMargin.png
comments: true
---
## 概要
`JTextField`に`Margin`、または二重の`Border`を設定して、内余白の変化をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVM2PvsXI/AAAAAAAAAnQ/3wxfaHXrEUk/s800/TextFieldMargin.png %}

## サンプルコード
<pre class="prettyprint"><code>Insets m = UIManager.getInsets("TextField.margin");
InsetsUIResource iur = new InsetsUIResource(m.top, m.left + 5, m.bottom, m.right);
UIManager.put("TextField.margin", iur);

Insets m = field01.getMargin();
Insets margin = new Insets(m.top, m.left + 10, m.bottom, m.right);
field01.setMargin(margin);

Border b1 = BorderFactory.createEmptyBorder(0, 20, 0, 0);
Border b2 = BorderFactory.createCompoundBorder(field02.getBorder(), b1);
field02.setBorder(b2);
</code></pre>

## 解説
以下のサンプルでは、それぞれ左側の内余白のサイズのみを変更しています。


- 上: `UIManager.put()`ですべての`JTextField`の余白を指定
    - `getMargin().left`: `7px`
    - `getInsets().left`: `8px`
    - `getBorder().getBorderInsets(c).left`: `8px`
- 中: 一番上の余白と`setMargin()`で余白を指定
    - `getMargin().left`: `17px`
    - `getInsets().left`: `18px`
    - `getBorder().getBorderInsets(c).left`: `18px`
- 下: 一番上の余白と`setBorder()`で余白を指定
    - `getMargin().left`: `7px`
    - `getInsets().left`: `28px`
    - `getBorder().getBorderInsets(c).left`: `28px`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextField内にアイコンを追加](https://ateraimemo.com/Swing/IconTextField.html)
- [JComboBoxにアイコンを表示](https://ateraimemo.com/Swing/IconComboBox.html)

<!-- dummy comment line for breaking list -->

## コメント
