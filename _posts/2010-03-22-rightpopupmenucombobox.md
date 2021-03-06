---
layout: post
category: swing
folder: RightPopupMenuComboBox
title: JComboBoxのPopupMenuを右側に表示する
tags: [JComboBox, JPopupMenu, PopupMenuListener, ArrowButton, Icon]
author: aterai
pubdate: 2010-03-22T02:10:46+09:00
description: JComboBoxの右側にPopupMenuが表示されるように設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTR6-BHykI/AAAAAAAAAh8/0mx4AWajd58/s800/RightPopupMenuComboBox.png
comments: true
---
## 概要
`JComboBox`の右側に`PopupMenu`が表示されるように設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTR6-BHykI/AAAAAAAAAh8/0mx4AWajd58/s800/RightPopupMenuComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class RightPopupMenuListener implements PopupMenuListener {
  @Override public void popupMenuWillBecomeVisible(final PopupMenuEvent e) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        JComboBox combo = (JComboBox) e.getSource();
        Accessible a = combo.getUI().getAccessibleChild(combo, 0);
        if (a instanceof BasicComboPopup) {
          BasicComboPopup pop = (BasicComboPopup) a;
          Point p = new Point(combo.getSize().width, 0);
          SwingUtilities.convertPointToScreen(p, combo);
          pop.setLocation(p);
        }
      }
    });
  }
  @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {}
  @Override public void popupMenuCanceled(PopupMenuEvent e) {}
}
</code></pre>

## 解説
- `JComboBox`のドロップダウンリストとして`PopupMenu`が開くとき、その位置を変更する`PopupMenuListener`を作成
    - `JComboBox#addPopupMenuListener(...)`メソッドで追加
- `JComboBox`の矢印アイコンも、以下のように変更
    
    <pre class="prettyprint"><code>combo2.setUI(new WindowsComboBoxUI() {
      @Override protected JButton createArrowButton() {
        JButton button = new JButton(icon) {
          @Override public Dimension getPreferredSize() {
            return new Dimension(14, 14);
          }
        };
        button.setRolloverIcon(makeRolloverIcon(icon));
        button.setFocusPainted(false);
        button.setContentAreaFilled(false);
        return button;
      }
    });
</code></pre>
- * 参考リンク [#reference]
- [PopupMenuListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/PopupMenuListener.html)

<!-- dummy comment line for breaking list -->

## コメント
- [Bug ID: 4743225 Size of JComboBox list is wrong when list is populated via PopupMenuListener](https://bugs.openjdk.java.net/browse/JDK-4743225)のせいで？、正常に動作しなくなっていたので修正。 -- *aterai* 2012-04-24 (火) 16:54:17

<!-- dummy comment line for breaking list -->
