---
layout: post
title: JComboBoxなどの幅をカラム数で指定
category: swing
folder: SetColumns
tags: [JTextField, JPasswordField, JSpinner, JComboBox]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-12-18

## JComboBoxなどの幅をカラム数で指定
`JTextField`,`JPasswordField`,`JSpinner`,`JComboBox`の幅をカラム数で指定して比較しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTS72PP0tI/AAAAAAAAAjk/RRG_w2fJBtA/s800/SetColumns.png)

### サンプルコード
<pre class="prettyprint"><code>JTextField field      = new JTextField(20);
JPasswordField passwd = new JPasswordField(20);
JSpinner.DefaultEditor e = (JSpinner.DefaultEditor)spinner.getEditor();
e.getTextField().setColumns(20);
combo1.setEditable(true);
Component c = combo1.getEditor().getEditorComponent();
if(c instanceof JTextField) ((JTextField)c).setColumns(20);
</code></pre>

### 解説
上記のサンプルでは、要素が空の`JComboBox`などのカラム幅を同じにして(下二つは`default`のまま)、以下のような順番で並べています。
1. `JTextField` [`setColumns(20)`]
1. `JPasswordField` [`setColumns(20)`]
1. `JSpinner` [`setColumns(20)`]
1. `JComboBox` [`setEditable(true)`, `setColumns(20)`]
1. `JComboBox` [`setEditable(true)`, `default`]
1. `JComboBox` [`setEditable(false)`, `default`]

スクリーンショットは、左が`JDK 1.6.0`、右が、`JDK 1.5.0_10`で実行したものになっています(どちらも`WindowsLookAndFeel`)。`1.6.0`ではきれいに揃っていますが、`1.5.0_10`などでは幅も高さも余白もガタガタ(左の内余白も`JTextField`は広すぎ、`JComboBox`などは狭すぎるなどバラバラ)なので、レイアウトマネージャーで工夫するか、`setPreferredSize(Dimension)`を使って幅を揃える方がよさそうです([JButtonなどの高さを変更せずに幅を指定](http://terai.xrea.jp/Swing/ButtonWidth.html))。

### 参考リンク
- [JButtonなどの高さを変更せずに幅を指定](http://terai.xrea.jp/Swing/ButtonWidth.html)

<!-- dummy comment line for breaking list -->

### コメント