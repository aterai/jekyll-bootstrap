---
layout: post
category: swing
folder: ClearGroupSelection
title: ButtonGroup内のJRadioButtonなどの選択をクリア
tags: [JRadioButton, JToggleButton, ButtonGroup]
author: aterai
pubdate: 2007-07-16T21:58:08+09:00
description: JDK 6で追加された機能を使用して、ButtonGroup内の選択をクリアします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTJDUnsHFI/AAAAAAAAATw/gkcmzcekHus/s800/ClearGroupSelection.png
comments: true
---
## 概要
`JDK 6`で追加された機能を使用して、`ButtonGroup`内の選択をクリアします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTJDUnsHFI/AAAAAAAAATw/gkcmzcekHus/s800/ClearGroupSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>final ButtonGroup bg = new ButtonGroup();
List&lt;? extends AbstractButton&gt; l = new ArrayList&lt;&gt;();
l.add(new JRadioButton("RadioButton1"));
l.add(new JRadioButton("RadioButton2"));
l.add(new JToggleButton(icon));
for (AbstractButton b: l) {
  bg.add(b); add(b);
}
add(new JButton(new AbstractAction("clearSelection") {
  @Override public void actionPerformed(ActionEvent e) {
    bg.clearSelection();
  }
}));
</code></pre>

## 解説
上記のサンプルでは、`JRadioButton`、`JToggleButton`を`ButtonGroup`に追加し、これらの選択状態を`ButtonGroup#clearSelection()`メソッドを使ってクリアしています。

## 参考リンク
- [ButtonGroup#clearSelection() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/ButtonGroup.html#clearSelection--)
- [「Java SE 6完全攻略」第34回 Swingのその他の新機能：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20070622/275590/)

<!-- dummy comment line for breaking list -->

## コメント
