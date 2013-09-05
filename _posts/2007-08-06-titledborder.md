---
layout: post
title: TitledBorderのタイトル位置
category: swing
folder: TitledBorder
tags: [TitledBorder, Border]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-08-06

## TitledBorderのタイトル位置
`TitledBorder`のタイトル位置や揃えを切り替えてテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTVZeDhwBI/AAAAAAAAAnk/QmV1N3Uqp3o/s800/TitledBorder.png)

### サンプルコード
<pre class="prettyprint"><code>VerticalOrientation vo = (VerticalOrientation)verticalOrientationChoices.getSelectedItem();
switch(vo) {
  case DEFAULT_POSITION: border.setTitlePosition(TitledBorder.DEFAULT_POSITION); break;
  case ABOVE_TOP:        border.setTitlePosition(TitledBorder.ABOVE_TOP);        break;
  case TOP:              border.setTitlePosition(TitledBorder.TOP);              break;
  case BELOW_TOP:        border.setTitlePosition(TitledBorder.BELOW_TOP);        break;
  case ABOVE_BOTTOM:     border.setTitlePosition(TitledBorder.ABOVE_BOTTOM);     break;
  case BOTTOM:           border.setTitlePosition(TitledBorder.BOTTOM);           break;
  case BELOW_BOTTOM:     border.setTitlePosition(TitledBorder.BELOW_BOTTOM);     break;
}
Justification jc = (Justification)justificationChoices.getSelectedItem();
switch(jc) {
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

### 解説
上記のサンプルでは、以下のような定数フィールド値をコンボボックスで指定することで、タイトルの位置や揃えを変更できるようになっています。

- タイトルの位置を`TitledBorder#setTitlePosition`メソッドで指定します。
    - `DEFAULT_POSITION`
    - `ABOVE_TOP`
    - `TOP`
    - `BELOW_TOP`
    - `ABOVE_BOTTOM`
    - `BOTTOM`
    - `BELOW_BOTTOM`

<!-- dummy comment line for breaking list -->

- タイトルの揃えを`TitledBorder#setTitleJustification`メソッドで指定します。
    - `LEFT`
    - `CENTER`
    - `RIGHT`
    - `LEADING`
    - `TRAILING`

<!-- dummy comment line for breaking list -->

### コメント
- メモ: [TitledBorder API inconsitent with implementation: uses TOP instead of DEFAULT_POSITION](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6658876) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-04-12 (土) 00:35:59

<!-- dummy comment line for breaking list -->
