---
layout: post
title: JTabbedPaneのTabTitleを左揃えに変更
category: swing
folder: TabTitleAlignment
tags: [JTabbedPane, Alignment, JButton]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-10-11

## JTabbedPaneのTabTitleを左揃えに変更
`JTabbedPane`の`TabTitle`をデフォルトに中央揃えから左揃えに変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTU2Jp4a6I/AAAAAAAAAms/x6g2ML8eyyQ/s800/TabTitleAlignment.png)

### サンプルコード
<pre class="prettyprint"><code>class MyTabbedPaneUI extends javax.swing.plaf.metal.MetalTabbedPaneUI {
  @Override protected void layoutLabel(int tabPlacement,
                                       FontMetrics metrics, int tabIndex,
                                       String title, Icon icon,
                                       Rectangle tabRect, Rectangle iconRect,
                                       Rectangle textRect, boolean isSelected ) {
    textRect.x = textRect.y = iconRect.x = iconRect.y = 0;
    //...
    SwingUtilities.layoutCompoundLabel((JComponent) tabPane,
                                       metrics, title, icon,
                                       SwingUtilities.CENTER,
                                       SwingUtilities.LEFT, //CENTER, &lt;----
                                       SwingUtilities.CENTER,
                                       SwingUtilities.TRAILING,
                                       tabRect,
                                       iconRect,
                                       textRect,
                                       textIconGap);
    tabPane.putClientProperty("html", null);
    textRect.translate(tabInsets.left, 0); //&lt;----
    textRect.width -= tabInsets.left+tabInsets.right;
    //...
  }
}
</code></pre>

### 解説
- 上
    - デフォルト(中央揃え)
- 中
    - `WindowsTabbedPaneUI#layoutLabel(...)`などをオーバーライドして左揃えに変更
- 下
    - [JTabbedPaneのタブを等幅にしてタイトルをクリップ](http://terai.xrea.jp/Swing/ClippedTitleTab.html)、[ButtonTabComponent.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/TabComponentsDemoProject/src/components/ButtonTabComponent.java)を変更してタイトルを左揃え、`TabButton`(閉じる)を右揃え

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public ButtonTabComponent(final JTabbedPane pane) {
  //unset default FlowLayout' gaps
  //super(new FlowLayout(FlowLayout.LEFT, 0, 0));
  super(new BorderLayout(0, 0));
  //...
  //add(button);
  add(button, BorderLayout.EAST);
  //...
</code></pre>

### 参考リンク
- [JTabbedPaneのタブを等幅にしてタイトルをクリップ](http://terai.xrea.jp/Swing/ClippedTitleTab.html)
- [ButtonTabComponent.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/TabComponentsDemoProject/src/components/ButtonTabComponent.java)
- [OTN Discussion Forums : JTabbedPane title alignment](http://forums.oracle.com/forums/thread.jspa?threadID=1554158)
- [Bug ID: 4220177 labels within JTabbedPane tabs should be alignable](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4220177)

<!-- dummy comment line for breaking list -->

### コメント
