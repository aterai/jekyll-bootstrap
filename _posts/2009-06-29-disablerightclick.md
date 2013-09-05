---
layout: post
title: JComboBoxのドロップダウンリストで右クリックを無効化
category: swing
folder: DisableRightClick
tags: [JComboBox, BasicComboPopup, MouseListener, JList]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-06-29

## JComboBoxのドロップダウンリストで右クリックを無効化
`JComboBox`のドロップダウンリスト(ポップアップメニュー)で、マウスの右クリックを無効にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTLKTBLgQI/AAAAAAAAAXI/mV-Gw1hPSYU/s800/DisableRightClick.png)

### サンプルコード
<pre class="prettyprint"><code>class BasicComboPopup2 extends BasicComboPopup {
  private Handler2 handler2;
  @Override public void uninstallingUI() {
    super.uninstallingUI();
    handler2 = null;
  }
  public BasicComboPopup2(JComboBox combo) {
    super(combo);
  }
  @Override protected MouseListener createListMouseListener() {
    if(handler2==null) handler2 = new Handler2();
    return handler2;
  }
  private class Handler2 implements MouseListener{
    @Override public void mouseEntered(MouseEvent e) {}
    @Override public void mouseExited(MouseEvent e)  {}
    @Override public void mouseClicked(MouseEvent e) {}
    @Override public void mousePressed(MouseEvent e) {}
    @Override public void mouseReleased(MouseEvent e) {
      if(e.getSource() == list) {
        if(list.getModel().getSize() &gt; 0) {
          // &lt;ins&gt;
          if(!SwingUtilities.isLeftMouseButton(e) || !comboBox.isEnabled()) return;
          // &lt;/ins&gt;
          // JList mouse listener
          if(comboBox.getSelectedIndex() == list.getSelectedIndex()) {
            comboBox.getEditor().setItem(list.getSelectedValue());
          }
          comboBox.setSelectedIndex(list.getSelectedIndex());
        }
        comboBox.setPopupVisible(false);
        // workaround for cancelling an edited item (bug 4530953)
        if(comboBox.isEditable() &amp;&amp; comboBox.getEditor() != null) {
          comboBox.configureEditor(comboBox.getEditor(), comboBox.getSelectedItem());
        }
      }
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`ComboBoxUI#createPopup()`をオーバーライドして、ドロップダウンリストに設定する`MouseListener`を入れ替えた`BasicComboPopup`を追加しています。

<pre class="prettyprint"><code>combo02.setUI(new BasicComboBoxUI() {
  @Override protected ComboPopup createPopup() {
    return new BasicComboPopup2( comboBox );
  }
});
</code></pre>

元の`MouseListener`は、`JComboBox`全体の`Handler`になっていますが、必要なのはドロップダウンリスト関係のみなので、`e.getSource() == list`な部分だけ元の`Handler`からコピーし、この中で`if(!SwingUtilities.isLeftMouseButton(e) || !comboBox.isEnabled()) return;`と右クリックを無視しています。

- - - -
以下のような方法もあります。

<pre class="prettyprint"><code>class BasicComboPopup3 extends BasicComboPopup {
  public BasicComboPopup3(JComboBox combo) {
    super(combo);
  }
  @Override protected JList createList() {
    return new JList(comboBox.getModel()) {
      @Override public void processMouseEvent(MouseEvent e) {
        if(SwingUtilities.isRightMouseButton(e)) return;
        if(e.isControlDown()) {
          // Fix for 4234053. Filter out the Control Key from the list.
          // ie., don't allow CTRL key deselection.
          e = new MouseEvent((Component)e.getSource(), e.getID(), e.getWhen(),
                     e.getModifiers() ^ InputEvent.CTRL_MASK,
                     e.getX(), e.getY(),
                     e.getXOnScreen(), e.getYOnScreen(),
                     e.getClickCount(),
                     e.isPopupTrigger(),
                     MouseEvent.NOBUTTON);
        }
        super.processMouseEvent(e);
      }
    };
  }
}
</code></pre>

### コメント
- ドロップダウンリストにスクロールバーが表示されていない場合、ホイールを回すとポップアップが閉じてしまうのも地味に困る…。[Bug ID: 6982607 JComboBox closes on MouseWheelEvent scrolling if no scroll bar is visible](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6982607) -- [aterai](http://terai.xrea.jp/aterai.html) 2012-04-24 (火) 18:28:39

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
        if(e instanceof MouseWheelEvent) {
          JScrollBar toScroll = getVerticalScrollBar();
          if(toScroll == null || !toScroll.isVisible()) {
            ((MouseWheelEvent)e).consume();
            return;
          }
        }
        super.processEvent(e);
      }
    };
    sp.setHorizontalScrollBar(null);
    return sp;
  }
//...
</code></pre>

- 上記の方法では、ドロップダウンリスト内では閉じなくなるが、ドロップダウンリスト外でホイールを回転するとポップアップが閉じてしまう。`Toolkit.getDefaultToolkit().addAWTEventListener(...)`でもうまくいかない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-04-24 (火) 20:07:13

<!-- dummy comment line for breaking list -->
