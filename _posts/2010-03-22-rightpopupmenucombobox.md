---
layout: post
title: JComboBoxのPopupMenuを右側に表示する
category: swing
folder: RightPopupMenuComboBox
tags: [JComboBox, JPopupMenu, PopupMenuListener, ArrowButton, Icon]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-03-22

## JComboBoxのPopupMenuを右側に表示する
`JComboBox`の右側に`PopupMenu`が表示されるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTR6-BHykI/AAAAAAAAAh8/0mx4AWajd58/s800/RightPopupMenuComboBox.png)

### サンプルコード
<pre class="prettyprint"><code>class RightPopupMenuListener implements PopupMenuListener {
  @Override public void popupMenuWillBecomeVisible(final PopupMenuEvent e) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        JComboBox combo = (JComboBox)e.getSource();
        Accessible a = combo.getUI().getAccessibleChild(combo, 0);
        if(a instanceof BasicComboPopup) {
          BasicComboPopup pop = (BasicComboPopup)a;
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

### 解説
上記のサンプルでは、`JComboBox`の`PopupMenu`が開くときに、その位置を変更するような`PopupMenuListener`を作成し、`addPopupMenuListener`メソッドで追加しています。

- - - -
`JComboBox`の矢印アイコンも、以下のようにして変更しています。

<pre class="prettyprint"><code>combo2.setUI(new com.sun.java.swing.plaf.windows.WindowsComboBoxUI() {
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

### コメント
- [Bug ID: 4743225 Size of JComboBox list is wrong when list is populated via PopupMenuListener](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4743225)のせいで？、正常に動作しなくなっていたので修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-04-24 (火) 16:54:17

<!-- dummy comment line for breaking list -->

