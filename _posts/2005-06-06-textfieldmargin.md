---
layout: post
title: JTextFieldのMarginを設定する
category: swing
folder: TextFieldMargin
tags: [JTextField, UIManager, Border]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-06-06

## JTextFieldのMarginを設定する
`JTextField`内部の余白を設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTVM2PvsXI/AAAAAAAAAnQ/3wxfaHXrEUk/s800/TextFieldMargin.png)

### サンプルコード
<pre class="prettyprint"><code>Insets m = UIManager.getInsets("TextField.margin");
InsetsUIResource iur = new InsetsUIResource(m.top,m.left+5,m.bottom,m.right);
UIManager.put("TextField.margin", iur);
</code></pre>
<pre class="prettyprint"><code>Insets m = field01.getMargin();
Insets margin = new Insets(m.top,m.left+10,m.bottom,m.right);
field01.setMargin(margin);
</code></pre>
<pre class="prettyprint"><code>Border b1 = BorderFactory.createEmptyBorder(0,20,0,0);
Border b2 = BorderFactory.createCompoundBorder(field02.getBorder(), b1);
field02.setBorder(b2);
</code></pre>

### 解説
以下のサンプルでは、それぞれ左余白のサイズのみを変更しています。

	javax.swing.plaf.InsetsUIResource[top=2,left=7,bottom=2,right=2]

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

### 参考リンク
- [JTextField内にアイコンを追加](http://terai.xrea.jp/Swing/IconTextField.html)
- [JComboBoxにアイコンを表示](http://terai.xrea.jp/Swing/IconComboBox.html)

<!-- dummy comment line for breaking list -->

### コメント