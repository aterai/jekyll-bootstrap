---
layout: post
title: ButtonGroup内のJRadioButtonなどの選択をクリア
category: swing
folder: ClearGroupSelection
tags: [JRadioButton, JToggleButton, ButtonGroup]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-07-16

## ButtonGroup内のJRadioButtonなどの選択をクリア
`JDK 6`で追加された機能を使用して、`ButtonGroup`内の選択をクリアします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTJDUnsHFI/AAAAAAAAATw/gkcmzcekHus/s800/ClearGroupSelection.png)

### サンプルコード
<pre class="prettyprint"><code>final ButtonGroup bg = new ButtonGroup();
Vector&lt;AbstractButton&gt; l = new Vector&lt;AbstractButton&gt;();
l.add(new JRadioButton("RadioButton1"));
l.add(new JRadioButton("RadioButton2"));
l.add(new JToggleButton(icon));
for(AbstractButton b:l) { bg.add(b); add(b); }
add(new JButton(new AbstractAction("clearSelection") {
  @Override public void actionPerformed(ActionEvent e) {
    bg.clearSelection();
  }
}));
</code></pre>

### 解説
上記のサンプルでは、`JRadioButton`、`JToggleButton`を`ButtonGroup`に追加し、これらの選択状態を、`ButtonGroup#clearSelection`メソッドを使ってクリアしています。

### 参考リンク
- [「Java SE 6完全攻略」第34回 Swingのその他の新機能：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20070622/275590/)

<!-- dummy comment line for breaking list -->

### コメント
