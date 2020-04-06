---
layout: post
category: swing
folder: DisableRightClick
title: JComboBoxのドロップダウンリストで右クリックを無効化
tags: [JComboBox, BasicComboPopup, MouseListener, JList]
author: aterai
pubdate: 2009-06-29T10:14:32+09:00
description: JComboBoxのドロップダウンリスト(ポップアップメニュー)で、マウスの右クリックを無効にします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLKTBLgQI/AAAAAAAAAXI/mV-Gw1hPSYU/s800/DisableRightClick.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/06/disable-right-click-in-jcombobox.html
    lang: en
comments: true
---
## 概要
`JComboBox`のドロップダウンリスト(ポップアップメニュー)で、マウスの右クリックを無効にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLKTBLgQI/AAAAAAAAAXI/mV-Gw1hPSYU/s800/DisableRightClick.png %}

## サンプルコード
<pre class="prettyprint"><code>class BasicComboPopup2 extends BasicComboPopup {
  private transient Handler2 handler2;
  @Override public void uninstallingUI() {
    super.uninstallingUI();
    handler2 = null;
  }
  public BasicComboPopup2(JComboBox combo) {
    super(combo);
  }
  @Override protected MouseListener createListMouseListener() {
    if (handler2 == null) {
      handler2 = new Handler2();
    }
    return handler2;
  }
  private class Handler2 extends MouseAdapter {
    @Override public void mouseReleased(MouseEvent e) {
      if (e.getSource().equals(list)) {
        if (list.getModel().getSize() &gt; 0) {
          // &lt;ins&gt;
          if (!SwingUtilities.isLeftMouseButton(e) || !comboBox.isEnabled()) {
            return;
          }
          // &lt;/ins&gt;
          // JList mouse listener
          if (comboBox.getSelectedIndex() == list.getSelectedIndex()) {
            comboBox.getEditor().setItem(list.getSelectedValue());
          }
          comboBox.setSelectedIndex(list.getSelectedIndex());
        }
        comboBox.setPopupVisible(false);
        // workaround for cancelling an edited item (bug 4530953)
        if (comboBox.isEditable() &amp;&amp; comboBox.getEditor() != null) {
          comboBox.configureEditor(comboBox.getEditor(), comboBox.getSelectedItem());
        }
      }
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`ComboBoxUI#createPopup()`をオーバーライドして、ドロップダウンリストに設定する`MouseListener`を入れ替えた`BasicComboPopup`を追加しています。

<pre class="prettyprint"><code>combo02.setUI(new BasicComboBoxUI() {
  @Override protected ComboPopup createPopup() {
    return new BasicComboPopup2(comboBox);
  }
});
</code></pre>

元の`MouseListener`は、`JComboBox`全体の`Handler`になっていますが、必要なのはドロップダウンリスト関係のみなので、`e.getSource() == list`な部分だけ元の`Handler`からコピーし、この中で`if(!SwingUtilities.isLeftMouseButton(e) || !comboBox.isEnabled()) return;`と右クリックを無視しています。

- - - -
以下のような方法もあります。

<pre class="prettyprint"><code>class BasicComboPopup3 extends BasicComboPopup {
  @SuppressWarnings("unchecked")
  @Override protected JList createList() {
    return new JList(comboBox.getModel()) {
      @Override public void processMouseEvent(MouseEvent e) {
        if (SwingUtilities.isRightMouseButton(e)) {
          return;
        }
        MouseEvent ev = e;
        if (e.isControlDown()) {
          // Fix for 4234053. Filter out the Control Key from the list.
          // ie., don't allow CTRL key deselection.
          Toolkit toolkit = Toolkit.getDefaultToolkit();
          ev = new MouseEvent(e.getComponent(), e.getID(), e.getWhen(),
                              //e.getModifiers() ^ InputEvent.CTRL_MASK,
                              e.getModifiers() ^ toolkit.getMenuShortcutKeyMask(),
                              e.getX(), e.getY(),
                              e.getXOnScreen(), e.getYOnScreen(),
                              e.getClickCount(),
                              e.isPopupTrigger(),
                              MouseEvent.NOBUTTON);
        }
        super.processMouseEvent(ev);
      }
    };
  }
}
</code></pre>

## 参考リンク
- [JDK-4249731 JComboBox (Windows L&F), right mouse click selects in menu - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-4249731)
    - 要望が矛盾しているとして却下されているが、もしかしたら「`Windows`環境の標準動作に合わせて、`WindowsLookAndFeel`の`JComboBox`では右クリックしてもドロップダウンリストを閉じないようにして欲しい」との意味だったのかもしれない
- [JMenuとJMenuItemで右クリックによる選択を無効にする](https://ateraimemo.com/Swing/DisableRightClickOnMenu.html)
    - `JMenu`と`JMenuItem`も同様にマウス右クリックの無効化が可能

<!-- dummy comment line for breaking list -->

## コメント
- ドロップダウンリストにスクロールバーが表示されていない場合、ホイールを回すとポップアップが閉じてしまうのも地味に困る…。[JDK-8033069 mouse wheel scroll closes combobox popup - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8033069) -- *aterai* 2012-04-24 (火) 18:28:39

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//Test
class BasicComboPopup3 extends BasicComboPopup {
  public BasicComboPopup3(JComboBox combo) {
    super(combo);
  }
  @Override protected JScrollPane createScroller() {
    JScrollPane sp = new JScrollPane(list,
                     ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED,
                     ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER) {
      @Override protected void processEvent(AWTEvent e) {
        if (e instanceof MouseWheelEvent) {
          JScrollBar toScroll = getVerticalScrollBar();
          if (toScroll == null || !toScroll.isVisible()) {
            ((MouseWheelEvent) e).consume();
            return;
          }
        }
        super.processEvent(e);
      }
    };
    sp.setHorizontalScrollBar(null);
    return sp;
  }
// ...
</code></pre>

- 上記の方法では、ドロップダウンリスト内では閉じなくなるが、ドロップダウンリスト外でホイールを回転するとポップアップが閉じてしまう。`Toolkit.getDefaultToolkit().addAWTEventListener(...)`でもうまくいかない。 -- *aterai* 2012-04-24 (火) 20:07:13
- [JDK-8033069 mouse wheel scroll closes combobox popup - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8033069)で、ホイール回転の方は修正され~~る予定(`Java 9`)~~、`JDK 8`にも[バックポート](https://bugs.openjdk.java.net/browse/JDK-8078391)された。 -- *aterai* 2015-05-07 (木) 15:59:53

<!-- dummy comment line for breaking list -->
