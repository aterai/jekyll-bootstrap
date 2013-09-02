---
layout: post
title: JScrollBarが最後までスクロールしたことを確認する
category: swing
folder: DetectScrollToBottom
tags: [JScrollBar, JScrollPane, ChangeListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-03-04

## JScrollBarが最後までスクロールしたことを確認する
`JScrollBar`が最後までスクロールしたかどうかを確認します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-OoIPVjne_9M/UTPo6KgN_NI/AAAAAAAABlw/7miro8ywcyg/s800/DetectScrollToBottom.png)

### サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane(c);
scroll.getVerticalScrollBar().getModel().addChangeListener(new ChangeListener() {
  @Override public void stateChanged(ChangeEvent e) {
    BoundedRangeModel m = (BoundedRangeModel)e.getSource();
    int extent  = m.getExtent();
    int maximum = m.getMaximum();
    int value   = m.getValue();
    if(value + extent &gt;= maximum) {
      check.setEnabled(true);
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、縦スクロールバーから取得した`BoundedRangeModel`に`ChangeListener`を追加し、ノブの幅を加えた値が最大値になった時に最後までスクロールしたと判断して、`JCheckBox`を有効に設定しています。

### 参考リンク
- [java - How to know if a JScrollBar has reached the bottom of the JScrollPane? - Stack Overflow](http://stackoverflow.com/questions/12916192/how-to-know-if-a-jscrollbar-has-reached-the-bottom-of-the-jscrollpane)
    - `JScrollBar`に`AdjustmentListener`を設定する方法と、`BoundedRangeModel`に`ChangeListener`を設定する方法が回答されています。
- [JScrollBarをJSliderとして使用する](http://terai.xrea.jp/Swing/ScrollBarAsSlider.html)

<!-- dummy comment line for breaking list -->

### コメント
