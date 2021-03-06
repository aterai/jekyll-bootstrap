---
layout: post
category: swing
folder: TitledBorder
title: TitledBorderのタイトル位置
tags: [TitledBorder, Border]
author: aterai
pubdate: 2007-08-06T12:08:09+09:00
description: TitledBorderのタイトル位置や揃えを切り替えてテストします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVZeDhwBI/AAAAAAAAAnk/QmV1N3Uqp3o/s800/TitledBorder.png
comments: true
---
## 概要
`TitledBorder`のタイトル位置や揃えを切り替えてテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVZeDhwBI/AAAAAAAAAnk/QmV1N3Uqp3o/s800/TitledBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>VerticalOrientation vo = (VerticalOrientation) verticalOrientationChoices.getSelectedItem();
switch (vo) {
  case DEFAULT_POSITION: border.setTitlePosition(TitledBorder.DEFAULT_POSITION); break;
  case ABOVE_TOP:        border.setTitlePosition(TitledBorder.ABOVE_TOP);        break;
  case TOP:              border.setTitlePosition(TitledBorder.TOP);              break;
  case BELOW_TOP:        border.setTitlePosition(TitledBorder.BELOW_TOP);        break;
  case ABOVE_BOTTOM:     border.setTitlePosition(TitledBorder.ABOVE_BOTTOM);     break;
  case BOTTOM:           border.setTitlePosition(TitledBorder.BOTTOM);           break;
  case BELOW_BOTTOM:     border.setTitlePosition(TitledBorder.BELOW_BOTTOM);     break;
}
Justification jc = (Justification) justificationChoices.getSelectedItem();
switch (jc) {
  case DEFAULT_JUSTIFICATION: border.setTitleJustification(
                                              TitledBorder.DEFAULT_JUSTIFICATION); break;
  case LEFT:     border.setTitleJustification(TitledBorder.LEFT);     break;
  case CENTER:   border.setTitleJustification(TitledBorder.CENTER);   break;
  case RIGHT:    border.setTitleJustification(TitledBorder.RIGHT);    break;
  case LEADING:  border.setTitleJustification(TitledBorder.LEADING);  break;
  case TRAILING: border.setTitleJustification(TitledBorder.TRAILING); break;
}
panel.repaint();
</code></pre>

## 解説
上記のサンプルでは、以下のような定数フィールド値を`JComboBox`で指定してタイトルの位置や揃えを変更できます。

- タイトルの位置を`TitledBorder#setTitlePosition(int)`メソッドで指定
    - `TitledBorder.DEFAULT_POSITION`
    - `TitledBorder.ABOVE_TOP`
    - `TitledBorder.TOP`
    - `TitledBorder.BELOW_TOP`
    - `TitledBorder.ABOVE_BOTTOM`
    - `TitledBorder.BOTTOM`
    - `TitledBorder.BELOW_BOTTOM`

<!-- dummy comment line for breaking list -->

- タイトルの揃えを`TitledBorder#setTitleJustification(int)`メソッドで指定
    - `TitledBorder.LEFT`
    - `TitledBorder.CENTER`
    - `TitledBorder.RIGHT`
    - `TitledBorder.LEADING`
    - `TitledBorder.TRAILING`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TitledBorder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/border/TitledBorder.html)
- [TitledBorderのタイトルにアイコンを表示する](https://ateraimemo.com/Swing/IconTitledBorder.html)
- [JDK-4199867 TitledBorder MIDDLE Veritcal Alignment - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4199867)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: [TitledBorder API inconsitent with implementation: uses TOP instead of DEFAULT_POSITION](https://bugs.openjdk.java.net/browse/JDK-6658876) -- *aterai* 2008-04-12 (土) 00:35:59

<!-- dummy comment line for breaking list -->
